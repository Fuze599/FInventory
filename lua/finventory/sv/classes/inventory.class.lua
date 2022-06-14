if not SERVER then return end

Inventory = {}
Inventory.__index = Inventory

function Inventory:new(owner, uniqueName, content)

    local itemTable = fillItemTable(content)
    local inventoryProperties = getInventoryPropertiesByUniqueName(uniqueName)

	return setmetatable({ 
        owner = owner,
        content = itemTable or {},
        place = inventoryProperties.place or finventoryConfig.basePlace,
        price = inventoryProperties.price or 0,
        beautifulName = inventoryProperties.beautifulName or "",
        uniqueName = inventoryProperties.uniqueName or "",
        model = inventoryProperties.model or "",
        modelExt = inventoryProperties.modelExt or inventoryProperties.model or "",
        viewModelVector = inventoryProperties.viewModelVector or Vector(0, 0, 0),
        viewModelAngle = inventoryProperties.viewModelAngle or Angle(0, 0, 0),
        isPocket = inventoryProperties.isPocket or false
	}, Inventory)
end

function Inventory:add(item) 
    if not IsValid(self.owner) then return false end
    if not item:isAccepted() then
        return false
    elseif self:isFull() then 
        self.owner:sendNotification(finventoryConfig.Language.noMorePlace) 
        return false
    end

    self.content[self:nextPlaceIndex()] = item
    self.owner:sendNotification(finventoryConfig.Language.takeItemSuccess) 

    self:save()
    return true
end

function Inventory:addToIndex(item, index) 
    if not item:isAccepted() or self:isFull() then 
        return false
    end
    
    table.insert(self.content, index, item)
    self:save()
    return true
end

function Inventory:addAllContentOf(otherInventory)
    if self:getActualPlace() + otherInventory:getActualPlace() > self:getPlace() then
        return false
    end

    local otherInventoryContent = otherInventory:getContent()
    for i = otherInventory:getActualPlace(), 1, -1 do
        local item = otherInventoryContent[i]
        table.insert(self.content, 1, item)
    end

    self:setOwner(otherInventory:getOwner())

    self:save()

    return true
end

function Inventory:remove(index) 
    if self:getActualPlace() < index or index < 1 then return end
    local removedItem = table.remove(self.content, index)
    self:save()
    return removedItem
end

function Inventory:dropBackpack() 
    local newInventory = Inventory(self:getOwner(), "", {})
    newInventory:save()
end

function Inventory:saveInFile()
    if not IsValid(self.owner) then return false end
    local inventoryPath = self:getSavePath()
    local jsonInventory = self:stringify()
    file.Write(inventoryPath, jsonInventory) 
end

function Inventory:save()
    if not IsValid(self.owner) then return false end
    if finventoryConfig.enhancedSaving then
        self:saveInFile()
    else
        self.owner.finventoryInventory = self
    end
end

function Inventory:stringify() 
    return util.TableToJSON({ uniqueName = self.uniqueName, content = self.content})
end

function Inventory:deleteIllegalItems() 
    local removedIndexTab = {}
    for k, item in pairs(self.content) do
        if finventoryConfig.illegalEntities[item:getClass()] then
            table.insert(removedIndexTab, k)
        end 
    end

    local totalItemsRemoved = 0
    for k, indexIllegalItem in pairs(removedIndexTab) do
        self:remove(indexIllegalItem - totalItemsRemoved)
        totalItemsRemoved = totalItemsRemoved + 1
    end

    self:save()

    return totalItemsRemoved
end

/******************
* GETTERS/SETTERS *
*******************/

function Inventory:getSavePath()
    return finventoryConfig.saveFolderName .. "/finventory_" .. self.owner:SteamID64() .. ".json"
end

function Inventory:getPlace() 
    return self.place
end

function Inventory:setPlace(place) 
    self.place = place
end

function Inventory:getActualPlace() 
    return #self.content
end

function Inventory:getRemainingPlace() 
    return self.place - #self.content
end

function Inventory:isFull() 
    return self:getRemainingPlace() == 0
end

function Inventory:isEmpty() 
    return self:getActualPlace() == 0
end

function Inventory:nextPlaceIndex()
    return #self.content + 1
end

function Inventory:getContent() 
    return table.Copy(self.content)
end

function Inventory:setContent(content) 
    self.content = content
end

function Inventory:getPrice() 
    return self.price
end

function Inventory:setPrice(price) 
    self.price = price
end

function Inventory:getBeautifulName() 
    return self.beautifulName
end

function Inventory:setBeautifulName(beautifulName) 
    self.beautifulName = beautifulName
end

function Inventory:getUniqueName() 
    return self.uniqueName
end

function Inventory:setUniqueName(uniqueName) 
    self.uniqueName = uniqueName
end

function Inventory:getModel() 
    return self.model
end

function Inventory:setModel(model) 
    self.model = model
end

function Inventory:getModelExt() 
    return self.modelExt
end

function Inventory:setModelExt(modelExt) 
    self.modelExt = modelExt
end

function Inventory:getViewModelVector() 
    return self.viewModelVector
end

function Inventory:setViewModelVector(viewModelVector) 
    self.viewModelVector = viewModelVector
end

function Inventory:getViewModelAngle() 
    return self.viewModelAngle
end

function Inventory:setViewModelAngle(viewModelAngle) 
    self.viewModelAngle = viewModelAngle
end

function Inventory:getIsPocket() 
    return self.isPocket
end

function Inventory:setIsPocket(isPocket) 
    self.isPocket = isPocket
end

function Inventory:getOwner() 
    return self.owner
end

function Inventory:setOwner(owner) 
    self.owner = owner
end

setmetatable(Inventory, {__call = Inventory.new })