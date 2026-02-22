local function OnTooltipSetItem(tooltip)
    local name, link = tooltip:GetItem()
    if not link then return end

    local itemID = tonumber(link:match("item:(%d+)"))
    if not itemID then return end

    local upgrades = UpgradeDB[itemID]
    if not upgrades then return end

    tooltip:AddLine(" ")
    tooltip:AddLine("|cff00ff00Upgrades into:|r")

    for _, upgradeID in ipairs(upgrades) do
        local upgradeName = GetItemInfo(upgradeID) or ("item:" .. upgradeID)
        tooltip:AddLine("  • " .. upgradeName)
    end

    tooltip:AddLine(" ")
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)

-------------------------------------------------
-- Icon overlay system
-------------------------------------------------

local function AddUpgradeIcon(frame, itemID)
    if not UpgradeDB[itemID] then return end
    if frame.LizardUpgradeIcon then return end

    local icon = frame:CreateTexture(nil, "OVERLAY")
    icon:SetSize(12, 12)
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
    icon:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")

    frame.LizardUpgradeIcon = icon
end

hooksecurefunc("ContainerFrame_Update", function(frame)
    for i = 1, frame.size do
        local button = _G[frame:GetName().."Item"..i]
        if button then
            local bag = frame:GetID()
            local slot = button:GetID()
            local itemID = GetContainerItemID(bag, slot)
            if itemID then
                AddUpgradeIcon(button, itemID)
            end
        end
    end
end)
