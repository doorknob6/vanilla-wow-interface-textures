FADE_IN_TIME = 2;
DEFAULT_TOOLTIP_COLOR = {0.8, 0.8, 0.8, 0.09, 0.09, 0.09};

function AccountLogin_OnLoad()
	this:SetSequence(0);
	this:SetCamera(0);

	local versionType, buildType, version, internalVersion, date = GetBuildInfo();
	AccountLoginVersion:SetText(format(TEXT(VERSION_TEMPLATE), versionType, version, internalVersion, buildType, date));

	-- Color edit box backdrops
	local backdropColor = DEFAULT_TOOLTIP_COLOR;
	AccountLoginAccountEdit:SetBackdropBorderColor(backdropColor[1], backdropColor[2], backdropColor[3]);
	AccountLoginAccountEdit:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
	AccountLoginPasswordEdit:SetBackdropBorderColor(backdropColor[1], backdropColor[2], backdropColor[3]);
	AccountLoginPasswordEdit:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
end

function AccountLogin_OnShow()
	CurrentGlueMusic = "Sound\\Music\\GlueScreenMusic\\wow_main_theme.mp3";

	-- Check the interface version
	if ( GetDataInterface() ~= GetCodeInterface() ) then
		GlueDialog_Show("DELETE_INTERFACE");
	end

	if ( TOSAccepted() ) then
		AccountLoginUI:Show();
		TOSFrame:Hide();
	else
		if ( ShowTOSNotice() ) then
			TOSNotice:Show();
		end
		AccountLoginUI:Hide();
		TOSFrame:Show();
	end
	
	local accountName = GetLastAccountName();
	local serverName = GetServerName();
	if(serverName) then
		AccountLoginRealmName:SetText(serverName);
	else
		AccountLoginRealmName:Hide()
	end
	
--	if ( accountName and strlen(accountName) > 0 ) then
--		AccountLoginAccountEdit:SetText(accountName);
--		AccountLoginPasswordEdit:SetFocus();
--	else
		AccountLoginAccountEdit:SetText("");
		AccountLoginAccountEdit:SetFocus();
--	end
	AccountLoginPasswordEdit:SetText("");
	
end

function AccountLogin_FocusPassword()
	AccountLoginPasswordEdit:SetFocus("");
end

function AccountLogin_FocusAccountName()
	AccountLoginAccountEdit:SetFocus("");
end

function AccountLogin_OnChar()
end

function AccountLogin_OnKeyDown()
	if ( arg1 == "ESCAPE" ) then
		AccountLogin_Exit();
	elseif ( arg1 == "ENTER" ) then
		if ( not TOSAccepted() ) then
			return;
		elseif ( TOSFrame:IsVisible() ) then
			return;
		end
		AccountLogin_Login();
	elseif ( arg1 == "PRINTSCREEN" ) then
		Screenshot();
	end
end

function AccountLogin_Login()
	PlaySound("gsLogin");
	DefaultServerLogin(AccountLoginAccountEdit:GetText(), AccountLoginPasswordEdit:GetText());
	AccountLoginPasswordEdit:SetText("");
	
end

function AccountLogin_CreateAccount()
	PlaySound("gsLoginNewAccount");
	LaunchURL(SIGNUP_PAGE_URL);
end

function AccountLogin_LaunchCommunitySite()
	PlaySound("gsLoginNewAccount");
	LaunchURL(COMMUNITY_URL);
end

function AccountLogin_Credits()
	if ( not GlueDialog:IsVisible() ) then
		PlaySound("gsTitleCredits");
		SetGlueScreen("credits");
	end
end

function AccountLogin_Cinematics()
	if ( not GlueDialog:IsVisible() ) then
		PlaySound("gsTitleIntroMovie");
		SetGlueScreen("movie");
	end
end

function AccountLogin_Options()
	PlaySound("gsTitleOptions");
end

function AccountLogin_Exit()
	PlaySound("gsTitleQuit");
	QuitGame();
end
