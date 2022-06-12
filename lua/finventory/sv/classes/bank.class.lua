if not SERVER then return end

Bank = {}
Bank.__index = Bank

function Bank:new(owner, jsonTable)
    local bankTable = util.JSONToTable(jsonTable)
    local content = fillItemTable(bankTable)
	return setmetatable({ 
        owner = owner,
		content = content or {}
	}, Bank)
end

function Bank:addToIndex(item, index)
    if not item:isAccepted() or self:isFull() then 
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
    local bankPath = self:getSavePath()
    local jsonBank = self:stringify()
    file.Write(bankPath, jsonBank) 
end

function Bank:save()
    if not IsValid(self:getOwner()) then return false end
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

function Bank:getOwner()
    return self.owner
end

function Bank:getSavePath()
    return finventoryConfig.saveFolderName .. "/finventory_bank_" .. self.owner:SteamID64() .. ".json"
end

setmetatable(Bank, {__call = Bank.new })