ENT.Base	    	= "base_ai"
ENT.Type	    	= "ai"

ENT.PrintName		= "Backpack Vendor"
ENT.Author			= "Couicos"
ENT.Contact			= ""

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "FInventory"


function ENT:SetAutomaticFrameAdvance(byUsingAnim)
	self.AutomaticFrameAdvance = byUsingAnim
end