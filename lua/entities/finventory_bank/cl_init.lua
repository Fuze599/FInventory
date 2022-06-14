include('shared.lua')
 

function ENT:Draw()
    self:DrawModel()

    local angle = self:GetAngles()
	angle:RotateAroundAxis(angle:Up(), -180)
	angle:RotateAroundAxis(angle:Forward(), 90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < finventoryConfig.distance3D2D then
		    cam.Start3D2D(self:GetPos(), angle, 0.1)
            -- draw.RoundedBox(15, -205, -385, 170, 70, Color(200,30,30))
		    -- draw.RoundedBox(15, -200, -380, 160, 60, Color(30,30,30))
		    draw.SimpleText("Bank", "FInventoryLargeFont", -120, -350, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
	end 
end
