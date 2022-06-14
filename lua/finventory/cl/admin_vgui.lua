
if not CLIENT then return end

function showAdminVgui( configTable, selector ) 

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
    mainTitle:SetSize(0.25 * ScrW(), ScrH() / 21,6 )
    mainTitle:SetFont("FInventoryLargeFont" )
    mainTitle:SetText("Admin panel" )
    
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


    local scroller = getAdminScroller(mainFrame)

    local TextEntry = vgui.Create( "DTextEntry", mainFrame ) -- create the form as a child of frame
    TextEntry:SetPos( ScrW() * 440 / 1920, ScrH() * 75 / 1080 )
    TextEntry:SetSize( 0.25 * ScrW(), ScrH() / 21,6 )
    TextEntry:SetFont("FInventoryMediumFont")
    TextEntry:SetPlaceholderText( " Search a player" )
    function TextEntry:GetAutoComplete(text) 
        scroller:Remove()
        scroller = getAdminScroller(mainFrame)
        local pos = 0
        for k, v in ipairs( player.GetAll() ) do
            if string.StartWith(string.lower(v:Nick()), string.lower(text)) or not v:IsBot() 
                and (string.StartWith(string.lower(tostring(v:SteamID())), string.lower(text)) 
                or string.StartWith(string.lower(tostring(v:SteamID64())), string.lower(text))) then

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
                    scroller:Remove()
                    scroller = getAdminScroller(mainFrame)


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

                    net.Start("finventoryShowInventoryAsAdmin")
                    net.WriteEntity(v)
                    net.SendToServer()
                    
                    function dlabelPlayerName:Think()
                        net.Receive("finventoryShowInventoryAsAdminRet", function(len) 
                            local configTable = net.ReadTable()
                            PrintTable(configTable)
                        end)
                    end
                    
                end	
                pos = pos + 120
            end
        end
    end
end
net.Receive( "finventoryShowConfigDerma", function( len, ply ) 
    local configTable = net.ReadTable()
    showAdminVgui( configTable, mainFrame, scroller ) 
end)


hook.Add("KeyPress", "xdced0", function(ply, key) 
    if key == IN_USE then
        -- showAdminVgui()
    end
end)


function getAdminScroller(mainFrame)
    local scroller = vgui.Create( "DScrollPanel", mainFrame )
    scroller:SetPos( ScrW() * 220 / 1920, ScrH() * 140 / 1080 )
    scroller:SetSize( ScrW() * 930 / 1920, ScrH() * 550 / 1080 )

    local sbar = scroller:GetVBar()
    sbar:SetHideButtons(true)
    sbar.Paint = function(self,w,h)
        draw.RoundedBox( 5, 0, 0, w, h, Color(20, 20, 20, 255) )
    end
    sbar.btnGrip.Paint = function(self,w,h)
        draw.RoundedBox( 5, 0, 0, w, h, Color(30, 30, 30, 255) )
    end

    return scroller
end