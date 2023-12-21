if not SERVER then return end

Item = {}
Item.__index = Item

function Item:new(itemType, class, model, name, count, content)
    if not itemType or not class or not model then return end

    if class == finventoryConfig.spawnedWeaponClass then 
        local newClass, newName = weaponHandling(entity)
        if newClass then class = newClass end
        if newName then name = newName end
    end

    if finventoryConfig.customItemsName[class] then
        name = finventoryConfig.customItemsName[class]
    end

	return setmetatable({ 
		itemType = itemType, -- weapon, entity, shipment, ammo
		class = class,
		model = model,
		name = name or "",
		count = count or -1,
		content = content or -1,
	}, Item)
end

/******************
* GETTERS/SETTERS *
*******************/

function Item:isAccepted()
	return finventoryConfig.acceptedEntities[self:getClass()]
		or (finventoryConfig.weaponsCanBeTaken and self:isWeapon())
		or (finventoryConfig.foodCanBeTaken and self:isFood())
		or (finventoryConfig.ammoCanBeTaken and self:isAmmo())
		or (finventoryConfig.shipmentCanBeTaken and self:isShipment())
end

function Item:isShipment()
	return self.itemType == getItemShipmentString()
end

function Item:isEntity()
	return self.itemType == getItemEntityString()
end

function Item:isWeapon()
	return self.itemType == getItemWeaponString()
end

function Item:isAmmo()
	return self.itemType == getItemAmmoString()
end

function Item:isFood()
	return self.itemType == getItemFoodString()
end

function Item:getItemType()
	return self.itemType
end

function Item:setItemType(itemType)
	self.itemType = itemType
end

function Item:getClass()
	return self.class
end

function Item:setClass(class)
	self.class = class
end

function Item:getModel()
	return self.model
end

function Item:setModel(model)
	self.model = model
end

function Item:getName()
	return self.name
end

function Item:setName(name)
	self.name = name
end

function Item:getCount()
	return self.count
end

function Item:setCount(count)
	self.count = count
end

function Item:getContent()
	return self.content
end

function Item:setContent(content)
	self.content = content
end

setmetatable(Item, {__call = Item.new })