finventoryConfig = {}

// The language of the addon ['en', 'fr']
finventoryConfig.lang = 'en'
// The currency
finventoryConfig.currency = '$'
// The model of the vendor
finventoryConfig.model = "models/Humans/Group01/male_02.mdl"
// If you want to allow the use of command.
finventoryConfig.allowCommand = true
// The command to open the inventory
finventoryConfig.openInventoryCommand = "/inventory"
// The order to pick up an item.
finventoryConfig.pickupItemCommand = "/pickup"
// The command to inspect a player.
finventoryConfig.inspectPlayerCommand = "/inspect"
// The base pocket place
finventoryConfig.basePlace = 3
// If the content of your pocket or you bag is dropped when you die
finventoryConfig.dropOnDeath = false
// If the content of your pocket or you bag is deleted when you disconnect
finventoryConfig.deleteInventoryOnDisconnect = false
// If you want to close the inventory panel when you drop an item
finventoryConfig.closeInventoryPanelOnDrop = false
// The number of bank place
finventoryConfig.bankPlace = 18
// The pay when a policeman remove illegal items (0 to disable)
finventoryConfig.removeIllegalItemPay = 50
// Time available for a police control (0 for unlimited but not recommended)
finventoryConfig.timePoliceControl = 5
// The time to open another player's inventory 
finventoryConfig.timeToCheckInventory = 2
// If you want to enable darkrp features (money, cp verification for the inventory checker, etc)
finventoryConfig.isGamemodeDarkRP = true
// If you want to make backpack in the F4 menu automatically based 
// on the backpacks config (else there is some notes at the end of the config)
finventoryConfig.automaticF4Items = true
// (if automaticF4Items is activated) The maximum backpack that can be purchased
finventoryConfig.maxBackpackPurchase = 10
// The max size of any inventory
finventoryConfig.maxInventorySize = 4095
// If the item transfer from the bank to the inventory (or vice versa) should generate a sound
finventoryConfig.soundOnTransfer = true
// If each access to an inventory should require a reading of the json file
finventoryConfig.devMode = false
// If a player can take any weapon in his inventory (if the player should only take the designated 
// weapons, set it to false and add the classes of it in the accepted entities)
finventoryConfig.weaponsCanBeTaken = true
// If a player can take food in his inventory
finventoryConfig.foodCanBeTaken = true
// If a player can take any ammo in his inventory
finventoryConfig.ammoCanBeTaken = true
// If a player can take any shipment in his inventory
finventoryConfig.shipmentCanBeTaken = true

// The list of entities that can be taken 
finventoryConfig.acceptedEntities = {
    edit_fog = true,
    edit_sky = true,
    money_printer = true,
    edit_sun = true,
    weapon_357 = true
}

// The list of entities that are illegal
finventoryConfig.illegalEntities = {
    money_printer = true
}

// If the name doesn't display well in the inventory, you can put custom name via class of the item
finventoryConfig.customItemsName = {
    fas2_ak47 = "AK 47",
    weapon_357 = "357 magnum"
}

--[[-- HOW TO CREATE A BACKPACK --

{
    uniqueName = "", -> A unique name
    beautifulName = "", -> A beautiful name
    price = 1, -> the price
    place = 1, -> the number of available place in the backpack
    model = "models/model/backpack.mdl", -> the model
    modelExt = "models/model/backpack_ext.mdl", -> (optionnal) the exterior model
    viewModelVector = Vector(0, 0, 0), -> The vector used to place the backpack on the playermodels
    viewModelAngle = Angle(0, 0, 0) -> The angle used to place the backpack on the playermodels
},

--]]

// All the backpack (config used for the vendor and the f4 menu if automaticF4Item is true)
finventoryConfig.backpacks = {
    simple_backpack = {
        beautifulName = "Simple backpack",
        price = 15,
        place = 9,
        model = "models/couicos/backpacks/simple_backpack.mdl",
        modelExt = "models/couicos/backpacks/simple_backpack_ext.mdl",
        viewModelVector = Vector(-3, -5, -1),
        viewModelAngle = Angle(0, 270, -90)
    },
    advanced_backpack = {
        beautifulName = "Advanced backpack",
        price = 60,
        place = 12,
        model = "models/couicos/backpacks/advanced_backpack.mdl",
        modelExt = "models/couicos/backpacks/advanced_backpack_ext.mdl",
        viewModelVector = Vector(0, -3, 0.5),
        viewModelAngle = Angle(0, 270, -90)
    },
    military_backpack = {
        beautifulName = "Military backpack",
        price = 250,
        place = 30,
        model = "models/couicos/backpacks/military_backpack_bis.mdl",
        modelExt = "models/couicos/backpacks/military_backpack.mdl",
        viewModelVector = Vector(0, -5, -1.5),
        viewModelAngle = Angle(0, 270, -90)
    },
}

// Theme for all the vguis
finventoryConfig.Theme = {
    veryMuchLightColor = Color(200, 200, 200),
    veryLightColor = Color(50, 50, 50),
    lightColor = Color(40, 40, 40),
    middleLightColor = Color(35, 35, 35),
    middleColor = Color(30, 30, 30),
    darkColor = Color(20, 20, 20),

    successColor = Color(20, 171, 20),
    loadBarColor = Color(250, 50, 50),
    backgroundColor = Color(0, 0, 0, 0),
    selectTextColor = Color(130, 130, 255),
}

--[[ -- ADD DARKRP ENTITY
    If you want to add custom properties to your entity for sale in the F4 menu, 
    you must deactivate the option <finventoryConfig.automaticF4Items> and add it to your darkrpmodification

    /!\ Put the same properties as in the <finventoryConfig.backpacks> array (model / ent)

    DarkRP.createEntity("Simple backpack", {
        ent = "finventory_base_backpack", --> DON'T TOUCH
        model = "models/couicos/backpacks/simple_backpack_ext.mdl", --> if you have modelExt then put it there else put model
        price = 30,
        max = 1,
        cmd = "simple_backpack" --> /!\ You have to put the unique name which is in the <finventoryConfig.backpacks> array
    })
--]]

// /!\ For all configuration below, it is not recommended to change /!\

// The fluidity of the loading bar and checking 
// distance between players, etc. when searching inventory
finventoryConfig.loadingBarInterval = 20
// The distance required for the inventory checker (Need distance beacause of synchronicity)
finventoryConfig.distanceChecker = 130
// The distance to show 3D2D
finventoryConfig.distance3D2D = 300000
// The distance to pickup items
finventoryConfig.distancePickupItems = 10000
// DONT CHANGE / calculates the number of bytes for net messages based on the maximum inventory size
finventoryConfig.maxUIntByte = math.ceil(math.log(finventoryConfig.maxInventorySize + 1, 2))
// The entity class of spawned weapon
finventoryConfig.spawnedWeaponClass = "spawned_weapon"
// The entity class of spawned shipment
finventoryConfig.spawnedShipmentClass = "spawned_shipment"
// The entity class of spawned ammo
finventoryConfig.spawnedAmmoClass = "spawned_ammo"
// The entity class of spawned food
finventoryConfig.spawnedFoodClass = "spawned_food"
// The name of the save folder
finventoryConfig.saveFolderName = "finventory"


finventoryConfig.Language = {}
finventoryConfig.Language.en = {
    noMorePlace = "No more place!",
    takeItemSuccess = "You taken an item!",
    dropItemFail = "You cannot drop this!",
    dropItemSuccess = "You dropped an item!",
    pickupBoxSuccess = "You picked up a box!",
    pickupBackpackSuccess = "You picked up a backpack!",
    pickupBackpackFailTooMuchItem = "Throw away the items you carry!",
    pickupBackpackFailAlreadyBack = "Drop your current backpack!",
    dropBackpackSuccess = "You dropped your bag!",
    buyBackpackSuccessDRP = "You've bought a backpack for %d" .. finventoryConfig.currency .. "!",
    buyBackpackSuccess = "You bought a new backpack!",
    notEnoughMoney = "You don't have enought money!",
    tooFarFromPerson = "You're too far from the person!",
    notAllowed = "You're not allowed to do this!",
    removedItemInspector = "You have removed %d illegal items!",
    removedItemInspectorMoney = "You have removed %d illegal items for %d" .. finventoryConfig.currency .. "!",
    removedItemSuspect = "You have had %d items requisitioned!",
    inventory = "Inventory",
    searchInventory = "Search inventory",
    dropBackpack = "Drop backpack",
    removeIllegalItems = "Remove Illegals Items",
    bank = "Bank",
    bought = "Bought",
    buy = "Buy",
    vendor = "Backpack vendor",
    price = "Price : ",
    place = "Place : ",
    adminPanel = "Admin panel",
    searchPlayer = " Search a player",
    allInventories = "All inventories",
    job = "Job : ",
    bag = "Bag : ",
    deleteInventory = "Delete inventory",
    showInventory = "Show inventory",
}
finventoryConfig.Language.fr = {
    noMorePlace = "Il n'y a plus de place !",
    takeItemSuccess = "Vous avez pris un item !",
    dropItemFail = "Vous ne pouvez pas déposer ceci !",
    dropItemSuccess = "Vous avez déposé un item !",
    pickupBoxSuccess = "Vous avez pris une boite !",
    pickupBackpackSuccess = "Vous avez pris un sac à dos !",
    pickupBackpackFailTooMuchItem = "Déposez vos affaires !",
    pickupBackpackFailAlreadyBack = "Déposez votre sac à dos !",
    dropBackpackSuccess = "Vous avez déposé votre sac à dos !",
    buyBackpackSuccessDRP = "Vous avez acheté un nouveau sac à dos pour %d" .. finventoryConfig.currency .. " !",
    buyBackpackSuccess = "Vous avez acheté un nouveau sac à dos !",
    notEnoughMoney = "Vous n'avez pas assez d'argent !",
    tooFarFromPerson = "Vous êtes trop loin de la personne !",
    notAllowed = "Vous n'êtes pas autorisé à faire ça !",
    removedItemInspector = "Vous avez retiré %d items illégaux !",
    removedItemInspectorMoney = "Vous avez retiré %d items illégaux pour %d" .. finventoryConfig.currency .. " !",
    removedItemSuspect = "On vous a réquisitionné %d items !",
    inventory = "Inventaire",
    searchInventory = "Fouillage en cours",
    dropBackpack = "Déposer le sac",
    removeIllegalItems = "Enlever les items illégaux",
    bank = "Banque",
    bought = "Acheté",
    buy = "Acheter",
    vendor = "Vendeur de sac à dos",
    price = "Prix : ",
    place = "Place : ",
    adminPanel = "Panneau d'administration",
    searchPlayer = " Rechercher un joueur",
    allInventories = "Tous les inventaires",
    job = "Métier : ",
    bag = "Sac : ",
    deleteInventory = "Supprimer l'inventaire",
    showInventory = "Voir l'inventaire",
}

function loadLanguage() 
    if not finventoryConfig.Language[finventoryConfig.lang] then finventoryConfig.lang = "en" end
    table.Merge(finventoryConfig.Language, finventoryConfig.Language[finventoryConfig.lang])
end
loadLanguage() 