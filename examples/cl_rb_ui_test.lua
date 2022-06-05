local function OpenDemoWindow()
    local b = RainBase.UI.CreateBuilder("DFrame")

    b:SetTitle("UI Builder Window")
    b:SetSize(800, 600)
    b:SetPos(50, 50)

    b:BeginChildren()
        b:AddChild("DLabel")
        b:Dock(FILL)
        b:SetText("Hello World!")
        b:SetFont("DermaLarge")

        b:AddChild("DButton")
        b:Dock(TOP)
        b:SetText("Press me to test logging")
        b.DoClick = function()
            RainBase.Logging.Info("This is an info msg", Color(119, 0, 255), "and it has colors!")
            RainBase.Logging.Warn("This is a warning msg")
            RainBase.Logging.Error("This is an error msg")
            RainBase.Logging.Debug("This is a debug msg")
        end
        
        b:AddChild("DPanel")
        b:Dock(BOTTOM)
        b:BeginChildren()
            b:AddChild("DLabel")
            b:Dock(FILL)
            b:SetText("I am nested!")
            b:SetColor(Color(0, 0, 0))
        b:EndChildren()

        b:AddChild("DPanel")
        b:Dock(RIGHT)
        b:BeginChildren()
            b:AddChild("DLabel")
            b:Dock(FILL)
            b:SetText("I am here!")
            b:SetColor(Color(0, 0, 0))
        b:EndChildren()
    b:EndChildren()

    b:MakePopup()
end

EnsureRainBase(function()
    print("RainBase Ready")
    OpenDemoWindow()
end)

print("Registered for RainBase")