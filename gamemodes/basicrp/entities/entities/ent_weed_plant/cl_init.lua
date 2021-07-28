include("shared.lua")

function ENT:Draw()
  if self.Entity:GetNWBool("done") then
    self:DrawEntityOutline(1.0)
  else
    self:DrawEntityOutline(0.0)
  end
  self:DrawModel();
end

local matOutlineWhite 	= Material( "white_outline" )
local ScaleNormal		= 1
local ScaleOutline1		= 1 * 1
local ScaleOutline2		= 1 * 1.1
local matOutlineBlack 	= Material( "black_outline" )

function ENT:DrawEntityOutline( size )
	
	size = size or 1.0
	render.SuppressEngineLighting( true )
	render.SetAmbientLight( 1, 1, 1 )
	render.SetColorModulation( 1, 1, 1 )
	
		// First Outline	
		self:SetModelScale( ScaleOutline2 * size,0 )
		render.MaterialOverride( matOutlineBlack )
		self:DrawModel()
		
		
		// Second Outline
		self:SetModelScale( ScaleOutline1 * size,0 )
		render.MaterialOverride( matOutlineWhite )
		self:DrawModel()
		
		// Revert everything back to how it should be
		render.MaterialOverride( nil )
		self:SetModelScale( ScaleNormal,0 )
		
	render.SuppressEngineLighting( false )
	
	local col = self:GetColor()
	render.SetColorModulation( col.r/255, col.g/255, col.b/255 )

end