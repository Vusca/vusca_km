ESX              = nil
local PlayerData = {}
local inVeh = false
local distance = 0
local vehPlate

local x = 0.0104
local y = 0.098
hasKM = 0
showKM = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(4, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
end

Citizen.CreateThread(function()
  while true do
	Citizen.Wait(250)
			if IsPedInAnyVehicle(PlayerPedId(), false) and not inVeh then
			Citizen.Wait(50)
			local veh = GetVehiclePedIsIn(PlayerPedId(),false)
			local driver = GetPedInVehicleSeat(veh, -1)
			if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
			inVeh = true
			Citizen.Wait(50)
			vehPlate = GetVehicleNumberPlateText(veh)
			Citizen.Wait(1)
			ESX.TriggerServerCallback('esx_carmileage:getMileage', function(hasKM)

			showKM = math.floor(hasKM*1.33)/1000

			local oldPos = GetEntityCoords(PlayerPedId())
			Citizen.Wait(1000)
			local curPos = GetEntityCoords(PlayerPedId())
			if IsVehicleOnAllWheels(veh) then
			dist = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
			else
			dist = 0
			end
			hasKM = hasKM + dist
			
			TriggerServerEvent('esx_carmileage:addMileage', vehPlate, hasKM)
			inVeh = false
			end, GetVehicleNumberPlateText(veh))
			else
			end
		end
	end
end)

displayHud = true

	Citizen.CreateThread(function()
		while true do
			if IsPedInAnyVehicle(PlayerPedId(), false) then
						local veh = GetVehiclePedIsIn(PlayerPedId(),false)
					local driver = GetPedInVehicleSeat(veh, -1)
					if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
				DrawAdvancedText(0.270 - x, 0.96 - y, 0.009, 0.1125, 0.8, round(showKM, 1), 255, 255, 255, 255, 6, 1)
				DrawAdvancedText(0.325 - x, 0.98 - y, 0.036, 0.1125, 0.4, "KM", 255, 255, 255, 255, 6, 1)
				DrawAdvancedText(0.266 - x, 0.96 - y, 0.009, 0.1125, 0.8, "0", 255, 255, 255, 255, 6, 1)
				end
			else
				Citizen.Wait(950)
			end

			Citizen.Wait(0)
		end
	end)

	
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(100000000 + num * mult + 0.5) / mult
end

