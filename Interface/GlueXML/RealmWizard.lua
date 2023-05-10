function RealmWizard_OnLoad()
	this:SetSequence(0);
	this:SetCamera(0);
end

function RealmWizard_OnShow()
	RealmWizardGameTypeButton1:Click(1);
	RealmWizardSuggest:Disable();
	RealmWizard_UpdateCategories(GetRealmCategories());
end

function RealmWizard_UpdateCategories(...)
	if ( arg.n > MAX_REALM_CATEGORY_TABS ) then
		_ERRORMESSAGE("Not enough category tabs!  Tell Derek");
	end
	local button;
	for i=1, MAX_REALM_CATEGORY_TABS do
		button = getglobal("RealmWizardLocationButton"..i);
		if ( i <= arg.n ) then
			button:SetText(arg[i]);
			if ( i == RealmWizard.selectedCategory ) then
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end
			button:Show();
		else
			button:Hide();
		end
	end
end

function RealmWizardLocationButton_OnClick(id)
	RealmWizardSuggest:Enable();
	RealmWizard.selectedCategory = id;
	RealmWizard_UpdateCategories(GetRealmCategories());
end

-- Wrapper function so it can be included as a dialog function
function RealmWizard_SetRealm()
	ChangeRealm(RealmWizard.suggestedCategory, RealmWizard.suggestedID);
end