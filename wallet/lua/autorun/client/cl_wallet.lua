/*-----------------------------------------------------------------
	Author		= SlownLS
	Addon 		= Wallet
-----------------------------------------------------------------*/

Wallet = {}

-- true = vous activez l'info de l'argent illegal.
-- false = vous desactivez l'info de l'argent illegal.
Wallet.ArgentIllegal = true 

--[[-------------------------------------------------------------------------
	Blur
---------------------------------------------------------------------------]]

local blur = Material("pp/blurscreen")
local function DrawBlur( p, a, d )
	local x, y = p:LocalToScreen( 0, 0 )
	
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

--[[-------------------------------------------------------------------------
	Wallet Menu
---------------------------------------------------------------------------]]

net.Receive( "Wallet:Player:OpenMenu", function()
	local Base = vgui.Create( "DFrame" )
	Base:SetSize( 500, 140 )
	Base:Center()
	Base:SetTitle( "" )
	Base:SetDraggable( false )
	Base:MakePopup()
	Base.Paint = function( self, w, h )
		DrawBlur( self, 6, 30 )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.RoundedBox( 1, 0, 0, w, 25, Color( 0, 0, 0, 80 ) )   
		draw.RoundedBox( 1, 0, 25, w, 1, Color( 0, 0, 0, 80 ) )    

		draw.SimpleText( "Vous avez " .. LocalPlayer():getDarkRPVar( 'money' ) .. "€ d'argent sur vous.", "Trebuchet24", w / 2 , 25, color_white, TEXT_ALIGN_CENTER )
		 
	  if Wallet.ArgentIllegal then
		draw.SimpleText( "Vous avez "..LocalPlayer():GetNWInt("player_money_illegal").."€ d'argent illegal sur vous.", "Trebuchet24", w / 2 , 45, color_white, TEXT_ALIGN_CENTER )
	  end
	end

	local Money = vgui.Create( "DTextEntry", Base )
	Money:SetSize( Base:GetWide() - 10, 25 )
	Money:SetPos( 5, 70 )
	Money:SetText( "Entrer un montant..." )
	Money:SetNumeric( true )
	Money.OnGetFocus = function( self ) if self:GetText() == "Entrer un montant..." then self:SetText( '' ) end end
	Money.OnLoseFocus = function( self ) if self:GetText() == "" then self:SetText( "Entrer un montant..." ) end end

	local DropMoney = vgui.Create( "DButton", Base )
	DropMoney:SetSize( 240, 35 )
	DropMoney:SetPos( 5, Base:GetTall() - 40 )
	DropMoney:SetText( "Jeter de l'argent" )
	DropMoney:SetFont( 'Trebuchet24' )
	DropMoney:SetTextColor(  Color( 255, 255, 255, 200 ) )
	DropMoney.OnCursorEntered = function( self ) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
	DropMoney.OnCursorExited = function( self ) self.hover = false end
	DropMoney.Slide = 0
	DropMoney.Paint = function( self, w, h )
		if self.hover then
			self.Slide = Lerp( 0.05, self.Slide, w )

			draw.RoundedBox(2, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox(1, 0, 0, self.Slide, h, Color( 236, 100, 75, 200 ) )
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 )
			draw.RoundedBox(2, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox(1, 0, 0, self.Slide, h, Color( 236, 100, 75, 200 ) )
		end
	end	
	DropMoney.DoClick = function()
		if Money:GetValue() == "" || Money:GetValue() == "Entrer un montant..." then return end

		net.Start( "Wallet:Player:DropMoney" )
		net.WriteInt( Money:GetValue(), 32 )
		net.SendToServer()

		Base:Remove()
	end

	local GiveMoney = vgui.Create( "DButton", Base )
	GiveMoney:SetSize( 245, 35 )
	GiveMoney:SetPos( 250, Base:GetTall() - 40 )
	GiveMoney:SetText( "Donner de l'argent" )
	GiveMoney:SetFont( 'Trebuchet24' )
	GiveMoney:SetTextColor(  Color( 255, 255, 255, 200 ) )
	GiveMoney.OnCursorEntered = function( self ) self.hover = true surface.PlaySound("UI/buttonrollover.wav") end
	GiveMoney.OnCursorExited = function( self ) self.hover = false end
	GiveMoney.Slide = 0
	GiveMoney.Paint = function( self, w, h )
		if self.hover then
			self.Slide = Lerp( 0.05, self.Slide, w )

			draw.RoundedBox(2, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox(1, 0, 0, self.Slide, h, Color( 236, 100, 75, 200 ) )
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 )
			draw.RoundedBox(2, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			draw.RoundedBox(1, 0, 0, self.Slide, h, Color( 236, 100, 75, 200 ) )
		end
	end
	GiveMoney.DoClick = function()
		if Money:GetValue() == "" || Money:GetValue() == "Entrer un montant..." then return end
		
		net.Start( "Wallet:Player:GiveMoney" )
		net.WriteInt( Money:GetValue(), 32 )
		net.SendToServer()

		Base:Remove()
	end
end)