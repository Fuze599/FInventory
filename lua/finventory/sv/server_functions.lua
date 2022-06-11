if false then

    util.AddNetworkString( "finventoryBuyInventory" )
    util.AddNetworkString( "finventorySendNotification" )
    util.AddNetworkString( "finventoryUpdateCSModel" )
    util.AddNetworkString( "finventoryDropItem" )
    util.AddNetworkString( "finventoryDropBag" )
    util.AddNetworkString( "finventoryTransferItem" )
    util.AddNetworkString( "finventoryDeleteIllegalItems" )
    util.AddNetworkString( "finventoryChangeInspectionMode" )
    util.AddNetworkString( "finventoryShowConfigDerma" )
    util.AddNetworkString( "finventoryRetrieveConfig" )
    util.AddNetworkString( "finventoryWriteConfig" )
    util.AddNetworkString( "finventoryShowPlayerInventory" )
    
    local meta = FindMetaTable( "Player" ) 

    function meta:sendNotification( msg ) 
        net.Start( "finventorySendNotification" ) 
        net.WriteEntity( self )
        net.WriteString( msg )
        net.Send( self )
    end

    // Remove against payment all illegal articles (used by policeman)
    function meta:deleteIllegalItems( policeman )
        if not IsValid( policeman ) or not IsValid( self ) then return end
        if policeman:GetPos():Distance( self:GetPos() ) > finventoryConfigInGame.distanceChecker.value then 
            policeman:sendNotification( finventoryConfig.Language["You're too far from the person"][finventoryConfigInGame.lang.value] )
            return false
        end
        if finventoryConfigInGame.isGamemodeDarkRP.value and not policeman:isCP() then 
            policeman:sendNotification( finventoryConfig.Language["You're not a policeman!"][finventoryConfigInGame.lang.value] )
            return false
        end

        local inventory = self.finventoryInventory
        if #inventory == 0 then return false end
        
        // Retrieve indexs of illegals items
        local removedIndexTab = {}
        for k, v in pairs( inventory ) do
            if finventoryConfig.illegalEntities[ v[1] ] then
                table.insert( removedIndexTab, k )
            end 
        end
        // Delete items via retrieved indexes
        local totalItemsRemoved = 0
        for k, v in pairs( removedIndexTab ) do
            table.remove( inventory, v - totalItemsRemoved )
            totalItemsRemoved = totalItemsRemoved + 1
        end
        self.finventoryInventory = inventory

        // Manage notification for the policeman and the pay him if necessary
        local notificationPoliceman = finventoryConfig.Language["You have removed"][finventoryConfigInGame.lang.value] .. " " ..
            totalItemsRemoved .. " " .. finventoryConfig.Language["illegal items"][finventoryConfigInGame.lang.value]  .. "!"

        if finventoryConfigInGame.removeIllegalItemPay.value > 0 and finventoryConfigInGame.isGamemodeDarkRP.value then
            policeman:addMoney( totalItemsRemoved * finventoryConfigInGame.removeIllegalItemPay.value )

            notificationPoliceman = finventoryConfig.Language["You have removed"][finventoryConfigInGame.lang.value] .. " " .. 
            totalItemsRemoved .. " " .. finventoryConfig.Language["illegal items"][finventoryConfigInGame.lang.value] .. " " ..
            finventoryConfig.Language["for"][finventoryConfigInGame.lang.value] .. " "  .. totalItemsRemoved * 
            finventoryConfigInGame.removeIllegalItemPay.value .. finventoryConfigInGame.currency.value .."!"

        end

        self:sendNotification( finventoryConfig.Language["You have had"][finventoryConfigInGame.lang.value] .. " " 
        .. totalItemsRemoved .. " " .. finventoryConfig.Language["items requisitioned!"][finventoryConfigInGame.lang.value] ) 
        policeman:sendNotification( notificationPoliceman ) 
        return true
    end
    net.Receive( "finventoryDeleteIllegalItems", function( len, ply ) 
        local suspectedPly = net.ReadEntity()
        suspectedPly:deleteIllegalItems( ply ) 
    end)
    
    // Transfer an item from one inventory to another
    function meta:transferItem( indexRemovedItem, indexNewPlace, isItemFromBank )
        if not IsValid( self ) then return end

        local inventory = self.finventoryInventory
        if #inventory == 0 then return false end
        
        local inventoryProperties = getInventoryPropertiesByUniqueName( inventory[1] )
        if not inventoryProperties then return end

        local bank = self.finventoryBank
        if not bank then return end

        if isItemFromBank then 
            local removedItem = table.remove( bank, indexRemovedItem )
            if not removedItem or indexNewPlace > inventoryProperties.place + 1 or indexNewPlace < 1 then return end
            table.insert(inventory, indexNewPlace, removedItem) 
        else
            local removedItem = table.remove( inventory, indexRemovedItem )
            if not removedItem or indexNewPlace > finventoryConfigInGame.bankPlace.value or indexNewPlace < 1 then return end
            table.insert(bank, indexNewPlace, removedItem) 
        end
    
        self.finventoryBank = bank
        self.finventoryInventory = inventory
    end
    net.Receive( "finventoryTransferItem", function( len, ply ) 
        local indexRemovedItem = net.ReadUInt( 32 )
        local indexNewPlace = net.ReadUInt( 32 )
        local isItemFromBank = net.ReadBool()
        ply:transferItem( indexRemovedItem, indexNewPlace, isItemFromBank ) 
    end)
    
    // Buy a new backpack
    function meta:buyInventory( inventoryUniqueName ) 
        if not IsValid( self ) then return end
        local inventoryProperties = getInventoryPropertiesByUniqueName( inventoryUniqueName )
        if not inventoryProperties or inventoryProperties.isPocket then return end

        if finventoryConfigInGame.isGamemodeDarkRP.value then
            if self:canAfford( inventoryProperties.price ) then
                if self:changeInventory( inventoryProperties ) then 
                    self:addMoney( -inventoryProperties.price )
                    self:sendNotification( finventoryConfig.Language["You've bought a new backpack for "][finventoryConfigInGame.lang.value] 
                                           .. inventoryProperties.price .. " " .. finventoryConfigInGame.currency.value .. " !" ) 
                end
            else 
                self:sendNotification( finventoryConfig.Language["You don't have enought money!"][finventoryConfigInGame.lang.value] ) 
            end
        else
            if self:changeInventory( inventoryProperties ) then
                self:sendNotification( finventoryConfig.Language["You bought a new backpack!"][finventoryConfigInGame.lang.value] ) 
            end
        end        
    end
    net.Receive( "finventoryBuyInventory", function( len, ply ) 
        local inventoryUniqueName = net.ReadString()
        ply:buyInventory( inventoryUniqueName ) 
    end)

    // Change the backpack of a player
    function meta:changeInventory( inventoryProperties )
        if not IsValid( self ) then return false end
        local inventory = self.finventoryInventory
        if #inventory == 0 then return false end
        local newInventory = { inventoryProperties.uniqueName }

        // If there is item in the current pocket
        if ( inventory and #inventory > 1 ) then
            if ( inventoryProperties.place + 1 < #inventory ) then
                self:sendNotification( finventoryConfig.Language["You have too much items in you current bag!"][finventoryConfigInGame.lang.value] ) 
                return false
            end
            inventory[1] = inventoryProperties.uniqueName
            newInventory = inventory
        end

        self.finventoryInventory = newInventory
        self:loadInventory()
        return true
    end
    
    // Drop an entity from the player's inventory
    function meta:dropItem( index ) 
        if not IsValid( self ) then return end
        local inventory = self.finventoryInventory
        if ( #inventory + 1 < index || index < 1 ) then 
            self:sendNotification( finventoryConfig.Language["You cannot drop this!"][finventoryConfigInGame.lang.value] ) 
            return 
        end
        local removedItem = table.remove( inventory, index )
        if not removedItem then return end
        
        local tr = util.TraceLine({
            start = self:EyePos(),
            endpos = self:EyePos() + self:EyeAngles():Forward() * 60,
            filter = self
        })

        if #removedItem == 3 then --> entity
            local spawnedEntity = ents.Create( removedItem[1] )
            if not IsValid( spawnedEntity ) then return end
            spawnedEntity:SetPos( tr.HitPos )
            spawnedEntity:Spawn()

        elseif #removedItem == 4 then --> spawned weapon
            local spawnedWeapon = ents.Create( "spawned_weapon" )
            if not IsValid( spawnedWeapon ) then return end
            spawnedWeapon:SetWeaponClass( removedItem[1] )
			spawnedWeapon:SetModel( removedItem[2] )
			spawnedWeapon:Setamount( removedItem[4] )
            spawnedWeapon:SetPos( tr.HitPos )
            spawnedWeapon:Spawn()

        elseif #removedItem == 5 then --> spawned shipment
            local spawnedShipment = ents.Create( "spawned_shipment" )
            if not IsValid( spawnedShipment ) then return end
            spawnedShipment:Setcount( removedItem[4] )
			spawnedShipment:Setcontents( removedItem[5] )
            spawnedShipment:SetPos( tr.HitPos )
            spawnedShipment:Spawn()
        end
    
        self.finventoryInventory = inventory
        self:sendNotification( finventoryConfig.Language["You dropped an item!"][finventoryConfigInGame.lang.value] ) 
    end
    net.Receive( "finventoryDropItem", function( len, ply ) 
        local index = net.ReadUInt( 32 )
        ply:dropItem( index ) 
    end)
    
    // Drop the current bag
    function meta:dropBag( hasNotification )
        if not IsValid( self ) then return end
        local inventory = self.finventoryInventory
        if #inventory == 0 then return false end

        local inventoryProperties = getInventoryPropertiesByUniqueName( inventory[1] )
        if not inventoryProperties then return end

        if inventoryProperties.isPocket then
            if ( #inventory < 2 ) then return end 
            inventoryProperties.modelExt = "models/props_junk/cardboard_box001a.mdl"
        end

        if not inventoryProperties.modelExt then
            inventoryProperties.modelExt = inventoryProperties.model
        end
    
        self.finventoryInventory = {"nothing"}
        self:loadInventory()

        local tr = util.TraceLine({
            start = self:EyePos(),
            endpos = self:EyePos() + self:EyeAngles():Forward() * 60,
            filter = self
        })
        local spawnedEntity = ents.Create( "finventory_base_backpack" )
        spawnedEntity:SetPos( tr.HitPos )
        spawnedEntity:SetModel( inventoryProperties.modelExt )
        spawnedEntity:SetAngles( Angle(0, 0, 0) )
        spawnedEntity.inventory = inventory
        spawnedEntity.Owner = self
        spawnedEntity:Spawn()

        if hasNotification then
            self:sendNotification( finventoryConfig.Language["You dropped your bag!"][finventoryConfigInGame.lang.value] ) 
        end
    end
    net.Receive( "finventoryDropBag", function( len, ply ) ply:dropBag( true ) end)

    function meta:showPlayerInventory( ply )
        if not IsValid( self ) or not self:IsAdmin() or not IsValid( ply ) then return end
        local inventory = ply.finventoryInventory 
        local bank = ply.finventoryBank

        net.Start("finventoryGetInventoryDerma")
        net.WriteEntity( ply )
        net.WriteTable( inventory )
        net.WriteBool( true )
        net.Send( self )
    end
    net.Receive( "finventoryShowPlayerInventory", function( len, ply ) 
        local playerChecked = net.ReadEntity()
        ply:showPlayerInventory( playerChecked ) 
    end)
    
    // Pick up a dropped backpack
    function meta:pickupBackpack( backpack )
        if not IsValid( self ) then return end
        local oldInventory = self.finventoryInventory
        if #oldInventory == 0 then return end
        local oldInventoryProperties
        if oldInventory[1] != "nothing" then
            oldInventoryProperties = getInventoryPropertiesByUniqueName( oldInventory[1] )
        end

        local newInventoryProperties = getInventoryPropertiesByUniqueName( backpack.inventory[1] )
        local newInventoryPlace = #backpack.inventory - 1

        local notificationStr = finventoryConfig.Language["Drop your current bag!"][finventoryConfigInGame.lang.value]

        // If you are able to pick up the bag
        if not oldInventoryProperties and #oldInventory - 1 + newInventoryPlace <= newInventoryProperties.place then
            // Merge the inventories
            table.remove( oldInventory, 1 )
            table.Add( backpack.inventory, oldInventory )
            self.finventoryInventory = backpack.inventory
            self:loadInventory()
            backpack:Remove()

            if newInventoryProperties.isPocket then
                notificationStr = finventoryConfig.Language["You taken a box!"][finventoryConfigInGame.lang.value]
            else
                notificationStr = finventoryConfig.Language["You've taken a bag!"][finventoryConfigInGame.lang.value]
            end
        elseif not oldInventoryProperties then
            notificationStr = finventoryConfig.Language["Drop your items first!"][finventoryConfigInGame.lang.value]
        end

        self:sendNotification( notificationStr ) 
    end 
    
    // Retrieve all the informations from the json file and update player inventory vars
    function meta:loadInventory() 
        if not IsValid( self ) then return end
        local inventory = self.finventoryInventory
        if #inventory == 0 then return end
        local inventoryProperties = getInventoryPropertiesByUniqueName( inventory[1] )
        if not inventoryProperties then return end

        // If there is no backpack
        if inventoryProperties.isPocket then
            inventoryProperties.model = ""
            inventoryProperties.uniqueName = ""
            if inventory and inventory[1] != "nothing" then
                inventory[1] = "nothing"
                self.finventoryInventory = inventory
            end
        end
    
        // Update the model of the player
        net.Start( "finventoryUpdateCSModel" )
        net.WriteEntity( self )
        net.WriteString( inventoryProperties.uniqueName )
        net.Broadcast()
        return inventory
    end

    // Add an item to a player backpack
    function meta:pickupItem( entity )
        if not IsValid( self ) then return end
        local playerInventory = self.finventoryInventory
        if #playerInventory == 0 then return end
        local inventoryProperties = getInventoryPropertiesByUniqueName( playerInventory[1] )
        if not inventoryProperties then return end
        
        // If there is no more place or if the item is not accepted
        if inventoryProperties.place < #playerInventory
                or not finventoryConfig.acceptedEntities[entity:GetClass()] then return end

        // If there is custom item name, do the modification
        if ( finventoryConfig.customItemsName[class] ) then
            entity.PrintName = finventoryConfig.customItemsName[class]
        end
        
        // Specific config for weapons
        local class = entity:GetClass()
        local tab = { class, entity:GetModel(), entity.PrintName }
        if class == "spawned_weapon" then 
            class = entity:GetWeaponClass() 
            if weapons.Get( class ) and weapons.Get( class ).PrintName then 
                entity.PrintName = weapons.Get( class ).PrintName 
            end
            tab = { class, entity:GetModel(), entity.PrintName, entity:Getamount() }
        elseif class == "spawned_shipment" then
            tab = { class, entity:GetModel(), entity.PrintName, entity:Getcount(), entity:Getcontents()  }
        end
        table.insert( playerInventory, tab )

        self.finventoryInventory = playerInventory
        entity:Remove()
        return playerInventory
    end

    // retrieve the config from the json file
    function retrieveConfig() 
        local path = "finventory/finventory_config.json"
        local tab = {}
        for k, v in pairs( finventoryConfigInGame ) do
            tab[k] = v.value
        end
        local config = retrieveInFile( path, tab )
        for k, v in pairs( config ) do
            finventoryConfigInGame[k].value = v
        end

        return config
    end
    net.Receive( "finventoryRetrieveConfig", function( len, ply ) 
        if not IsValid( ply ) and not ply:IsAdmin() then return end
        local config = retrieveConfig() 
        net.Start( "finventoryShowConfigDerma" ) 
        net.WriteTable( config )
        net.Send( ply )
    end)

    function retrieveInFile( path, baseTable ) 
        local f = file.Open( path, "r", "DATA" )
        if not f then
            if not file.Exists( "finventory", "DATA" ) then 
                file.CreateDir("finventory")  
            end
            file.Write( path, util.TableToJSON( baseTable ) )
            f = file.Open( path, "r", "DATA" )
        end  
        local jsonTable = f:Read()
        local inventory = {}
        if jsonTable then
            inventory = util.JSONToTable( jsonTable ) 
        end
        f:Close()
        return inventory
    end

    // Write anything into the player json file
    function meta:writeBagInFile( tableInventory ) 
        if not IsValid( self ) then return end
        local path = "finventory/finventory_" .. self:SteamID64() .. ".json"
        writeInFile( tableInventory, path )
    end
    
    // Write anything into the player bank json file
    function meta:writeBankInFile( tableInventory ) 
        if not IsValid( self ) then return end
        local path = "finventory/finventory_bank_" .. self:SteamID64() .. ".json"
        writeInFile( tableInventory, path )
    end

    // Write anything into the player bank json file
    function meta:writeConfigInFile( tableConfig ) 
        if not IsValid( self ) or not self:IsAdmin() then return end
        writeInFile( tableConfig, "finventory/finventory_config.json" )
    end
    net.Receive( "finventoryWriteConfig", function( len, ply ) 
        local tableConfig = net.ReadTable()
        ply:writeConfigInFile( tableConfig ) 
    end)
    
    function writeInFile( tableInventory, path ) 
        if not tableInventory then return end
        local f = file.Open( path, "r", "DATA" )
        if not f then
            if not file.Exists( "finventory", "DATA" ) then 
                file.CreateDir("finventory")  
            end
        end  
        f:Close()
        file.Write( path, util.TableToJSON( tableInventory ) )
    end
    
    // Load inventory on player spawn
    hook.Add("PlayerSpawn", "ReloadInventoryOnSpawn", function(ply)
        if not timer.Exists("InitialSpawnLoadAttributes") then ply:loadInventory() end
    end)
    
    // Drop inventory on death
    if finventoryConfigInGame.dropOnDeath.value then
        hook.Add( "PlayerDeath", "DropOnDeath", function(ply)
            ply:dropBag( false )
        end)
    end
    
    // Drop or save inventory on disconnect
    if not finventoryConfigInGame.deleteInventoryOnDisconnect.value then
        hook.Add( "PlayerDisconnected", "DeleteOnDisconnected", function(ply)
            if not finventoryConfigInGame.deleteInventoryOnDisconnect.value then
                writeInFile( ply.finventoryInventory, "finventory/finventory_" .. ply:SteamID64() .. ".json" )
                writeInFile( ply.finventoryBank, "finventory/finventory_bank_" .. ply:SteamID64() .. ".json" )
            else
                writeInFile( {"nothing"}, "finventory/finventory_" .. ply:SteamID64() .. ".json" )
                writeInFile( {}, "finventory/finventory_bank_" .. ply:SteamID64() .. ".json" )
            end
        end)
    end
    
    // Init backpack dropped from the F4 menu
    hook.Add( "playerBoughtCustomEntity", "dropCustomBackpackEntity", function(ply, tab, ent)
        if not tab.modelExt then
            tab.modelExt = tab.model
        end
        if ent:GetClass() == 'finventory_base_backpack' then
            ent:SetModel( tab.modelExt )
            ent:PhysicsInit( SOLID_VPHYSICS )
            ent:SetMoveType( MOVETYPE_VPHYSICS )
            ent:SetSolid( SOLID_VPHYSICS )
            ent.inventory = { tab.cmd }
            local phys = ent:GetPhysicsObject()
            if phys:IsValid() then
                phys:Wake()
            end
        end
    end)   

    retrieveConfig() 

end 