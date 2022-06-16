SWEP.PrintName 		= "Inventory"
SWEP.Author 		= "Couicos"
SWEP.Contact 		= ""
 
SWEP.AdminSpawnable = true
SWEP.Spawnable 		= true

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV 	= 62
SWEP.ViewModel 		= ""
SWEP.WorldModel 	= ""
SWEP.AutoSwitchTo 	= false
SWEP.AutoSwitchFrom = true
SWEP.Slot 			= 1
SWEP.HoldType = "normal"
SWEP.AnimPrefix = "rpg"
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Weight = 5
SWEP.DrawCrosshair = true
SWEP.Category = "FInventory"
SWEP.DrawAmmo = false
SWEP.base = "weapon_cs"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
 
function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end 
 
if SERVER then  
    util.AddNetworkString("finventoryGetInventoryDerma")
end

function SWEP:PrimaryAttack()
    if not SERVER then return end
    local eyeTrace = self:GetOwner():GetEyeTrace()
    local entity = eyeTrace.Entity

    if self:GetOwner():GetPos():DistToSqr(eyeTrace.HitPos) > finventoryConfig.distancePickupItems then return end

    self:GetOwner():pickupItem(entity) 
end 

function SWEP:SecondaryAttack()  
    if not SERVER then return end
    self:GetOwner():showInventoryOf(self:GetOwner())
end 
