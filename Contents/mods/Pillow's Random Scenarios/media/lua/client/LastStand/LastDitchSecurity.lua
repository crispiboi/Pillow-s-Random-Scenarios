LastDitchSecurity = {}



LastDitchSecurity.Add = function()
	addChallenge(LastDitchSecurity);
end

LastDitchSecurity.OnGameStart = function()

    		
Events.OnGameStart.Add(LastDitchSecurity.OnNewGame);
Events.OnCreatePlayer.Add(LastDitchSecurity.DireCheck);
end

LastDitchSecurity.DifficultyCheck = function ()
local pl = getPlayer();
pillowmod = pl:getModData();
	--1in2 is dire, and 1in4 of those is brutal.
	if pillowmod.diffcheckdone == nil
		and ZombRand(2)+1 == ZombRand(2)+1 
		then 
			--dire start settings
			pillowmod.direstart = true;
			pillowmod.brutalstart = false;
			pillowmod.diffcheckdone = true;
			--check dire start and make it brutal 1 in 4
			if ZombRand(4)+1 == ZombRand(4)+1
			then 
				pillowmod.brutalstart = true;
				pillowmod.direstart = false;
				pillowmod.diffcheckdone = true;
			else 
				pillowmod.brutalstart = false;
			end
		else 
				pillowmod.direstart = false;
				pillowmod.brutalstart = false;
				pillowmod.diffcheckdone = true;
				pillowmod.difficultymodifier = 1;

				print("Normal Start selected");
	end 

	--play the sound
	if pillowmod.direstart then
 		print("Dire Start selected");
		pl:playSound("Thunder");
	elseif pillowmod.brutalstart then
		print("Brutal Start selected");
		pl:playSound("PlayerDied");
	else end



end -- end diffiuclty

LastDitchSecurity.DestroyStairsCheck = function()

end 


LastDitchSecurity.OnNewGame = function()
--moved this stuff from onGameStart. 
local pl = getPlayer();
		--check if it's a new game

		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then

			local inv = pl:getInventory();
			local bag = pl:getInventory():AddItem("Base.Bag_DuffelBag");

			--player stuff 
			--belt 
			belt = inv:AddItem("Base.Belt2");
			pl:setWornItem(belt:getBodyLocation(),belt);


			wpn = inv:AddItem("Base.HuntingKnife")
			wpn:setAttachedSlot(2);
			pl:setAttachedItem("Belt Left", wpn);
			wpn:setAttachedSlotType("BeltLeft");
			wpn:setAttachedToModel("Belt Left");


			--give player supplies
			--randomized stuff
			LastDitchSecurity.supplies = {"Base.CannedTomato2","Base.CannedPotato2","Base.CannedChili","Base.TinnedSoup","Base.TunaTin","Base.WaterBottleFull","Base.PopBottle","Base.Bandage","Base.AlcoholWipes"};
			

			--static stuff main inv
			inv:AddItem("Base.WaterBottleFull");
			inv:AddItem("Base.Lighter");
			-- static stuff bag
			bag:getItemContainer():AddItem("Base.TinOpener");
			bag:getItemContainer():AddItem("Base.Hammer");
			bag:getItemContainer():AddItem("Base.NailsBox");
			bag:getItemContainer():AddItems("Base.SheetRope",4);
	


			--fill bag with stuff randomly. 1 in 10 chance of giving stuff
			for i , item in pairs(LastDitchSecurity.supplies) do
				local giveit = ZombRand(10)+1 ;
				if giveit == 1 then 
				local amt = ZombRand(4) + 1;
				bag:getItemContainer():AddItems(item,amt);
				end
			end
			--wear bag
			pl:setClothingItem_Back(bag);
		

			--destroy the south stairs
			stairy = 12665;
			for stairx = 10061 , 10063 do
				sq = getCell():getGridSquare(stairx ,stairy,0);
				--sq= getCell():getGridSquare(10061 ,12665,0) -- top of stair
				obs = sq:getObjects();
				print(obs);
				i = obs:size()-1;
				while i >= 0 do 
					if obs:get(i):isStairsObject() == true then
					obs:get(i):getSquare():transmitRemoveItemFromSquare(obs:get(i)); -- 2nd one
					pl:playSound("BurnedObjectExploded");
					pl:playSound("HitObjectWithSledgehammer");
					end
					i=i-1;

				end
			
			end -- end south stairs

			--destroy the east stairs
			stairx = 10122;
			for stairy = 12623 , 12625 do
				sq = getCell():getGridSquare(stairx ,stairy,0);
				--sq= getCell():getGridSquare(10061 ,12665,0) -- top of stair
				obs = sq:getObjects();
				print(obs);
				i = obs:size()-1;
				while i >= 0 do 
					if obs:get(i):isStairsObject() == true then
					obs:get(i):getSquare():transmitRemoveItemFromSquare(obs:get(i)); -- 2nd one
					pl:playSound("HitObjectWithSledgehammer");
					pl:playSound("BreakObject");

					end
					i=i-1;

				end
			
			end -- end east stairs


			--v2 new hordes
			--direselect = 1;
			--direchance = 1;
			direchance = ZombRand(5)+1;
			direselect = ZombRand(5)+1;
			diremodifier = ZombRand(2)+1;
			direloops = ZombRand(2)+1;
			zombcount = 50 + ZombRand(50,250);
			spawnvariance = ZombRand(1,40);
			print("dire chance =" .. direchance .. " direselect=" .. direselect);
			print("horde params- dire modifier:" .. diremodifier .. " zombcount:" .. zombcount .. " dire loops:" .. direloops);
			
			---outside south stairs 10067x12666
			-- outside main entrance 10081x12641
			--outside east stairs 10123x12630
			--behind east wing 10088x12610
			--behind west wing 10046x 12632
			if direchance == direselect then
				pl:Say("Dire Start Activated")
				pl:playSound("Thunder");
				zombcount = zombcount * diremodifier;
				for i = 0 , direloops do

					print("spawn horde outside south stairs size:" .. zombcount)
					createHordeFromTo(10067, 12666, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10067 +spawnvariance, 12666+spawnvariance, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10067 -spawnvariance, 12666-spawnvariance, pl:getX(), pl:getY(), zombcount);

					print("spawn horde outside main entrance size:" .. zombcount)
					createHordeFromTo(10081, 12641, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10081 +spawnvariance, 12641+spawnvariance, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10081 -spawnvariance, 12641-spawnvariance, pl:getX(), pl:getY(), zombcount);

					print("spawn horde outside east stairs size:" .. zombcount)
					createHordeFromTo(10123, 12630, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10123 +spawnvariance, 12630+spawnvariance, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10123 -spawnvariance, 12630-spawnvariance, pl:getX(), pl:getY(), zombcount);

					print("spawn horde behind east wing size:" .. zombcount)
					createHordeFromTo(10088, 12610, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10088 +spawnvariance, 12610+spawnvariance, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10088 -spawnvariance, 12610-spawnvariance, pl:getX(), pl:getY(), zombcount);

					print("spawn horde behind west wing size:" .. zombcount)
					createHordeFromTo(10046, 12632, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10046 +spawnvariance, 12632+spawnvariance, pl:getX(), pl:getY(), zombcount);
					createHordeFromTo(10046 -spawnvariance, 12632-spawnvariance, pl:getX(), pl:getY(), zombcount);


					spawnvariance = spawnvariance + 25;
				end
			else
					spawnvariance = spawnvariance + ZombRand(11) +1;
					print("spawn horde outside south stairs size:" .. zombcount)
					createHordeFromTo(10067 +spawnvariance, 12666+spawnvariance, pl:getX(), pl:getY(), zombcount);
					print("spawn horde outside main entrance size:" .. zombcount)
					createHordeFromTo(10081 +spawnvariance, 12641+spawnvariance, pl:getX(), pl:getY(), zombcount);
					print("spawn horde outside east stairs size:" .. zombcount)
					createHordeFromTo(10123 -spawnvariance, 12630-spawnvariance, pl:getX(), pl:getY(), zombcount);
					print("spawn horde behind east wing size:" .. zombcount)
					createHordeFromTo(10088 -spawnvariance, 12610-spawnvariance, pl:getX(), pl:getY(), zombcount);
					print("spawn horde behind west wing size:" .. zombcount)
					createHordeFromTo(10046 -spawnvariance, 12632-spawnvariance, pl:getX(), pl:getY(), zombcount);

			end
			
			addSound(getPlayer(), getPlayer():getX(), getPlayer():getY(), 0, 500, 500); 
		else end	
--createHordeFromTo(11848, 9804, 11848 , 9804, 250); --testing one



end


LastDitchSecurity.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	
	Events.OnGameStart.Add(LastDitchSecurity.OnGameStart);
	LastDitchSecurity.setSandBoxVars();

end

LastDitchSecurity.setSandBoxVars = function()
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


LastDitchSecurity.RemovePlayer = function(p)

end

LastDitchSecurity.AddPlayer = function(p)

end

LastDitchSecurity.Render = function()

end

LastDitchSecurity.spawns = {
		{xcell = 33, ycell = 42, x = 152, y = 54, z = 1} -- march ridge dorm 1
}



local spawnselection = ZombRand(1)+1;
local xcell = LastDitchSecurity.spawns[spawnselection].xcell;
local ycell = LastDitchSecurity.spawns[spawnselection].ycell;
local x = LastDitchSecurity.spawns[spawnselection].x;
local y = LastDitchSecurity.spawns[spawnselection].y;
local z = LastDitchSecurity.spawns[spawnselection].z;
LastDitchSecurity.cardinal = LastDitchSecurity.spawns[spawnselection].cardinal; -- this doesn't seem to work out.



LastDitchSecurity.id = "LastDitchSecurity";
LastDitchSecurity.image = "media/lua/client/LastStand/LastDitchSecurity.png";
LastDitchSecurity.gameMode = "Last Ditch Security";
LastDitchSecurity.world = "Muldraugh, KY";
LastDitchSecurity.xcell = xcell;
LastDitchSecurity.ycell = ycell;
LastDitchSecurity.x = x;
LastDitchSecurity.y = y;
LastDitchSecurity.z = z;


LastDitchSecurity.hourOfDay = 7;


Events.OnChallengeQuery.Add(LastDitchSecurity.Add)

