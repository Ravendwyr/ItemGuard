
-- localisation --
local LibStub				= _G.LibStub
local GetNumBuybackItems	= _G.GetNumBuybackItems
local GetBuybackItemLink	= _G.GetBuybackItemLink
local BuybackItem			= _G.BuybackItem



-- creation --
local ItemGuard = LibStub("AceAddon-3.0"):NewAddon("ItemGuard", "AceConsole-3.0", "AceEvent-3.0")



-- initialisation --
function ItemGuard:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ItemGuardDB")
end

function ItemGuard:OnEnable()
	self:RegisterEvent("MERCHANT_UPDATE")
end



-- protection --
function ItemGuard:MERCHANT_UPDATE()
	for i = 1, GetNumBuybackItems() do
		local link = GetBuybackItemLink(i)

		if link then
			BuybackItem(i)
			self:Print(link .. " has been automatically recovered from the vendor.")

			return
		end
	end
end
