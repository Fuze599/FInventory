SWEP.PrintName 		= "Inventory Checker"
SWEP.Author 		= "Couicos"
SWEP.Contact 		= ""
 
SWEP.AdminSpawnable = true
SWEP.Spawnable 		= true
SWEP.ViewModelFOV 	= 128
SWEP.ViewModel 		= ""
SWEP.WorldModel 	= ""
SWEP.AutoSwitchTo 	= false
SWEP.AutoSwitchFrom = true
SWEP.Slot 			= 1
SWEP.HoldType = "normal"
SWEP.Weight = 5
SWEP.DrawCrosshair = true
SWEP.Category = "FInventory"
SWEP.DrawAmmo = false
SWEP.base = "weapon_cs"
SWEP.use = CurTime()

SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.Delay = 0.3
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
    self:GetOwner():inspectTargetedPlayer()
end 

function SWEP:SecondaryAttack()
end