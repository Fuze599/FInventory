if not CLIENT then return end

local scrw = ScrW()
local scrh = ScrH()

function showInventoryDerma(inventory, inspectedPlayer)
    local checkMod = (inspectedPlayer and inspectedPlayer ~= LocalPlayer() 
                        and inspectedPlayer:IsPlayer() and LocalPlayer():isCP())

    if not inspectedPlayer or not inspectedPlayer:IsPlayer() then inspectedPlayer = LocalPlayer() end                

    local hasIllegalItem = false
    if checkMod then
        for k, v in pairs(inventory.content) do
            if finventoryConfig.illegalEntities[v.class] then
                hasIllegalItem = true 
                break
            end
        end
    end

    local backgroundCloseButton = vgui.Create('DButton')
    backgroundCloseButton:SetSize(scrw, scrh)
    backgroundCloseButton:SetCursor("arrow")
    backgroundCloseButton:SetText("")
    backgroundCloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.backgroundColor)
    end
    backgroundCloseButton.DoClick = function() quitInventory() end
    backgroundCloseButton.DoRightClick = function() quitInventory() end

    function quitInventory() 
        backgroundCloseButton:Remove() 
        if checkMod then
            net.Start("finventoryChangeInspectionMode")
            net.WriteEntity(inspectedPlayer)
            net.WriteBool(false)
            net.SendToServer()
            timer.Remove("removeInventoryCheckerPanel")
        end
    end

    function backgroundCloseButton:Think()
        net.Receive('finventoryCloseDerma', function()
            quitInventory()
        end)	
    end

    local mainFrame = vgui.Create('DFrame', backgroundCloseButton)
    mainFrame:SetSize(scrw * 960 / 1920, scrh * 572.4 / 1080)
    mainFrame:SetTitle("")
    mainFrame:Center()
    mainFrame:SetVisible(true)
    mainFrame:SetDraggable(false)
    mainFrame:ShowCloseButton(false)
    mainFrame:MakePopup()
    mainFrame.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.veryLightColor)
    end

    local upperBar = vgui.Create("DPanel", mainFrame)
    upperBar:SetSize(scrw * 960 / 1920, scrh * 40 / 1080) 
    upperBar:SetPos(0, 0)
    upperBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.lightColor)
    end 

    local closeButton = vgui.Create("DButton", mainFrame)
    closeButton:SetPos(scrw * 925 / 1920, scrh * 10 / 1080)
    closeButton:SetSize(scrw * 20 / 1920, scrh * 20 / 1080)
    closeButton:SetFont("FInventorySmallFont")
    closeButton:SetText("")
    closeButton.Paint = function(self,w,h)
        draw.RoundedBox(100, 0, 0, w, h, finventoryConfig.Theme.loadBarColor)
    end
    closeButton.DoClick = function() quitInventory() end

    local title = finventoryConfig.Language.inventory
    if checkMod then
        title = finventoryConfig.Language.searchInventory
    end

    local mainTitle = vgui.Create("DLabel", mainFrame)
    mainTitle:SetPos(scrw * 15 / 1920, scrh * -6 / 1080)
    mainTitle:SetSize(scrw * 480 / 1920, scrh * 50 / 1080)
    mainTitle:SetFont("FInventoryLargeFont")
    mainTitle:SetText(title)

    if checkMod and finventoryConfig.timePoliceControl > 0 then
        local progressIndex = 1
        local dProgressTimeLeft = vgui.Create("DPanel", mainFrame)
        dProgressTimeLeft:SetSize(scrw * 965 / 1920, scrh * 10 / 1080)
        dProgressTimeLeft:SetPos(0, scrh * 565 / 1080)
        dProgressTimeLeft.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.veryLightColor)
            draw.RoundedBoxEx(0, 0, 0, w * progressIndex, h, finventoryConfig.Theme.loadBarColor)
        end 

        local interval = finventoryConfig.loadingBarInterval
        timer.Create("removeInventoryCheckerPanel", 1 / interval, finventoryConfig.timePoliceControl * interval, function()
            local repsLeft = timer.RepsLeft("removeInventoryCheckerPanel")
            if repsLeft <= 0 then quitInventory() end
            progressIndex = repsLeft / finventoryConfig.timePoliceControl / interval
        end)
    end

    local modelPanel = vgui.Create("DModelPanel", mainFrame)
    if inventory.isPocket then
        modelPanel:SetPos(scrw * -50 / 1920, scrh * 54 / 1080)
        modelPanel:SetModel(inspectedPlayer:GetModel())
    else
        modelPanel:SetPos(scrw * -50 / 1920, scrh * 30 / 1080)
        modelPanel:SetModel(inventory.modelExt)
    end
    modelPanel:SetSize(scrw * 500 / 1920, scrh * 500 / 1080)
    modelPanel:SetCursor("arrow")
    modelPanel.LayoutEntity = function(self)
        local size1, size2 = self.Entity:GetRenderBounds()
        local size = (-size1 + size2):Length()
        if inventory.isPocket and not hasIllegalItem then size  = size - 20 end
        self:SetFOV(25)
        self:SetCamPos(Vector(size * 2, size, size))
        self:SetLookAt((size1 + size2) / 2)
    end

    if (not inventory.isPocket and not checkMod) or hasIllegalItem then
        local buttonName = finventoryConfig.Language.dropBackpack
        if hasIllegalItem then buttonName = finventoryConfig.Language.removeIllegalItems end

        local dropBackpackButton = vgui.Create("DButton", mainFrame)
        dropBackpackButton:SetPos(scrw * 100 / 1920, scrh * 490 / 1080)
        dropBackpackButton:SetSize(scrw * 230 / 1920, scrh * 50 / 1080)
        dropBackpackButton:SetFont("FInventorySmallFont")
        dropBackpackButton:SetText("")
        dropBackpackButton:SetCursor("hand")
        dropBackpackButton.DoClick = function()
            if not checkMod then
                mainFrame:Close()
                net.Start("finventoryDropInventory")
                net.SendToServer() 
            elseif hasIllegalItem then
                net.Start("finventoryDeleteIllegalItems")
                net.WriteEntity(inspectedPlayer)
                net.SendToServer()
            end
            backgroundCloseButton:Remove()
        end
        dropBackpackButton.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(15, 0, 0, w, h, finventoryConfig.Theme.middleLightColor)
            else
                draw.RoundedBox(15, 0, 0, w, h, finventoryConfig.Theme.lightColor)
            end
            draw.DrawText(buttonName, "FInventorySmallFont", scrw * 114 / 1920, scrh * 15 / 1080, finventoryConfig.Theme.veryMuchLightColor, TEXT_ALIGN_CENTER)
        end
    end

    local wPosScroller = scrw * 425.7 / 1920
    local hPosScroller = scrh * 95 / 1920
    local wSizeScroller = scrh * 525 / 1080
    local hSizeScroller = scrh * 499 / 1080
    local gridItems = getScroller(mainFrame, wPosScroller, hPosScroller, wSizeScroller, hSizeScroller)

    local decalingIndex = {}
    for i = 1, inventory.place do
        decalingIndex[i] = 0
        local isOccuped = false
        local modelItem = ""
        local text = ""

        local buttonItem, modelItemPanel, buttonBackgroundItem , isOccuped, nameItem
                    = getGrid(gridItems, inventory.content, i)

        if isOccuped and not checkMod then
            buttonItem.DoClick = function()
                net.Start("finventoryDropItem")
                net.WriteUInt(i - decalingIndex[i], finventoryConfig.maxUIntByte)
                net.SendToServer()

                for j = i, inventory.place do
                    decalingIndex[j] = decalingIndex[j] + 1 
                end

                if finventoryConfig.closeInventoryPanelOnDrop then
                    mainFrame:Remove()
                else
                    modelItemPanel:SetModel("")
                    buttonItem:SetCursor("arrow")
                    buttonItem.DoClick = function() end
                    buttonBackgroundItem.Paint = function(self, w, h) 
                        draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.lightColor)
                    end                    
                end
            end
        else
            buttonItem:SetCursor("arrow")
        end 
    end
end
net.Receive('finventoryGetInventoryDerma', function()
    local inventory = net.ReadTable()
    local inspectedPlayer = net.ReadEntity()
    showInventoryDerma(inventory, inspectedPlayer)
end)