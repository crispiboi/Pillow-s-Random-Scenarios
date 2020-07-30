EnterAreaChallenge = {}



EnterAreaChallenge.Add = function()
	addChallenge(EnterAreaChallenge);
end


EnterAreaChallenge.OnGameStart = function()

    		
Events.OnGameStart.Add(EnterAreaChallenge.OnNewGame);

end


EnterAreaChallenge.OnNewGame = function()
--moved this stuff from onGameStart. 
local pl = getPlayer();
		--check if it's a new game

		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			--:getMinutes() <= 1 
			--and getGameTime():getHour() == getGameTime():getStartTimeOfDay()
			--and getGameTime():getYear() == getGameTime():getStartYear() 

			local inv = pl:getInventory();
			local bag = pl:getInventory():AddItem("Base.Bag_NormalHikingBag");

			--player stuff 
			--give player a hoodie and hat
			EnterAreaChallenge.clothes = {"Base.HoodieDOWN_WhiteTINT","Base.Hat_Beany"}
			for i , item in pairs(EnterAreaChallenge.clothes) do
				clothes = inv:AddItem(item);
				pl:setWornItem(clothes:getBodyLocation(), clothes);
			end



			--vehcile stuff
			--randomize vehicle, 19 in array right now
			local pickacar = ZombRand(19)+1;
			EnterAreaChallenge.carlist = {"Base.CarNormal","Base.CarStationWagon","Base.Van","Base.VanSeats","Base.VanRadio","Base.StepVan","Base.PickUpVan","Base.PickUpTruck","Base.PickUpTruckLights","Base.SportsCar","Base.SmallCar","Base.VanSpecial", "Base.SUV","Base.CarTaxi","Base.SmallCar02","Base.ModernCar","Base.ModernCar02","Base.OffRoad","Base.CarTaxi2"};
			local car = addVehicleDebug(EnterAreaChallenge.carlist[pickacar],IsoDirections.E, nil, getCell():getGridSquare((EnterAreaChallenge.xcell*300)+(EnterAreaChallenge.x-1), (EnterAreaChallenge.ycell*300)+(EnterAreaChallenge.y-1), 0));
			--randomize gas 
			gasvalue= car:getPartById("GasTank"):getContainerCapacity() * ((ZombRand(100)+1)/100);
			car:repair();
			car:getPartById("GasTank"):setContainerContentAmount(gasvalue);
			inv:AddItem(car:createVehicleKey());

			ISTimedActionQueue.add(ISEnterVehicle:new(pl,car,0)); --(character, vehicle, seat index 0 driver)
			ISTimedActionQueue.add(ISStartVehicleEngine:new(pl));
			--add stuff to trunk ... Todo
			

			--give player supplies
			--randomized stuff
			EnterAreaChallenge.supplies = {"Base.CannedTomato2","Base.CannedPotato2","Base.CannedChili","Base.TinnedSoup","Base.TunaTin","Base.WaterBottleFull","Base.PopBottle"};
			--static stuff
			car:getPartById("TruckBed"):getItemContainer():AddItem("camping.CampingTentKit");
			car:getPartById("TruckBed"):getItemContainer():AddItem("Base.TinOpener");
			car:getPartById("TruckBed"):getItemContainer():AddItem("Base.PetrolCan");
			car:getPartById("TruckBed"):getItemContainer():AddItem("Base.TirePump");
			car:getPartById("TruckBed"):getItemContainer():AddItem("Base.LugWrench");
			--fill trunk with stuff randomly.
			for i , item in pairs(EnterAreaChallenge.supplies) do
				local giveit = ZombRand(2)+1 ;
				if giveit == 1 then 
				local amt = ZombRand(4) + 1;
				car:getPartById("TruckBed"):getItemContainer():AddItems(item,amt);
				end
			end
			--wear bag
			pl:setClothingItem_Back(bag);
		else end	
--getSandboxOptions():set("FoodLoot",4); 

end


EnterAreaChallenge.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	--Events.OnGameStart.Add(EnterAreaChallenge.setSandBoxVars);
	Events.OnGameStart.Add(EnterAreaChallenge.OnGameStart);
	EnterAreaChallenge.setSandBoxVars();

end

EnterAreaChallenge.setSandBoxVars = function()
local options= {}
	if getSandboxPresets():indexOf("pillow")
		
		then
		options = getSandboxOptions();
		options:loadPresetFile("pillow");
		options:toLua();
		options:updateFromLua();
		options:applySettings();
		SandboxVars.TimeSinceApo =  getSandboxOptions():getTimeSinceApo();
		SandboxVars.WaterShutModifier = 0;
		SandboxVars.ElecShutModifier = 0;
		
	else 
		SandboxVars = require "Sandbox/SixMonthsLater"
		SandboxVars.WaterShutModifier = 0;
		SandboxVars.ElecShutModifier = 0;


	end

		--start time is returned as the index of the list, not the time.
		--7 am is 1
		--9am is 2, noon is 3, 2 pm is 4, 5pm is 5, 9pm is 6, 12am is 7, 2am is 8,5am is 9
		hourvalue = 7;
		hourset = options:getOptionByName("StartTime"):getValue();
		if hourset == 1 then return 
		elseif hourset == 2 then hourvalue = 9;
		elseif hourset == 3 then hourvalue = 12;
		elseif hourset == 4 then hourvalue = 14;
		elseif hourset == 5 then hourvalue = 17;
		elseif hourset == 6 then hourvalue = 21;
		elseif hourset == 7 then hourvalue = 0;
		elseif hourset == 8 then hourvalue = 2;
		else hourvalue = 5 ;
		end 
		
		gt = getGameTime();
		gt:setTimeOfDay(hourvalue);
		gt:setDay(getSandboxOptions():getOptionByName("StartDay"):getValue());
		gt:setStartDay(getSandboxOptions():getOptionByName("StartDay"):getValue());
		gt:setMonth(getSandboxOptions():getOptionByName("StartMonth"):getValue()-1); -- minus 1 seems to fix the problem


end


EnterAreaChallenge.RemovePlayer = function(p)

end

EnterAreaChallenge.AddPlayer = function(p)

end

EnterAreaChallenge.Render = function()

end

EnterAreaChallenge.spawns = {
		{xcell = 10, ycell = 20, x = 15, y = 144, z = 0, cardinal = "IsoDirections.E"},-- East of Riverside
		{xcell = 35, ycell = 44, x = 95, y = 288, z = 0, cardinal = "IsoDirections.N"},-- South of March Ridge
		{xcell = 42, ycell = 37, x = 277, y = 103, z = 0, cardinal = "IsoDirections.W"},-- South of Muldraugh
		{xcell = 47, ycell = 15, x = 268, y = 38, z = 0, cardinal = "IsoDirections.S"},-- North Valley STation, country road
		{xcell = 41, ycell = 15, x = 217, y = 50, z = 0, cardinal = "IsoDirections.S"},-- North Valley STation, main road
}



local spawnselection = ZombRand(5)+1;
local xcell = EnterAreaChallenge.spawns[spawnselection].xcell;
local ycell = EnterAreaChallenge.spawns[spawnselection].ycell;
local x = EnterAreaChallenge.spawns[spawnselection].x;
local y = EnterAreaChallenge.spawns[spawnselection].y;
EnterAreaChallenge.cardinal = EnterAreaChallenge.spawns[spawnselection].cardinal; -- this doesn't seem to work out.



EnterAreaChallenge.id = "EnterAreaChallenge";
EnterAreaChallenge.image = "media/lua/client/LastStand/EnterAreaChallenge.png";
EnterAreaChallenge.gameMode = "Enter Area Challenge";
EnterAreaChallenge.world = "Muldraugh, KY";
EnterAreaChallenge.xcell = xcell;
EnterAreaChallenge.ycell = ycell;
EnterAreaChallenge.x = x;
EnterAreaChallenge.y = y;
EnterAreaChallenge.z = 0;

EnterAreaChallenge.hourOfDay = 7;


Events.OnChallengeQuery.Add(EnterAreaChallenge.Add)
