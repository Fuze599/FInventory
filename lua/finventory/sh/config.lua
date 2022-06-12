finventoryConfig = {}

// The language of the addon ['en', 'fr']
finventoryConfig.lang = 'en'
// The currency
finventoryConfig.currency = '€'
// The model of the vendor
finventoryConfig.model = "models/Humans/Group01/male_02.mdl"
// The base pocket place
finventoryConfig.basePlace = 3
// If the content of your pocket or you bag is dropped when you die
finventoryConfig.dropOnDeath = true
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
finventoryConfig.enhancedSaving = true
// If a player can take any weapon in his inventory (if the player should only take the designated 
// weapons, set it to false and add the classes of it in the accepted entities)
finventoryConfig.weaponsCanBeTaken = true
// If a player can take food in his inventory
finventoryConfig.foodCanBeTaken = true
// If a player can take any ammo in his inventory
finventoryConfig.ammoCanBeTaken = true
// If a player can take any shipment in his inventory
finventoryConfig.shipmentCanBeTaken = true


// /!\ For all configuration below, it is not recommended to change /!\

// The fluidity of the loading bar and checking 
// distance between players, etc. when searching inventory
finventoryConfig.loadingBarInterval = 20
// The distance required for the inventory checker
finventoryConfig.distanceChecker = 130
// The distance to show 3D2D
finventoryConfig.distance3D2D = 250
// The distance to pickup items
finventoryConfig.distancePickupItems = 130
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

// The list of entities that can be taken 
finventoryConfig.acceptedEntities = {
    edit_fog = true,
    edit_sky = true,
    edit_sun = true,
    ent_batch = true,
    ent_meth_crystal = true,
    sent_ball = true,
    ent_hazmat = true,
    ent_glassware = true,
    ent_iodine = true,
    ent_meth_container = true,
    ent_batch = true,
    ent_glassware = true
}

// The list of entities that are illegal
finventoryConfig.illegalEntities = {
    ent_batch = true
}

finventoryConfig.customItemsName = {
    fas2_ak47 = "AK 47"
}

/*
    -- HOW TO CREATE A BACKPACK --
{
    uniqueName = "", -> A unique name, if you modify it, you MUST delete data file (data/finventory)
    beautifulName = "", -> A beautiful name for
    price = 1, -> the price
    place = 1, -> the number of available place in the backpack
    model = "models/model/backpack.mdl", -> the model for the backpack
    viewModelVector = Vector( 0, 0, 0 ), -> The vector used to place the backpack on the playermodels
    viewModelAngle = Angle( 0, 0, 0 ) -> The angle used to place the backpack on the playermodels
},
*/
// All the backpack (config used for the vendor and the f4 menu)
finventoryConfig.backpacks = {

    simple_backpack = {
        beautifulName = "Simple backpack",
        price = 15,
        place = 6,
        model = "models/couicos/backpacks/simple_backpack.mdl",
        modelExt = "models/couicos/backpacks/simple_backpack_ext.mdl",
        viewModelVector = Vector( -3, -5, -1 ),
        viewModelAngle = Angle( 0, 270, -90 )
    },

    advanced_backpack = {
        beautifulName = "Advanced backpack",
        price = 60,
        place = 12,
        model = "models/couicos/backpacks/advanced_backpack.mdl",
        modelExt = "models/couicos/backpacks/advanced_backpack_ext.mdl",
        viewModelVector = Vector( 0, -3, 0.5),
        viewModelAngle = Angle( 0, 270, -90 )
    },
}

/*
    If you want to add custom properties to your entity for sale in the F4 menu, 
    you must deactivate the option <finventoryConfig.automaticF4Items> and add it to your darkrpmodification

    /!\ Put the same properties as in the <finventoryConfig.backpacks> array (price / model / ent)

    DarkRP.createEntity("Simple backpack", {
        ent = "finventory_base_backpack", --> DON'T TOUCH
        model = "models/couicos/backpacks/simple_backpack.mdl",
        modelExt = "models/couicos/backpacks/simple_backpack_ext.mdl", -> (opionnal) If you want to have different 
                                                                                     models dropped and equipped
        price = 30,
        max = 1,
        cmd = "simple_backpack" --> /!\ You have to put the unique name which 
                                        is in the <finventoryConfig.backpacks> array
    })
*/


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
}