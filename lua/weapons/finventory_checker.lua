SWEP.PrintName 		= "Inventory Checker"
SWEP.Author 		= "Couicos"
SWEP.Contact 		= "No no no"
 
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
    if SERVER then
        local eyeTrace = self:GetOwner():GetEyeTrace()
        local inspectedPlayer = eyeTrace.Entity

        if self:GetOwner():GetPos():Distance(inspectedPlayer:GetPos()) < finventoryConfig.distanceChecker 
            and inspectedPlayer:IsPlayer() then

            self:GetOwner():showLoadingBar(inspectedPlayer, true)
            inspectedPlayer:showLoadingBar(self:GetOwner(), false)

            local interval = finventoryConfig.loadingBarInterval
            timer.Create("removeInventoryCheckerPanel", 1 / interval, finventoryConfig.timeToCheckInventory * interval, function()
                local repsLeft = timer.RepsLeft("removeInventoryCheckerPanel")
 
                if self:GetOwner():GetEyeTrace().Entity ~= inspectedPlayer or not inspectedPlayer:IsPlayer()
                    or self:GetOwner():GetPos():Distance(eyeTrace.HitPos) > finventoryConfig.distanceChecker then 
                    timer.Remove("removeInventoryCheckerPanel") 
                    return
                end 

                if repsLeft <= 0 then
                    if self:GetOwner():changeInspectionMode(inspectedPlayer, true) then
                        inspectedPlayer:closeAllDermas()
                        self:GetOwner():showInventoryOf(inspectedPlayer)
                    end
                end 
            end)
        end
    end
end 

function SWEP:SecondaryAttack()
end