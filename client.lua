 --(  ___ \ (  ___  )(  ____ \\__   __/(  ___  )( (    /|(  ____ \| \    /\\__   __/
                          --| (   ) )| (   ) || (    \/   ) (   | (   ) ||  \  ( || (    \/|  \  / /   ) (   
                          --| (__/ / | |   | || (_____    | |   | |   | ||   \ | || (_____ |  (_/ /    | |   
                          --|  __ (  | |   | |(_____  )   | |   | |   | || (\ \) |(_____  )|   _ (     | |   
                          --| (  \ \ | |   | |      ) |   | |   | |   | || | \   |      ) ||  ( \ \    | |   
                          --| )___) )| (___) |/\____) |   | |   | (___) || )  \  |/\____) ||  /  \ \___) (___
                          --|/ \___/ (_______)\_______)   )_(   (_______)|/    )_)\_______)|_/    \/\_______/
                                                                                 
  --_______  _______  ______   _______  _______ _________ _______  _______  _______    _   _    _______   _____    _____   _______ 
  ---|\     /|(  ____ \(  ____ )(  ___ \ (  ___  )(  ____ \\__   __/(  ___  )(  ____ )/ ___   )  ( ) ( )  (  __   ) / ___ \  / ___ \ (  ____ \
  --| )   ( || (    \/| (    )|| (   ) )| (   ) || (    \/   ) (   | (   ) || (    )|\/   )  | _| |_| |_ | (  )  |( (___) )( (   ) )| (    \/
  --| (___) || (__    | (____)|| (__/ / | (___) || |         | |   | (___) || (____)|    /   )(_   _   _)| | /   | \     / ( (___) || (____  
  --|  ___  ||  __)   |     __)|  __ (  |  ___  || |         | |   |  ___  ||     __)   /   /  _| (_) |_ | (/ /) | / ___ \  \____  |(_____ \ 
  ---| (   ) || (      | (\ (   | (  \ \ | (   ) || |         | |   | (   ) || (\ (     /   /  (_   _   _)|   / | |( (   ) )      ) |      ) )
  --| )   ( || (____/\| ) \ \__| )___) )| )   ( || (____/\___) (___| )   ( || ) \ \__ /   (_/\  | | | |  |  (__) |( (___) )/\____) )/\____) )
   --|/     \|(_______/|/   \__/|/ \___/ |/     \|(_______/\_______/|/     \||/   \__/(_______/  (_) (_)  (_______) \_____/ \______/ \______/ 


ESX	= nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
-----------------------------------------------
-------------- GLOBAL VARIABLES ---------------
-----------------------------------------------
local playerPed     	= PlayerPedId()
local isInBaitShopMenu  = false
local currentBaitshop   = {}
local shopMenu
local anchored = false
local boat = nil
local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0
local bait = "none"

-----------------------------------------------
-------------------- SHOP ---------------------
-----------------------------------------------

local SellFishblip = AddBlipForCoord(Config.SellFish.x, Config.SellFish.y, Config.SellFish.z)
SetBlipSprite(SellFishblip, 68)
SetBlipColour(SellFishblip, 15)
SetBlipScale(SellFishblip, 0.8)
SetBlipAsShortRange(SellFishblip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Targ Rybny")
EndTextCommandSetBlipName(SellFishblip)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('vg_fishing:message')
AddEventHandler('vg_fishing:message', function(text)	
	ShowNotification(text)
end, false)

			
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if fishing then
		
		BlockWeaponWheelThisFrame()
		
			if IsControlJustReleased(0, Keys['1']) then
				 input = 1
			end
			if IsControlJustReleased(0, Keys['2']) then
				input = 2
			end
			if IsControlJustReleased(0, Keys['3']) then
				input = 3
			end
			if IsControlJustReleased(0, Keys['4']) then
				input = 4
			end
			if IsControlJustReleased(0, Keys['5']) then
				input = 5
			end
			if IsControlJustReleased(0, Keys['6']) then
				input = 6
			end
			if IsControlJustReleased(0, Keys['7']) then
				input = 7
			end
			if IsControlJustReleased(0, Keys['8']) then
				input = 8
			end
			
			
			if IsControlJustReleased(0, Keys['X']) then
				fishing = false
				ShowNotification("~r~Przestałeś łowić")
			end
			if fishing then
				playerPed = PlayerPedId()
				local pos = GetEntityCoords(PlayerPedId())
				if pos.y >= 5000 or pos.y <= -2700 or pos.x <= -2100 or pos.x >= 2900 or IsPedInAnyVehicle(PlayerPedId()) then
				else
					fishing = false
					ShowNotification("~r~Przestałeś łowić")
				end
				if IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
					ShowNotification("~r~Przestałeś łowić")
				end
			end
			
			
			if pausetimer > 3 then
				input = 99
			end
			
			if pause and input ~= 0 then
				pause = false
				if input == correct then
					TriggerServerEvent('vg_fishing:catch', bait)
				else
					ShowNotification("~r~Ryba się uwolniła")
				end
			end
		end
		
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.SellFish.x, Config.SellFish.y, Config.SellFish.z, true) <= 3 then
			TriggerServerEvent('vg_fishing:startSelling', "fish")
			Citizen.Wait(4000)
		end
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.SellShark.x, Config.SellShark.y, Config.SellShark.z, true) <= 3 then
			TriggerServerEvent('vg_fishing:startSelling', "shark")
			Citizen.Wait(4000)
		end
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z, true) <= 3 then
			TriggerServerEvent('vg_fishing:startSelling', "turtle")
			Citizen.Wait(4000)
		end
		
	end
end)
				

Citizen.CreateThread(function()
	while true do
		Wait(1)
		
		DrawMarker(1, Config.SellFish.x, Config.SellFish.y, Config.SellFish.z , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 250, 250, 0, 50, false, true, 2, false, false, false, false)
		DrawMarker(1, Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 250, 250, 0, 50, false, true, 2, false, false, false, false)
		DrawMarker(1, Config.SellShark.x, Config.SellShark.y, Config.SellShark.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 250, 250, 0, 50, false, true, 2, false, false, false, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = math.random(Config.FishTime.a , Config.FishTime.b)
		Wait(wait)
		if fishing then
			pause = true
			correct = math.random(1,8)
			ShowNotification("~g~Ryba bierze przynętę \n ~h~Wciśnij " .. correct .. " aby ją złapać")
			input = 0
			pausetimer = 0
		end
	end
end)

RegisterNetEvent('vg_fishing:break')
AddEventHandler('vg_fishing:break', function()
	fishing = false
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('vg_fishing:spawnPed')
AddEventHandler('vg_fishing:spawnPed', function()
	RequestModel( GetHashKey( "A_C_SharkTiger" ) )
	while ( not HasModelLoaded( GetHashKey( "A_C_SharkTiger" ) ) ) do
		Citizen.Wait( 1 )
	end
	local pos = GetEntityCoords(PlayerPedId())
	
	local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
	SetEntityHealth(ped, 0)
end)

RegisterNetEvent('vg_fishing:setbait')
AddEventHandler('vg_fishing:setbait', function(bool)
	bait = bool
end)

RegisterNetEvent('vg_fishing:fishstart')
AddEventHandler('vg_fishing:fishstart', function()	
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(playerPed)
	if IsPedInAnyVehicle(playerPed) then
		ShowNotification("~y~Nie możesz łowić z pojazdu")
	else
		if pos.y >= 5000 or pos.y <= -2700 or pos.x <= -2100 or pos.x >= 2900 then
			ShowNotification("~g~Rozpoczełeś łowienie ryb")
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_FISHING", 0, true)
			TriggerEvent('vg_fishing:playSound', "fishing_start")
			fishing = true
		else
			ShowNotification("~y~Musisz się oddalić od brzegu")
		end
	end
end, false)

RegisterNetEvent('vg_fishing:playSound')
AddEventHandler('vg_fishing:playSound', function(sound)
	local clientNetId = GetPlayerServerId(PlayerId())
	TriggerServerEvent("InteractSound_SV:PlayOnOne", clientNetId, sound, 0.5)
end)
