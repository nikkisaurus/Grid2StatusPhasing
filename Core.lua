local Phasing = Grid2.statusPrototype:new("phasing", false)

local cache = {}

local f = CreateFrame("Frame")

function f:Update()
	for unit in Grid2:IterateRosterUnits() do
		if unit == "player" then
			cache[unit] = false
		else
			cache[unit] = UnitPhaseReason and UnitPhaseReason(unit) or (UnitInPhase and (not UnitInPhase(unit) or UnitIsWarModePhased(unit)))
		end

		Phasing:UpdateIndicators(unit)
	end
end

f:SetScript("OnEvent", function(...)
	f:Update()
end)

function Phasing:OnEnable()
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("PLAYER_FLAGS_CHANGED")
	f:RegisterEvent("UNIT_FLAGS")
	f:Update()
end

function Phasing:OnDisable()
	f:UnregisterAllEvents()
	table.wipe(cache)
	f:Update()
end


function Phasing:IsActive(unit)
	return cache[unit]
end

function Phasing:GetIcon()
	return "Interface\\TARGETINGFRAME\\UI-PhasingIcon"
end

Phasing.GetColor = Grid2.statusLibrary.GetColor

Grid2.setupFunc["phasing"] = function(baseKey, dbx)
	Grid2:RegisterStatus(Phasing, {"icon", "color"}, baseKey, dbx)

	return Phasing
end

Grid2:DbSetStatusDefaultValue("phasing", {
	type = "phasing",
	color1 = {r=0, g=0, b=0, a=1}
})