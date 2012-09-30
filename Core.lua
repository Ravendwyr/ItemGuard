
-- localisation --

local _G					= _G
local LibStub				= _G.LibStub
local GetNumBuybackItems	= _G.GetNumBuybackItems
local GetBuybackItemLink	= _G.GetBuybackItemLink
local BuybackItem			= _G.BuybackItem

local db



-- creation --

local ItemGuard = LibStub("AceAddon-3.0"):NewAddon("ItemGuard", "AceConsole-3.0", "AceEvent-3.0")



-- initialisation --

function ItemGuard:OnInitialize()
	db = LibStub("AceDB-3.0"):New("ItemGuardDB").profile
end

function ItemGuard:OnEnable()
	self:RegisterEvent("MERCHANT_UPDATE")

	self:RegisterChatCommand("itemguard", "HandleChatCommand")
	self:RegisterChatCommand("guard", "HandleChatCommand")
	self:RegisterChatCommand("protect", "HandleChatCommand")
end



-- protection --

function ItemGuard:HandleChatCommand(link)
	local itemID = link:match("item:(%d+):")

	if not itemID then
		self:Print("Usage: /itemguard [item link]")
		return
	end

	if db[itemID] then
		db[itemID] = nil
		self:Print(link .. " is no longer a protected item.")
	else
		db[itemID] = true
		self:Print(link .. " has been marked as a protected item.")
	end
end

function ItemGuard:MERCHANT_UPDATE()
	for i = 1, GetNumBuybackItems() do
		local link = GetBuybackItemLink(i)

		if link then
			local itemID = link:match("item:(%d+):")

			if db[itemID] then
				BuybackItem(i)
				self:Print(link .. " is a protected item and has been automatically recovered from the vendor.")

				return -- buying an item back triggers another MERCHANT_UPDATE so bail out here to prevent potential hiccups
			end
		end
	end
end
