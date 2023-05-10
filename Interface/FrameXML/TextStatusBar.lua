
function TextStatusBar_Initialize()
	this:RegisterEvent("CVAR_UPDATE");
	this.lockShow = 0;
end

function SetTextStatusBarText(bar, text)
	if ( not bar or not text ) then
		return
	end
	bar.TextString = text;
end

function TextStatusBar_OnEvent(cvar, value)
	if ( event == "CVAR_UPDATE" and cvar == "STATUS_BAR_TEXT" ) then
		if ( this.TextString ) then
			if ( value == "1" and this.textLockable ) then
				this.TextString:Show();
			elseif ( this.lockShow == 0 ) then
				this.TextString:Hide();
			end
		end
	end
end

function TextStatusBar_UpdateTextString()
	local string = this.TextString;
	if(string) then
		local value = this:GetValue();
		local valueMin, valueMax = this:GetMinMaxValues();
		if ( valueMax > 0 ) then
			this:Show();
			if ( value == 0 and this.zeroText ) then
				string:SetText(this.zeroText);
				this.isZero = 1;
				string:Show();
			else
				this.isZero = nil;
				if ( this.prefix ) then
					string:SetText(this.prefix.." "..value.." / "..valueMax);
				else
					string:SetText(value.." / "..valueMax);
				end
				if ( UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"].value == "1" and this.textLockable ) then
					string:Show();
				elseif ( this.lockShow > 0 ) then
					string:Show();
				else
					string:Hide();
				end
			end
		else
			this:Hide();
		end
	end
end

function TextStatusBar_OnValueChanged()
	TextStatusBar_UpdateTextString();
end

function SetTextStatusBarTextPrefix(bar, prefix)
	if ( bar and bar.TextString ) then
		bar.prefix = prefix;
	end
end

function SetTextStatusBarTextZeroText(bar, zeroText)
	if ( bar and bar.TextString ) then
		bar.zeroText = zeroText;
	end
end

function ShowTextStatusBarText(bar)
	if ( bar and bar.TextString ) then
		if ( not bar.lockShow ) then
			bar.lockShow = 0;
		end
		bar.TextString:Show();
		bar.lockShow = bar.lockShow + 1;
	end
end

function HideTextStatusBarText(bar)
	if ( bar and bar.TextString ) then
		if ( not bar.lockShow ) then
			bar.lockShow = 0;
		end
		if ( bar.lockShow > 0 ) then
			bar.lockShow = bar.lockShow - 1;
		end
		if ( bar.lockShow > 0 or this.isZero == 1) then
			bar.TextString:Show();
		elseif ( UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"].value == "1" and bar.textLockable ) then
			bar.TextString:Show();
		else
			bar.TextString:Hide();
		end
	end
end
