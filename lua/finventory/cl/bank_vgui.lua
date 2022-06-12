if not CLIENT then return end

function showBankDerma(inventory, bank)     
    local backgroundCloseButton = vgui.Create('DButton')
    backgroundCloseButton:SetSize(ScrW(), ScrH())
    backgroundCloseButton:SetCursor("arrow")
    backgroundCloseButton:SetText("")
    backgroundCloseButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.backgroundColor)
    end
    backgroundCloseButton.DoClick = function(self) backgroundCloseButton:Remove() end
    backgroundCloseButton.DoRightClick = function(self) backgroundCloseButton:Remove() end

    function backgroundCloseButton:Think()
        net.Receive('finventoryCloseDerma', function()
            backgroundCloseButton:Remove()
        end)	
    end

    local mainFrame = vgui.Create('DFrame', backgroundCloseButton)
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
    closeButton.DoClick = function() backgroundCloseButton:Remove() end

    local mainTitle = vgui.Create("DLabel", mainFrame)
    mainTitle:SetPos(ScrW() * 15 / 1920, ScrH() * -6 / 1080)
    mainTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    mainTitle:SetFont("FInventoryLargeFont")
    mainTitle:SetText("Bank")

    local youTitle = vgui.Create("DLabel", mainFrame)
    youTitle:SetPos(ScrW() * 75 / 1920, ScrH() * 35 / 1080)
    youTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    youTitle:SetFont("FInventorySmallFont")
    youTitle:SetText("Inventory")

    local bankTitle = vgui.Create("DLabel", mainFrame)
    bankTitle:SetPos(ScrW() * 600 / 1920, ScrH() * 35 / 1080)
    bankTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    bankTitle:SetFont("FInventorySmallFont")
    bankTitle:SetText("Bank")

    local bankButtons = {}
    local inventoryButtons = {}
    for i = 1, 2 do 
        local isBank = i == 2
        local w = ScrW() * 70 / 1920
        local actualInventory = inventory.content
        local otherInventory = bank.content
        local nbPlaceInventory = inventory.place
        if isBank then
            w = ScrW() * 600 / 1920
            actualInventory = bank.content
            otherInventory = inventory.content
            nbPlaceInventory = finventoryConfig.bankPlace
        end

        local scroller = vgui.Create("DScrollPanel", mainFrame)
        scroller:SetSize(ScrW() * 510 / 1920, ScrH() * 495 / 1080)
        scroller:SetPos(w, ScrH() * 75 / 1080)
        local sbar = scroller:GetVBar()
        sbar:SetHideButtons(true)
        sbar.Paint = function(self,w,h)
            draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.darkColor)
        end
        sbar.btnGrip.Paint = function(self,w,h)
            draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.middleColor)
        end

        local gridItems = vgui.Create("DGrid", scroller)
        gridItems:SetPos(0, 0)
        gridItems:SetCols(3)
        gridItems:SetColWide(ScrW() * 166.66 / 1920)
        gridItems:SetRowHeight(ScrH() * 166.66 / 1080)

        for j = 1, nbPlaceInventory do
            local nameItem = ""
            local modelItem = ""

            local isOccuped = false
            if j <= #actualInventory then
                local entity = scripted_ents.Get(actualInventory[j])
                if actualInventory[j] then
                    isOccuped = true

                    if actualInventory[j].itemType == getItemShipmentString() then
                        local class = CustomShipments[actualInventory[j].content].entity
                        local metaTableWeapon = weapons.Get(class)
                        nameItem = metaTableWeapon.PrintName .. " (ship.)"
                        modelItem = CustomShipments[actualInventory[j].content].model
                    else
                        modelItem = actualInventory[j].model
                        nameItem = actualInventory[j].name
                    end
    
                    if actualInventory[j].count > 1 then
                        nameItem = actualInventory[j].count .. " " .. nameItem
                    end

                end
            end

            local listItem = vgui.Create("DPanel")
            listItem:SetSize(ScrW() * 159.2 / 1920, ScrH() * 159.2 / 1080) 
            listItem.Paint = function(self, w, h)
                surface.SetDrawColor(55, 55, 55, 255)
                surface.DrawTexturedRect(0, 0, w, h)
            end

            local buttonBackgroundItem = vgui.Create("DButton", listItem)
            buttonBackgroundItem:SetPos(0, 0)
            buttonBackgroundItem:SetSize(ScrW() * 159.2 / 1920, ScrH() * 159.2 / 1080)
            buttonBackgroundItem:SetText("")
            buttonBackgroundItem.text = nameItem
            buttonBackgroundItem.index = j

            local modelItemPanel = vgui.Create("DModelPanel", buttonBackgroundItem)
            modelItemPanel:SetSize(ScrW() * 120.3 / 1920, ScrH() * 120.2 / 1080)
            modelItemPanel:SetPos(ScrW() * 20 / 1920, 0)
            modelItemPanel:SetModel(modelItem)
            modelItemPanel.LayoutEntity = function(self)
                local size1, size2 = self.Entity:GetRenderBounds()
                local size = (-size1 + size2):Length()
                self:SetFOV(25)
                self:SetCamPos(Vector(size * 2, size * 1, size * 1))
                self:SetLookAt((size1 + size2) / 2)
            end	

            local buttonItem = vgui.Create("DButton", buttonBackgroundItem)
            buttonItem:SetPos(0, 0)
            buttonItem:SetSize(ScrW() * 159.2 / 1920, ScrH() * 159.2 / 1080)
            buttonItem:SetText("")
            buttonItem.Paint = function(self, w, h) 
                draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.backgroundColor)
            end
            if isOccuped then
                buttonItem.DoClick = function()
                    local toggled = togglePlace(bankButtons, inventoryButtons, modelItemPanel, buttonItem, isBank, buttonBackgroundItem)
                    if not toggled then LocalPlayer():showNotification("You don't have enough place!") end
                end 
            else
                buttonItem:SetCursor("arrow")
                if isBank then
                    bankButtons[buttonBackgroundItem.index] = { buttonItem, modelItemPanel } 
                else
                    inventoryButtons[buttonBackgroundItem.index] = { buttonItem, modelItemPanel } 
                end
            end  

            buttonBackgroundItem.Paint = function(self, w, h) 
                if isOccuped then
                    if (buttonItem:IsHovered()) then
                        draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.middleColor)
                    else
                        draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.lightColor)
                    end
                    draw.SimpleText(nameItem, "FInventoryExtraSmallFont", w / 2, h / 1.2, finventoryConfig.Theme.veryMuchLightColor, 1, 1)
                else
                    draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.lightColor)
                end
            end
            gridItems:AddItem(listItem)
        end
    end
end
net.Receive('finventoryGetBankDerma', function(len) showBankDerma(net.ReadTable(), net.ReadTable()) end)

function togglePlace(bankButtons, inventoryButtons, actualSideModel, actualSideButton, isBank, actualSideButtonBackgroundItem)
    // SetUp actual inventory with decaling index
    local actualInventoryDecalingIndex = 0
    local otherInventoryDecalingIndex = 0
    local otherSideButtons = bankButtons
    local actualSideButtons = inventoryButtons
    if isBank then
        otherSideButtons = inventoryButtons
        actualSideButtons = bankButtons
    end

    // Get the index of the first non occuped place. If return it mean there is no place
    local index = findFirstIndex(otherSideButtons)
    if not index then return end

    // Intervert buttons table
    local newPlaceButtons = otherSideButtons[index]
    otherSideButtons[index] = nil
    actualSideButtons[actualSideButtonBackgroundItem.index] = {actualSideButton, actualSideModel}
    local otherSideButton = newPlaceButtons[1]
    local otherSideModel = newPlaceButtons[2]
    local otherSideBackgroundButton = otherSideModel:GetParent()

    // If the place is decaled, get the physic position index of the inventory
    for k, v in pairs(actualSideButtons) do
        if (k < actualSideButtonBackgroundItem.index) then 
            actualInventoryDecalingIndex = actualInventoryDecalingIndex - 1
        end
    end

    // Exchange inventory in the server
    local indexActualSide = actualSideButtonBackgroundItem.index + actualInventoryDecalingIndex
    local indexOtherSide = otherSideBackgroundButton.index + otherInventoryDecalingIndex
    if isBank then
        net.Start("finventoryTransferItemFromBankToInventory") 
        net.WriteUInt(indexActualSide, finventoryConfig.maxUIntByte)
        net.WriteUInt(indexOtherSide, finventoryConfig.maxUIntByte)
        net.SendToServer()
    else
        net.Start("finventoryTransferItemFromInventoryToBank") 
        net.WriteUInt(indexActualSide, finventoryConfig.maxUIntByte)
        net.WriteUInt(indexOtherSide, finventoryConfig.maxUIntByte)
        net.SendToServer()
    end

    // Exchange text and the paint of the new place
    otherSideBackgroundButton.text = actualSideButtonBackgroundItem.text
    otherSideBackgroundButton.Paint = function(self, w, h) 
        if (otherSideButton:IsHovered()) then
            draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.middleColor)
        else
            draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.lightColor)
        end
        draw.SimpleText(otherSideBackgroundButton.text, "FInventoryExtraSmallFont", w / 2, h / 1.2, finventoryConfig.Theme.veryMuchLightColor, 1, 1)
    end

    // Remove the paint anim of the previous place
    actualSideButtonBackgroundItem.Paint = function(self, w, h) 
        draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.lightColor)
    end

    // Set model and button of the revious place
    otherSideModel:SetModel(actualSideModel:GetModel())
    otherSideButton:SetCursor("hand")
    otherSideButton.DoClick = function()
        local toggled = togglePlace(bankButtons, inventoryButtons, otherSideModel, otherSideButton, 
                                      not isBank, otherSideBackgroundButton)
        if not toggled then LocalPlayer():showNotification("You don't have enough place!") end
    end

    // Set model and button of the new place
    actualSideModel:SetModel("")
    actualSideButton:SetCursor("arrow")
    actualSideButton.DoClick = function() end

    // Play sound to notify all is ok
    if finventoryConfig.soundOnTransfer then surface.PlaySound("buttons/button15.wav") end
    return true
end

function findFirstIndex(tab)
    local min = 1024
    for k, v in pairs(tab) do
        if (min > k) then min = k end
    end
    if min == 1024 then return end
    return min
end