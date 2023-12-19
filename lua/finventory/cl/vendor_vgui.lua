if not CLIENT then return end

local scrw = ScrW()
local scrh = ScrH()

function showVendorDerma(ply) 

    local backgroundCloseButton = vgui.Create('DButton')
    backgroundCloseButton:SetSize(scrw, scrh)
    backgroundCloseButton:SetCursor("arrow")
    backgroundCloseButton:SetText("")
    backgroundCloseButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.backgroundColor)
    end
    backgroundCloseButton.DoClick = function(self) backgroundCloseButton:Remove() end
    backgroundCloseButton.DoRightClick = function(self) backgroundCloseButton:Remove() end

    net.Receive('finventoryCloseDerma', function()
        backgroundCloseButton:Remove()
    end)	
    
    local mainFrame = vgui.Create('DFrame', backgroundCloseButton)
    mainFrame:SetSize(scrw * 1440 / 1920, scrh * 810 / 1080)
    mainFrame:SetTitle('')
    mainFrame:Center()
    mainFrame:SetVisible(true)
    mainFrame:SetDraggable(false)
    mainFrame:ShowCloseButton(false)
    mainFrame:MakePopup()
    mainFrame.Paint = function(self, w, h)
        draw.RoundedBox(15, 0, 0, w, h, finventoryConfig.Theme.veryLightColor)
    end

    local upperBar = vgui.Create("DPanel", mainFrame)
    upperBar:SetSize(scrw * 1440 / 1920, scrh * 40 / 1080) 
    upperBar:SetPos(0, 0)
    upperBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, finventoryConfig.Theme.lightColor)
    end 

    local closeButton = vgui.Create("DButton", mainFrame)
    closeButton:SetPos(scrw * 1407 / 1920, scrh * 10 / 1080)
    closeButton:SetSize(scrw * 20 / 1920, scrh * 20 / 1080)
    closeButton:SetFont("FInventorySmallFont")
    closeButton:SetText("")
    closeButton:SetCursor("hand")
    closeButton.Paint = function(self,w,h)
        draw.RoundedBox(100, 0, 0, w, h, finventoryConfig.Theme.loadBarColor)
    end
    closeButton.DoClick = function() mainFrame:Close() end

    local mainTitle = vgui.Create("DLabel", mainFrame)
    mainTitle:SetPos(scrw * 15 / 1920, scrh * -6 / 1080)
    mainTitle:SetSize(scrw * 480 / 1920, scrh * 50 / 1080)
    mainTitle:SetFont("FInventoryLargeFont")
    mainTitle:SetText(finventoryConfig.Language.vendor)

    local vendorModel = vgui.Create("DModelPanel", mainFrame)
    vendorModel:SetSize(scrw * 432.4 / 1920, scrh * 812 / 1080) 
    vendorModel:SetPos(Vector(1, 1, 100))
    vendorModel:SetModel(finventoryConfig.model)
    local eyepos = vendorModel.Entity:GetBonePosition(vendorModel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    eyepos:Add(Vector(0, 0, -1))
    vendorModel:SetLookAt(eyepos)
    vendorModel:SetEnabled(false)
    vendorModel:SetCursor("arrow")
    vendorModel:SetCamPos(eyepos - Vector(-12, 3, 0))
    vendorModel.Entity:SetEyeTarget(eyepos - Vector(-12, 0, 0))
    function vendorModel:LayoutEntity(Entity) return end

    local scroller = vgui.Create("DScrollPanel", mainFrame)
    scroller:SetSize(scrw * 911 / 1920, scrh * 750 / 1080)
    scroller:SetPos(scrw * 525 / 1920, scrh * 50 / 1080)
    local sbar = scroller:GetVBar()
    sbar:SetHideButtons(true)
    sbar.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.darkColor)
    end
    sbar.btnGrip.Paint = function(self,w,h)
        draw.RoundedBox(5, 0, 0, w, h, finventoryConfig.Theme.middleColor)
    end

    local backpackGrid = vgui.Create("DGrid", scroller)
    backpackGrid:SetPos(0, 0)
    backpackGrid:SetCols(2)
    backpackGrid:SetColWide(scrw * 450 / 1920)
    backpackGrid:SetRowHeight(scrh * 210 / 1080)

    for k, v in pairs(finventoryConfig.backpacks) do

        if not v.modelExt then
            v.modelExt = v.model
        end

        local backpackCard = vgui.Create("DPanel")
        backpackCard:SetSize(scrw * 440 / 1920, scrh * 200 / 1080) 
        backpackCard.Paint = function(self, w, h)
            surface.SetDrawColor(55, 55, 55, 255)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        local buttonBackgroundItem = vgui.Create("DButton", backpackCard)
        buttonBackgroundItem:SetPos(0, 0)
        buttonBackgroundItem:SetSize(scrw * 440 / 1920, scrh * 200 / 1080)
        buttonBackgroundItem:SetText("")
        buttonBackgroundItem:SetCursor("arrow")

        local backpackModel = vgui.Create("DModelPanel", buttonBackgroundItem)
        backpackModel:SetSize(scrw * 200 / 1920, scrh * 200 / 1080)
        backpackModel:SetPos(scrw * -10 / 1920, 0)
        backpackModel:SetModel(v.modelExt)
        backpackModel:SetCursor("arrow")
        backpackModel.LayoutEntity = function(self)
            local size1, size2 = self.Entity:GetRenderBounds()
            local size = (-size1+size2):Length()
            self:SetFOV(25)
            self:SetCamPos(Vector(size*2,size*1,size*1))
            self:SetLookAt((size1+size2)/2)
        end	
        buttonBackgroundItem.Paint = function(self, w, h) 
            draw.RoundedBox(4, 0, 0, w, h, finventoryConfig.Theme.lightColor)
        end

        local nameText = vgui.Create("DLabel", buttonBackgroundItem)
        nameText:SetPos(scrw * 175 / 1920, scrh * 20 / 1080)
        nameText:SetSize(scrw * 500 / 1920, scrh * 50 / 1920)
        nameText:SetFont("FInventoryMediumFont")
        nameText:SetText(v.beautifulName)

        local placeText = vgui.Create("DLabel", buttonBackgroundItem)
        placeText:SetPos(scrw * 180 / 1920, scrh * 50 / 1080)
        placeText:SetSize(scrw * 500 / 1920, scrh * 50 / 1920)
        placeText:SetFont("FInventorySmallFont")
        placeText:SetText(finventoryConfig.Language.place .. v.place)

        if finventoryConfig.isGamemodeDarkRP then
            local price = vgui.Create("DLabel", buttonBackgroundItem)
            price:SetPos(scrw * 180 / 1920, scrh * 75 / 1080)
            price:SetSize(scrw * 500 / 1920, scrh * 50 / 1080)
            price:SetFont("FInventorySmallFont")
            price:SetText(finventoryConfig.Language.price .. v.price .. finventoryConfig.currency)
        end

        if ply.finventoryUniqueName ~= k then
            local buyButton = vgui.Create("DButton", buttonBackgroundItem)
            buyButton:SetText("")
            buyButton:SetPos(scrw * 200 / 1920, scrh * 125 / 1080)
            buyButton:SetSize(scrw * 150 / 1920, scrh * 50 / 1080)
            buyButton.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(10, 0, 0, w, h, finventoryConfig.Theme.darkColor)
                else
                    draw.RoundedBox(10, 0, 0, w, h, finventoryConfig.Theme.middleColor)
                end
                draw.DrawText(finventoryConfig.Language.buy, "FInventorySmallFont", w/2, h/2 - h/5, finventoryConfig.Theme.veryMuchLightColor, TEXT_ALIGN_CENTER)
            end
            buyButton.DoClick = function() 
                mainFrame:Close() 
                net.Start("finventoryBuyInventory")
                net.WriteString(k)
                net.SendToServer()
            end
        else
            local BoughtText = vgui.Create("DLabel", buttonBackgroundItem)
            BoughtText:SetPos(scrw * 250 / 1920, scrh * 125 / 1080)
            BoughtText:SetSize(scrw * 200 / 1920, scrh * 50 / 1080)
            BoughtText:SetFont("FInventorySmallFont") 
            BoughtText:SetText("") 
            BoughtText:SetColor(finventoryConfig.Theme.successColor)
            BoughtText.Paint = function(self, w, h)
                draw.DrawText(finventoryConfig.Language.bought, "FInventorySmallFont", w/7.5, h/2 - h/5, finventoryConfig.Theme.successColor, TEXT_ALIGN_CENTER)
            end
        end
        backpackGrid:AddItem(backpackCard)
    end
end
net.Receive('finventoryGetVendorDerma', function(len)
    local ply = net.ReadEntity() 
    showVendorDerma(ply) 
end)