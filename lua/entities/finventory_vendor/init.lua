AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString( "finventoryGetVendorDerma" )

function ENT:Initialize()
	self:SetModel(finventoryConfigInGame.model.value)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use( activator )
	net.Start( "finventoryGetVendorDerma" )
	net.WriteEntity( activator )
	net.Send( activator )
end