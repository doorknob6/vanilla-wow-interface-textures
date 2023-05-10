
TUTORIALFRAME_QUEUE = { };

function TutorialFrame_OnHide()
	PlaySound("igMainMenuClose");
	tremove(TUTORIALFRAME_QUEUE, 1);
	if ( not TutorialFrameCheckButton:GetChecked() ) then
		ClearTutorials();
		TutorialFrameQuestionMarkButton:Hide();
		return;
	end
	if ( getn(TUTORIALFRAME_QUEUE) > 0 ) then
		TutorialFrame_FlashQuestionMark();
	else
		TutorialFrameQuestionMarkButton:Hide();
	end
end

function TutorialFrame_OnShow()
	PlaySound("igMainMenuOpen");
	local currentTutorial = TUTORIALFRAME_QUEUE[1];
	FlagTutorial(currentTutorial);
	local title = getglobal("TUTORIAL_TITLE"..currentTutorial);
	local text = getglobal("TUTORIAL"..currentTutorial);
	if ( title and text) then
		TutorialFrameTitle:SetText(title);
		TutorialFrameText:SetText(text);
	end
	TutorialFrame:SetHeight(TutorialFrameText:GetHeight() + 82);
end

function TutorialFrame_NewTutorial(tutorialID)
	tinsert(TUTORIALFRAME_QUEUE,tutorialID);
	if ( not TutorialFrame:IsVisible() ) then
		TutorialFrame_FlashQuestionMark();
	end
end

function TutorialFrame_FlashQuestionMark()
	TutorialFrameQuestionMarkButton:Show();
	UIFrameFlash(TutorialFrameQuestionMarkButton, 0.75, 0.75, 10, 1);
end
