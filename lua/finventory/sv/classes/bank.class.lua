if not SERVER then return end

Bank = {}
Bank.__index = Bank

function Bank:new(owner, jsonTable)
    local bankTable = util.JSONToTable(jsonTable)
	return setmetatable({ 
        owner = owner,
		content = bankTable or {}
	}, Bank)
end

function Bank:add(item) 
    if self:isFull() or not finventoryConfig.acceptedEntities[item:GetClass()] then return false end

    self.content[self:nextPlaceIndex()] = item
    return true
end

function Bank:addToIndex(item, index) 
    if not finventoryConfig.acceptedEntities[item.class] or self:isFull() then 
        return false
    end
    
    table.insert(self.content, index, item)
    self:save()
    return true
end

function Bank:remove(index) 
    if self:getActualPlace() < index or index < 1 then return end
    local removedItem = table.remove(self.content, index)
    self:save()
    return removedItem
end

function Bank:stringify(index) 
    return util.TableToJSON(self.content)
end

function Bank:saveInFile()
    local bankPath = finventoryConfig.saveFolderName .. "/finventory_bank_" .. self.owner:SteamID64() .. ".json"
    local jsonBank = self:stringify()
    file.Write(bankPath, jsonBank) 
end

function Bank:save()
    if not IsValid(self.owner) then return false end
    if finventoryConfig.enhancedSaving then
        self:saveInFile()
    else
        self.owner.finventoryBank = self
    end
end

/******************
* GETTERS/SETTERS *
*******************/

function Bank:nextPlaceIndex()
    return self:getActualPlace() + 1
end

function Bank:getActualPlace()
    return #self.content
end

function Bank:isFull()
    return self:getActualPlace() >= finventoryConfig.bankPlace
end

setmetatable(Bank, {__call = Bank.new })