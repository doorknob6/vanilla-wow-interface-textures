function Localize()
	GOVERNMENT_RATING_IMAGE = "Interface\\Glues\\Login\\Glues-ESRBRating";

	WorldOfWarcraftRating:SetTexture(GOVERNMENT_RATING_IMAGE);
	WorldOfWarcraftRating:ClearAllPoints();
	WorldOfWarcraftRating:SetPoint("BOTTOMLEFT", "GlueParent", "BOTTOMLEFT", 10, 45);
	WorldOfWarcraftRating:Show();
end
