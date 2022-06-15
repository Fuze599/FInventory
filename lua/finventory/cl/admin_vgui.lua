if not CLIENT then return end

local ply = FindMetaTable("Player")

function showAdminVgui() 
    local backgroundFrame = vgui.Create('DButton')
    backgroundFrame:SetSize(ScrW(), ScrH())
    backgroundFrame:SetCursor("arrow")
    backgroundFrame:SetText("")
    backgroundFrame.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.backgroundColor)
    end
    backgroundFrame.DoClick = function(self) backgroundFrame:Remove() end
    backgroundFrame.DoRightClick = function(self) backgroundFrame:Remove() end

    function backgroundFrame:Think()
        net.Receive('finventoryCloseDerma', function()
            backgroundFrame:Remove()
        end)	
    end

    local mainFrame = vgui.Create('DFrame', backgroundFrame)
    mainFrame:SetSize(ScrW() * 1152 / 1920, ScrH() * 594 / 1080)
    mainFrame:SetTitle('')
    mainFrame:Center()
    mainFrame:SetVisible(true)
    mainFrame:SetDraggable(false)
    mainFrame:SetBackgroundBlur(true)
    mainFrame:ShowCloseButton(false)
    mainFrame:MakePopup()
    mainFrame.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.veryLightColor)
    end

    local leftBar = vgui.Create("DPanel", mainFrame)
    leftBar:SetSize(ScrW() * 220 / 1920, ScrH() * 594 / 1080) 
    leftBar:SetPos(0, 0)
    leftBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.lightColor)
    end 

    local upperBar = vgui.Create("DPanel", mainFrame)
    upperBar:SetSize(ScrW() * 1152 / 1920, ScrH() * 40 / 1080) 
    upperBar:SetPos(0, 0)
    upperBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.lightColor)
    end 

    local closeButton = vgui.Create("DButton", mainFrame)
    closeButton:SetPos(ScrW() * 1120 / 1920, ScrH() * 10 / 1080)
    closeButton:SetSize(ScrW() * 20 / 1920, ScrH() * 20 / 1080)
    closeButton:SetFont("FInventorySmallFont")
    closeButton:SetText("")
    closeButton:SetCursor("hand")
    closeButton.Paint = function(self,w,h)
        draw.RoundedBox(100, 0, 0, w, h, finventoryConfig.Theme.loadBarColor)
    end
    closeButton.DoClick = function() backgroundFrame:Remove() end

    local mainTitle = vgui.Create("DLabel", mainFrame)
    mainTitle:SetPos(ScrW() * 15 / 1920, ScrH() * -6 / 1080)
    mainTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    mainTitle:SetFont("FInventoryLargeFont")
    mainTitle:SetText(finventoryConfig.Language.adminPanel)
    
    local allInventoryButton = vgui.Create("DButton", mainFrame)
    allInventoryButton:SetPos(ScrW() * 10 / 1920, ScrH() * 50 / 1080)
    allInventoryButton:SetSize(ScrW() * 200 / 1920, ScrH() * 50 / 1080)
    allInventoryButton:SetFont("FInventorySmallFont")
    allInventoryButton:SetText(finventoryConfig.Language.allInventories)
    allInventoryButton:SetCursor("hand")
    allInventoryButton.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.middleColor)
    end
    allInventoryButton.DoClick = function()
        backgroundFrame:Remove()
        showAdminVgui()
    end

    showAllInventory(mainFrame, backgroundFrame)
end

function showAllInventory(mainFrame, backgroundFrame)
    local wPosScroller = ScrW() * 210 / 1920
    local hPosScroller = ScrH() * 120 / 1080
    local wSizeScroller = ScrW() * 525 / 1080
    local hSizeScroller = ScrH() * 470 / 1080

    local scrollerInfoFrame
    local gridInfoFrame

    local scrollerInventory
    local gridItemsInventory

    local dTextEntrySearchPlayer = vgui.Create("DTextEntry", mainFrame)
    dTextEntrySearchPlayer:SetPos(ScrW() * 440 / 1920, ScrH() * 50 / 1080)
    dTextEntrySearchPlayer:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    dTextEntrySearchPlayer:SetFont("FInventoryMediumFont")
    dTextEntrySearchPlayer:SetPlaceholderText(finventoryConfig.Language.searchPlayer)
    dTextEntrySearchPlayer.Paint = function(self)
        surface.SetDrawColor(finventoryConfig.Theme.middleColor)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(finventoryConfig.Theme.veryMuchLightColor, finventoryConfig.Theme.selectTextColor, finventoryConfig.Theme.veryMuchLightColor)
    end

    function dTextEntrySearchPlayer:GetAutoComplete(text) 
        if scrollerInfoFrame then scrollerInfoFrame:Remove() end
        if scrollerInventory then scrollerInventory:Remove() end
        gridInfoFrame, scrollerInfoFrame = getScroller(mainFrame, wPosScroller, hPosScroller, wSizeScroller, hSizeScroller)

        local pos = 0
        for k, ply in ipairs(player.GetAll()) do
            if searchUserRegex(text, ply) then
                local buttonBackgroundPlayer = scrollerInfoFrame:Add("DButton")
                buttonBackgroundPlayer:SetPos(ScrW() * 20 / 1920, ScrH() * (0 + pos) / 1080)
                buttonBackgroundPlayer:SetSize(ScrW() * 890 / 1920, ScrH() * 100 / 1080)
                buttonBackgroundPlayer:SetText("")
                buttonBackgroundPlayer:SetPaintBackground(false )
                buttonBackgroundPlayer:SetCursor("arrow")
                buttonBackgroundPlayer.Paint = function(self,w,h)
                    draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.middleColor)
                end

                local dlabelPlayerName = scrollerInfoFrame:Add("DLabel")
                dlabelPlayerName:SetPos(ScrW() * 30 / 1920, ScrH() * (-20 + pos) / 1080)
                dlabelPlayerName:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
                dlabelPlayerName:SetFont("FInventoryMediumFont")
                dlabelPlayerName:SetText(ply:GetName())

                local dlabelPlayerID = scrollerInfoFrame:Add("DLabel")
                dlabelPlayerID:SetPos(ScrW() * 40 / 1920, ScrH() * (20 + pos) / 1080)
                dlabelPlayerID:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
                dlabelPlayerID:SetFont("FInventorySmallFont")
                dlabelPlayerID:SetText(ply:SteamID())

                local buttonInventory = scrollerInfoFrame:Add("DButton")
                buttonInventory:SetPos(ScrW() * 720 / 1920, ScrH() * (25 + pos) / 1080)
                buttonInventory:SetSize(ScrW() * 150 / 1920, ScrH() * 50 / 1080)
                buttonInventory:SetText("Voir l'inventaire")
                buttonInventory.Paint = function(self,w,h)
                    draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.lightColor)
                end
                buttonInventory.DoClick = function()
                    dTextEntrySearchPlayer:Remove()
                    ply:showProfile(mainFrame, backgroundFrame, scrollerInfoFrame, gridInfoFrame, scrollerInventory, gridItemsInventory)
                end	
                pos = pos + 120
            end
        end
    end
end

function ply:showProfile(mainFrame, backgroundFrame, scrollerInfoFrame, gridInfoFrame, scrollerInventory, gridItemsInventory)
    local wPosScroller = ScrW() * 210 / 1920
    local hPosScroller = ScrH() * 120 / 1080
    local wSizeScroller = ScrW() * 525 / 1080
    local hSizeScroller = ScrH() * 470 / 1080

    scrollerInfoFrame:Remove()

    gridInfoFrame, scrollerInfoFrame = getScroller(mainFrame, wPosScroller, hPosScroller, wSizeScroller, hSizeScroller)

    local dlabelPlayerName = scrollerInfoFrame:Add("DLabel")
    dlabelPlayerName:SetPos(ScrW() * 40 / 1920, ScrH() * -30 / 1080)
    dlabelPlayerName:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
    dlabelPlayerName:SetFont("FInventoryMediumFont")
    dlabelPlayerName:SetText(self:Nick())

    local dlabelPlayerSteamName = scrollerInfoFrame:Add("DLabel")
    dlabelPlayerSteamName:SetPos(ScrW() * 40 / 1920, 0)
    dlabelPlayerSteamName:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
    dlabelPlayerSteamName:SetFont("FInventorySmallFont")
    if not self:IsBot() then
        steamworks.RequestPlayerInfo(self:SteamID64(), function(steamName)
            dlabelPlayerSteamName:SetText("Steam : " .. steamName)
        end)
    end    

    local dlabelPlayerID = scrollerInfoFrame:Add("DLabel")
    dlabelPlayerID:SetPos(ScrW() * 40 / 1920, ScrH() * 30 / 1080)
    dlabelPlayerID:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
    dlabelPlayerID:SetFont("FInventorySmallFont")
    dlabelPlayerID:SetText("SteamID : " .. self:SteamID())

    local dlabelPlayerJob = scrollerInfoFrame:Add("DLabel")
    dlabelPlayerJob:SetPos(ScrW() * 40 / 1920, ScrH() * 60 / 1080)
    dlabelPlayerJob:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
    dlabelPlayerJob:SetFont("FInventorySmallFont")
    dlabelPlayerJob:SetText(finventoryConfig.Language.job .. self:getDarkRPVar("job"))
    
    local buttonDeleteInventory = scrollerInfoFrame:Add("DButton")
    buttonDeleteInventory:SetPos(ScrW() * 40 / 1920, ScrH() * 400 / 1080)
    buttonDeleteInventory:SetSize(ScrW() * 150 / 1920, ScrH() * 50 / 1080)
    buttonDeleteInventory:SetText("Supprimer l'inventaire")
    buttonDeleteInventory.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.lightColor)
    end
    buttonDeleteInventory.DoClick = function()
        net.Start("finventoryDeleteInventory")
        net.WriteEntity(self)
        net.SendToServer()

        backgroundFrame:Remove()
        showAdminVgui()
    end

    local wPosScrollerInventory = ScrW() * 625 / 1920
    local wSizeScrollerInventory = ScrW() * 290 / 1080
    gridItemsInventory, scrollerInventory 
            = getScroller(mainFrame, wPosScrollerInventory, hPosScroller, wSizeScrollerInventory, hSizeScroller)

    self:retrieveInventoryAsAdmin()
    
    function dlabelPlayerName:Think()
        net.Receive("finventoryShowInventoryAsAdminRet", function(len) 
            local configTable = net.ReadTable()
            showInventoryCases(configTable, gridItemsInventory, scrollerInfoFrame)
        end)
    end
end

function showInventoryCases(configTable, gridItemsInventory, scrollerInfoFrame)       
    local inventoryPlace = configTable.place
    local isInventoryPocket = configTable.isPocket

    for i = 1, inventoryPlace do
        local buttonItem, modelItemPanel, buttonBackgroundItem , isOccuped, nameItem 
                = getGrid(gridItemsInventory, configTable.content, i)
        buttonItem:SetCursor("arrow")
    end

    if isInventoryPocket then configTable.beautifulName = "Pocket" end

    local dlabelBagDescription = scrollerInfoFrame:Add("DLabel")
    dlabelBagDescription:SetPos(ScrW() * 40 / 1920, ScrH() * 90 / 1080)
    dlabelBagDescription:SetSize(ScrW() * 500 / 1920, ScrH() * 100 / 1080)
    dlabelBagDescription:SetFont("FInventorySmallFont")
    dlabelBagDescription:SetText(finventoryConfig.Language.bag .. configTable.beautifulName)
end

function searchUserRegex(text, ply)
    return string.StartWith(string.lower(ply:Nick()), string.lower(text)) or not ply:IsBot() 
    and (string.StartWith(string.lower(tostring(ply:SteamID())), string.lower(text)) 
    or string.StartWith(string.lower(tostring(ply:SteamID64())), string.lower(text)))
end

function ply:retrieveInventoryAsAdmin()
    net.Start("finventoryShowInventoryAsAdmin")
    net.WriteEntity(self)
    net.SendToServer()
end

concommand.Add("finventory_admin", function() 
    if not LocalPlayer():IsAdmin() then 
        Msg("Not authorized")
        return 
    end
    showAdminVgui()
end)