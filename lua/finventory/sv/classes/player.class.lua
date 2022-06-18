if not SERVER then return end

util.AddNetworkString("finventorySendNotification")
util.AddNetworkString("finventoryDropItem")
util.AddNetworkString("finventoryUpdateCSModel")
util.AddNetworkString("finventoryDropInventory")
util.AddNetworkString("finventoryTransferItemFromBankToInventory")
util.AddNetworkString("finventoryTransferItemFromInventoryToBank")
util.AddNetworkString("finventoryBuyInventory")
util.AddNetworkString("finventoryChangeInspectionMode")
util.AddNetworkString("finventoryShowLoadBar")
util.AddNetworkString("finventoryDeleteIllegalItems")
util.AddNetworkString("finventoryGetInventoryDerma")
util.AddNetworkString("finventoryCloseDerma")
util.AddNetworkString("finventoryShowInventoryAsAdminRet")
util.AddNetworkString("finventoryShowInventoryAsAdmin")
util.AddNetworkString("finventoryDeleteInventory")

local ply = FindMetaTable("Player")

function ply:retrieveInventoryFromFile()
    if not IsValid(self) then return end

    local inventoryPath = "finventory_" .. self:SteamID64() .. ".json"
    local baseFileValue = {uniqueName = "", content = {}}
    local fileContent = retrieveFileContent(inventoryPath, baseFileValue)

    local inventoryTable = util.JSONToTable(fileContent)

    local inventoryUniqueName = inventoryTable.uniqueName
    local inventoryContent = inventoryTable.content

    return Inventory(self, inventoryUniqueName, inventoryContent)
end

function ply:retrieveBankFromFile()
    if not IsValid(self) then return end

    local bankPath = "finventory_bank_" .. self:SteamID64() .. ".json"
    local baseFileValue = {}
    local fileContent = retrieveFileContent(bankPath, baseFileValue)

    return Bank(self, fileContent) 
end

function ply:retrieveInventory()
    if not IsValid(self) then return end

    if finventoryConfig.enhancedSaving then
        return self:retrieveInventoryFromFile()
    else
        return self.finventoryInventory
    end
end

function ply:retrieveBank()
    if not IsValid(self) then return end
    if finventoryConfig.enhancedSaving then
        return self:retrieveBankFromFile()
    else
        return self.finventoryBank
    end
end

function retrieveFileContent(storagePath, baseFileValue) 
    local folderName = finventoryConfig.saveFolderName
    if not file.Exists(folderName .. "/" .. storagePath, "DATA") then
        if not file.Exists(folderName, "DATA") then 
            file.CreateDir(folderName)  
        end
        file.Write(folderName .. "/" .. storagePath, util.TableToJSON(baseFileValue))
    end  

    local jsonTable = file.Read(folderName .. "/" .. storagePath, "DATA")
    return jsonTable
end

function ply:sendNotification(msg) 
    if not IsValid(self) then return end
    net.Start("finventorySendNotification") 
    net.WriteEntity(self)
    net.WriteString(msg)
    net.Send(self)
end

function ply:pickupItem(itemEntity)
    if not IsValid(self) then return end
    local inventory = self:retrieveInventory()

    local item = createItem(itemEntity)

    local isInserted = inventory:add(item)
    if not isInserted then return false end

    itemEntity:Remove()
    return true
end

function createItem(itemEntity)
    local itemType = getItemEntityString()
    local class = itemEntity:GetClass()
    local model = itemEntity:GetModel()
    local name = itemEntity.PrintName
    local count
    local content

    if class == finventoryConfig.spawnedWeaponClass then 
        itemType = getItemWeaponString()
        count = itemEntity:Getamount()
        class = itemEntity:GetWeaponClass() 
        
        local weaponName = getWeaponName(class)
        if weaponName then name = weaponName end

    elseif class == finventoryConfig.spawnedShipmentClass then
        itemType = getItemShipmentString()
        count = itemEntity:Getcount()
        content = itemEntity:Getcontents()

        local weaponClass = CustomShipments[content].entity
        local weaponName = getWeaponName(weaponClass)
        if weaponName then name = weaponName end

    elseif class == finventoryConfig.spawnedAmmoClass then
        itemType = getItemAmmoString()
        count = itemEntity.amountGiven
        content = itemEntity.ammoType
    elseif class == finventoryConfig.spawnedFoodClass then
        itemType = getItemFoodString()
        content = itemEntity.foodItem
    end

    return Item(itemType, class, model, name, count, content)
end

function getWeaponName(class) 
    local metaTableWeapon = weapons.Get(class)
    if metaTableWeapon and metaTableWeapon.PrintName then 
        return metaTableWeapon.PrintName 
    end
end

function ply:dropItem(index) 
    if not IsValid(self) then return end
    local inventory = self:retrieveInventory()

    local removedItem = inventory:remove(index)
    if not removedItem then 
        self:sendNotification(finventoryConfig.Language.dropItemFail) 
        return 
    end

    self:spawnItem(removedItem)

    self:sendNotification(finventoryConfig.Language.dropItemSuccess) 
end
net.Receive("finventoryDropItem", function(len, ply) 
    local index = net.ReadUInt(finventoryConfig.maxUIntByte)
    ply:dropItem(index) 
end)

function ply:spawnItem(item)
    if not IsValid(self) or not item then return end

    local traceLine = util.TraceLine({
        start = self:EyePos(),
        endpos = self:EyePos() + self:EyeAngles():Forward() * 60,
        filter = self
    })

    local spawnedItem
    if item:isEntity() then
        spawnedItem = ents.Create(item:getClass())
        if not IsValid(spawnedItem) then return end
    elseif item:isWeapon() then 
        spawnedItem = ents.Create(finventoryConfig.spawnedWeaponClass)
        if not IsValid(spawnedItem) then return end
        spawnedItem:SetWeaponClass(item:getClass())
        spawnedItem:SetModel(item:getModel())
        spawnedItem:Setamount(item:getCount())
    elseif item:isShipment() then
        spawnedItem = ents.Create(finventoryConfig.spawnedShipmentClass)
        if not IsValid(spawnedItem) then return end
        spawnedItem:Setcount(item:getCount())
        spawnedItem:Setcontents(item:getContent())
    elseif item:isAmmo() then
        spawnedItem = ents.Create(finventoryConfig.spawnedAmmoClass)
        if not IsValid(spawnedItem) then return end
        spawnedItem.amountGiven = item:getCount()
        spawnedItem.ammoType = item:getContent()
        spawnedItem:SetModel(item:getModel())
    elseif item:isFood() then
        spawnedItem = ents.Create(finventoryConfig.spawnedFoodClass)
        if not IsValid(spawnedItem) then return end
        spawnedItem.foodItem = item:getContent()
        spawnedItem.FoodEnergy = spawnedItem.foodItem.energy
        spawnedItem:SetModel(item:getModel())
    end

    spawnedItem:SetPos(traceLine.HitPos)
    spawnedItem:SetOwner(self)
    -- spawnedItem:Setowning_ent(self)
    spawnedItem:Spawn()
end

function ply:pickupBackpack(backpack)
    if not IsValid(self) or not backpack then return end

    local formerInventory = self:retrieveInventory()
    if not formerInventory:getIsPocket() then 
        self:sendNotification(finventoryConfig.Language.pickupBackpackFailAlreadyBack) 
        return false
    end

    local newInventory = backpack.finventoryInventory

    local isContentAdded = newInventory:addAllContentOf(formerInventory)
    if not isContentAdded then 
        self:sendNotification(finventoryConfig.Language.pickupBackpackFailTooMuchItem)
        return false 
    end

    backpack:Remove()
    self:loadModel()

    if newInventory:getIsPocket() then
        self:sendNotification(finventoryConfig.Language.pickupBoxSuccess) 
    else
        self:sendNotification(finventoryConfig.Language.pickupBackpackSuccess) 
    end
    
    return true
end 

function ply:loadModel() 
    if not IsValid(self) then return end
    local inventory = self:retrieveInventory()
    net.Start("finventoryUpdateCSModel")
    net.WriteEntity(self)
    net.WriteTable(inventory)
    net.Broadcast()
end

function ply:deleteInventory(eraser)
    if not IsValid(self) or not IsValid(eraser) then return end
    if not eraser:IsAdmin() then return end
    local inventory = self:retrieveInventory()
 
    inventory:dropBackpack()
    self:loadModel() 

    self:sendNotification("Your inventory has been deleted!") 
    eraser:sendNotification("Your have deleted the inventory of " .. self:Nick() .. "!") 
end
net.Receive("finventoryDeleteInventory", function(len, eraser) 
    local ply = net.ReadEntity()
    ply:deleteInventory(eraser) 
end)

function ply:dropInventory(hasNotification)
    if not IsValid(self) then return end
    local inventory = self:retrieveInventory()

    if inventory:getIsPocket() then
        if inventory:isEmpty() then return end 
        inventory:setModelExt("models/props_junk/cardboard_box001a.mdl") 
    end

    self:spawnBackpack(inventory)
 
    inventory:dropBackpack()
    self:loadModel() 

    if hasNotification then
        self:sendNotification(finventoryConfig.Language.dropBackpackSuccess) 
    end
end
net.Receive("finventoryDropInventory", function(len, ply) 
    ply:dropInventory(true) 
end)

function ply:spawnBackpack(inventory)
    if not IsValid(self) then return end

    local traceLine = util.TraceLine({
        start = self:EyePos(),
        endpos = self:EyePos() + self:EyeAngles():Forward() * 60,
        filter = self
    })

    local spawnBackpack = ents.Create("finventory_base_backpack")
    if not IsValid(spawnBackpack) then return end
    spawnBackpack:SetPos(traceLine.HitPos)
    spawnBackpack:SetModel(inventory:getModelExt())
    spawnBackpack.finventoryInventory = inventory
    spawnBackpack:Spawn()
end

function ply:transferItemFromBankToInventory(indexBank, indexInventory)
    if not IsValid(self) then return end

    local inventory = self:retrieveInventory()
    local bank = self:retrieveBank()

    local item = bank:remove(indexBank)
    if not item then end

    inventory:addToIndex(item, indexInventory)
end
net.Receive("finventoryTransferItemFromBankToInventory", function(len, ply) 
    local indexBank = net.ReadUInt(finventoryConfig.maxUIntByte)
    local indexInventory = net.ReadUInt(finventoryConfig.maxUIntByte)
    ply:transferItemFromBankToInventory(indexBank, indexInventory) 
end)

function ply:transferItemFromInventoryToBank(indexInventory, indexBank)
    local inventory = self:retrieveInventory()
    local bank = self:retrieveBank()

    local item = inventory:remove(indexInventory)
    if not item then return end

    bank:addToIndex(item, indexBank)
end
net.Receive("finventoryTransferItemFromInventoryToBank", function(len, ply) 
    local indexInventory = net.ReadUInt(finventoryConfig.maxUIntByte)
    local indexBank = net.ReadUInt(finventoryConfig.maxUIntByte)
    ply:transferItemFromInventoryToBank(indexInventory, indexBank) 
end)

function ply:closeAllDermas()
    net.Start("finventoryCloseDerma")
    net.Send(self)
end

function ply:buyInventory(inventoryUniqueName)
    local newInventory = Inventory(self, inventoryUniqueName, {})

    if not finventoryConfig.isGamemodeDarkRP or self:canAfford(newInventory:getPrice()) then
        if newInventory:addAllContentOf(self:retrieveInventory()) then 
            if finventoryConfig.isGamemodeDarkRP then
                self:addMoney(-newInventory:getPrice())
                self:sendNotification(Format(finventoryConfig.Language.buyBackpackSuccessDRP, newInventory:getPrice())) 
            else
                self:sendNotification(finventoryConfig.Language.buyBackpackSuccess)
            end
            self:loadModel()
        else
            self:sendNotification(finventoryConfig.Language.pickupBackpackFailTooMuchItem) 
        end
    elseif finventoryConfig.isGamemodeDarkRP then
        self:sendNotification(finventoryConfig.Language.notEnoughMoney) 
    end
end
net.Receive("finventoryBuyInventory", function(len, ply) 
    local inventoryUniqueName = net.ReadString()
    ply:buyInventory(inventoryUniqueName) 
end)

function ply:changeInspectionMode(inspectedPlayer, activated)
    if not checkPlayerInspectionValid(self, inspectedPlayer) then return end

    inspectedPlayer:Freeze(activated)
    if activated and finventoryConfig.timePoliceControl > 0 then --> unfreeze after x seconds
        timer.Create("finventoryUnsetFreezingInspectionMode", finventoryConfig.timePoliceControl, 1, function()
            self:Freeze(false)
        end)
    end
    return true
end
net.Receive("finventoryChangeInspectionMode", function(len, ply) 
    local inspectedPlayer = net.ReadEntity()
    local activated = net.ReadBool()
    ply:changeInspectionMode(inspectedPlayer, activated) 
end)

function ply:showLoadingBar(inspectedPlayer, isInspector)
    net.Start("finventoryShowLoadBar")
    net.WriteEntity(inspectedPlayer)
    net.WriteBool(isInspector)
    net.Send(self)
end

function ply:deleteIllegalItems(inspectedPlayer)
    if not checkPlayerInspectionValid(self, inspectedPlayer) then return end

    local suspectInventory = inspectedPlayer:retrieveInventory()

    local nbRemovedItems = suspectInventory:deleteIllegalItems()
    if nbRemovedItems == 0 then return false end

    local reward = nbRemovedItems * finventoryConfig.removeIllegalItemPay

    if finventoryConfig.removeIllegalItemPay > 0 and finventoryConfig.isGamemodeDarkRP then
        self:addMoney(reward)
        self:sendNotification(Format(finventoryConfig.Language.removedItemInspectorMoney, nbRemovedItems, reward))
    else
        self:sendNotification(Format(finventoryConfig.Language.removedItemInspector, nbRemovedItems)) 
    end

    inspectedPlayer:sendNotification(Format(finventoryConfig.Language.removedItemSuspect, nbRemovedItems)) 
    return true
end
net.Receive("finventoryDeleteIllegalItems", function(len, ply) 
    local inspectedPlayer = net.ReadEntity()
    ply:deleteIllegalItems(inspectedPlayer) 
end)

function checkPlayerInspectionValid(inspectorPlayer, inspectedPlayer)
    if not IsValid(inspectedPlayer) or not IsValid(inspectorPlayer) then return end
    if inspectedPlayer:GetPos():Distance(inspectorPlayer:GetPos()) > finventoryConfig.distanceChecker then 
        inspectorPlayer:sendNotification(finventoryConfig.Language.tooFarFromPerson)
        return false
    end
    if finventoryConfig.isGamemodeDarkRP and not inspectorPlayer:isCP() then 
        inspectorPlayer:sendNotification(finventoryConfig.Language.notAllowed)
        return false
    end
    return true
end

function ply:showInventoryOf(ply)
    if not IsValid(ply) or not IsValid(self) then return end
    local inventory = ply:retrieveInventory()
    net.Start("finventoryGetInventoryDerma")
    net.WriteTable(inventory)
    net.WriteEntity(ply)
    net.Send(self)
end

function ply:showInventoryAsAdmin(ply)
    if not IsValid(ply) or not IsValid(self) or not self:IsAdmin() then return end
    local inventory = ply:retrieveInventory()

    net.Start("finventoryShowInventoryAsAdminRet")
    net.WriteTable(inventory)
    net.Send(self)
end
net.Receive("finventoryShowInventoryAsAdmin", function(len, ply) 
    local inspectedPlayer = net.ReadEntity()
    ply:showInventoryAsAdmin(inspectedPlayer)
end)