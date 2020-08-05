NakedAndAfraid = {}


NakedAndAfraid.Add = function()
	addChallenge(NakedAndAfraid);
end

NakedAndAfraid.OnGameStart = function()

    		
Events.OnGameStart.Add(NakedAndAfraid.OnNewGame);
Events.EveryTenMinutes.Add(NakedAndAfraid.EveryTenMinutes);
Events.EveryHours.Add(NakedAndAfraid.EveryHours);

end

NakedAndAfraid.DifficultyCheck = function()
	local pl = getPlayer();
	pillowmod = pl:getModData();

	if ModOptions and ModOptions.getInstance then
		pillowmod.alwaysdire = PillowModOptions.options.alwaysdire
		pillowmod.alwaysbrutal = PillowModOptions.options.alwaysbrutal
	end 

	--1in2 is dire, and 1in4 of those is brutal.
	if ZombRand(2)+1 == ZombRand(2)+1 
		then 
			pillowmod.direstart = true;
			pillowmod.brutalstart = false;
			if ZombRand(4)+1 == ZombRand(4)+1
			then pillowmod.brutalstart = true;
				pillowmod.direstart = false;
			else print("Normal Start selected");
				pillowmod.direstart = false;
				pillowmod.brutalstart = false;
			end
	end 

	--do override
	if pillowmod.alwaysdire == true
		then pillowmod.direstart = true;
			pillowmod.brutalstart = false;
	elseif pillowmod.alwaysbrutal == true
		then pillowmod.brutalstart = true;
			pillowmod.direstart = false;
	else end

	--play the sound
	if pillowmod.direstart 
	and pillowmod.soundplayed == nil 
	then
 		print("Dire Start selected");
		pl:playSound("Thunder");
		pillowmod.soundplayed = true;

	elseif pillowmod.brutalstart 
	and pillowmod.soundplayed == nil
	then
		print("Brutal Start selected");
		pl:playSound("PlayerDied");
		pillowmod.soundplayed = true;
	else end

end--end difficulty check

NakedAndAfraid.OnNewGame = function()

NakedAndAfraid.DifficultyCheck();

--moved this stuff from onGameStart. 
--
NakedAndAfraid.itemlist = {"Base.Spiffo","Base.Banana","Base.Hat_SantaHatGreen","Base.Scalpel","Base.Ham","Base.Glasses_Aviators","Base.Bleach"};
local pl = getPlayer();
local inv = pl:getInventory();
		--check if it's a new game
		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			--initialize some scenario variables
			pillowmod.wasalarmed = false ;
			pillowmod.building = pl:getCurrentSquare():getRoom():getBuilding();
			--remove everything
			pl:clearWornItems();
		    pl:getInventory():clear();
		    inv:AddItem("Base.KeyRing");

		    if ZombRand(2) == 1 then
		    inv:AddItem(NakedAndAfraid.itemlist[ZombRand(7)]);
			else
			sq = getCell():getGridSquare(pl:getX()+2, pl:getY()-2, pl:getZ());
			sq:AddWorldInventoryItem(NakedAndAfraid.itemlist[ZombRand(7)], 0, 0, 0);
			end 
		  	--set stats 
			pl:getStats():setPanic(100); -- 0 to 100
			pl:getStats():setStress(100); -- 0 to 100
		else 
		end

end

NakedAndAfraid.BuildingAlarmCheck = function()
	pl = getPlayer();

	--check player's building since they could have left
	if pl:getCurrentSquare():getRoom() == nil
		then return
		else pillowmod.plbuilding = pl:getCurrentSquare():getRoom():getBuilding();
	end 

	--make sure player isn't outside nor the alarm has not been set and the current building is not the spawn building
	if (pl:getCurrentSquare():isOutside() == true 
		or pillowmod.wasalarmed == true )
		and (pillowmod.plbuilding ~= pillowmod.building)
		then return
		else 
			pillowmod.plbuilding:getDef():setAlarmed(true);
			pillowmod.wasalarmed = true;
			print("set alarm");
	end 
end--building alarm function

NakedAndAfraid.EveryTenMinutes = function()
	if pillowmod.brutalstart
		then NakedAndAfraid.BuildingAlarmCheck();
	else end 
end -- every 10 mins

NakedAndAfraid.EveryHours = function()
	if pillowmod.direstart
		then NakedAndAfraid.BuildingAlarmCheck();
	else end 
end --every hours.


NakedAndAfraid.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	Events.OnGameStart.Add(NakedAndAfraid.OnGameStart);
	NakedAndAfraid.setSandBoxVars();

end

NakedAndAfraid.setSandBoxVars = function()
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
		SandboxVars = require "Sandbox/Apocalypse"
		


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



NakedAndAfraid.RemovePlayer = function(p)

end

NakedAndAfraid.AddPlayer = function(p)

end

NakedAndAfraid.Render = function()

end

NakedAndAfraid.spawns = {
{xcell = 41, ycell = 17, x = 242, y = 115}, -- Valley Station,  vacant store ID:87
{xcell = 39, ycell = 23, x = 159, y = 12}, -- West Point,  vacant store  ID:115
{xcell = 38, ycell = 23, x = 259, y = 136}, -- West Point,  vacant store ID:157
{xcell = 35, ycell = 31, x = 109, y = 164}, -- Muldraugh,  vacant storefront ID:229
{xcell = 35, ycell = 33, x = 112, y = 6}, -- Muldraugh,  vacant store  ID:249
{xcell = 35, ycell = 33, x = 122, y = 138}, -- Muldraugh,  abandoned restaraunt ID:258
{xcell = 35, ycell = 33, x = 127, y = 247}, -- Muldraugh,  vacant store ID:263
{xcell = 35, ycell = 34, x = 110, y = 117}, -- Muldraugh,  vacant store ID:269
{xcell = 35, ycell = 34, x = 109, y = 150}, -- Muldraugh,  vacant store 1 ID:273
{xcell = 35, ycell = 34, x = 109, y = 158}, -- Muldraugh,  vacant store 2 ID:274
{xcell = 39, ycell = 29, x = 59, y = 103}, -- Dixie, vacant trailer
{xcell = 19, ycell = 17, x = 111, y = 217}, -- Riverside, vacant house
{xcell = 26, ycell = 38, x = 249, y = 156}, -- Rosewood, vacant house
{xcell = 38, ycell = 22, x = 222, y = 281}, -- Westpointe, vacant house
{xcell = 36, ycell = 33, x = 111, y = 120} -- muldraugh, vacant house
}



local spawnselection = ZombRand(15)+1;
local xcell = NakedAndAfraid.spawns[spawnselection].xcell;
local ycell = NakedAndAfraid.spawns[spawnselection].ycell;
local x = NakedAndAfraid.spawns[spawnselection].x;
local y = NakedAndAfraid.spawns[spawnselection].y;




NakedAndAfraid.id = "NakedAndAfraid";
NakedAndAfraid.image = "media/lua/client/LastStand/NakedAndAfraid.png";
NakedAndAfraid.gameMode = "NakedAndAfraid";
NakedAndAfraid.world = "Muldraugh, KY";
NakedAndAfraid.xcell = xcell;
NakedAndAfraid.ycell = ycell;
NakedAndAfraid.x = x;
NakedAndAfraid.y = y;
NakedAndAfraid.z = 0;


NakedAndAfraid.hourOfDay = 7;




Events.OnChallengeQuery.Add(NakedAndAfraid.Add)

