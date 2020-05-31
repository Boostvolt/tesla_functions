local tesla = nil
local tesla_blip = nil
local tesla_pilot = false
local tesla_pilot_ped = nil
local tesla_dance = false

local pilot = false
local crash = false
local dance = false
local crash_ped_fl = nil
local crash_ped_fr = nil
local crash_ped_rl = nil
local crash_ped_rr = nil

TriggerEvent('chat:addSuggestion', '/tesla', 'Tesla car features', {{name="pilot|crash|dance|mark", help="Enable autopilot, crash-avoidance, Model-X Dance or mark your current vehicle as your Tesla."}})
RegisterCommand("tesla", function(source, args)
	if(args[1] == "mark") then
		if(IsPedInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
			tesla = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			minimap("This vehicle is now marked as your Tesla.\nIt can be controlled when you are not sitting in it.")
			if(DoesBlipExist(tesla_blip)) then
				RemoveBlip(tesla_blip)
			end
			tesla_blip = AddBlipForEntity(tesla)
			SetBlipSprite(tesla_blip, 225)
			SetBlipColour(tesla_blip, 75)
			BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Tesla")
			EndTextCommandSetBlipName(tesla_blip)
		else
			tesla = nil
			minimap("Your Tesla has been unmarked.")
			if(DoesBlipExist(tesla_blip)) then
				RemoveBlip(tesla_blip)
			end
			tesla_blip = nil
		end
	else
		if(IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
			if(args[1] == "pilot") then
				waypoint = Citizen.InvokeNative(0xFA7C7F0AADF25D09, GetFirstBlipInfoId(8), Citizen.ResultAsVector())
				print(waypoint)
				if(IsWaypointActive()) then
					if(pilot) then
						pilot = false
						minimap("Auto-Pilot canceled.")
						ClearPedTasks(GetPlayerPed(-1))
					else
						if(crash) then
							crash = false
							minimap("Crash-Avoidance deactivated.")
							--DeletePed(crash_ped_fl)
							DeleteEntity(crash_ped_fl)
							--DeletePed(crash_ped_fr)
							DeleteEntity(crash_ped_fr)
							--DeletePed(crash_ped_front)
							DeleteEntity(crash_ped_front)
							--DeletePed(crash_ped_rear)
							DeleteEntity(crash_ped_rear)
						end
						pilot = true
						minimap("Auto-Pilot activated.")
						TaskVehicleDriveToCoord(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), 0), waypoint["x"], waypoint["y"], waypoint["z"], 100.0, 1.0, GetHashKey(GetVehiclePedIsIn(GetPlayerPed(-1), 0)), 786603, 1.0, 1)
						Citizen.CreateThread(function()
							while pilot do
								Wait(100)
								if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1))["x"], GetEntityCoords(GetPlayerPed(-1))["y"], GetEntityCoords(GetPlayerPed(-1))["z"], waypoint["x"], waypoint["y"], waypoint["z"], 0) < 10.0) then
									while GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0)) - 1.0 > 0.0 do
										SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0), GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), 0)) - 1.0)
										Wait(100)
									end
									pilot = false
									ClearPedTasks(GetPlayerPed(-1))
									minimap("Auto-Pilot deactivated.")
								end
							end
						end)
					end
				else
					minimap("No waypoint set.")
				end
			elseif(args[1] == "crash") then
				if(crash) then
					crash = false
					minimap("Crash-Avoidance deactivated.")
					--DeletePed(crash_ped_fl)
					DeleteEntity(crash_ped_fl)
					--DeletePed(crash_ped_fr)
					DeleteEntity(crash_ped_fr)
					--DeletePed(crash_ped_front)
					DeleteEntity(crash_ped_front)
					--DeletePed(crash_ped_rear)
					DeleteEntity(crash_ped_rear)
				elseif(pilot) then
					minimap("Crash-Avoidance is disabled.")
				else
					RequestModel(225514697)
					while not HasModelLoaded(225514697) do
						Wait(5)
					end
					crash = true
					minimap("Crash-Avoidance activated.")
					crash_ped_fl = CreatePed(0, 225514697, GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["x"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["y"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["z"], 0.0, false, true)
					SetEntityInvincible(crash_ped_fl, true)
					SetEntityVisible(crash_ped_fl, false, 0)
					crash_ped_fr = CreatePed(0, 225514697, GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["x"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["y"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["z"], 0.0, false, true)
					SetEntityInvincible(crash_ped_fr, true)
					SetEntityVisible(crash_ped_fr, false, 0)
					crash_ped_front = CreatePed(0, 225514697, GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["x"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["y"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["z"], 0.0, false, true)
					SetEntityInvincible(crash_ped_front, true)
					SetEntityVisible(crash_ped_front, false, 0)
					crash_ped_rear = CreatePed(0, 225514697, GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["x"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["y"], GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), 0))["z"], 0.0, false, true)
					SetEntityInvincible(crash_ped_rear, true)
					SetEntityVisible(crash_ped_rear, false, 0)
					AttachEntityToEntity(crash_ped_rear, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "boot"), 0.0, -1.8, 0.0, -90.0, 0.0, 0.0, false, false, false, true, 0, true)
					Citizen.CreateThread(function()
						while crash do
							Wait(50)
							DetachEntity(crash_ped_front, false, false)
							DetachEntity(crash_ped_fl, false, false)
							DetachEntity(crash_ped_fr, false, false)
							if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > 5.0) then
								if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) < 16.0) then
									AttachEntityToEntity(crash_ped_front, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "bonnet"), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 2.0, 0.0, 90.0, 0.0, 0.0, false, false, false, true, 0, true)
									AttachEntityToEntity(crash_ped_fl, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "headlight_l"), -0.8, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 5.0, 0.0, 50.0, 90.0, 0.0, false, false, false, true, 0, true)
									AttachEntityToEntity(crash_ped_fr, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "headlight_r"), 0.8, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 5.0, 0.0, 50.0, -90.0, 0.0, false, false, false, true, 0, true)
								else
									AttachEntityToEntity(crash_ped_front, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "bonnet"), 0.0, 8.0, 0.0, 90.0, 0.0, 0.0, false, false, false, true, 0, true)
									AttachEntityToEntity(crash_ped_fl, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "headlight_l"), -0.8, 3.0, 0.0, 50.0, 90.0, 0.0, false, false, false, true, 0, true)
									AttachEntityToEntity(crash_ped_fr, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "headlight_r"), 0.8, 3.0, 0.0, 50.0, -90.0, 0.0, false, false, false, true, 0, true)
								end
							else
								AttachEntityToEntity(crash_ped_front, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "bonnet"), 0.0, 3.5, 0.0, 90.0, 0.0, 0.0, false, false, false, true, 0, true)
								AttachEntityToEntity(crash_ped_fl, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "headlight_l"), -0.8, 0.7, 0.0, 50.0, 90.0, 0.0, false, false, false, true, 0, true)
								AttachEntityToEntity(crash_ped_fr, GetVehiclePedIsIn(GetPlayerPed(-1), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), "headlight_r"), 0.8, 0.7, 0.0, 50.0, -90.0, 0.0, false, false, false, true, 0, true)
							end
							if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
								if(IsAnyObjectNearPoint(GetEntityCoords(crash_ped_fl)["x"], GetEntityCoords(crash_ped_fl)["y"], GetEntityCoords(crash_ped_fl)["z"], 1.4, false)) then
										if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))) > 3.0 then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 45)
										else
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, 45)
										end
								end
								if(IsAnyVehicleNearPoint(GetEntityCoords(crash_ped_fl)["x"], GetEntityCoords(crash_ped_fl)["y"], GetEntityCoords(crash_ped_fl)["z"], 1.4)) then
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))) > 3.0 then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 45)
									else
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, 45)
									end
								end
								--[[if(IsAnyPedNearPoint(GetEntityCoords(crash_ped_fl)["x"], GetEntityCoords(crash_ped_fl)["y"], GetEntityCoords(crash_ped_fl)["z"], 1.4)) then
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))) > 3.0 then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 45)
									else
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, 45)
									end
								end]]
								if(IsAnyObjectNearPoint(GetEntityCoords(crash_ped_fr)["x"], GetEntityCoords(crash_ped_fr)["y"], GetEntityCoords(crash_ped_fr)["z"], 1.4, false)) then
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))) > 3.0 then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 45)
									else
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, 45)
									end
								end
								if(IsAnyVehicleNearPoint(GetEntityCoords(crash_ped_fr)["x"], GetEntityCoords(crash_ped_fr)["y"], GetEntityCoords(crash_ped_fr)["z"], 1.4)) then
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))) > 3.0 then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 45)
									else
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, 45)
									end
								end
								--[[if(IsAnyPedNearPoint(GetEntityCoords(crash_ped_fr)["x"], GetEntityCoords(crash_ped_fr)["y"], GetEntityCoords(crash_ped_fr)["z"], 1.4)) then
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))) > 3.0 then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 45)
									else
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, 45)
									end
								end]]
								if(IsAnyObjectNearPoint(GetEntityCoords(crash_ped_front)["x"], GetEntityCoords(crash_ped_front)["y"], GetEntityCoords(crash_ped_front)["z"], 3.0, false)) then
									TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 45)
								end
								if(IsAnyVehicleNearPoint(GetEntityCoords(crash_ped_front)["x"], GetEntityCoords(crash_ped_front)["y"], GetEntityCoords(crash_ped_front)["z"], 3.0)) then
									TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 45)
								end
								--[[if(IsAnyPedNearPoint(GetEntityCoords(crash_ped_front)["x"], GetEntityCoords(crash_ped_front)["y"], GetEntityCoords(crash_ped_front)["z"], 3.0)) then
									TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 45)
								end]]
								if(IsAnyObjectNearPoint(GetEntityCoords(crash_ped_rear)["x"], GetEntityCoords(crash_ped_rear)["y"], GetEntityCoords(crash_ped_rear)["z"], 2.5, false)) then
									TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 45)
								end
								if(IsAnyVehicleNearPoint(GetEntityCoords(crash_ped_rear)["x"], GetEntityCoords(crash_ped_rear)["y"], GetEntityCoords(crash_ped_rear)["z"], 2.5)) then
									TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 45)
								end
								--[[if(IsAnyPedNearPoint(GetEntityCoords(crash_ped_rear)["x"], GetEntityCoords(crash_ped_rear)["y"], GetEntityCoords(crash_ped_rear)["z"], 2.5)) then
									TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 45)
								end]]
								if(HasEntityBeenDamagedByAnyObject(GetVehiclePedIsIn(GetPlayerPed(-1), false)) or HasEntityBeenDamagedByAnyVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
									crash = false
									minimap("Crash Avoidance canceled.")
									--DeletePed(crash_ped_fl)
									DeleteEntity(crash_ped_fl)
									--DeletePed(crash_ped_fr)
									DeleteEntity(crash_ped_fr)
									--DeletePed(crash_ped_front)
									DeleteEntity(crash_ped_front)
									--DeletePed(crash_ped_rear)
									DeleteEntity(crash_ped_rear)
									ClearEntityLastDamageEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
								end
							else
								crash = false
								minimap("Crash-Avoidance deactivated.")
								--DeletePed(crash_ped_fl)
								DeleteEntity(crash_ped_fl)
								--DeletePed(crash_ped_fr)
								DeleteEntity(crash_ped_fr)
								--DeletePed(crash_ped_front)
								DeleteEntity(crash_ped_front)
								--DeletePed(crash_ped_rear)
								DeleteEntity(crash_ped_rear)
							end
						end
					end)
				end
			elseif(args[1] == "dance") then
				if(dance) then
					dance = false
					SetVehicleDoorsShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
					minimap("Dance-Mode stopped.")
				else
					dance = true
					minimap("Dance-Mode started.")
					Citizen.CreateThread(function()
						while dance do
							Wait(100)
							SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), false), math.random(0, 6), false, false)
							SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), false), math.random(0, 6), false)
						end
					end)
				end
			else
				minimap("Unknown action.")
			end
		elseif(tesla) then
			if(args[1] == "pilot") then
				if(tesla_pilot) then
					if(tesla_pilot_ped) then
						--DeletePed(tesla_pilot_ped)
						RemovePedElegantly(tesla_pilot_ped)
					end
					tesla_pilot = false
					tesla_pilot_ped = nil
					SetVehicleEngineOn(tesla, false, false, false)
					minimap("Auto-Pilot canceled.")
				else
					RequestModel(225514697)
					while not HasModelLoaded(225514697) do
						Wait(5)
					end
					minimap("Auto-Pilot activated.")
					tesla_pilot = true
					tesla_pilot_ped = CreatePed(0, 225514697, GetEntityCoords(tesla)["x"], GetEntityCoords(tesla)["y"], GetEntityCoords(tesla)["z"], 0.0, false, true)
					SetPedIntoVehicle(tesla_pilot_ped, tesla, -1)
					SetEntityInvincible(tesla_pilot_ped, true)
					SetEntityVisible(tesla_pilot_ped, false, 0)
					player_coords = GetEntityCoords(GetPlayerPed(-1))
					TaskVehicleDriveToCoord(tesla_pilot_ped, tesla, player_coords.x, player_coords.y, player_coords.z, 100.0, 1.0, GetHashKey(tesla), 786603, 1.0, 1)
					Citizen.CreateThread(function()
						while tesla_pilot do
							Wait(100)
							if(GetDistanceBetweenCoords(GetEntityCoords(tesla)["x"], GetEntityCoords(tesla)["y"], GetEntityCoords(tesla)["z"], player_coords.x, player_coords.y, player_coords.z, 0) < 10.0) then
								while GetEntitySpeed(tesla) - 1.0 > 0.0 do
									SetVehicleForwardSpeed(tesla, GetEntitySpeed(tesla) - 1.0)
									Wait(100)
								end
								tesla_pilot = false
								--DeletePed(tesla_pilot_ped)
								RemovePedElegantly(tesla_pilot_ped)
								tesla_pilot_ped = nil
								SetVehicleEngineOn(tesla, false, false, false)
								minimap("Auto-Pilot deactivated.")
							end
						end
					end)
				end
			elseif(args[1] == "dance") then
				if(tesla_dance) then
					tesla_dance = false
					SetVehicleDoorsShut(tesla, false)
					minimap("Dance-Mode stopped.")
				else
					tesla_dance = true
					minimap("Dance-Mode started.")
					Citizen.CreateThread(function()
						while tesla_dance do
							Wait(100)
							SetVehicleDoorOpen(tesla, math.random(0, 6), false, false)
							SetVehicleDoorShut(tesla, math.random(0, 6), false)
						end
					end)
				end
			end
		else
			minimap("Unknown vehicle.")
		end
	end
end, false)

function minimap(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end