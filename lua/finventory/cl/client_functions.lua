if not CLIENT then return end

local ply = FindMetaTable("Player")
local scrw = ScrW()
local scrh = ScrH()

function ply:showNotification(msg)
    notification.AddLegacy(msg, NOTIFY_GENERIC, 3)
    surface.PlaySound("buttons/button15.wav")
    Msg(msg .. "\n") 
end
net.Receive('finventorySendNotification', function(len) 
    local ply = net.ReadEntity()
    local msg = net.ReadString()
    ply:showNotification(msg) 
end)

function ply:updateCSmodel(inventory)
    if not inventory.isPocket then
        self.finventoryCSModel = ClientsideModel(inventory.model)
        self.finventoryCSModel:SetNoDraw(true)
        self.finventoryCSModelVector = inventory.viewModelVector
        self.finventoryCSModelAngle = inventory.viewModelAngle
        self.finventoryUniqueName = inventory.uniqueName
    else
        self.finventoryCSModel = nil
        self.finventoryCSModelVector = nil
        self.finventoryCSModelAngle = nil
        self.finventoryUniqueName = nil
    end
end
net.Receive('finventoryUpdateCSModel', function(len) 
    local ply = net.ReadEntity()
    local inventory = net.ReadTable()
    ply:updateCSmodel(inventory)
end)

hook.Add("PostPlayerDraw" , "finventoryDrawBackpackPlayer" , function(ply)
    if ply.finventoryCSModel then
        local boneid = ply:LookupBone("ValveBiped.Bip01_Spine2")
        if not boneid then return end
        
        local matrix = ply:GetBoneMatrix(boneid)
        if not matrix then return end

        local newpos, newang = LocalToWorld(
            ply.finventoryCSModelVector,
            ply.finventoryCSModelAngle,
            matrix:GetTranslation(), 
            matrix:GetAngles() 
        )

        ply.finventoryCSModel:SetPos(newpos)
        ply.finventoryCSModel:SetAngles(newang)
        ply.finventoryCSModel:SetupBones()
        ply.finventoryCSModel:DrawModel()
    end 
end)

function ply:showCheckerLoadBar(otherPly, isInspector)
    local progressIndex = 1
    local interval = finventoryConfig.loadingBarInterval
    local w = scrw * 300 / 1920
    local h = scrh * 40 / 1080
    local hPos = scrh * 20 / 1080
    local text = "Search in progress"
    if not isInspector then 
        text = "You get searched!"
        hPos = scrh * 500 / 1080
    end
    
    hook.Remove("HUDPaint", "finventoryLoadBarHUD")
    timer.Create("FInventoryCheckerProgressBar", 1 / interval, finventoryConfig.timeToCheckInventory * interval, function()
        local repsLeft = timer.RepsLeft("FInventoryCheckerProgressBar")
        if repsLeft > 0 then
            if (isInspector and self:GetEyeTrace().Entity ~= otherPly) 
                or (not isInspector and otherPly:GetEyeTrace().Entity ~= self)
                or (self:GetPos():Distance(otherPly:GetPos()) > finventoryConfig.distanceChecker) then

                hook.Remove("HUDPaint", "finventoryLoadBarHUD")
                timer.Remove("FInventoryCheckerProgressBar") 
                return 
            end
            progressIndex = repsLeft / finventoryConfig.timeToCheckInventory / interval
            hook.Add("HUDPaint", "finventoryLoadBarHUD", function() 
                draw.RoundedBox(0, scrw / 2 - w / 2 - 5, scrh / 2 - hPos - 5, w + 10, h + 10, finventoryConfig.Theme.middleColor) --> border
                draw.RoundedBox(0, scrw / 2 - w / 2, scrh / 2 - hPos, w, h, finventoryConfig.Theme.veryLightColor) --> background
                draw.RoundedBox(0, scrw / 2 - w / 2 + 3, scrh / 2 - hPos + 3, w * progressIndex - 6, h - 6, finventoryConfig.Theme.loadBarColor) --> bar
                draw.DrawText(text, "FInventorySmallBoldFont", scrw / 2 - w / 2 + 10, scrh / 2 - hPos + 10, color_white, TEXT_ALIGN_LEFT)
            end)
        else
            hook.Remove("HUDPaint", "finventoryLoadBarHUD")
        end
    end)
end
net.Receive('finventoryShowLoadBar', function(len) 
    local ply = LocalPlayer()
    local otherPly = net.ReadEntity()
    local isInspector = net.ReadBool()
    ply:showCheckerLoadBar(otherPly, isInspector) 
end)

/*
    ███████╗ ██████╗ ███╗   ██╗████████╗███████╗
    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔════╝
    █████╗  ██║   ██║██╔██╗ ██║   ██║   ███████╗
    ██╔══╝  ██║   ██║██║╚██╗██║   ██║   ╚════██║
    ██║     ╚██████╔╝██║ ╚████║   ██║   ███████║
    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝
*/

surface.CreateFont("FInventoryExtraLargeFont", {
    font = "DermaLarge",
    size = 100,
})

surface.CreateFont("FInventoryLargeFont", {
    font = "Frutiger",
    size = 40
})

surface.CreateFont("FInventoryMediumFont", {
    font = "Frutiger",
    size = 30
})

surface.CreateFont("FInventorySmallFont", {
    font = "Frutiger",
    size = 20
})

surface.CreateFont("FInventorySmallBoldFont", {
    font = "Frutiger",
    size = 20,
    additive = true
})

surface.CreateFont("FInventoryExtraSmallFont", {
    font = "Frutiger",
    size = 15
})