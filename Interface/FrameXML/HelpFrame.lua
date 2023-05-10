-- "name" is the name of the frame to open, "ticketType" is the trouble ticket category associated with that frame
HELPFRAME_FRAMES = {};
HELPFRAME_FRAMES["Behavior/Harassment"] = { name = "HelpFrameHarassment"};
HELPFRAME_FRAMES["Stuck"] = { name = "HelpFrameStuck"};
HELPFRAME_FRAMES["GMHome"] = { name = "HelpFrameGM"};
HELPFRAME_FRAMES["Home"] = { name = "HelpFrameHome"};
HELPFRAME_FRAMES["OpenTicket"] = { name = "HelpFrameOpenTicket"};

NUM_GM_CATEGORIES_TO_DISPLAY = 10;
GMTICKET_CHECK_INTERVAL = 600;		-- 10 Minutes

elapsedTime = 0;

function HelpFrame_OnLoad()
	-- Tab Handling code
	--PanelTemplates_SetNumTabs(this, 5);
	--PanelTemplates_SetTab(this, 1);
	this:RegisterEvent("UPDATE_GM_STATUS");
end

function HelpFrame_OnShow()
	--HelpFrame_ShowFrame(PanelTemplates_GetSelectedTab(this));
	HelpFrame_ShowFrame("Home");
	UpdateMicroButtons();
	PlaySound("igCharacterInfoOpen");
	GetGMStatus();
end

function HelpFrame_OnEvent()
	if ( event ==  "UPDATE_GM_STATUS" ) then
		if ( arg1 == 1 ) then
			HelpFrameHomeGMButton:Show();
		else
			HelpFrameHomeGMButton:Hide();
		end
	end
end

function HelpFrame_ShowFrame(key, ticketType)
	-- Close previously opened frame
	if ( HelpFrame.openFrame ) then
		HelpFrame.openFrame:Hide();
	end
	
	-- If key is in the HELPFRAME_FRAMES table, use its name otherwise set to OpenTicket and set the category
	local frame;
	if ( HELPFRAME_FRAMES[key] ) then
		frame = getglobal(HELPFRAME_FRAMES[key].name);
	else
		frame = getglobal(HELPFRAME_FRAMES["OpenTicket"].name);
	end
	frame:Show();
	HelpFrame.openFrame = frame;
	
	-- Set the ticketType if there is one
	if ( ticketType ) then
		HelpFrameOpenTicket.ticketType = ticketType;
	end

	--PanelTemplates_SetTab(HelpFrame, id);
end

function ToggleHelpFrame()
	if ( HelpFrame:IsVisible() ) then
		HideUIPanel(HelpFrame);
	else
		ShowUIPanel(HelpFrame);
		StaticPopup_Hide("HELP_TICKET_ABANDON_CONFIRM");
		StaticPopup_Hide("HELP_TICKET");
	end
end

function HelpFrameOpenTicketDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, HelpFrameOpenTicketDropDown_Initialize);
	UIDropDownMenu_SetWidth(335, HelpFrameOpenTicketDropDown);
end

function HelpFrameOpenTicketDropDown_Initialize()
	local index = 1;
	local ticketType = getglobal("TICKET_TYPE"..index);
	local info;
	while (ticketType) do
		info = {};
		info.text = ticketType;
		info.func = HelpFrameOpenTicketDropDown_OnClick;
		info.checked = checked;
		UIDropDownMenu_AddButton(info);
		index = index + 1;
		ticketType = getglobal("TICKET_TYPE"..index);
	end
end

function HelpFrameOpenTicketDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(HelpFrameOpenTicketDropDown, this:GetID());
end

function HelpFrameOpenTicketDropDown_OnShow()
	GetGMTicket();
end

function HelpFrameOpenTicket_OnEvent()
	-- If there are args then the player has a ticket
	if ( arg1 ~= 0 ) then
		-- Has an open ticket
		HelpFrameOpenTicket.ticketType = arg1;
		HelpFrameOpenTicketText:SetText(arg2);
		HelpFrameOpenTicket.hasTicket = 1;
		HelpFrameOpenTicketSubmit:SetText(EDIT_TICKET);
		HelpFrameOpenTicketCancel:SetText(EXIT);
		HelpFrameOpenTicketLabel:SetText(HELPFRAME_OPENTICKET_EDITTEXT);
	else
		-- Doesn't have an open ticket
		HelpFrameOpenTicketText:SetText("");
		HelpFrameOpenTicket.hasTicket = nil;
		HelpFrameOpenTicketSubmit:SetText(SUBMIT);
		HelpFrameOpenTicketCancel:SetText(CANCEL);
		HelpFrameOpenTicketLabel:SetText(HELPFRAME_OPENTICKET_TEXT);
	end	
end

function HelpFrameOpenTicketSubmit_OnClick()
	if ( HelpFrameOpenTicket.hasTicket ) then
		UpdateGMTicket(HelpFrameOpenTicket.ticketType, HelpFrameOpenTicketText:GetText());
		HideUIPanel(HelpFrame);
	else
		NewGMTicket(HelpFrameOpenTicket.ticketType, HelpFrameOpenTicketText:GetText());
		HideUIPanel(HelpFrame);
	end
end

function TicketStatusFrame_OnEvent()
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		GetGMTicket();
	else
		if ( arg1 ~= 0 ) then		
			this:Show();
			BuffFrame:SetPoint("TOPRIGHT", this:GetParent():GetName(), "TOPRIGHT", -205, (-this:GetHeight()));
			refreshTime = GMTICKET_CHECK_INTERVAL;
		else
			this:Hide();
			BuffFrame:SetPoint("TOPRIGHT", this:GetParent():GetName(), "TOPRIGHT", -205, -13);
		end
	end	
end

function HelpFrameButton_OnClick()
	HelpFrame_ShowFrame(this.key, this.ticketType);
end

function HelpFrameGM_Update()
	HelpFrameGM_UpdateCategories(GetGMTicketCategories());
end

function HelpFrameGM_UpdateCategories(...)
	local offset = FauxScrollFrame_GetOffset(HelpFrameGMScrollFrame);
	local index, button, text;
	for i=1, NUM_GM_CATEGORIES_TO_DISPLAY do
		index = 2 * (offset + i) - 1;
		button = getglobal("HelpFrameButton"..i);
		text = getglobal("HelpFrameButton"..i.."Text");
		if ( index <= arg.n  ) then
			text:SetText(arg[index+1]);
			button.key = arg[index+1];
			button.ticketType = arg[index];
			button:Show();
		else
			button:Hide();
		end
	end

	FauxScrollFrame_Update(HelpFrameGMScrollFrame, arg.n/2, NUM_GM_CATEGORIES_TO_DISPLAY, 37);
end

-- Every so often, query the server for our ticket status
-- This only gets called if the UI is up for the ticket
function TicketStatus_OnUpdate(elapsed)
	if ( HelpFrameOpenTicket.hasTicket ) then
		if( refreshTime ) then
			refreshTime = refreshTime - elapsed;

			if ( refreshTime <= 0 ) then
				refreshTime = GMTICKET_CHECK_INTERVAL;
				GetGMTicket();
			end
		end	
	end
end
