TheTestSubject = {}


TheTestSubject.Add = function()
	addChallenge(TheTestSubject);
end

TheTestSubject.OnGameStart = function()

    		
Events.OnGameStart.Add(TheTestSubject.OnNewGame);
Events.EveryTenMinutes.Add(TheTestSubject.EveryTenMinutes);
Events.EveryHours.Add(TheTestSubject.EveryHours);

end


TheTestSubject.OnNewGame = function()


local pl = getPlayer();
local inv = pl:getInventory();
pillowmod = pl:getModData();

pillowmod.caves1done = false;
pillowmod.caves2done = false;
pillowmod.security1done = false;
pillowmod.morguedone = false;
pillowmod.operatingdone  = false;
pillowmod.cafeteriadone = false;
pillowmod.armorydone = false;
pillowmod.controldone = false;
pillowmod.stairsdone = false;
pillowmod.lobbydone = false;
pillowmod.dorm1done = false;
pillowmod.dorm2done = false;
pillowmod.dorm3done = false;
pillowmod.dorm4done = false;

		--check if it's a new game
		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
		    inv:AddItem("Lantern_CraftedElectric");
		    inv:AddItem("Battery");
		    wpn = inv:AddItem("Stone2");
		    pl:setPrimaryHandItem(wpn);

		    -- there are 6 sleeping spots in the room
		    local sq = getCell():getGridSquare(5695, 12438, -17);
        	if sq ~= nil then
           	zombieBody = createRandomDeadBody(sq, 10);
        	else end
        	local sq = getCell():getGridSquare(5688, 12445, -17);
        	if sq ~= nil then
           	createRandomDeadBody(sq, 10);
        	else end
        	local sq = getCell():getGridSquare(5690, 12434, -17);
        	if sq ~= nil then
           	createRandomDeadBody(sq, 10);
        	else end
        	local sq = getCell():getGridSquare(5685, 12441, -17);
        	if sq ~= nil then
           	createRandomDeadBody(sq, 10);
        	else end
        	local sq = getCell():getGridSquare(5685, 12441, -17);
        	if sq ~= nil then
        	addZombiesInOutfit(5674,12458,-17, 1, None,0);
        	else end
		end

end



TheTestSubject.EveryTenMinutes = function()
	pl=getPlayer();
	pillowmod = pl:getModData();

	if pillowmod.caves1done == false
		and getCell():getGridSquare(5671,12445,-17) ~= nil
	then
		print("spawning zombies outside start area")
		-- spawn 3 zombies right outside and have them break in
	    addZombiesInOutfit(5671, 12445, -17, 4 , None , 0); 
	    addSound(getPlayer(), getPlayer():getX(), getPlayer():getY(), getPlayer():getZ(), 100, 100); 
	    pillowmod.caves1done = true;
	end

	if pillowmod.caves2done == false
		and getCell():getGridSquare(5628,12462,-17) ~= nil
	then
	    -- spawn zombies in the caves
	    print("spawning zombies in caves")
    	addZombiesInOutfit(5628, 12462, -17, 5 , None , 0); 
    	pillowmod.caves2done = true;
    end

	if pillowmod.security1done == false
		and getCell():getGridSquare(5581,12470,-17) ~= nil
	then
	    -- spawn zombies outside the caves, make sound to have them start breaking doors
	    print("spawning zombies outside the caves")
	    addZombiesInOutfit(5581, 12470, -17, 3 , HazardSuit , 0); 
	    addZombiesInOutfit(5581, 12470, -17, 3 , Security , 0); 
	    addZombiesInOutfit(5581, 12470, -17, 3 , Pharmacist , 0); 
	    addZombiesInOutfit(5581, 12470, -17, 3 , HospitalPatient , 0); 
	    addSound(getPlayer(), 5601, 12467, -17 , 50, 50); 
	    pillowmod.security1done = true;
	end

	if pillowmod.morguedone == false
		and getCell():getGridSquare(5569,12438,-17) ~= nil
	then
	    --spawn horde in the morgue
	    print("spawning zombies in morgue")
	    addZombiesInOutfit(5569, 12438, -17, 20 , HospitalPatient , 0); 
	    pillowmod.morguedone = true;
	end 

	if pillowmod.operatingdone == false
		and getCell():getGridSquare(5563,12421,-16) ~= nil
	then
		 --spawn zombies in the operating areas
		 print("spawning zombies in operating area")
	    addZombiesInOutfit(5563, 12421, -16, 10 , HospitalPatient , 0); 
	    addZombiesInOutfit(5563, 12421, -16, 2 , Doctor , 0); 
	    pillowmod.operatingdone = true;
	end 

	if pillowmod.armorydone == false
		and getCell():getGridSquare(5562,12448,-16) ~= nil
	then
	    -- spawn zombies in the armory
	    print("spawning zombies in armory")
	    addZombiesInOutfit(5562, 12448, -16, 5 , ArmyCamoGreen , 0); 
	    addZombiesInOutfit(5562, 12448, -16, 5 , None , 0); 
	    pillowmod.armorydone = true;
	end 

	if pillowmod.cafeteriadone == false
		and getCell():getGridSquare(5568,12474,-15) ~= nil
	then
		 --spawn zombies in the cafteria
		print("spawning zombies in cafteria")
	    addZombiesInOutfit(5568, 12474, -15, 8 , None , 0); 
	    pillowmod.cafeteriadone = true;
	end 

	if pillowmod.controldone == false
		and getCell():getGridSquare(5543,12476,-15) ~= nil
	then
		--spawn zombies in the control room
		print("spawning zombies in control room")
	    addZombiesInOutfit(5543, 12476, -15, 16 , HazardSuit , 0); 
	    pillowmod.controldone = true;
	end 

	if dorm1done == false
		and getCell():getGridSquare(5565,12475,-14) ~= nil
	then
		print("spawning zombies in dorm 1")
	    addZombiesInOutfit(5565, 12475, -14, 2 , None , 0); 
	    pillowmod.dorm1done = true;		
	end

	if dorm2done == false
		and getCell():getGridSquare(5558,12496,-14) ~= nil
	then
		print("spawning zombies in dorm 2")
	    addZombiesInOutfit(5558, 12496, -14, 2 , None , 0); 
	    pillowmod.dorm2done = true;		
	end

	if dorm3done == false
		and getCell():getGridSquare(5560,12496,-13) ~= nil
	then
		print("spawning zombies in dorm 3")
	    addZombiesInOutfit(5560, 12496, -13, 2 , None , 0); 
	    pillowmod.dorm3done = true;		
	end 

	if dorm4done == false
		and getCell():getGridSquare(5578,12499,-13) ~= nil
	then
		print("spawning zombies in dorm 4")
	    addZombiesInOutfit(5578, 12499, -13, 2 , None , 0); 
	    pillowmod.dorm4done = true;		
	end 

	if pillowmod.stairsdone == false
		and getCell():getGridSquare(5543,12466,-13) ~= nil
	then
		--spawn hazard zombies in the stairwell, make some noise to move them around
		print("spawning zombies in stairwell")
	    addZombiesInOutfit(5543, 12466, -13, 16 , HazardSuit , 0); 
	    addSound(getPlayer(), 5547, 12470, -13 , 25, 25); 
	    pillowmod.stairsdone = true;
	 end 

	if pillowmod.lobbydone == false
		and getCell():getGridSquare(5579,12482,0) ~= nil
	then
 		--spawn horde in the lobby of secret base
 		print("spawning zombies in lobby")
	    addZombiesInOutfit(5579, 12482, 0, 25 , ArmyCamoGreen , 0); 
	    addZombiesInOutfit(5579, 12482, 0, 175 , None , 0); 
	    pillowmod.lobbydone = true;
	end 

end -- every 10 mins

TheTestSubject.EveryHours = function()

TheTestSubject.ScriptCheck();

local pl = getPlayer();
pillowmod = pl:getModData();

	if pillowmod.caves1done == true 
	and pillowmod.caves2done == true 
	and pillowmod.security1done == true
	and pillowmod.morguedone == true
	and pillowmod.operatingdone  == true
	and pillowmod.armorydone == true
	and pillowmod.cafeteriadone == true
	and pillowmod.controldone == true
	and pillowmod.stairsdone == true
	and pillowmod.lobbydone == true
	and pillowmod.dorm1done == true
	and pillowmod.dorm2done == true
	and pillowmod.dorm3done == true
	and pillowmod.dorm4done == true
	then
		print("all events triggered, removing every 10 mins script")
		Events.EveryTenMinutes.Remove(TheTestSubject.EveryTenMinutes);
		Events.EveryHours.Remove(TheTestSubject.EveryHours);
	else 
		if pillowmod.caves1done == true 
		then 
		print("caves 1 done true");
		else end

		if pillowmod.caves2done == true 
		then 
		print("caves 2 done true");
		else end

		if pillowmod.security1done == true 
		then 
		print("security1 done true");
		else end

		if pillowmod.morguedone == true 
		then 
		print("morgue done true");
		else end

		if pillowmod.operatingdone == true 
		then 
		print("operating done true");
		else end

		if pillowmod.armorydone == true 
		then 
		print("armory done true");
		else end

		if pillowmod.cafeteriadone == true 
		then 
		print("cafteria done true");
		else end

		if pillowmod.controldone == true 
		then 
		print("control done true");
		else end

		if pillowmod.stairsdone == true 
		then 
		print("stairs done true");
		else end

		if pillowmod.lobbydone == true 
		then 
		print("lobby done true");
		else end

		if pillowmod.dorm1done == true 
		then 
		print("dorm 1 done true");
		else end

		if pillowmod.dorm2done == true 
		then 
		print("dorm 2 done true");
		else end

		if pillowmod.dorm3done == true 
		then 
		print("dorm 3 done true");
		else end

		if pillowmod.dorm4done == true 
		then 
		print("dorm 4 done true");
		else end
	end

end --every hours.


TheTestSubject.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	Events.OnGameStart.Add(TheTestSubject.OnGameStart);
	TheTestSubject.setSandBoxVars();

end

TheTestSubject.ScriptCheck = function()

	if getPlayer():getHoursSurvived() > 23 then
	Events.EveryHours.Remove(TheTestSubject.EveryHours)
	Events.EveryTenMinutes.Remove(TheTestSubject.EveryTenMinutes)
	else end

end

TheTestSubject.setSandBoxVars = function()

end


TheTestSubject.RemovePlayer = function(p)

end

TheTestSubject.AddPlayer = function(p)

end

TheTestSubject.Render = function()

end

TheTestSubject.spawns = {
{xcell = 18, ycell = 41, x = 86, y = 134, z = -17 } -- caves under military base

}



--local spawnselection = 0;
--local xcell = TheTestSubject.spawns[spawnselection].xcell;
--local ycell = TheTestSubject.spawns[spawnselection].ycell;
--local x = TheTestSubject.spawns[spawnselection].x;
--local y = TheTestSubject.spawns[spawnselection].y;


TheTestSubject.id = "TheTestSubject";
TheTestSubject.image = "media/lua/client/LastStand/TheTestSubject.png";
TheTestSubject.gameMode = "TheTestSubject";
TheTestSubject.world = "Muldraugh, KY";
TheTestSubject.xcell = 18;
TheTestSubject.ycell = 41;
TheTestSubject.x = 286;
TheTestSubject.y = 134;
TheTestSubject.z = -17;
TheTestSubject.enableSandbox = true;

Events.OnChallengeQuery.Add(TheTestSubject.Add)

