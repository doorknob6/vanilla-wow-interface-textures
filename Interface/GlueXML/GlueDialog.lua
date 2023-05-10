
GlueDialogTypes = { };

GlueDialogTypes["SUGGEST_REALM"] = {
	text = TEXT(format(SUGGESTED_REALM_TEXT,"UNKNOWN REALM")),
	button1 = TEXT(VIEW_ALL_REALMS),
	button2 = TEXT(ACCEPT),
	OnShow = function()
		GlueDialogText:SetText(format(SUGGESTED_REALM_TEXT, RealmWizard.suggestedRealmName));
	end,
	OnAccept = function()
		SetGlueScreen("charselect");
		CharacterSelect_ChangeRealm();
	end,
	OnCancel = function()
		SetGlueScreen("charselect");
		ChangeRealm(RealmWizard.suggestedCategory, RealmWizard.suggestedID);
	end,
}

GlueDialogTypes["DELETE_INTERFACE"] = {
	text = TEXT(DELETE_INTERFACE),
	button1 = TEXT(DELETE),
	button2 = TEXT(EXIT),
	OnAccept = function()
		DeleteInterface();
	end,
	OnCancel = function()
		QuitGame();
	end,
}

GlueDialogTypes["DISCONNECTED"] = {
	text = TEXT(DISCONNECTED),
	button1 = TEXT(OKAY),
	button2 = nil,
	OnShow = function()
		RealmList:Hide();
	end,
	OnAccept = function()
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["INVALID_NAME"] = {
	text = TEXT(CHAR_CREATE_INVALID_NAME),
	button1 = TEXT(OKAY),
	button2 = nil,
	OnAccept = function()
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["CANCEL"] = {
	text = "",
	button1 = TEXT(CANCEL),
	button2 = nil,
	OnAccept = function()
		StatusDialogClick();
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["OKAY"] = {
	text = "",
	button1 = TEXT(OKAY),
	button2 = nil,
	OnAccept = function()
		StatusDialogClick();
	end,
	OnCancel = function()
	end,
}

GlueDialogTypes["OKAY_WITH_URL"] = {
	text = "",
	button1 = TEXT(HELP),
	button2 = TEXT(OKAY),
	OnAccept = function()
		LaunchURL(getglobal(GlueDialog.data));
	end,
	OnCancel = function()
		StatusDialogClick();
	end,
--	useDataForButton1 = 1,
}

GlueDialogTypes["CONNECTION_HELP"] = {
	text = "",
	button1 = TEXT(HELP),
	button2 = TEXT(OKAY),
	OnAccept = function()
		AccountLoginUI:Hide();
		ConnectionHelpFrame:Show();
	end,
	OnCancel = function()
	end,
}

function GlueDialog_Show(which, text, data)
	-- Pick a free dialog to use
	if ( GlueDialog:IsVisible() ) then
		if ( GlueDialogTypes[GlueDialog.which].OnHide ) then
			GlueDialogTypes[GlueDialog.which].OnHide();	
		end
	end

	GlueDialog.data = data;
	-- Set the text of the dialog
	if ( text ) then
		GlueDialogText:SetText(text);
	else
		GlueDialogText:SetText(GlueDialogTypes[which].text);
	end

	-- Set the buttons of the dialog
	if ( GlueDialogTypes[which].button2 ) then
		GlueDialogButton1:ClearAllPoints();
		GlueDialogButton1:SetPoint("BOTTOMRIGHT", "GlueDialogBackground", "BOTTOM", -6, 16);
		GlueDialogButton2:ClearAllPoints();
		GlueDialogButton2:SetPoint("LEFT", "GlueDialogButton1", "RIGHT", 13, 0);
		GlueDialogButton2:SetText(GlueDialogTypes[which].button2);
		GlueDialogButton2:Show();
	else
		GlueDialogButton1:ClearAllPoints();
		GlueDialogButton1:SetPoint("BOTTOM", "GlueDialogBackground", "BOTTOM", 0, 16);
		GlueDialogButton2:Hide();
	end

	if ( GlueDialogTypes[which].useDataForButton1 ) then
		GlueDialogButton1:SetText(getglobal(data..GlueDialogTypes[which].button1));
	else
		GlueDialogButton1:SetText(GlueDialogTypes[which].button1);
	end

	-- Set the miscellaneous variables for the dialog
	GlueDialog.which = which;
	GlueDialog.data = data;

	-- Show or hide the alert icon
	if ( GlueDialogTypes[which].showAlert ) then
		-- If is the delete item dialog display the error image
		GlueDialog:SetWidth(420);
		GlueDialogAlertIcon:Show();
	else
		GlueDialog:SetWidth(320);
		GlueDialogAlertIcon:Hide();
	end

	-- Editbox setup
	if ( GlueDialogTypes[which].hasEditBox ) then
		GlueDialogEditBox:Show();
		if ( GlueDialogTypes[which].maxLetters ) then
			GlueDialogEditBox:SetMaxLetters(GlueDialogTypes[which].maxLetters);
		end
		if ( GlueDialogTypes[which].maxBytes ) then
			GlueDialogEditBox:SetMaxBytes(GlueDialogTypes[which].maxBytes);
		end
	else
		GlueDialogEditBox:Hide();
	end

	-- Finally size and show the dialog
	if ( GlueDialogTypes[which].hasEditBox ) then
		GlueDialogBackground:SetHeight(16 + GlueDialogText:GetHeight() + 8 + GlueDialogEditBox:GetHeight() + 8 + GlueDialogButton1:GetHeight() + 16);
	else
		GlueDialogBackground:SetHeight(16 + GlueDialogText:GetHeight() + 8 + GlueDialogButton1:GetHeight() + 16);
	end
	
	
	--GlueDialogBackground:SetHeight(32 + GlueDialogText:GetHeight() + 8 + GlueDialogButton1:GetHeight() + 16);
	GlueDialog:Show();
end

function GlueDialog_OnLoad()
	this:RegisterEvent("OPEN_STATUS_DIALOG");
	this:RegisterEvent("UPDATE_STATUS_DIALOG");
	this:RegisterEvent("CLOSE_STATUS_DIALOG");
end

function GlueDialog_OnShow()
	local OnShow = GlueDialogTypes[this.which].OnShow;
	if ( OnShow ) then
		OnShow();
	end
end

function GlueDialog_OnEvent()
	if ( event == "OPEN_STATUS_DIALOG" ) then
		GlueDialog_Show(arg1, arg2, arg3);
	elseif ( event == "UPDATE_STATUS_DIALOG" and arg1 and (strlen(arg1) > 0) ) then
		GlueDialogText:SetText(arg1);
		GlueDialogBackground:SetHeight(32 + GlueDialogText:GetHeight() + 8 + GlueDialogButton1:GetHeight() + 16);
	elseif ( event == "CLOSE_STATUS_DIALOG" ) then
		GlueDialog:Hide();
	end
end

function GlueDialog_OnHide()
	
end

function GlueDialog_OnClick(index)
	if ( index == 1 ) then
		local OnAccept = GlueDialogTypes[GlueDialog.which].OnAccept;
		if ( OnAccept ) then
			OnAccept();
		end
	else
		local OnCancel = GlueDialogTypes[GlueDialog.which].OnCancel;
		if ( OnCancel ) then
			OnCancel();
		end
	end
	GlueDialog:Hide();
end

function GlueDialog_OnKeyDown()
	if ( arg1 == "PRINTSCREEN" ) then
		Screenshot();
		return;
	end

	local info = GlueDialogTypes[GlueDialog.which];
	if ( not info or info.ignoreKeys ) then
		return;
	end

	if ( arg1 == "ESCAPE" ) then
		if ( GlueDialogButton2:IsVisible() ) then
			GlueDialogButton2:Click();
		else
			GlueDialogButton1:Click();
		end
	elseif (arg1 == "ENTER" ) then
		GlueDialogButton1:Click();
	end
end
