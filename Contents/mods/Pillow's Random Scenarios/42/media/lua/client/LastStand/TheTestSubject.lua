TheTestSubject = {}


TheTestSubject.Add = function()
	addChallenge(TheTestSubject);
end

TheTestSubject.OnGameStart = function()

    		
Events.OnGameStart.Add(TheTestSubject.OnNewGame);
Events.EveryTenMinutes.Add(TheTestSubject.EveryTenMinutes);
--Events.EveryHours.Add(TheTestSubject.EveryHours);

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
pillowmod.armorydone = false;
pillowmod.controldone = false;
pillowmod.stairsdone = false;
pillowmod.lobbydone = false;

		--check if it's a new game
		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
		    inv:AddItem("Lantern_CraftedElectric");
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
	    addZombiesInOutfit(5671, 12445, -17, 3 , None , 0); 
	    addSound(getPlayer(), getPlayer():getX(), getPlayer():getY(), getPlayer():getZ(), 50, 50); 
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
	    addZombiesInOutfit(5581, 12470, -17, 5 , HazardSuit , 0); 
	    addZombiesInOutfit(5581, 12470, -17, 5 , Security , 0); 
	    addZombiesInOutfit(5581, 12470, -17, 5 , Pharmacist , 0); 
	    addZombiesInOutfit(5581, 12470, -17, 5 , HospitalPatient , 0); 
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
	    addZombiesInOutfit(5563, 12421, -16, 10 , Doctor , 0); 
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

	if pillowmod.armorydone == false
		and getCell():getGridSquare(5564,12475,-15) ~= nil
	then
		 --spawn zombies in the cafteria
		print("spawning zombies in cafteria")
	    addZombiesInOutfit(5564, 12475, -15, 16 , None , 0); 
	end 

	if pillowmod.controldone == false
		and getCell():getGridSquare(5564,12475,-15) ~= nil
	then
		--spawn zombies in the control room
		print("spawning zombies in control room")
	    addZombiesInOutfit(5543, 12476, -13, 16 , HazardSuit , 0); 
	    pillowmod.controldone = true;
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
	    Events.EveryTenMinutes.Remove(TheTestSubject.EveryTenMinutes);
	end 

end -- every 10 mins

TheTestSubject.EveryHours = function()

end --every hours.


TheTestSubject.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	Events.OnGameStart.Add(TheTestSubject.OnGameStart);
	TheTestSubject.setSandBoxVars();

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

