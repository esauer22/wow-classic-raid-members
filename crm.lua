SLASH_GET_RAID_NAMES1 = "/raidmembers"

function SlashCmdList.GET_RAID_NAMES()
	local t = {}
	local t2 = {}
	local parties = {}
	
	for p = 1, 8 do
		local party = {}
		tinsert(parties, party)
	end
	
	for i = 1, GetNumGroupMembers() do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
				
		tinsert(parties[subgroup], name)
		tinsert(t2, name)
	end
	
	for r = 1, 5 do
	    local row = ""
		
		for s = 1, 4 do
			if parties[s][r] ~= nil then
				row = row .. parties[s][r] 	
			else
				row = row .. " "
			end
			
			if s < 4 then
				row = row .. "\t"
			end
		end
		
		tinsert(t, row)
	end
	
	tinsert(t, "")
	tinsert(t, "")
	tinsert(t, "")
	
	for r = 1, 5 do
	    local row = ""
		
		for s = 5, 8 do
			if parties[s][r] ~= nil then
				row = row .. parties[s][r] 	
			else
				row = row .. " "
			end
			
			if s < 8 then
				row = row .. "\t"
			end
		end
		
		tinsert(t, row)
	end
	
	tinsert(t, "")
	tinsert(t, "")
	tinsert(t, "")
	
	sort(t2)
	for i = 1, GetNumGroupMembers() do	
		tinsert(t, t2[i])		
	end
	
	TextAreaBox:Show(table.concat(t, "\n"))
end

TextAreaBox = {}

function TextAreaBox:Create()
	local f = CreateFrame("Frame", nil, UIParent, "DialogBoxFrame")
	self.Frame = f
	f:SetPoint("CENTER")
	f:SetSize(600, 500)

	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
		edgeSize = 16,
		insets = { left = 8, right = 6, top = 8, bottom = 8 },
	})
	f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue

	-- Movable
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown", function(frame, button)
		if button == "LeftButton" then
			frame:StartMoving()
		end
	end)
	f:SetScript("OnMouseUp", f.StopMovingOrSizing)

	-- ScrollFrame
	local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	sf:SetPoint("LEFT", 16, 0)
	sf:SetPoint("RIGHT", -32, 0)
	sf:SetPoint("TOP", 0, -16)
	sf:SetPoint("BOTTOM", f, "BOTTOM", 0, 50)

	-- EditBox
	local eb = CreateFrame("EditBox", nil, sf)
	self.EditBox = eb
	eb:SetSize(sf:GetSize())
	eb:SetMultiLine(true)
	eb:SetAutoFocus(false) -- dont automatically focus
	eb:SetFontObject("ChatFontNormal")
	eb:SetScript("OnEscapePressed", eb.ClearFocus)
	sf:SetScrollChild(eb)

	-- Resizable
	f:SetResizable(true)
	f:SetMinResize(150, 100)
	local rb = CreateFrame("Button", nil, f)
	rb:SetPoint("BOTTOMRIGHT", -6, 7)
	rb:SetSize(16, 16)
	rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

	rb:SetScript("OnMouseDown", function(frame, button)
		if button == "LeftButton" then
			f:StartSizing("BOTTOMRIGHT")
			frame:GetHighlightTexture():Hide() -- more noticeable
		end
	end)
	rb:SetScript("OnMouseUp", function(frame)
		f:StopMovingOrSizing()
		frame:GetHighlightTexture():Show()
		eb:SetWidth(sf:GetWidth())
	end)
end

function TextAreaBox:Show(text)
	if not self.EditBox then
		self:Create()
	end
	self.EditBox:SetText(text)
	self.Frame:Show()
end
