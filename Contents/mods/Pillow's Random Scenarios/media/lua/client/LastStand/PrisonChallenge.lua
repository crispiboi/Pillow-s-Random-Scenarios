PrisonChallenge = {}


PrisonChallenge.Add = function()
	addChallenge(PrisonChallenge);
end

PrisonChallenge.OnGameStart = function()

    		
Events.OnGameStart.Add(PrisonChallenge.OnNewGame);
Events.OnCreatePlayer.Add(PrisonChallenge.DireCheck);
Events.EveryTenMinutes.Add(PrisonChallenge.EveryTenMinutes);


end

PrisonChallenge.DifficultyCheck = function()
	local pl = getPlayer();
	pillowmod = pl:getModData();

	if ModOptions and ModOptions.getInstance then
		pillowmod.alwaysdire = PillowModOptions.options.alwaysdire
		pillowmod.alwaysbrutal = PillowModOptions.options.alwaysbrutal
	end 

	--1in2 is dire, and 1in4 of those is brutal.
	if pillowmod.diffcheckdone == nil
		and ZombRand(2)+1 == ZombRand(2)+1 
		then 
			pillowmod.direstart = true;
			pillowmod.brutalstart = false;
			pillowmod.diffcheckdone = true;
			if ZombRand(4)+1 == ZombRand(4)+1
			then pillowmod.brutalstart = true;
				pillowmod.direstart = false;
				pillowmod.diffcheckdone = true;
			else 
				pillowmod.brutalstart = false;
			end
		else 
				pillowmod.direstart = false;
				pillowmod.brutalstart = false;
				pillowmod.diffcheckdone = true;
	end 

	--do override
	if pillowmod.alwaysdire == true
		then pillowmod.direstart = true;
			pillowmod.brutalstart = false;
	elseif pillowmod.alwaysbrutal == true
		then pillowmod.brutalstart = true;
			pillowmod.direstart = false;
	else end

	if pillowmod.direstart == true
		then 
			--dire variables
			pillowmod.extrazombs = ZombRand(50,150);
			pillowmod.difficultyloops = ZombRand(3)+1;
			pillowmod.alarmcounter = 3;
			pillowmod.spawnincellchance = ZombRand(1,3);
	elseif pillowmod.brutalstart == true
		then
			--brtual variables
			pillowmod.extrazombs = ZombRand(100,200);
			pillowmod.difficultyloops = ZombRand(6)+1;
			pillowmod.alarmcounter = 1;
			pillowmod.spawnincellchance = ZombRand(1,2);
	else
			--normal variables
			pillowmod.extrazombs = 0;
			pillowmod.difficultyloops = 1;
			pillowmod.alarmcounter = ZombRand(5,20);
			pillowmod.spawnincellchance = ZombRand(1,4);
	end

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

	print("Params -difficultyloops:" .. pillowmod.difficultyloops .. " spawn in cell chance:" .. pillowmod.spawnincellchance .. "alarmcounter:" .. pillowmod.alarmcounter);
	pillowmod.wasalarmed = false;
	pillowmod.breakroomseen = false;
	pillowmod.diningroomseen = false;
	pillowmod.outdoorrecseen = false; 
	pillowmod.parkinglotseen = false;
	pillowmod.mainentranceseen = false;
	pillowmod.northcellblock = false;
	pillowmod.southcellblock = false;
	pillowmod.zombct = 104;


end--end difficulty check

PrisonChallenge.EveryTenMinutes = function ()
	pl=getPlayer();
	pillowmod = pl:getModData();
	--start alarm check stuff
	if pl:getCurrentSquare():isOutside() == true 
				or pl:getCurrentSquare():getRoom() == nil
				then return
				else 
					plbuilding = pl:getCurrentSquare():getRoom():getBuilding();			
	end 

	if building == plbuilding 
		and pillowmod.wasalarmed == false 
		and pillowmod.alarmcounter  <= 1 
		then
			plbuilding:getDef():setAlarmed(true);	
			pillowmod.wasalarmed = true;
	else 
		pillowmod.alarmcounter = pillowmod.alarmcounter - 1 ;
	end	 -- end alarm check stuff	


	--if direstart or brutalstart then
	--	zombct = zombct + extrazombs;
	--else end


	if pillowmod.diningroomseen == false
	 and getCell():getGridSquare(7647,11877,0) ~= nil
	 then 
		-- spawn more zombies in areas
		zombz = ZombRand(pillowmod.zombct);
		print("spawning horde in dining room size:"  .. zombz );
		addZombiesInOutfit(7647, 11877, 0, zombz, Inmate, 0);
		pillowmod.diningroomseen = true;
	end 

	if pillowmod.breakroomseen == false
	and getCell():getGridSquare(7659,11847,0) ~= nil
	then 				
		zombz = ZombRand(pillowmod.zombct);
		print("spawning horde in break room size:" .. zombz);
		addZombiesInOutfit(7659, 11847, 0, zombz, Inmate, 0);
		pillowmod.breakroomseen = true;
	end

	if pillowmod.outdoorrecseen == false
	and getCell():getGridSquare(7640,11918,0) ~= nil
	then 
		zombz = ZombRand(pillowmod.zombct);
		print("spawning horde in outdoor rec size:" .. zombz);
		addZombiesInOutfit(7640, 11918, 0, zombz, Inmate, 0);
		pillowmod.outdoorrecseen = true;
	end 

	if  pillowmod.parkinglotseen == false 
	and getCell():getGridSquare(7615,11782,0) ~= nil
	then 
		zombz = ZombRand(pillowmod.zombct);
		print("spawning horde north of parking lot size:" .. zombz);
		addZombiesInOutfit(7615, 11782, 0, zombz, Inmate , 0);
		pillowmod.parkinglotseen = true;
	end 

	-- spawn zombies outside main door, doesn't matter what difficulty 
	if pillowmod.mainentranceseen == false
	and getCell():getGridSquare(7722,11884,0) ~= nil
	then
		for i=0, pillowmod.difficultyloops do
			zombz = ZombRand(pillowmod.zombct);
			print("spawning horde outside main entrance size:" .. zombz);
			addZombiesInOutfit(7722, 11884, 0, zombz, Inmate, 0);
		end
		pillowmod.mainentranceseen = true;
	end 	


end --end every 10 mins


PrisonChallenge.SpawnZombiesInCells = function()
	print("Run spawn zombies in cells.");

	--algorithm to spawn zombies
	--south bblock east side 7682 x 11943 to 7682 x 11908, south block west side 7696 x 11943 to 7696 x 11908
	--north block east side is 7682 x 11854 to 768x x 11819, north block west side 7696 x 11855 to 7696 x 11819
	-- new prison cell is every 3 squares
	--104 total cells

	local xposeast = 7682;
	local xposwest  = 7696;
	local zpos = 0;
	local ypos = 0;
	local yposnorth = 11855;
	local yposnorthmin = 11817;
	local ypossouthmin = 11907;
	local ypossouth = 11943;
	local sq = getCell():getGridSquare(7683,11943,0);
	pillowmod = getPlayer():getModData();
	--createHordeFromTo(7714,11851,7714,11851,1);


	-- do south side
	while ypossouth >= ypossouthmin do
		--do south side, east
		if ZombRand(pillowmod.spawnincellchance)+1 == 1 
		 then
				print("spawn 1 at :" .. xposeast .. " x " .. ypossouth .. " x " .. zpos);
				addZombiesInOutfit(xposeast,ypossouth, 0, 1, Inmate, 0);
				addZombiesInOutfit(xposeast,ypossouth, 1, 1, Inmate, 0);
		end
		--do south side, west
		if ZombRand(pillowmod.spawnincellchance)+1 == 1 
		 then
				print("spawn 1 at :" .. xposeast .. " x " .. ypossouth .. " x " .. zpos);
				addZombiesInOutfit(xposwest,ypossouth, 0, 1, Inmate, 0);
				addZombiesInOutfit(xposwest,ypossouth, 1, 1, Inmate, 0);
		end
		ypossouth = ypossouth-1;
	end --end south side


-- do north side
	while yposnorth >= yposnorthmin do
		--do north side, east
		if ZombRand(pillowmod.spawnincellchance)+1 == 1  
		 then
				print("spawn 1 at :" .. xposeast .. " x " .. yposnorth .. " x " .. zpos);
				addZombiesInOutfit(xposeast,yposnorth, 0, 1, Inmate, 0);
				addZombiesInOutfit(xposeast,yposnorth, 1, 1, Inmate, 0);
		end
		--do north side, west
		if ZombRand(pillowmod.spawnincellchance)+1 == 1 
		 then
				print("spawn 1 at :" .. xposeast .. " x " .. yposnorth .. " x " .. zpos);
				addZombiesInOutfit(xposwest,yposnorth, 0, 1, Inmate, 0);
				addZombiesInOutfit(xposwest,yposnorth, 1, 1, Inmate, 0);
		end
		yposnorth = yposnorth-1;
	end --end north side

end --end spawn zombies in cell function


PrisonChallenge.OnNewGame = function()
--moved this stuff from onGameStart. 
local pl = getPlayer();
local inv = pl:getInventory();
PrisonChallenge.DifficultyCheck();
building = pl:getCurrentSquare():getRoom():getBuilding();



		-- give player a jump suit and a random tool to break out with
		--check if it's a new game
		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			--remove everything
			pl:clearWornItems();
		    pl:getInventory():clear();

		  --give player gear
			PrisonChallenge.clothes = {"Base.Boilersuit_Prisoner","Base.Shoes_Slippers","Base.Socks_Long"}
			for i , item in pairs(PrisonChallenge.clothes) do
				clothes = inv:AddItem(item);
				pl:setWornItem(clothes:getBodyLocation(), clothes);
			end

			belt = inv:AddItem("Base.Belt2");
			pl:setWornItem(belt:getBodyLocation(),belt);

			inv:AddItem("Base.KeyRing");
			

			PrisonChallenge.toollist = {"Base.BallPeenHammer","Base.Broom","Base.ClubHammer","Base.Crowbar","Base.Hammer","Base.HandAxe",
			"Base.LeadPipe","Base.Nightstick","Base.PickAxe","Base.PipeWrench","Base.Rake","Base.Shovel","Base.Shovel2",
			"Base.SnowShovel","Base.WoodAxe","Base.WoodenMallet"}

			--roll for Sledgehammer
			--give slege for roll won, else something from the list
			if ZombRand(100)+1 == ZombRand(100)+1 then
				print("Lucky enough to win the Sledgehammer")
				wpn = inv:AddItem("Base.Sledgehammer");
			else
				local pickatool = ZombRand(16)+1;
				wpn = inv:AddItem(PrisonChallenge.toollist[pickatool]);
			end

			pl:setPrimaryHandItem(wpn);
			pl:setSecondaryHandItem(wpn);

			--roll for building key
			if ZombRand(100)+1 == ZombRand(100)+1 then
				print("Lucky enough to win the building key")
				sq = pl:getCurrentSquare();
				keyid = sq:getBuilding():getDef():getKeyId();
				inv:AddItem("Base.Key1"):setKeyID(keyid);
			end


			PrisonChallenge.SpawnZombiesInCells();



		--make noise so zombies try to get player
		addSound(getPlayer(), getPlayer():getX(), getPlayer():getY(), 0, 500, 500); 
		addSound(getPlayer(), 7708, 11878, 0, 500, 500); --main desk
		addSound(getPlayer(), 7659, 11882, 0, 500, 500); --hall outside dining hall
		addSound(getPlayer(), 7655, 11912, 0, 500, 500); --locker room near basketball court

		else end --end of new game check loop, anything below this is not going to happen


end


PrisonChallenge.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	
	Events.OnGameStart.Add(PrisonChallenge.OnGameStart);
	PrisonChallenge.setSandBoxVars();
end

PrisonChallenge.setSandBoxVars = function()
local options= {}
	if getSandboxPresets():indexOf("pillow")
		
		then
		options = getSandboxOptions();
		options:loadPresetFile("pillow");
		options:toLua();
		options:updateFromLua();
		options:applySettings();
		SandboxVars.TimeSinceApo =  getSandboxOptions():getTimeSinceApo();
		SandboxVars.WaterShutModifier = 1;
		SandboxVars.ElecShutModifier = 1;		
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


PrisonChallenge.RemovePlayer = function(p)

end

PrisonChallenge.AddPlayer = function(p)

end

PrisonChallenge.Render = function()

end

PrisonChallenge.spawns = {
{xcell = 25, ycell = 39, x = 179, y = 130,z=0}, -- Rosewood,  cell 1, north block ID:472
{xcell = 25, ycell = 39, x = 198, y = 127,z=0}, -- Rosewood,  cell 2, north block ID:473
{xcell = 25, ycell = 39, x = 179, y = 240,z=0}, -- Rosewood,  cell 3, south block ID:475
{xcell = 25, ycell = 39, x = 198, y = 225,z=0}, -- Rosewood,  cell 4, south block ID:476
{xcell = 25, ycell = 39, x = 179, y = 210,z=0}, -- Rosewood, cell 5, south block ID:648
{xcell = 25, ycell = 39, x = 179, y = 231,z=0}, -- Rosewood, cell 6, south block ID:649
{xcell = 25, ycell = 39, x = 179, y = 234, z = 1}, -- Rosewood, cell 7, south block ID:650
{xcell = 25, ycell = 39, x = 198, y = 234, z = 1} -- Rosewood, cell 8, south block ID:651


}



local spawnselection = ZombRand(8)+1;
local xcell = PrisonChallenge.spawns[spawnselection].xcell;
local ycell = PrisonChallenge.spawns[spawnselection].ycell;
local x = PrisonChallenge.spawns[spawnselection].x;
local y = PrisonChallenge.spawns[spawnselection].y;
local z = PrisonChallenge.spawns[spawnselection].z;

PrisonChallenge.id = "PrisonChallenge";
PrisonChallenge.image = "media/lua/client/LastStand/PrisonChallenge.png";
PrisonChallenge.gameMode = "PrisonChallenge";
PrisonChallenge.world = "Muldraugh, KY";
PrisonChallenge.xcell = xcell;
PrisonChallenge.ycell = ycell;
PrisonChallenge.x = x;
PrisonChallenge.y = y;
PrisonChallenge.z = z;

Events.OnChallengeQuery.Add(PrisonChallenge.Add)

