include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	local angle = self:GetAngles()
	local position = self:GetPos()

	angle:RotateAroundAxis(angle:Up(), 90)
	angle:RotateAroundAxis(angle:Forward(), 90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < finventoryConfig.distance3D2D then
		cam.Start3D2D(position + angle:Right() * - 80 + angle:Forward() * - 0.5, Angle(0, LocalPlayer():GetAngles().y - 90, 90), 0.05)
			draw.SimpleText("Backpack vendor", "FInventoryExtraLargeFont", 0, -4, color_white, 1)
		cam.End3D2D()
	end

end