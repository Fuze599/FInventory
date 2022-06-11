if not CLIENT then return end

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
    backgroundCloseButton:SetSize(ScrW(), ScrH())
    backgroundCloseButton:SetCursor("arrow")
    backgroundCloseButton:SetText("")
    backgroundCloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
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
    mainFrame:SetSize(ScrW() * 960 / 1920, ScrH() * 572.4 / 1080)
    mainFrame:SetTitle("")
    mainFrame:Center()
    mainFrame:SetVisible(true)
    mainFrame:SetDraggable(false)
    mainFrame:ShowCloseButton(false)
    mainFrame:MakePopup()
    mainFrame.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50))
    end

    local upperBar = vgui.Create("DPanel", mainFrame)
    upperBar:SetSize(ScrW() * 960 / 1920, ScrH() * 40 / 1080) 
    upperBar:SetPos(0, 0)
    upperBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end 

    local closeButton = vgui.Create("DButton", mainFrame)
    closeButton:SetPos(ScrW() * 925 / 1920, ScrH() * 10 / 1080)
    closeButton:SetSize(ScrW() * 20 / 1920, ScrH() * 20 / 1080)
    closeButton:SetFont("FInventorySmallFont")
    closeButton:SetText("")
    closeButton.Paint = function(self,w,h)
        draw.RoundedBox(100, 0, 0, w, h, Color(201, 10, 10))
    end
    closeButton.DoClick = function() quitInventory() end

    local title = "Inventory"
    if checkMod then
        title = "Search inventory"
    end

    local mainTitle = vgui.Create("DLabel", mainFrame)
    mainTitle:SetPos(ScrW() * 15 / 1920, ScrH() * -6 / 1080)
    mainTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    mainTitle:SetFont("FInventoryLargeFont")
    mainTitle:SetText(title)

    if checkMod and finventoryConfig.timePoliceControl > 0 then
        local progressIndex = 1
        local dProgressTimeLeft = vgui.Create("DPanel", mainFrame)
        dProgressTimeLeft:SetSize(ScrW() * 965 / 1920, ScrH() * 10 / 1080)
        dProgressTimeLeft:SetPos(0, ScrH() * 565 / 1080)
        dProgressTimeLeft.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
            draw.RoundedBoxEx(0, 0, 0, w * progressIndex, h, Color(250, 50, 50))
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
        modelPanel:SetPos(ScrW() * -50 / 1920, ScrH() * 54 / 1080)
        modelPanel:SetModel(inspectedPlayer:GetModel())
    else
        modelPanel:SetPos(ScrW() * -50 / 1920, ScrH() * 30 / 1080)
        modelPanel:SetModel(inventory.modelExt)
    end
    modelPanel:SetSize(ScrW() * 500 / 1920, ScrH() * 500 / 1080)
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
        local buttonName = "Drop the bag"
        if hasIllegalItem then buttonName = "Remove Illegals Items" end

        local dropBackpackButton = vgui.Create("DButton", mainFrame)
        dropBackpackButton:SetPos(ScrW() * 100 / 1920, ScrH() * 490 / 1080)
        dropBackpackButton:SetSize(ScrW() * 230 / 1920, ScrH() * 50 / 1080)
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
                draw.RoundedBox(15, 0, 0, w, h, Color(35, 35, 35, 255))
            else
                draw.RoundedBox(15, 0, 0, w, h, Color(40, 40, 40, 255))
            end
            draw.DrawText(buttonName, "FInventorySmallFont", ScrW() * 114 / 1920, ScrH() * 15 / 1080, Color(190,190,190), TEXT_ALIGN_CENTER)
        end
    end

    local scroller = vgui.Create("DScrollPanel", mainFrame)
    scroller:SetSize(ScrW() * 526 / 1920, ScrH() * 502.3 / 1080)
    scroller:SetPos(ScrW() * 425.7 / 1920, ScrH() * 55 / 1080)
    local sbar = scroller:GetVBar()
    sbar:SetHideButtons(true)
    sbar.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, Color(20, 20, 20, 255))
    end
    sbar.btnGrip.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, Color(30, 30, 30, 255))
    end

    local itemsGrid = vgui.Create("DGrid", scroller)
    itemsGrid:SetPos(0, 0)
    itemsGrid:SetCols(3)
    itemsGrid:SetColWide(ScrW() * 166.66 / 1920)
    itemsGrid:SetRowHeight(ScrH() * 166.66 / 1080)

    local decalingIndex = {}
    for i = 1, inventory.place do
        decalingIndex[i] = 0;
        local isOccuped = false
        local modelItem = ""
        local text = ""
        
        if i <= #inventory.content then
            local entity = scripted_ents.Get(inventory.content[i])
            if (inventory.content[i]) then
                modelItem = inventory.content[i].model
                text = inventory.content[i].name
                isOccuped = true
            end
        end

        local itemCard = vgui.Create("DPanel")
        itemCard:SetSize(ScrW() * 159.2 / 1920, ScrH() * 159.2 / 1080) 
        itemCard.Paint = function(self, w, h)
            surface.SetDrawColor(55, 55, 55, 255)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local buttonBackgroundItem = vgui.Create("DButton", itemCard)
        buttonBackgroundItem:SetPos(0, 0)
        buttonBackgroundItem:SetSize(ScrW() * 159.2 / 1920, ScrH() * 159.2 / 1080)
        buttonBackgroundItem:SetText("")

        // Item model
        local itemModelPanel = vgui.Create("DModelPanel", buttonBackgroundItem)
        itemModelPanel:SetSize(ScrW() * 120.2 / 1920, ScrH() * 120.2 / 1080)
        itemModelPanel:SetPos(ScrW() * 20 / 1920, 0)
        itemModelPanel:SetModel(modelItem)
        itemModelPanel.LayoutEntity = function(self)
            local size1, size2 = self.Entity:GetRenderBounds()
            local size = (-size1+size2):Length()
            self:SetFOV(25)
            self:SetCamPos(Vector(size*2,size*1,size*1))
            self:SetLookAt((size1+size2)/2)
        end	

        local buttonItem = vgui.Create("DButton", buttonBackgroundItem)
        buttonItem:SetPos(0, 0)
        buttonItem:SetSize(ScrW() * 159.2 / 1920, ScrH() * 159.2 / 1080)
        buttonItem:SetText("")
        buttonItem.Paint = function(self, w, h) 
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end
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
                    itemModelPanel:Hide()
                    text = ""
                    isOccuped = false
                    buttonItem:SetCursor("arrow")
                    buttonItem.DoClick = function() end
                end
            end
            -- local nbButton = 1
            -- if false then 
            --     // isweapon
            --     nbButton = 2
            -- end
            -- for i = 1, nbButton do

            --     local vertical = 50
            --     local text = "Drop"
            --     if nbButton == 2 and i ~= 2 then
            --         vertical = 23
            --     elseif nbButton == 2 and i == 2 then
            --         vertical = 75
            --         text = "Equip"
            --     end

            --     local val = 0
            --     local dropButton = vgui.Create("DButton", buttonBackgroundItem)
            --     dropButton:SetText("")
            --     dropButton:SetPos(30, vertical)
            --     dropButton:SetSize(100, 40)
            --     function dropButton:Paint(w, h)
            --         local buttonColor = Color(40, 40, 40, val)
            --         if buttonItem:IsHovered() or dropButton:IsHovered() then  
            --             val = val + 40
            --             if val > 255 then val = 255 end
            --             if dropButton:IsHovered() then
            --                 buttonColor = Color(28, 28, 28, val)
            --             end
            --         else   
            --             val = val - 40 
            --             if val < 0 then val = 0 end
            --         end
            --         draw.RoundedBox(8, 0, 0, w, h, buttonColor)
            --         draw.SimpleText(text, "FInventoryExtraSmallFont", w / 2, 20, Color(200,200,200, val), 1, 1)
            --     end
            -- end
        else
            buttonItem:SetCursor("arrow")
        end 
        buttonBackgroundItem.Paint = function(self, w, h) 
            if isOccuped then
                if buttonItem:IsHovered() and not checkMod then
                    draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30))
                else
                    draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40, 255))
                end
                draw.SimpleText(text, "FInventoryExtraSmallFont", w / 2, h / 1.2, Color(200,200,200), 1, 1)
            else
                draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40, 255))
            end
        end
        itemsGrid:AddItem(itemCard)
    end
end
net.Receive('finventoryGetInventoryDerma', function()
    local inventory = net.ReadTable()
    local inspectedPlayer = net.ReadEntity()
    showInventoryDerma(inventory, inspectedPlayer)
end)