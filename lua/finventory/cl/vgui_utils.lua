if not CLIENT then return end

local scrw = ScrW()
local scrh = ScrH()

function getScroller(mainFrame, wPosScroller, hPosScroller, wSizeScroller, hSizeScroller)
    local scroller = vgui.Create("DScrollPanel", mainFrame)
    scroller:SetSize(wSizeScroller, hSizeScroller)
    scroller:SetPos(wPosScroller, hPosScroller)
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
    gridItems:SetColWide(scrw * 166.66 / 1920)
    gridItems:SetRowHeight(scrh * 166.66 / 1080)

    return gridItems, scroller
end

function getGrid(gridItems, actualInventory, inventoryIndex)
    local nameItem = ""
    local modelItem = ""
    local isOccuped = false

    if inventoryIndex <= #actualInventory then
        local entity = scripted_ents.Get(actualInventory[inventoryIndex])
        if actualInventory[inventoryIndex] then
            isOccuped = true

            if actualInventory[inventoryIndex].itemType == getItemShipmentString() then
                nameItem = actualInventory[inventoryIndex].name .. " (ship.)"
                modelItem = CustomShipments[actualInventory[inventoryIndex].content].model
            elseif actualInventory[inventoryIndex].itemType == getItemAmmoString() then
                local ammoName = game.GetAmmoName(game.GetAmmoID(actualInventory[inventoryIndex].content))
                modelItem = actualInventory[inventoryIndex].model
                nameItem = ammoName .. " ammo"
            elseif actualInventory[inventoryIndex].itemType == getItemFoodString() then
                modelItem = actualInventory[inventoryIndex].model
                nameItem = actualInventory[inventoryIndex].content.name
            else
                modelItem = actualInventory[inventoryIndex].model
                nameItem = actualInventory[inventoryIndex].name
            end

            if actualInventory[inventoryIndex].count > 1 then
                nameItem = actualInventory[inventoryIndex].count .. " " .. nameItem
            end

        end
    end

    local listItem = vgui.Create("DPanel")
    listItem:SetSize(scrw * 159.2 / 1920, scrh * 159.2 / 1080) 
    listItem.Paint = function(self, w, h)
        surface.SetDrawColor(55, 55, 55, 255)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local buttonBackgroundItem = vgui.Create("DButton", listItem)
    buttonBackgroundItem:SetPos(0, 0)
    buttonBackgroundItem:SetSize(scrw * 159.2 / 1920, scrh * 159.2 / 1080)
    buttonBackgroundItem:SetText("")
    buttonBackgroundItem.text = nameItem
    buttonBackgroundItem.index = inventoryIndex

    local modelItemPanel = vgui.Create("DModelPanel", buttonBackgroundItem)
    modelItemPanel:SetSize(scrw * 120.3 / 1920, scrh * 120.2 / 1080)
    modelItemPanel:SetPos(scrw * 20 / 1920, 0)
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
    buttonItem:SetSize(scrw * 159.2 / 1920, scrh * 159.2 / 1080)
    buttonItem:SetText("")
    buttonItem.Paint = function(self, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.backgroundColor)
    end
    buttonBackgroundItem.Paint = function(self, w, h) 
        if isOccuped then
            if buttonItem:IsHovered() then
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

    return buttonItem, modelItemPanel, buttonBackgroundItem, isOccuped, nameItem
end
