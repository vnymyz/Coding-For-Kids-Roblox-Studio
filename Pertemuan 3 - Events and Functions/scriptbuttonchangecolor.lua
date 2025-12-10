local button = script.Parent

-- function itu seperti jurus atau perintah khusus
-- jadi kalau function nya kita panggil nanti jurus nya kita pake !
function changeColor()
	button.Color = Color3.new(
		math.random(), 
		math.random(), 
		math.random()
	)
end

-- event itu seperti alarm atau sinyal
-- kalau terjadi sesuatu nanti  script atau kodingannya bakalan respon
button.ClickDetector.MouseClick:Connect(function(player)
	changeColor()
end)
