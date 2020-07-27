DodgeballofTheDead = {}


DodgeballofTheDead.Add = function()
	addChallenge(DodgeballofTheDead);
end

DodgeballofTheDead.OnGameStart = function()

    		
Events.OnGameStart.Add(DodgeballofTheDead.OnNewGame);
Events.EveryTenMinutes.Add(DodgeballofTheDead.EveryTenMinutes);
Events.EveryHours.Add(DodgeballofTheDead.EveryHours);

end

DodgeballofTheDead.DifficultyCheck = function()
	local pl = getPlayer();
	pillowmod = pl:getModData();
	--1in2 is dire, and 1in4 of those is brutal.
	if ZombRand(2)+1 == ZombRand(2)+1 
		then 
			pillowmod.direstart = true;
			pillowmod.brutalstart = false;
			pillowmod.diffcheckdone = true;
			pillowmod.difficultymodifier = ZombRand(5,10);
			pillowmod.injurytimemodifier = ZombRand(10,20);
			if ZombRand(4)+1 == ZombRand(4)+1
			then pillowmod.brutalstart = true;
				pillowmod.direstart = false;

			else print("Normal Start selected");
				pillowmod.direstart = false;
				pillowmod.brutalstart = false;
			end
	end 

	--play the sound
	if pillowmod.direstart then
 		print("Dire Start selected");
		pl:playSound("Thunder");
	elseif pillowmod.brutalstart then
		print("Brutal Start selected");
		pl:playSound("PlayerDied");
	else end

end--end difficulty check

DodgeballofTheDead.OnNewGame = function()

DodgeballofTheDead.DifficultyCheck();

--moved this stuff from onGameStart. 
--

local pl = getPlayer();
pillowmod = pl:getModData();
local inv = pl:getInventory();
		--check if it's a new game
		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			building = pl:getCurrentSquare():getRoom():getBuilding();
			--do gender check  
			--	Tie_Worn 	Shirt_FormalWhite Dress_Normal 		Trousers_Suit Skirt_Knees
			--remove everything
			pl:clearWornItems();
		    pl:getInventory():clear();
		    inv:AddItem("Base.KeyRing");
		else 
		end

end



DodgeballofTheDead.EveryTenMinutes = function()

end -- every 10 mins

DodgeballofTheDead.EveryHours = function()

end --every hours.


DodgeballofTheDead.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	Events.OnGameStart.Add(DodgeballofTheDead.OnGameStart);
	DodgeballofTheDead.setSandBoxVars();

end

DodgeballofTheDead.setSandBoxVars = function()
local options= {}
	if getSandboxPresets():indexOf("pillow")
		
		then
		options = getSandboxOptions();
		options:loadPresetFile("pillow");
		options:toLua();
		options:updateFromLua();
		options:applySettings();
		SandboxVars.TimeSinceApo =  getSandboxOptions():getTimeSinceApo();
		
	else 
		SandboxVars = require "Sandbox/SixMonthsLater"
		


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



DodgeballofTheDead.RemovePlayer = function(p)

end

DodgeballofTheDead.AddPlayer = function(p)

end

DodgeballofTheDead.Render = function()

end

DodgeballofTheDead.spawns = {
{xcell = 42, ycell = 16, x = 253, y = 51}, -- Valley Station,  academy, classroom ID:56
{xcell = 42, ycell = 16, x = 272, y = 67}, -- Valley Station,  academy, office ID:57
{xcell = 37, ycell = 22, x = 227, y = 194}, -- West Point,  school, classroom ID:171
{xcell = 35, ycell = 33, x = 122, y = 74}, -- Muldraugh,  elementary school, classroom ID:255
{xcell = 35, ycell = 33, x = 114, y = 81}, -- Muldraugh,  elementary school, office ID:256
{xcell = 33, ycell = 42, x = 96, y = 60}, -- March Ridge, school, lobby ID:358
{xcell = 33, ycell = 42, x = 104, y = 66}, -- March Ridge, school, office ID:359
{xcell = 33, ycell = 42, x = 95, y = 46}, -- March Ridge, school, classroom ID:360
{xcell = 27, ycell = 38, x = 237, y = 197}, -- Rosewood,  school lobby ID:441
{xcell = 27, ycell = 38, x = 229, y = 198}, -- Rosewood,  school office ID:442
{xcell = 27, ycell = 38, x = 258, y = 214}, -- Rosewood,  school classroom ID:444
{xcell = 21, ycell = 18, x = 129, y = 40}, -- Riverside,  school, lobby ID:579
{xcell = 21, ycell = 18, x = 125, y = 24}, -- Riverside,  school, office ID:580
{xcell = 21, ycell = 18, x = 143, y = 66} -- Riverside,  school, classroom ID:581
}






local spawnselection = ZombRand(14)+1;
local xcell = DodgeballofTheDead.spawns[spawnselection].xcell;
local ycell = DodgeballofTheDead.spawns[spawnselection].ycell;
local x = DodgeballofTheDead.spawns[spawnselection].x;
local y = DodgeballofTheDead.spawns[spawnselection].y;




DodgeballofTheDead.id = "DodgeballofTheDead";
DodgeballofTheDead.image = "media/lua/client/LastStand/DodgeballofTheDead.png";
DodgeballofTheDead.gameMode = "DodgeballOfTheDead";
DodgeballofTheDead.world = "Muldraugh, KY";
DodgeballofTheDead.xcell = xcell;
DodgeballofTheDead.ycell = ycell;
DodgeballofTheDead.x = x;
DodgeballofTheDead.y = y;
DodgeballofTheDead.z = 0;


DodgeballofTheDead.hourOfDay = 7;


DodgeballofTheDead.locations = {
	spawn1 = {playerPos ={xcell = 42, ycell = 16, x = 253, y = 51}, hordePos = {xcell = 42, ycell = 16, x = 253, y = 51}}
}

--Events.OnChallengeQuery.Add(DodgeballofTheDead.Add)

