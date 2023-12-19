if not SERVER then return end

resource.AddWorkshop( "2822621090" )

function fillItemTable(inventoryContent)
    local itemTable = {}
    for k, v in pairs(inventoryContent) do
        itemTable[#itemTable + 1] = Item(v.itemType, v.class, v.model, v.name, v.count, v.content)
    end
    return itemTable
end

// HOOKS
hook.Add("PlayerInitialSpawn", "finventoryReloadInventoryOnSpawn", function(ply)
    timer.Create("InitialSpawnLoadAttributes", 3, 1, function()
        local inventory = ply:retrieveInventoryFromFile()
        local bank = ply:retrieveBankFromFile()
        ply.finventoryInventory = inventory
        ply.finventoryBank = bank
        ply:loadModel()
    end)
end)

hook.Add("playerBoughtCustomEntity", "finventoryDropCustomBackpackEntity", function(ply, tab, ent)
    if ent:GetClass() == 'finventory_base_backpack' then
        ent:SetModel(tab.model)
        ent:PhysicsInit(SOLID_VPHYSICS)
        ent:SetMoveType(MOVETYPE_VPHYSICS)
        ent:SetSolid(SOLID_VPHYSICS)
        ent.finventoryInventory = Inventory(nil, tab.cmd, {})
        local phys = ent:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end
end)   

if finventoryConfig.dropOnDeath then
    hook.Add("PlayerDeath", "finventoryDropOnDeath", function(ply)
        ply:dropInventory(false)
        ply:loadModel()
    end)
end

hook.Add("PlayerDisconnected", "finventorySavingBackpackOnDisconnect", function(ply)
    if finventoryConfig.deleteInventoryOnDisconnect then
        local inventory = ply:retrieveInventory()
        inventory:dropBackpack() 
        inventory:saveInFile()
    elseif not finventoryConfig.devMode then
        local inventory = ply:retrieveInventory()
        inventory:saveInFile() 
    end
end)
