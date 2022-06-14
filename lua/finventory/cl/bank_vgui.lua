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
    mainTitle:SetText(finventoryConfig.Language.bank)

    local youTitle = vgui.Create("DLabel", mainFrame)
    youTitle:SetPos(ScrW() * 75 / 1920, ScrH() * 35 / 1080)
    youTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    youTitle:SetFont("FInventorySmallFont")
    youTitle:SetText(finventoryConfig.Language.inventory)

    local bankTitle = vgui.Create("DLabel", mainFrame)
    bankTitle:SetPos(ScrW() * 600 / 1920, ScrH() * 35 / 1080)
    bankTitle:SetSize(ScrW() * 480 / 1920, ScrH() * 50 / 1080)
    bankTitle:SetFont("FInventorySmallFont")
    bankTitle:SetText(finventoryConfig.Language.bank)

    local bankButtons = {}
    local inventoryButtons = {}
    for i = 1, 2 do 
        local isBank = i == 2
        local widthScroller = ScrW() * 70 / 1920
        local actualInventory = inventory.content
        local otherInventory = bank.content
        local nbPlaceInventory = inventory.place
        if isBank then
            widthScroller = ScrW() * 600 / 1920
            actualInventory = bank.content
            otherInventory = inventory.content
            nbPlaceInventory = finventoryConfig.bankPlace
        end

        local heightScroller = ScrH() * 75 / 1080
        local sbarWidth = ScrW() * 515 / 1920
        local gridItems = getScroller(mainFrame, widthScroller, heightScroller, sbarWidth)

        for j = 1, nbPlaceInventory do

            // Add item case
            local buttonItem, modelItemPanel, buttonBackgroundItem , isOccuped, nameItem
                        = getGrid(gridItems, actualInventory, j)
            
            // Case init
            if isOccuped then
                buttonItem.DoClick = function()
                    local toggled = togglePlace(bankButtons, inventoryButtons, modelItemPanel, buttonItem, isBank, buttonBackgroundItem)
                    if not toggled then LocalPlayer():showNotification(finventoryConfig.Language.noMorePlace) end
                end 
            else
                buttonItem:SetCursor("arrow")
                if isBank then
                    bankButtons[buttonBackgroundItem.index] = { buttonItem, modelItemPanel } 
                else
                    inventoryButtons[buttonBackgroundItem.index] = { buttonItem, modelItemPanel } 
                end
            end  
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
        if k < actualSideButtonBackgroundItem.index then 
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
        if otherSideButton:IsHovered() then
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

    // Set model and button of the old place
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
        if min > k then min = k end
    end
    if min == 1024 then return end
    return min
end