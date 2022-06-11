
if CLIENT then

    local function showAdminVgui( configTable, selector ) 

        local backgroundFrame = vgui.Create( 'DButton' )
        backgroundFrame:SetSize( ScrW(), ScrH() )
        backgroundFrame:SetCursor( "arrow" )
        backgroundFrame:SetText( "" )
        backgroundFrame.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0) )
        end
        backgroundFrame.DoClick = function(self) backgroundFrame:Remove() end
        backgroundFrame.DoRightClick = function(self) backgroundFrame:Remove() end

        function backgroundFrame:Think()
            net.Receive('finventoryCloseDerma', function()
                backgroundFrame:Remove()
            end)	
        end

        // Main panel
        local mainFrame = vgui.Create( 'DFrame', backgroundFrame )
        mainFrame:SetSize( ScrW() * 0.6, ScrH() * 0.55 )
        mainFrame:SetTitle( '' )
        mainFrame:Center()
        mainFrame:SetVisible( true )
        mainFrame:SetDraggable( false )
        mainFrame:SetBackgroundBlur( true )
        mainFrame:ShowCloseButton( false )
        mainFrame:MakePopup()
        mainFrame.Paint = function(self,w,h)
            draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50) )
        end

        local leftBar = vgui.Create( "DPanel", mainFrame)
        leftBar:SetSize( 220, ScrH() * 0.55 ) 
        leftBar:SetPos( 0, 0 )
        leftBar.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40 ) )
        end 

        local upperBar = vgui.Create( "DPanel", mainFrame)
        upperBar:SetSize( ScrW() * 0.6, ScrH() * 40 / 1080 ) 
        upperBar:SetPos( 0, 0 )
        upperBar.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40 ) )
        end 

        local closeButton = vgui.Create( "DButton", mainFrame )
        closeButton:SetPos( ScrW() * 1120 / 1920, ScrH() * 10 / 1080 )
        closeButton:SetSize( ScrW() * 20 / 1920, ScrH() * 20 / 1080 )
        closeButton:SetFont( "FInventorySmallFont" )
        closeButton:SetText( "" )
        closeButton:SetCursor( "hand" )
        closeButton.Paint = function(self,w,h)
            draw.RoundedBox(100, 0, 0, w, h, Color(201, 10, 10) )
        end
        closeButton.DoClick = function() backgroundFrame:Remove() end

        // Main title
        local mainTitle = vgui.Create( "DLabel", mainFrame )
        mainTitle:SetPos( ScrW() * 15 / 1920, ScrH() * -6 / 1080 )
        mainTitle:SetSize( 0.25 * ScrW(), ScrH() / 21,6 )
        mainTitle:SetFont( "FInventoryLargeFont" )
        mainTitle:SetText( "Admin panel" )

        local scroller = vgui.Create( "DScrollPanel", mainFrame )
        scroller:SetPos( ScrW() * 220 / 1920, ScrH() * 40 / 1080 )
        scroller:SetSize( ScrW() * 930 / 1920, ScrH() * 550 / 1080 )

        local sbar = scroller:GetVBar()
        sbar:SetHideButtons(true)
        sbar.Paint = function(self,w,h)
            draw.RoundedBox( 5, 0, 0, w, h, Color(20, 20, 20, 255) )
        end
        sbar.btnGrip.Paint = function(self,w,h)
            draw.RoundedBox( 5, 0, 0, w, h, Color(30, 30, 30, 255) )
        end
        
        local allInventoryButton = vgui.Create( "DButton", mainFrame )
        allInventoryButton:SetPos( ScrW() * 10 / 1920, ScrH() * 50 / 1080 )
        allInventoryButton:SetSize( ScrW() * 200 / 1920, ScrH() * 50 / 1080 )
        allInventoryButton:SetFont( "FInventorySmallFont" )
        allInventoryButton:SetText( "All inventory" )
        allInventoryButton:SetCursor( "hand" )
        allInventoryButton.Paint = function(self,w,h)
            draw.RoundedBox(5, 0, 0, w, h, Color(30, 30, 30) )
        end
        allInventoryButton.DoClick = function()
            backgroundFrame:Remove()
            showAdminVgui( configTable, 1 )
        end

        local basicConfigButton = vgui.Create( "DButton", mainFrame )
        basicConfigButton:SetPos( ScrW() * 10 / 1920, ScrH() * 110 / 1080 )
        basicConfigButton:SetSize( ScrW() * 200 / 1920, ScrH() * 50 / 1080 )
        basicConfigButton:SetFont( "FInventorySmallFont" )
        basicConfigButton:SetText( "Basic configuration" )
        basicConfigButton:SetCursor( "hand" )
        basicConfigButton.Paint = function(self,w,h)
            draw.RoundedBox(5, 0, 0, w, h, Color(30, 30, 30) )
        end
        basicConfigButton.DoClick = function()
            backgroundFrame:Remove()
            showAdminVgui( configTable, 2 )
        end

        local saveButton = vgui.Create( "DButton", mainFrame )
        saveButton:SetPos( ScrW() * 35 / 1920, ScrH() * 170 / 1080 )
        saveButton:SetSize( ScrW() * 150 / 1920, ScrH() * 50 / 1080 )
        saveButton:SetFont( "FInventorySmallFont" )
        saveButton:SetText( "Save" )
        saveButton:SetCursor( "hand" )
        saveButton.Paint = function(self,w,h)
            draw.RoundedBox(5, 0, 0, w, h, Color(30, 30, 30) )
        end
        saveButton.DoClick = function()
            net.Start( "finventoryWriteConfig" )
            net.WriteTable( configTable )
            net.SendToServer()
        end

        if selector and selector == 2 then
            showBasicConfig( configTable, mainFrame, scroller )
        else
            showInventory( configTable, mainFrame, scroller )
        end
    end
    net.Receive( "finventoryShowConfigDerma", function( len, ply ) 
        local configTable = net.ReadTable()
        showAdminVgui( configTable, mainFrame, scroller ) 
    end)

    function showInventory( configTable, mainFrame, scroller )
        local titleInventory = scroller:Add( "DLabel" )
        titleInventory:SetPos( 5, 5 )
        titleInventory:SetSize( 400, 30 )
        titleInventory:SetFont( "FInventoryLargeFont" )
        titleInventory:SetText( "Inventories" )

        
        // Grid
        local grid = vgui.Create( "DGrid", scroller )
        grid:SetPos( 0, 0 )
        grid:SetCols( 3 )
        grid:SetColWide( ScrW() / 11.53 )
        grid:SetRowHeight( ScrH() / 6.48 )

        local pos = 0
        for k, v in pairs( player.GetAll() ) do
            local buttonBackgroundItem = scroller:Add( "DButton" )
            buttonBackgroundItem:SetPos( 20, 50 + pos )
            buttonBackgroundItem:SetSize( 890, 100 )
            buttonBackgroundItem:SetText( "" )
            buttonBackgroundItem:SetCursor( "arrow" )
            buttonBackgroundItem.Paint = function(self,w,h)
                draw.RoundedBox(5, 0, 0, w, h, Color(30, 30, 30) )
            end

            local dlabelPlayerName = scroller:Add( "DLabel" )
            dlabelPlayerName:SetPos( 30, 25 + pos )
            dlabelPlayerName:SetSize( 500, 100 )
            dlabelPlayerName:SetFont( "FInventoryMediumFont" )
            dlabelPlayerName:SetText( v:GetName() )

            local dlabelPlayerID = scroller:Add( "DLabel" )
            dlabelPlayerID:SetPos( 40, 50 + pos )
            dlabelPlayerID:SetSize( 500, 100 )
            dlabelPlayerID:SetFont( "FInventorySmallFont" )
            dlabelPlayerID:SetText( v:SteamID() )

            local buttonBackgroundItem = scroller:Add( "DButton" )
            buttonBackgroundItem:SetPos( 720, 75 + pos )
            buttonBackgroundItem:SetSize( 150, 50 )
            buttonBackgroundItem:SetText( "Voir l'inventaire" )
            buttonBackgroundItem.Paint = function(self,w,h)
                draw.RoundedBox(5, 0, 0, w, h, Color(40, 40, 40) )
            end
            buttonBackgroundItem.DoClick = function()
                mainFrame:Remove()
                net.Start( "finventoryShowPlayerInventory" )
                net.WriteEntity( v )
                net.SendToServer()
            end	

            pos = pos + 120
        end
    end

    function showBasicConfig( configTable, mainFrame, scroller ) 
        for k, v in pairs ( finventoryConfigInGame ) do
            local explanation = scroller:Add( "DLabel" )
            explanation:SetPos( 40, 40 )
            explanation:SetFont( "FInventorySmallFont" )
            explanation:SetText( finventoryConfigInGame[k].explanation )
            explanation:Dock( TOP )
            explanation:DockMargin( 5, 5, 5, 5 )

            if finventoryConfigInGame[k].configType == 'boolean' then
                local value = "true"
                if not finventoryConfigInGame[k].tab then 
                    finventoryConfigInGame[k].tab = {"true", "false"} 
                end

                if type( configTable[k] ) == "boolean" then
                    if configTable[k] then 
                        value = "true" 
                    else 
                        value = "false" 
                    end
                else
                    value = configTable[k]
                end

                local DComboBox = scroller:Add( "DComboBox" )
                DComboBox:SetPos( 5, 30 )
                DComboBox:SetSize( 100, 20 )
                DComboBox:DockMargin( 5, 5, 5, 5 )
                DComboBox:SetFont( "FInventorySmallFont" )
                DComboBox:SetSize( 100, 40 )
                DComboBox:Dock( TOP )
                DComboBox:SetValue( value )
                for k2, v2 in pairs ( finventoryConfigInGame[k].tab ) do
                    DComboBox:AddChoice( v2 )
                end  
                DComboBox.OnSelect = function( self, index, value )
                    configTable[k] = value
                    finventoryConfigInGame[k].value = value
                end
            elseif v.configType == "entry" then
                local TextEntry = scroller:Add( "DTextEntry" )
                TextEntry:Dock( TOP )
                TextEntry:DockMargin( 5, 5, 5, 5 )
                TextEntry:SetFont( "FInventorySmallFont" )
                TextEntry:SetSize( 100, 40 )
                TextEntry:SetUpdateOnType( true )
                TextEntry:SetValue( configTable[k] )
                TextEntry.OnValueChange = function( self )
                    configTable[k] = self:GetValue()
                    finventoryConfigInGame[k].value = self:GetValue()
                end
            elseif v.configType == "list" then
                local DermaButton = scroller:Add( "DButton" )
                DermaButton:SetText( "See the list" )		
                DermaButton:Dock( TOP )
                DermaButton:DockMargin( 5, 5, 5, 5 )			
                DermaButton:SetPos( 25, 50 )					
                DermaButton.DoClick = function()	
                    local frame = vgui.Create( "DButton" )
                    frame:SetSize( ScrW(), ScrH() )
                    frame:SetText( "" )
                    frame:MakePopup()	
                    frame.DoClick = function()
                        frame:Remove()
                    end	
                    function frame:Paint( w, h )
                        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
                    end

                    local panel = vgui.Create( "DPanel", frame )
                    panel:SetSize( 500, 500 )
                    panel:SetText( "" )
                    panel:Center()
                    panel:MakePopup()	
                    function panel:Paint( w, h )
                        draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 255 ) )
                    end

                    local scrollerEntities = vgui.Create( "DScrollPanel", panel )
                    scrollerEntities:SetPos( 0, 0 )
                    scrollerEntities:SetSize( ScrW() * 400 / 1920, ScrH() * 50 / 1080 )

                    local TextEntry = vgui.Create( "DTextEntry", scrollerEntities ) -- create the form as a child of frame
                    TextEntry:Dock( TOP )
                    TextEntry.OnEnter = function( self )
                        chat.AddText( self:GetValue() )
                    end
                
                    local TextEntryPH = vgui.Create( "DTextEntry", scrollerEntities )
                    TextEntryPH:Dock( TOP )
                    TextEntryPH:DockMargin( 0, 5, 0, 0 )
                    TextEntryPH:SetPlaceholderText( "I am a placeholder" )
                    TextEntryPH.OnEnter = function( self )
                        chat.AddText( self:GetValue() )
                    end

                    -- local TextEntry = vgui.Create( "DTextEntry", panel )
                    -- TextEntry:Dock( BOTTOM )
                    -- TextEntry:DockMargin( 5, 15, 5, 5 )
                    -- TextEntry:SetFont( "FInventorySmallFont" )
                    -- TextEntry:SetSize( 100, 40 )
                    -- TextEntry:SetUpdateOnType( true )
                    -- TextEntry:SetValue( configTable[k] )
                    -- TextEntry.OnValueChange = function( self )
                    --     configTable[k] = self:GetValue()
                    --     finventoryConfigInGame[k].value = self:GetValue()
                    -- end

                end

            elseif v.configType == "number" then
                local Wang = scroller:Add( "DNumberWang" )
                Wang:Dock( TOP )
                Wang:DockMargin( 5, 5, 5, 5 )
                Wang:SetFont( "FInventorySmallFont" )
                Wang:SetSize( 100, 40 )
                Wang:SetMin(0)
                Wang:SetMax(10000)
                Wang:SetValue( configTable[k] )
                Wang.OnValueChange = function( self )
                    configTable[k] = self:GetValue()
                    finventoryConfigInGame[k].value = self:GetValue()
                end
            end
        end
    end

    -- hook.Add( "KeyPress", "xdced0", function( ply, key ) 
    --     if ( key == IN_USE ) then
    --         net.Start("finventoryRetrieveConfig")
    --         net.SendToServer()
    --     end
    -- end )
    -- concommand.Add('finventory_admin', function(len) showAdminVgui( ) end)
end