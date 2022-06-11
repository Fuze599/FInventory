finventoryConfigInGame = {
    lang = {
        explanation = "The language of the addon",
        configType = "boolean",
        tab = {"fr", "en"},
        value = "en"
    },
    currency = {
        explanation = "The currency",
        configType = "entry",
        value = "$"
    },
    model = {
        explanation = "The model of the vendor",
        configType = "entry",
        value = "models/Humans/Group01/male_02.mdl"
    },
    basePlace = {
        explanation = "The base pocket place",
        configType = "number",
        value = 3
    },
    bankPlace = {
        explanation = "The number of bank place",
        configType = "number",
        value = 18
    },
    dropOnDeath = {
        explanation = "If the content of your pocket or you bag should be dropped when you die",
        configType = "boolean",
        value = true
    },
    automaticF4Items = {
        explanation = "If you want to make backpack in the F4 menu automatically",
        configType = "boolean",
        value = true
    },
    deleteInventoryOnDisconnect = {
        explanation = "If the content of your pocket or you bag is deleted when you disconnect",
        configType = "boolean",
        value = false
    },
    closeInventoryPanelOnDrop = {
        explanation = "If you want to close the inventory panel when you drop an item",
        configType = "boolean",
        value = false
    },
    isGamemodeDarkRP = {
        explanation = "Is the gamemode DarkRP ?",
        configType = "boolean",
        value = true
    },
    removeIllegalItemPay = {
        explanation = "The pay when a policeman remove illegal items (0 to disable)",
        configType = "number",
        value = 10
    },
    timePoliceControl = {
        explanation = "Time available for a police control (0 for unlimited but not recommended)",
        configType = "number",
        value = 15
    },
    distanceChecker = {
        explanation = "The distance required for a police control",
        configType = "number",
        value = 150
    },
    timeToCheckInventory = {
        explanation = "Time to check the inventory for a police control",
        configType = "number",
        value = 15
    },
    loadingBarInterval = {
        explanation = "Loading bar interval (not recommended to change)",
        configType = "number",
        value = 20
    },
    acceptedEntities = {
        explanation = "The list of entities that can be taken ",
        configType = "list",
        value = {
            edit_fog = true,
            edit_sky = true,
            edit_sun = true,
        }
    },
}

finventoryConfig = {}

finventoryConfig.saveFolderName = "finventory"
finventoryConfig.spawnedWeaponName = "spawned_weapon"

finventoryConfig.enhancedSaving = true

finventoryConfig.soundOnTransfer = true

-- // The language of the addon ['en', 'fr']
finventoryConfig.lang = 'en'
-- // The currency (used in the store)
finventoryConfig.currency = '€'
-- // The model of the vendor
finventoryConfig.model = "models/Humans/Group01/male_02.mdl"
-- // The base pocket place
finventoryConfig.basePlace = 3
-- // If the content of your pocket or you bag is dropped when you die
finventoryConfig.dropOnDeath = false
-- // If you want to make backpack in the F4 menu automatically (else there is some notes at the end of the config)
finventoryConfig.automaticF4Items = true
-- // If the content of your pocket or you bag is deleted when you disconnect
finventoryConfig.deleteInventoryOnDisconnect = false
-- // If you want to close the inventory panel when you drop an item
finventoryConfig.closeInventoryPanelOnDrop = false
-- // The number of bank place
finventoryConfig.bankPlace = 18
-- // The pay when a policeman remove illegal items (0 to disable)
finventoryConfig.removeIllegalItemPay = 50
-- // Time available for a police control (0 for unlimited but not recommended)
finventoryConfig.timePoliceControl = 5

finventoryConfig.timeToCheckInventory = 2

finventoryConfig.loadingBarInterval = 20

finventoryConfig.isGamemodeDarkRP = true

finventoryConfig.maxBackpackPurchase = 10

finventoryConfig.maxInventorySize = 4095

-- // The distance required for a police control
finventoryConfig.distanceChecker = 130
finventoryConfig.distance3D2D = 250
finventoryConfig.distancePickupItems = 130
 
finventoryConfig.maxUIntByte = math.ceil(math.log(finventoryConfig.maxInventorySize + 1, 2))

// The list of entities that can be taken 
// (Remove "spawned_weapon" to delete the weapon in the inventory)
finventoryConfig.acceptedEntities = {
    weapon_deagle2 = true,
    spawned_shipment = true,
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

// The list of entities that can be taken 
// (Remove "spawned_weapon" to delete the weapon in the inventory)
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
        cmd = "simple_backpack" --> /!\ You have to put the single command which 
                                        is in the <finventoryConfig.backpacks> array
    })
*/

finventoryConfig.Language = {}
finventoryConfig.Language["Backpack vendor"] = {
	["en"] = "Backpack vendor",
	["fr"] = "Vendeur de sac à dos"
}

finventoryConfig.Language["Bought"] = {
	["en"] = "Bought",
	["fr"] = "Acheté"
}

finventoryConfig.Language["Buy"] = {
	["en"] = "Buy",
	["fr"] = "Acheter"
}

finventoryConfig.Language["You don't have enought money!"] = {
	["en"] = "You don't have enought money!",
	["fr"] = "Vous n'avez pas assez d'argent !"
}

finventoryConfig.Language["You've bought a new backpack for "] = {
	["en"] = "You've bought a new backpack for ",
	["fr"] = "Vous avez acheté un nouveau sac à dos pour "
}

finventoryConfig.Language["Inventory"] = {
	["en"] = "Inventory",
	["fr"] = "Inventaire"
}

finventoryConfig.Language["You don't have enough place!"] = {
	["en"] = "You don't have enough place!",
	["fr"] = "Vous n'avez pas assez de place !"
}

finventoryConfig.Language["You picked up an item!"] = {
	["en"] = "You picked up an item!",
	["fr"] = "Vous avez pris un objet !"
}

finventoryConfig.Language["Drop the bag"] = {
	["en"] = "Drop the bag",
	["fr"] = "Déposer le sac"
}

finventoryConfig.Language["You dropped your bag!"] = {
	["en"] = "You dropped your bag!",
	["fr"] = "Vous avez déposé votre sac !"
}

finventoryConfig.Language["You dropped an item!"] = {
	["en"] = "You dropped an item!",
	["fr"] = "Vous avez déposé un objet !"
}

finventoryConfig.Language["Drop your current bag!"] = {
	["en"] = "Drop your current bag!",
	["fr"] = "Déposez d'abord vos affaires !"
}

finventoryConfig.Language["You've taken a bag!"] = {
	["en"] = "You've taken a bag!",
	["fr"] = "Vous avez pris un sac !"
}

finventoryConfig.Language["You have too much items in you current bag!"] = {
    ["en"] = "You have too much items in you current bag!",
	["fr"] = "Vous avez trop d'objets dans votre sac !"
}

finventoryConfig.Language["Inventory Checker"] = {
    ["en"] = "Inventory Checker",
	["fr"] = "Vérificateur d'inventaire"
}

finventoryConfig.Language["You taken a box!"] = {
    ["en"] = "You taken a box!",
	["fr"] = "Vous avez pris une boite !"
}

finventoryConfig.Language["Search inventory"] = {
    ["en"] = "Search inventory",
	["fr"] = "Fouiller l'inventaire"
}

finventoryConfig.Language["Remove Illegals Items"] = {
    ["en"] = "Remove Illegals Items",
	["fr"] = "Retirer les items illégaux"
}

finventoryConfig.Language["Price : "] = {
    ["en"] = "Price : ",
	["fr"] = "Prix : "
}

finventoryConfig.Language["Place : "] = {
    ["en"] = "Place : ",
	["fr"] = "Place : "
}

finventoryConfig.Language["Bank"] = {
    ["en"] = "Bank",
	["fr"] = "Banque"
}

finventoryConfig.Language["Search in progress"] = {
    ["en"] = "Search in progress",
	["fr"] = "Recherche en cours"
}

finventoryConfig.Language["You get searched!"] = {
    ["en"] = "You get searched!",
	["fr"] = "Vous vous faites fouiller !"
}

finventoryConfig.Language["You bought a new backpack!"] = {
    ["en"] = "You bought a new backpack!",
	["fr"] = "Vous avez acheté un nouveau sac à dos !"
}

finventoryConfig.Language["Drop your items first!"] = {
    ["en"] = "Drop your items first!",
	["fr"] = "Déposez d'abord vos affaires !"
}

finventoryConfig.Language["You cannot drop this!"] = {
    ["en"] = "You cannot drop this!",
	["fr"] = "Vous ne pouvez pas déposer ça !"
}

finventoryConfig.Language["You're too far from the person"] = {
    ["en"] = "You're too far from the person",
	["fr"] = "Vous êtes trop loin de la personne !"
}

finventoryConfig.Language["You're not a policeman!"] = {
    ["en"] = "You're not a policeman!",
	["fr"] = "Vous n'êtes pas policier !"
}

finventoryConfig.Language["You have removed"] = {
    ["en"] = "You have removed",
	["fr"] = "Vous avez enlevé"
}

finventoryConfig.Language["illegal items"] = {
    ["en"] = "illegal items",
	["fr"] = "objets illégaux"
}

finventoryConfig.Language["for"] = {
    ["en"] = "for",
	["fr"] = "pour"
}

finventoryConfig.Language["You have had"] = {
    ["en"] = "You have had",
	["fr"] = "Vous avez requisitionné"
}

finventoryConfig.Language["You have had"] = {
    ["en"] = "You have had",
	["fr"] = "Vous avez requisitionné"
}

finventoryConfig.Language["items requisitioned!"] = {
    ["en"] = "items requisitioned!",
	["fr"] = "objets !"
}