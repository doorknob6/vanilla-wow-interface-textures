UIOptionsFrameCheckButtons = { };
UIOptionsFrameCheckButtons["INVERT_MOUSE"] = { index = 1, cvar = "mouseInvertPitch" , tooltipText = OPTION_TOOLTIP_INVERT_MOUSE};
UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"] = { index = 2, cvar = "statusBarText" , tooltipText = OPTION_TOOLTIP_STATUS_BAR_TEXT};
UIOptionsFrameCheckButtons["ASSIST_ATTACK"] = { index = 3, cvar = "assistAttack" , tooltipText = OPTION_TOOLTIP_ASSIST_ATTACK};
UIOptionsFrameCheckButtons["SHOW_UNIT_NAMES"] = { index = 4, cvar = "UnitNameRenderMode" , tooltipText = OPTION_TOOLTIP_SHOW_UNIT_NAMES};
UIOptionsFrameCheckButtons["PROFANITY_FILTER"] = { index = 5, cvar = "profanityFilter" , tooltipText = OPTION_TOOLTIP_PROFANITY_FILTER};
UIOptionsFrameCheckButtons["CLICK_TO_MOVE"] = { index = 6, cvar = "autointeract" , tooltipText = OPTION_TOOLTIP_CLICK_TO_MOVE};
UIOptionsFrameCheckButtons["SIMPLE_CHAT_TEXT"] = { index = 7, uvar = "SIMPLE_CHAT" , tooltipText = OPTION_TOOLTIP_SIMPLE_CHAT};
UIOptionsFrameCheckButtons["CHAT_LOCKED_TEXT"] = { index = 8, uvar = "CHAT_LOCKED" , tooltipText = OPTION_TOOLTIP_CHAT_LOCKED};
UIOptionsFrameCheckButtons["SHOW_PET_MELEE_DAMAGE"] = { index = 9, cvar = "PetMeleeDamage" , tooltipText = OPTION_TOOLTIP_PET_MELEE_DAMAGE };
UIOptionsFrameCheckButtons["SHOW_PET_SPELL_DAMAGE"] = { index = 10, cvar = "PetSpellDamage", tooltipText = OPTION_TOOLTIP_PET_SPELL_DAMAGE };
UIOptionsFrameCheckButtons["LOG_PERIODIC_EFFECTS"] = { index = 11, cvar = "CombatLogPeriodicSpells" , tooltipText = OPTION_TOOLTIP_PERIODIC_EFFECTS};
UIOptionsFrameCheckButtons["USE_UBERTOOLTIPS"] = { index = 12, cvar = "UberTooltips" , tooltipText = OPTION_TOOLTIP_UBERTOOLTIPS};
UIOptionsFrameCheckButtons["GUILDMEMBER_ALERT"] = { index = 13, cvar = "guildMemberNotify" , tooltipText = OPTION_TOOLTIP_GUILDMEMBER_ALERT};
UIOptionsFrameCheckButtons["BLOCK_TRADES"] = { index = 14, cvar = "BlockTrades" , tooltipText = OPTION_TOOLTIP_BLOCK_TRADES};
UIOptionsFrameCheckButtons["CAMERA_MODE"] = { index = 15, cvar = "cameraPivot" , tooltipText = OPTION_TOOLTIP_CAMERA_MODE};
UIOptionsFrameCheckButtons["CLEAR_AFK"] = { index = 16, cvar = "autoClearAFK" , tooltipText = OPTION_TOOLTIP_CLEAR_AFK};
UIOptionsFrameCheckButtons["SHOW_PET_NAMEPLATES"] = { index = 17, cvar = "PetNamePlates", tooltipText = OPTION_TOOLTIP_PET_NAMEPLATES};
UIOptionsFrameCheckButtons["REMOVE_CHAT_DELAY_TEXT"] = { index = 18, uvar = "REMOVE_CHAT_DELAY", tooltipText = OPTION_TOOLTIP_REMOVE_CHAT_DELAY};


function UIOptionsFrame_Init()
	SIMPLE_CHAT = "0";
	RegisterForSave("SIMPLE_CHAT");
	CHAT_LOCKED = "0"
	RegisterForSave("CHAT_LOCKED");
	RegisterForSave("REMOVE_CHAT_DELAY");
	--[[for index, value in UIOptionsFrameCheckButtons do
		if ( not value.uvar ) then
			local string = GetCVar(value.cvar);
			value.value = string;
		end
	end]]
	--this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CVAR_UPDATE");
end

function UIOptionsFrame_OnEvent()
	if ( event == "CVAR_UPDATE" ) then
		local info = UIOptionsFrameCheckButtons[arg1];
		if ( info ) then
			info.value = arg2;
		end
		return;
	end
end

function UIOptionsFrame_Load()
	for index, value in UIOptionsFrameCheckButtons do
		local button = getglobal("UIOptionsFrameCheckButton"..value.index);
		local string = getglobal("UIOptionsFrameCheckButton"..value.index.."Text");
		local checked;
		if ( index == "SHOW_UNIT_NAMES" ) then
			if ( GetCVar(value.cvar) == "3" ) then
				checked = 1;
			else
				checked = 0;
			end
		else
			-- See if there's user defined variable, else use a cvar
			if ( value.uvar ) then
				checked = getglobal(value.uvar);
			else
				checked = GetCVar(value.cvar);
			end
		end
		button:SetChecked(checked);
		string:SetText(TEXT(getglobal(index)));
		button.tooltipText = value.tooltipText;
	end
end

function UIOptionsFrame_Save()
	for index, value in UIOptionsFrameCheckButtons do
		local button = getglobal("UIOptionsFrameCheckButton"..value.index);
		if ( index == "SHOW_UNIT_NAMES" ) then
			if ( button:GetChecked() ) then
				value.value = "3";
			else
				value.value = "2";
			end
		else
			if ( button:GetChecked() ) then
				value.value = "1";
			else
				value.value = "0";
			end
			
		end
		if ( value.uvar == "SIMPLE_CHAT" ) then
			SIMPLE_CHAT = value.value;
			if ( value.value == "1" ) then
				FCF_Set_SimpleChat();
			end
		elseif ( value.uvar == "CHAT_LOCKED" ) then
			CHAT_LOCKED = value.value;
		elseif ( value.uvar == "REMOVE_CHAT_DELAY" ) then
			REMOVE_CHAT_DELAY = value.value;
			SetChatMouseOverDelay(REMOVE_CHAT_DELAY);
		else
			SetCVar(value.cvar, value.value, index);
		end
		
	end
end