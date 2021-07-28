local PANEL = {
  Init = function(self)
  
    self:SetSize(1000, 720)
    self:Center()
    
    local x, y = self:GetSize()

    local button = vgui.Create("DButton", self)
    button:SetText("X")
    button:SetFont("MenuFont")
    button:SetSize(50, 30)
    button:SetPos(x - 50, 10)
    function button:Paint(w, h)
      if button:IsDown() or button:IsHovered() then
        button:SetColor(Color(255, 0, 0, 255))
      else
        button:SetColor(Color(255, 255, 255, 255))
      end
    end
    button.DoClick = function() 
      self:SetVisible(false)
      gui.EnableScreenClicker(false)
    end

    local label = vgui.Create("DLabel", self)      
    label:SetFont("MenuFont")
    label:SetText("Help menu")
    label:SizeToContents()
    label:CenterHorizontal()
    label:AlignTop(10)

    local mainPanel = vgui.Create("DPanel", self)
    mainPanel:SetPos(3, 45)
    mainPanel:SetSize(x - 6, y - 35 - 3)
    mainPanel.Paint = function(self, w, h) 
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    local columnSheet = vgui.Create("DColumnSheet", mainPanel)
    columnSheet:Dock(FILL)

    local secondSheet = vgui.Create("DPanel", columnSheet)
    secondSheet:Dock(FILL)
    secondSheet.Paint = function(self, w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 100))
    end
    columnSheet:AddSheet("How to play", secondSheet, "icon16/lightbulb.png")

    local mainSheet = vgui.Create("DPanel", columnSheet)
    mainSheet:Dock(FILL)
    mainSheet.Paint = function(self, w, h) 
      draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 100))
    end
    columnSheet:AddSheet("Rules", mainSheet, "icon16/book.png")

    local thirdSheet = vgui.Create("DPanel", columnSheet)
    thirdSheet:Dock(FILL)
    thirdSheet.Paint = function(self, w, h)
      draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 100))
    end
    columnSheet:AddSheet("Jobs", thirdSheet, "icon16/medal_gold_2.png")

    local scrollPanel = vgui.Create("DScrollPanel", mainSheet)
    scrollPanel:Dock(FILL)

    local scrollPanel2 = vgui.Create("DScrollPanel", secondSheet)
    scrollPanel2:Dock(FILL)

    local scrollPanel3 = vgui.Create("DScrollPanel", thirdSheet)
    scrollPanel3:Dock(FILL)

    local lines = {
      "1 Roleplay refers to the CREDIBILITY with which you play your character and the credibility of the scenes that take place in Evocity. You must strive to get closer to reality. If you have a profession, you must obey your direct superiors and remain credible in the performance of your duties. Abusive, irrational or out-of-context scenarios are prohibited.",
      "2 The NLR or New Life Rule refers to the moment when you die. As soon as you reappear, you play a character who has no memory of his former life. Do not seek revenge.",
      "3 The return on zone designates the fact of intervening in the same action, whereas you are already dead once. This is forbidden for the smooth running of RolePlay. You are dead, you do not return to the area of an action that is still in progress. Resuscitation by a doctor is not considered as a return to the area.",
      "4 You can only undertake an action in the same place every 30 minutes. Avoid regularly attacking the same people, who better to scare off their best enemies? Take your time.",
      "5 It is forbidden to kill a person without CREDIBLE motives or on ABUSIVE motives.",
      "6 In the same way as for rule 5 the action of running over a person with his vehicle is forbidden except in self-defence (someone shooting at your vehicle).",
      "7 Any action known as 'metagaming', i.e., going outside of one's PR role is to be banned as much as possible.",
      "8 It is forbidden to use the physic gun to interact with other players using in-game objects.",
      "9 The Mayor has the power to enact laws directly affecting the lives of citizens. He must justify his laws in a PR manner. His actions may affect the operation of Rule 1.",
      "10 It is forbidden to close a door that has been hung when an action is in progress.",
      "11 It is forbidden to pick up objects while an action is in progress.",
      "12 You can barricade access to an entire area only if all buildings in that area are under your control. The area must still be accessible.",
      "13 It is not allowed to block a room, building or area with objects. Everything must remain accessible without destroying the objects.",
      }

    for _, line in pairs(lines) do
      local label = scrollPanel:Add("DLabel");
      label:SetFont("MenuFont");
      label:SetText(line);
      label:SetAutoStretchVertical(true);
      label:Dock(TOP);
      label:DockMargin(10, 10, 10, 40);
      label:SetWrap(true);
    end

    local logo = vgui.Create("DPanel", secondSheet)
    logo:Dock(TOP)
    logo:SetSize(170, 170)
    logo.Paint = function(self, w, h) 
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
    end

    local mdl = vgui.Create("DModelPanel", logo)
    mdl:SetPos(280, 10)
    mdl:SetSize(160, 160)
    mdl:SetModel("models/maxofs2d/logo_gmod_b.mdl")
    mdl:SetCamPos(Vector(240, 0, 0))
    mdl:SetLookAt(Vector(0, 0, 0))
    mdl:SetFOV(40)

    function mdl:LayoutEntity(ent)
	    ent:SetAngles(Angle(0, RealTime()*100,  0))
    end

    local text_htp = {
      "Hello new player!",
      "Welcome in BasicRP a semi role play gmod server.",
      "Here you can do whatever you want, there is a large choice of job you can do, the goal is simple :LIVE YOUR LIFE AS YOU WANT. To do that you have to discover the world around you and meet people to find differents activities to do.",
      "In this Menu you can find all the information you need to enjoy your life here.",
      "Don't forget to behave well in the game and to pay respect to other player.",
      "Have a great time!",
    }

    for _, line in pairs(text_htp) do
      local label2 = scrollPanel2:Add("DLabel");
      label2:SetFont("MenuFont");
      label2:SetText(line);
      label2:SetAutoStretchVertical(true);
      label2:Dock(TOP);
      label2:DockMargin(10, 10, 10, 10);
      label2:SetWrap(true);
    end

    local text_job1 = {
      "In this section you can find all the informations for jobs you can have in the game.",
    }

    
    local text_job2 = {
      "THE COP:",
      "The principle task of the cop is to enforce the law. For that he past most of his time in patrol.",
      "LOCATION:"
    }

    local text_job3 = {
      "THE MEDIC:",
      "The principle task of the medic is to save people. He has to rescue other players.",
      "LOCATION:"
    }

    local text_job4 = {
      "THE FIREFIGHTER:",
      "The firefighter has to put out the fire when a building is in flame",
      "LOCATION:",
    }

    local text_job5 = {
      "THE MAYOR:",
      "The mayor is the boss of the city, he is in charge of the law and the economy. He is elected by the players but he can be ousted too.",
      "LOCATION:",
    }

    for _, line in pairs(text_job1) do
      local label3 = scrollPanel3:Add("DLabel");
      label3:SetFont("MenuFont");
      label3:SetText(line);
      label3:SetAutoStretchVertical(true);
      label3:Dock(TOP);
      label3:DockMargin(10, 10, 10, 40);
      label3:SetWrap(true);
    end

    for _, line in pairs(text_job2) do
      local label4 = scrollPanel3:Add("DLabel");
      label4:SetFont("MenuFont");
      label4:SetText(line);
      label4:SetAutoStretchVertical(true);
      label4:Dock(TOP);
      label4:DockMargin(10, 10, 10, 10);
      label4:SetWrap(true);
    end
    
    local img_cop = vgui.Create("DImage", scrollPanel3)
    img_cop:Dock(TOP)
    img_cop:SetSize(200, 200)
    img_cop:DockMargin(10, 10, 630, 20)
    img_cop:SetImage("vgui/govt")

    for _, line in pairs(text_job3) do
      local label5 = scrollPanel3:Add("DLabel");
      label5:SetFont("MenuFont");
      label5:SetText(line);
      label5:SetAutoStretchVertical(true);
      label5:Dock(TOP);
      label5:DockMargin(10, 10, 10, 10);
      label5:SetWrap(true);
    end

    local img_medic = vgui.Create("DImage", scrollPanel3)
    img_medic:Dock(TOP)
    img_medic:SetSize(200, 200)
    img_medic:DockMargin(10, 10, 630, 20)
    img_medic:SetImage("vgui/healthstation")

    for _, line in pairs(text_job4) do
      local label6 = scrollPanel3:Add("DLabel");
      label6:SetFont("MenuFont");
      label6:SetText(line);
      label6:SetAutoStretchVertical(true);
      label6:Dock(TOP);
      label6:DockMargin(10, 10, 10, 10);
      label6:SetWrap(true);
    end

    local img_ff = vgui.Create("DImage", scrollPanel3)
    img_ff:Dock(TOP)
    img_ff:SetSize(200, 200)
    img_ff:DockMargin(10, 10, 630, 20)
    img_ff:SetImage("vgui/healthstation")

    for _, line in pairs(text_job5) do
      local label7 = scrollPanel3:Add("DLabel");
      label7:SetFont("MenuFont");
      label7:SetText(line);
      label7:SetAutoStretchVertical(true);
      label7:Dock(TOP);
      label7:DockMargin(10, 10, 10, 10);
      label7:SetWrap(true);
    end

    local img_mayor = vgui.Create("DImage", scrollPanel3)
    img_mayor:Dock(TOP)
    img_mayor:SetSize(200, 200)
    img_mayor:DockMargin(10, 10, 630, 20)
    img_mayor:SetImage("vgui/govt")

  end,

  Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(2, 2, w-4, h-4)
  end

}

vgui.Register("menu_help", PANEL)