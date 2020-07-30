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

	if ModOptions and ModOptions.getInstance then
		pillowmod.alwaysdire = PillowModOptions.options.alwaysdire
		pillowmod.alwaysbrutal = PillowModOptions.options.alwaysbrutal
	end 

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


				print("Normal Start selected");
	end 



	--do override
	if pillowmod.alwaysdire == true
		then pillowmod.direstart = true;
			pillowmod.brutalstart = false;
	elseif pillowmod.alwaysbrutal == true
		then pillowmod.brutalstart = true;
			pillowmod.direstart = false;
	else end

	--assign variables
	if pillowmod.direstart ==  true
		then
			--Dire variables
			pillowmod.difficultymodifier = 2;
			pillowmod.spawnvariance = ZombRand(1,25);
			pillowmod.zombcount = ZombRand(25,100);
			pillowmod.difficultyloops = 2;
	elseif pillowmod.brutalstart == true
		then
			--Brutal variables
			pillowmod.difficultymodifier = 3;
			pillowmod.spawnvariance = ZombRand(1,10);
			pillowmod.zombcount = ZombRand(50,100);
			pillowmod.difficultyloops = 3;
	else
			--Normal variables
			pillowmod.difficultymodifier = 1;
			pillowmod.spawnvariance = ZombRand(1,40);
			pillowmod.zombcount = ZombRand(10,75);
			pillowmod.difficultyloops = 1;
	end

	
	pillowmod.zombcount = pillowmod.zombcount * pillowmod.difficultymodifier;
	print("horde params- dire modifier:" .. pillowmod.difficultymodifier .. " zombcount:" .. pillowmod.zombcount .. " difficulty loops:" .. pillowmod.difficultyloops);


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





end -- end diffiuclty

LastDitchSecurity.DestroyStairsCheck = function()

end 


LastDitchSecurity.OnNewGame = function()
--moved this stuff from onGameStart. 
local pl = getPlayer();
		--check if it's a new game

		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			LastDitchSecurity.DifficultyCheck();

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


			
			---outside south stairs 10067x12666
			-- outside main entrance 10081x12641
			--outside east stairs 10123x12630
			--behind east wing 10088x12610
			--behind west wing 10046x 12632
			
				for i = 0 , pillowmod.difficultyloops do

					print("spawn horde outside south stairs size:" .. pillowmod.zombcount)
					createHordeFromTo(10067, 12666, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10067 +pillowmod.spawnvariance, 12666+pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10067 -pillowmod.spawnvariance, 12666-pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);

					print("spawn horde outside main entrance size:" .. pillowmod.zombcount)
					createHordeFromTo(10081, 12641, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10081 +pillowmod.spawnvariance, 12641+pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10081 -pillowmod.spawnvariance, 12641-pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);

					print("spawn horde outside east stairs size:" .. pillowmod.zombcount)
					createHordeFromTo(10123, 12630, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10123 +pillowmod.spawnvariance, 12630+pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10123 -pillowmod.spawnvariance, 12630-pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);

					print("spawn horde behind east wing size:" .. pillowmod.zombcount)
					createHordeFromTo(10088, 12610, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10088 +pillowmod.spawnvariance, 12610+pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10088 -pillowmod.spawnvariance, 12610-pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);

					print("spawn horde behind west wing size:" .. pillowmod.zombcount)
					createHordeFromTo(10046, 12632, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10046 +pillowmod.spawnvariance, 12632+pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);
					createHordeFromTo(10046 -pillowmod.spawnvariance, 12632-pillowmod.spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);

					pillowmod.spawnvariance = pillowmod.spawnvariance + 25;
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

