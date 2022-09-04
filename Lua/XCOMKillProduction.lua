-- XCOMKillProduction
-- Author: cicero225
-- DateCreated: 6/12/2015 1:26:06 AM
--------------------------------------------------------------

function XCOMStart()
	for _, player in pairs(Players) do
		if player:IsEverAlive() then
			if(player:GetCivilizationType() == GameInfoTypes["CIVILIZATION_XCOM"]) then		
				GameEvents.UnitKilledInCombat.Add(OnUnitKilledInCombatbyXCOMGiveProduction)
			end
		end
	end
end
Events.SequenceGameInitComplete.Add(XCOMStart)

function OnUnitKilledInCombatbyXCOMGiveProduction(iKiller, iKilled, iKilledUnit)
	if iKiller == GameDefines.MAX_CIV_PLAYERS then return end
	local pKiller = Players[iKiller]
	if pKiller:IsEverAlive() and not pKiller:IsMinorCiv() and iKiller~=GameDefines.MAX_CIV_PLAYERS then
		if (pKiller:GetCivilizationType()==GameInfoTypes["CIVILIZATION_XCOM"]) and iKilled~=GameDefines.MAX_CIV_PLAYERS then --Barb kills don't count
			local addProd=GameInfo.Units[iKilledUnit].Cost/2
			--local addSci=GameInfo.Units[iKilledUnit].Combat/2
			pKiller:GetCapitalCity():ChangeProduction(addProd)
			local pTeamID = pKiller:GetTeam()
			local pTeam = Teams[pTeamID]
			local pTeamTechs = pTeam:GetTeamTechs()
			local Research = pKiller:GetCurrentResearch()		
			pTeamTechs:ChangeResearchProgress(Research, addProd, iKiller)
		end
	end
end