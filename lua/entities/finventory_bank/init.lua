AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString( "finventoryGetBankDerma" )

function ENT:Initialize()
	self:SetModel( "models/couicos/safe/vault_door.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:OnTakeDamage()
	return false
end
 
function ENT:Use( activator, caller )
	local plyInventory = activator:retrieveInventory()
	local plyBank = activator:retrieveBank()
	net.Start( "finventoryGetBankDerma" )
	net.WriteTable( plyInventory )
	net.WriteTable( plyBank )
	net.Send( activator )
end