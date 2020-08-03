--- START OF CONFIGURATION
local vehicles = "ast,some,example,vehicle,models" -- define what cars can be used as a tesla (by modelname), set to "" (empty) for all cars
local debug = true
--- END OF CONFIGURATION

local tesla = nil
local tesla_blip = nil
local tesla_pilot = false
local tesla_pilot_ped = nil
local tesla_dance = false

local pilot = false
local lines = false
local crash = false
local dance = false

TriggerEvent('chat:addSuggestion', '/tesla', 'Tesla car features', {{name="pilot|lines|crash|dance|mark", help="Enable autopilot, reverse lines, crash-avoidance, Model-X Dance or mark your current vehicle as your Tesla."}})
RegisterCommand("tesla", function(source, args)
	if(args[1] == "mark") then
		if(IsPedInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and (vehicles:find(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))) or vehicles == "")) then
			tesla = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			SetEntityAsMissionEntity(tesla, true, true)
			minimap("This vehicle is now marked as your Tesla.\nIt can be controlled when you are not sitting in it.")
			if(DoesBlipExist(tesla_blip)) then
				RemoveBlip(tesla_blip)
			end
			tesla_blip = AddBlipForEntity(tesla)
			SetBlipSprite(tesla_blip, 79)
			SetBlipColour(tesla_blip, 25)
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
		if(IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and (vehicles:find(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)))) or vehicles == "")) then
			if(args[1] == "pilot") then
				waypoint = Citizen.InvokeNative(0xFA7C7F0AADF25D09, GetFirstBlipInfoId(8), Citizen.ResultAsVector())
				if(IsWaypointActive()) then
					if(pilot) then
						pilot = false
						minimap("Auto-Pilot canceled.")
						ClearPedTasks(GetPlayerPed(-1))
					else
						if(crash) then
							crash = false
							minimap("Crash-Avoidance deactivated.")
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
								if(IsControlPressed(27, 63) or IsControlPressed(27, 64) or IsControlPressed(27, 71) or IsControlPressed(27, 72) or IsControlPressed(27, 76)) then
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
				elseif(pilot) then
					pilot = false
					ClearPedTasks(GetPlayerPed(-1))
					minimap("Auto-Pilot deactivated.")
					crash = true
					minimap("Crash-Avoidance activated.")
				else
					RequestModel(225514697)
					while not HasModelLoaded(225514697) do
						Wait(5)
					end
					crash = true
					minimap("Crash-Avoidance activated.")
					Citizen.CreateThread(function()
						while crash do
							Wait(5)
							if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
								if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) < 0.2) then -- standing
									if(debug) then
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 1.5, false)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 200)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 200)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 1.5) or IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, 200)
									end
								elseif(GetVehicleCurrentGear(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 0) then -- reverse
									if(debug) then
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).z, 1.5, false)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).z, 1.5, false)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 200)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).z, 1.5, false)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, 200)
									end
									if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
									end
									if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 200)
									end
									if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 4.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 3.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, 200)
									end
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) < 4.0) then
										if(debug) then
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 1.5) or IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -3.5, 0.0).z, 1.5) or IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -3.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
									elseif(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > 12.0) then
										if(debug) then
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).z, 255, 50, 50, 1.0, 10.0)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).z, 1.5) or IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -13.0, 0.0).z, 1.5) or IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -13.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
									else
										if(debug) then
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 255, 50, 50, 1.0, 10.0)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5) or IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5) or IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, 200)
										end
									end
								else -- normal
									if(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) < 4.0) then
										if(debug) then
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 3.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 2.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 2.5, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
									elseif(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > 25.0) then
										if(debug) then
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).z, 255, 50, 50, 1.0, 10.0)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, 26.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, 25.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, 25.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
									else
										if(debug) then
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 255, 50, 50, 1.0, 10.0)
											DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 255, 50, 50, 1.0, 10.0)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).z, 1.5, false)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 200)
										end
										if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -2.0, GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) - 1.0, 0.0).z, 1.5)) then
											TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, 200)
										end
									end
									if(debug) then
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
										DrawLightWithRange(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).z, 255, 50, 50, 1.0, 10.0)
									end
									if(IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).z, 1.5, false)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, 200)
									end
									if(IsAnyPedNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, 200)
									end
									if(IsAnyVehicleNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -4.5, 0.0).z, 1.5, false) or IsAnyObjectNearPoint(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -4.5, 0.0).z, 1.5)) then
										TaskVehicleTempAction(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, 200)
									end
								end
								if(HasEntityBeenDamagedByAnyObject(GetVehiclePedIsIn(GetPlayerPed(-1), false)) or HasEntityBeenDamagedByAnyVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
									crash = false
									minimap("Crash Avoidance canceled.")
									ClearEntityLastDamageEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
								end
							else
								crash = false
								minimap("Crash Avoidance deactivated.")
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
			elseif(args[1] == "lines") then
				if(lines) then
					minimap("Reverse lines deactivated.")
					lines = false
				else
					minimap("Reverse lines activated.")
					lines = true
					Citizen.CreateThread(function()
						while lines do
							Wait(5)
							if(IsPedInAnyVehicle(GetPlayerPed(-1)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
								if(GetVehicleCurrentGear(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == 0) then
									DrawLine(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -2.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -2.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0, -2.0, 0.0).z, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0 - (GetVehicleSteeringAngle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false), "CHandlingData", "fSteeringLock")), -6.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0 - (GetVehicleSteeringAngle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false), "CHandlingData", "fSteeringLock")), -6.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0 - (GetVehicleSteeringAngle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false), "CHandlingData", "fSteeringLock")), -6.0, 0.0).z, 255, 255, 255, 255)
									DrawLine(GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -2.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -2.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0, -2.0, 0.0).z, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0 - (GetVehicleSteeringAngle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false), "CHandlingData", "fSteeringLock")), -6.0, 0.0).x, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0 - (GetVehicleSteeringAngle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false), "CHandlingData", "fSteeringLock")), -6.0, 0.0).y, GetOffsetFromEntityInWorldCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1.0 - (GetVehicleSteeringAngle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false), "CHandlingData", "fSteeringLock")), -6.0, 0.0).z, 255, 255, 255, 255)
								end
							else
								lines = false
							end
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
					SetEntityAsMissionEntity(tesla_pilot_ped, true, true)
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