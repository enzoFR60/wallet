/*-----------------------------------------------------------------
	Author		= SlownLS
	Addon 		= Wallet
-----------------------------------------------------------------*/

AddCSLuaFile()

SWEP.PrintName = "Porte-Monnaie"
SWEP.Author = "SlownLS"
SWEP.Category = "Other"
SWEP.Instructions = ""

SWEP.AnimPrefix  = ""
SWEP.WorldModel = ""

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Other"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType( "normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:DrawWorldModel() end

function SWEP:PreDrawViewModel(vm)
    return true
end

--[[-------------------------------------------------------------------------
	Primary Attack
---------------------------------------------------------------------------]]

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.2 )

	if SERVER then
		net.Start( "Wallet:Player:OpenMenu" )
		net.Send( self.Owner )
	end
end

--[[-------------------------------------------------------------------------
	Secondary Attack 
---------------------------------------------------------------------------]]

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.2 )

	if SERVER then
		net.Start( "Wallet:Player:OpenMenu" )
		net.Send( self.Owner )
	end
end
