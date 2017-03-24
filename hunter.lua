--[[
mongoose bite when YOU dodge Interface\Icons\Ability_Hunter_SwiftStrike
counterattack when YOU parry Interface\Icons\Ability_Warrior_Challange

CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES 'Winter wolf attacks. You parry.'
--]]

if UnitClass('player') ~= 'Hunter' then
	return
end

local counterattack
local CA_Timer = 0
local MB_Timer = 0
hunterlock = 0

local f = CreateFrame("Frame")

f:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES')
f:RegisterEvent('CHAT_MSG_SPELL_SELF_DAMAGE')
f:RegisterEvent('PLAYER_ALIVE')

function hunter_OnUpdate()
	if GetTime() >= MB_Timer then
		MB_Frame:Hide()
	end
	if counterattack then
		if GetTime() >= CA_Timer then
			CA_Frame:Hide()
		end
	end
	if CA_Frame:IsShown() ~= 1 and MB_Frame:IsShown() ~= 1 then
		f:SetScript('OnUpdate', nil)
	end
end

function CA_Frame_OnEvent()
	if event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then
		if string.find(arg1, 'Your Mongoose Bite') then
			MB_Frame:Hide()
		end
		if string.find(arg1, 'Your Counterattack') then
			CA_Frame:Hide()
		end
	end
	if event == 'CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES' then
		if string.find(arg1, '%a+ attacks. You parry.') and counterattack then
			CA_Timer = GetTime() + 4
			CA_Frame:Show()
			f:SetScript('OnUpdate', hunter_OnUpdate)
		end
		if string.find(arg1, '%a+ attacks. You dodge.') then
			MB_Timer = GetTime() + 4
			MB_Frame:Show()
			f:SetScript('OnUpdate', hunter_OnUpdate)
		end
	end
	if event == 'PLAYER_ALIVE' then
		local _,_,_,_,islearned = GetTalentInfo(3,14)
		if islearned == 1 then	
			counterattack = true
		else
			counterattack = false
		end
		f:UnregisterEvent('PLAYER_ALIVE')
	end
end

SLASH_HUNTERTIMR1 = '/hunticons'
function SlashCmdList.HUNTERTIMR()
	if hunterlock == 0 then
		hunterlock = 1
		MB_Frame:Show()
		CA_Frame:Show()
		DEFAULT_CHAT_FRAME:AddMessage('Icons unlocked.')
	else
		hunterlock = 0
		MB_Frame:Hide()
		CA_Frame:Hide()
		DEFAULT_CHAT_FRAME:AddMessage('Icons locked.')
	end
end


f:SetScript('OnEvent', CA_Frame_OnEvent)