FireSale = {}



FireSale.Add = function()
	addChallenge(FireSale);
end

FireSale.OnGameStart = function()

    		
Events.OnGameStart.Add(FireSale.OnNewGame);
Events.OnCreatePlayer.Add(FireSale.DireCheck);
Events.EveryTenMinutes.Add(FireSale.EveryTenMinutes);
Events.EveryTenMinutes.Add(FireSale.SpawnMallHordes);
Events.EveryHours.Add(FireSale.EveryHours);

end


FireSale.DifficultyCheck = function()
	print("run difficulty check");
	local pl = getPlayer();
	pillowmod = pl:getModData();

	if ModOptions and ModOptions.getInstance then
		--ModOptions:getInstance(SETTINGS)
		pillowmod.alwaysdire = PillowModOptions.options.alwaysdire
		pillowmod.alwaysbrutal = PillowModOptions.options.alwaysbrutal
	end 

	--1in2 is dire, and 1in4 of those is brutal.
	if pillowmod.diffcheckdone == nil 
		--direstart variables
	 and ZombRand(2)+1 == ZombRand(2)+1 
		then 
			pillowmod.direstart = true;
			pillowmod.brutalstart = false;
			pillowmod.diffcheckdone = true;
			--brutal start variables
			if ZombRand(4)+1 == ZombRand(4)+1
			then pillowmod.brutalstart = true;
				pillowmod.direstart = false;
				pillowmod.diffcheckdone = true;
			else
			end
		else print("Normal Start selected");
			--normal variables
			pillowmod.direstart = false;
			pillowmod.brutalstart = false;
			pillowmod.diffcheckdone = true;
	end 



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
		pillowmod.statmod = 0.1 ;
		pillowmod.wasalarmed = false;
		pillowmod.alarmchance = 4;
		pillowmod.alarmdecrement = 0;
		pillowmod.northentranceseen = false;
		pillowmod.southentranceseen = false;
		pillowmod.eastentranceseen = false;
		pillowmod.utilityentrance1seen = false;
		pillowmod.utilityentrance2seen = false;
		pillowmod.utilityentrance3seen = false;
		pillowmod.utilityentrance4seen = false;
		pillowmod.utilityentrance5seen = false;
		pillowmod.utilityentrance6seen = false;
		pillowmod.safeexit= ZombRand(6)+1 ;
	elseif pillowmod.brutalstart
		then
		--brtual variables
		pillowmod.statmod = 0.2 ; 
		pillowmod.wasalarmed = false;
		pillowmod.alarmchance = 4;
		pillowmod.alarmdecrement = 0;
		pillowmod.northentranceseen = false;
		pillowmod.southentranceseen = false;
		pillowmod.eastentranceseen = false;
		pillowmod.utilityentrance1seen = false;
		pillowmod.utilityentrance2seen = false;
		pillowmod.utilityentrance3seen = false;
		pillowmod.utilityentrance4seen = false;
		pillowmod.utilityentrance5seen = false;
		pillowmod.utilityentrance6seen = false;
		pillowmod.safeexit= ZombRand(6)+1 ;			
	else
		--normal variables
		pillowmod.statmod = 0;
		pillowmod.wasalarmed = false;
		pillowmod.alarmchance = 4;
		pillowmod.alarmdecrement = 0;
		pillowmod.northentranceseen = false;
		pillowmod.southentranceseen = false;
		pillowmod.eastentranceseen = false;
		pillowmod.utilityentrance1seen = false;
		pillowmod.utilityentrance2seen = false;
		pillowmod.utilityentrance3seen = false;
		pillowmod.utilityentrance4seen = false;
		pillowmod.utilityentrance5seen = false;
		pillowmod.utilityentrance6seen = false;
		pillowmod.safeexit= ZombRand(6)+1 ;
	end
	
	print("safe exit number:" .. pillowmod.safeexit );



	--play the sound
	if pillowmod.direstart then
 		print("Dire Start selected");
		pl:playSound("Thunder");
	elseif pillowmod.brutalstart then
		print("Brutal Start selected");
		pl:playSound("PlayerDied");
	else end

end--end difficulty check

FireSale.SpawnMallHordes = function()
		if pillowmod.direstart then
			pillowmod.zombmulti = ZombRand(4)+1;
		elseif pillowmod.brutalstart then
			pillowmod.zombmulti = ZombRand(3)+4;
		else pillowmod.zombmulti = ZombRand(2)+1;
		end 
		-- move all of the horde spawning stuff into this function and call it later on.
		--spawn hordes outside
		--12 at each door
		--south entrance 1 13935x5921
		--south entrance 2 13950x5921
		--west entrance 1 13866x5823
		--west entrance 2 13866x5834
		--north entrance 1 13901x5743
		--north entrance 2 13915x5743
		--north entrance 3 13932x5743
		--west (17 possible)  13868 only x value, y values = 5841-5838 , 5833-5825, 5820-5817
		--north (37 possible) 5745 only y value , x values = 13893-13899, 13904-13913, 13918-13930, 13935-13941
		--south has 3 sets.. with 30 total possible
		--south left 13926x5914-5911
		--south bottom 5918 only y value 13927-13932, 13937-13946, 13951-13956
		--south right 13957x5914-5911


		print("checking entrances");
		if pillowmod.northentranceseen == false
		 and getCell():getGridSquare(13913,5730,0) ~= nil
			then 
			print("spawning horde north entrance");
			--getCell():getGridSquare(13913,5730,0);
			zombs = 72 * pillowmod.zombmulti;
			--for i=0, zombs do
			addZombiesInOutfit(13913, 5730, 0, zombs, None, 0);
			pillowmod.northentranceseen = true;
			--end
			 
			 --define number to remove. dire 1/4 to 1/2. Brutal 1/2 to all. normal 1/4. 
			if pillowmod.direstart then
				numtoremove = ZombRand(9,18) ;
				chancetoremove = 2;
			elseif pillowmod.brutalstart then
				numtoremove = ZombRand(18,36);
				chancetoremove = 1;
			else numtoremove = ZombRand(1,9);
				chancetoremove = 3;
			end 
			print("Number of gates to remove at north:" .. numtoremove);

			y= 5745;
			removedcount = 0;
			for x=13893, 13941 do --iterate over north entrance bars
				if removedcount  >= numtoremove
					then return
				else 
					if ZombRand(1,chancetoremove) == 1 then -- chance to remove
						sq = getCell():getGridSquare(x,y,0);
						
						for i=0 , sq:getObjects():size()-1  do --iterate over a square's objects
							metalBar = sq:getObjects():get(i);
							if metalBar:getSprite() and (metalBar:getSprite():getName() == "location_shop_mall_01_18" or
		                                    metalBar:getSprite():getName() == "location_shop_mall_01_19")
							then sq:getObjects():remove(metalBar);
								removedcount = removedcount + 1;
								print("removed a gate");
								break
							else end
						end --iterate over a square end
					else end --end chance to remove
				end --end count check
			end --iterate over north

		else end --end north entrance check

		if pillowmod.southentranceseen == false
			and getCell():getGridSquare(13935,5921,0) ~= nil
			then 
				print("spawning horde south entrance");
			--getCell():getGridSquare(13935,5921,0);

			zombs = 24 * pillowmod.zombmulti;
			--for i=0, zombs do
			addZombiesInOutfit(13935, 5921, 0, zombs, None, 0);
			addZombiesInOutfit(13950, 5921, 0, zombs, None, 0);
			pillowmod.southentranceseen = true;
			--end

			--south has 3 sets.. with 30 total possible
			--south left 13926x5914-5911
			--south bottom 5918 only y value 13927-13932, 13937-13946, 13951-13956
			--south right 13957x5914-5911

			--define number to remove. dire 1/4 to 1/2. Brutal 1/2 to all. normal 1/4. 
			if pillowmod.direstart then
				numtoremove = ZombRand(8,15) ;
				chancetoremove = 2;
			elseif pillowmod.brutalstart then
				numtoremove = ZombRand(15,30);
				chancetoremove = 1;
			else numtoremove = ZombRand(1,8);
				chancetoremove = 3;
			end 

			print("Number of gates to remove at south:" .. numtoremove);

			x1= 13926;
			x2= 13957;
			removedcount = 0;
			for y=5911, 5914 do --iterate over south left/right entrance bars
				if removedcount  >= numtoremove
					then return
				else 
					if ZombRand(1,chancetoremove) == 1 then -- chance to remove
						--x1 THIS IS INEFFICENT, FIGURE OUT THE BETTER WAY.
						sq = getCell():getGridSquare(x1,y,0);
						print("X:" .. x1);
						print("Y:" .. y);
						
						for i=0 , sq:getObjects():size()-1  do --iterate over a square's objects
							metalBar = sq:getObjects():get(i);
							if metalBar:getSprite() and (metalBar:getSprite():getName() == "location_shop_mall_01_18" or
		                                    metalBar:getSprite():getName() == "location_shop_mall_01_19")
							then sq:getObjects():remove(metalBar);
								removedcount = removedcount + 1;
								print("removed a gate");
								break
							else end
						end --iterate over a square end

						--x2 THIS IS INEFFICENT, FIGURE OUT THE BETTER WAY.
						sq = getCell():getGridSquare(x2,y,0);
						print("X:" .. x2);
						print("Y:" .. y);
						
						for i=0 , sq:getObjects():size()-1  do --iterate over a square's objects
							metalBar = sq:getObjects():get(i);
							if metalBar:getSprite() and (metalBar:getSprite():getName() == "location_shop_mall_01_18" or
		                                    metalBar:getSprite():getName() == "location_shop_mall_01_19")
							then sq:getObjects():remove(metalBar);
								removedcount = removedcount + 1;
								print("removed a gate");
								break
							else end
						end --iterate over a square end
							
					else end --end chance to remove
				end --end count check
			end --iterate over south left/right entrance bars

			--iterate over south entrance bars 
			y= 5919;
			removedcount = 0;
			for x=13927, 13956 do --iterate over north entrance bars
				if removedcount  >= numtoremove
					then return
				else 
					if ZombRand(1,chancetoremove) == 1 then -- chance to remove
						sq = getCell():getGridSquare(x,y,0);
						print("X:" .. x);
						print("Y:" .. y);
						
						for i= 0 , sq:getObjects():size()-1  do --iterate over a square's objects
							metalBar = sq:getObjects():get(i);
							if metalBar:getSprite() and (metalBar:getSprite():getName() == "location_shop_mall_01_18" or
		                                    metalBar:getSprite():getName() == "location_shop_mall_01_19")
							then sq:getObjects():remove(metalBar);
								removedcount = removedcount + 1;
								print("removed a gate");
								break
							else end
						end --iterate over a square end
					else end --end chance to remove
				end --end count check
			end --iterate over south


		else end --end south entrance work

		if pillowmod.eastentranceseen == false
			and getCell():getGridSquare(13863,5821,0) ~= nil
			then
			print("spawning horde west entrance");
			--getCell():getGridSquare(13863,5821,0);

			zombs = 24 * pillowmod.zombmulti;
			--for i=0, zombs do
			addZombiesInOutfit(13863, 5821, 0, zombs, None, 0);
			addZombiesInOutfit(13863, 5834, 0, zombs, None, 0);
			pillowmod.eastentranceseen = true;
			--end

			--west (17 possible)  13868 only x value, y values = 5841-5838 , 5833-5825, 5820-5817
			 --define number to remove. dire 1/4 to 1/2. Brutal 1/2 to all. normal 1/4. 
			if pillowmod.direstart then
				numtoremove = ZombRand(5,9) ;
				chancetoremove = 2;
			elseif pillowmod.brutalstart then
				numtoremove = ZombRand(9,17);
				chancetoremove = 1;
			else numtoremove = ZombRand(1,5);
				chancetoremove = 3;
			end 
			print("Number of gates to remove at west:" .. numtoremove);

			x= 13868;
			removedcount = 0;
			for y=5817, 5841 do --iterate over east entrance bars
				if removedcount  >= numtoremove
					then return
				else 
					if ZombRand(1,chancetoremove) == 1 then -- chance to remove
						sq = getCell():getGridSquare(x,y,0);
						
						for i=0 , sq:getObjects():size()-1  do --iterate over a square's objects
							metalBar = sq:getObjects():get(i);
							if metalBar:getSprite() and (metalBar:getSprite():getName() == "location_shop_mall_01_18" or
		                                    metalBar:getSprite():getName() == "location_shop_mall_01_19")
							then sq:getObjects():remove(metalBar);
								removedcount = removedcount + 1;
								print("removed a gate");
								break
							else end
						end --iterate over a square end
					else end --end chance to remove
				end --end count check
			end --iterate over west


		else end --end east entrance check


		if pillowmod.safeexit == 1
			then 
			print("west utility 1 is safe");
			else 
				if  pillowmod.utilityentrance1seen == false then
				--west utility 1 13870x5789
				print("spawning horde west utility 1 size:" .. 24*pillowmod.zombmulti);
				addZombiesInOutfit(13870,5789,0, 24 * pillowmod.zombmulti, None, 50);
				pillowmod.utilityentrance1seen = true;
				else end
		end

		if pillowmod.safeexit == 2
			then 
			print("southwest utility 1 is safe");
			else 
				if  pillowmod.utilityentrance2seen == false then
				print("spawning horde southwest utility 1 size:" .. 24*pillowmod.zombmulti);
				--southwest utility 1 13867x5889
				addZombiesInOutfit(13867,5889,0, 24 * pillowmod.zombmulti, None, 50);
				pillowmod.utilityentrance2seen = true;
				else end
		end 

		if pillowmod.safeexit == 3

			then
			print("south gargage/ utility 1 is safe");
			else 
				if  pillowmod.utilityentrance3seen == false then
				print("spawning horde south gargage/ utility 1 size:" .. 48*pillowmod.zombmulti);
				--south garage 1 + south utility 1 (close) 13888x5894
				addZombiesInOutfit(13888,5894,0, 48 * pillowmod.zombmulti, None, 50);
				pillowmod.utilityentrance3seen = true;
				else end
		end 

		if pillowmod.safeexit == 4
			
			then
			print("east utility 1 is safe");
			else 
				if  pillowmod.utilityentrance4seen == false then
				print("spawning horde east utility 1 size:" .. 36*pillowmod.zombmulti);
				--east utility 1 14003x5832
				addZombiesInOutfit(14003,5832,0, 36 * pillowmod.zombmulti, None, 50);
				pillowmod.utilityentrance4seen = true;
				else end
		end 

		if pillowmod.safeexit == 5
			then 
			print("east garage/utility 1 is safe");
			else 
				if  pillowmod.utilityentrance5seen == false then
				print("spawning horde east garage/utility 1 size:" .. 48*pillowmod.zombmulti);
				--east utility 2 + east gargae (close)  14002x5805
				addZombiesInOutfit(14002,5805,0, 48 * pillowmod.zombmulti, None, 50);
				pillowmod.utilityentrance5seen = true;
				else end
		end 

		if pillowmod.safeexit == 6
			then 
			print("northwest spiffos is safe");
			else 
				if  pillowmod.utilityentrance6seen == false then
				--east spiffos entrance 13960x5755
				print("spawning horde northwest spiffos size:" .. 24*pillowmod.zombmulti);
				addZombiesInOutfit(13960,5755,0, 24 * pillowmod.zombmulti, None, 50);
				pillowmod.utilityentrance6seen = true;
				else end
		end 

end --end spawn horde function



FireSale.OnNewGame = function()


local pl = getPlayer();


--brutalstart = true; --testing line for brutal
--direstart = false; 
		--check if it's a new game

		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			FireSale.DifficultyCheck();
			




			pl:getStats():setThirst(0.15 + pillowmod.statmod); -- from 0 to 1
			pl:getStats():setHunger(0.15 + pillowmod.statmod); -- from 0 to 1
			pl:getStats():setFatigue(0.25 + pillowmod.statmod); -- from 0 to 1


			--reset inventory

			local inv = pl:getInventory();
			--local bag = pl:getInventory():AddItem("Base.Bag_ALICEpack_Army");

			--player stuff 

			wpn = inv:AddItem("Base.Crowbar")
			wpn:setAttachedSlot(1);
			pl:setPrimaryHandItem(wpn);
			pl:setSecondaryHandItem(wpn);


			--give player supplies
			--randomized stuff
			FireSale.supplies = {"Base.Crisps","Base.BeefJerky","Base.JuiceBox","Base.WaterBottleFull","Base.PopBottle","Base.Peanuts"};
			FireSale.supplies2 = {"Base.Shoes_BlackBoots","Base.Gloves_WhiteTINT","Base.HoodieDOWN_WhiteTINT","Base.Jacket_Black","Base.Scarf_StripeBlueWhite","Base.Lighter","Base.HandAxe","Base.TinOpener","Base.Saw","Base.Screwdriver","Base.Hammer","Base.Torch"}

			--static stuff main inv
			inv:AddItem("Base.WaterBottleFull");

			--start bag creation
			if pillowmod.brutalstart then 
				bag = pl:getInventory():AddItem("Base.Bag_DuffelBag"); 
			else
				bag = pl:getInventory():AddItem("Base.Bag_DuffelBag"); 
						
				--fill bag with multiple stuff randomly.
				for i , item in pairs(FireSale.supplies) do
					local giveit = ZombRand(3)+1 ;
					if giveit == 1 then 
					local amt = ZombRand(4) + 1;
					bag:getItemContainer():AddItems(item,amt);
					end
				end

				for i , item in pairs(FireSale.supplies2) do
					local giveit = ZombRand(4)+1 ;
					if giveit == 1 then 
					bag:getItemContainer():AddItem(item);
					end
				end
			end --end bag creation

			pl:setClothingItem_Back(bag);



			--v2 new hordes
			--v3 new dire selection + new brutal start
			--direchance = ZombRand(5)+1;
			--direselect = ZombRand(5)+1;


			--if direstart then

			--direchance = 1; --testing force dire on
			--direselect = 1; --testing force dire on

			pillowmod.building = pl:getCurrentSquare():getRoom():getBuilding();
			pillowmod.direloops = ZombRand(10,20);
			pillowmod.normalloops = ZombRand(5,10);	



			--print("dire chance =" .. direchance .. " direselect=" .. direselect);
			--print("params- normal loops:" .. normalloops .. " dire loops:" .. direloops);


			if pillowmod.direstart or pillowmod.brutalstart then
				print("intiial dire/brutal fires");
				for i = 0 , pillowmod.direloops do 
					if tile == nil then
						return end
					 
					tile = building:getRandomRoom():getRandomSquare();
				 	tile:explode();
				 end
			else 
				print("initial normal fires");
				for i = 0 , normalloops do
						if tile == nil then
						return end 
					tile = pillowmod.building:getRandomRoom():getRandomSquare();
				 	tile:explode();
				 end
			end 

		
		

		else end	



end --end new game function


FireSale.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"

	--SandboxVars.StartMonth = 7;
	Events.OnGameStart.Add(FireSale.OnGameStart);
	FireSale.setSandBoxVars();

end

FireSale.setSandBoxVars = function()
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
		SandboxVars.ElecShutModifier = 1
		
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

FireSale.FireDialogue = function()
	firespeech = ZombRand(9)+1 ;
	if firespeech == 1
		then pl:Say("what's that smell?");
	elseif firespeech == 2
		then pl:Say("it's a little warm in here..");
	elseif firespeech == 3  
		then pl:Say("that was spooky.");
	elseif firespeech == 4
		then pl:Say("smells like something is burning..");
	elseif firespeech == 5
		then pl:Say("that was weird.");
	elseif firespeech == 6
		then pl:Say("what?");
	elseif firespeech == 7
		then pl:Say("what the heck?");
	elseif firespeech == 8
		then pl:Say("that was spoopy.");
	elseif firespeech == 9 
		then pl:Say("strange..");
	else
		pl:Say("huh?");
	end
end -- end firedialogue 

FireSale.EveryTenMinutes = function()

	if getPlayer():getHoursSurvived()>24 
		then return
	else

		
		pl = getPlayer();
		pillowmod = pl:getModData();

		--check to see if player is outside. fixes lua errors.
		if pl:getCurrentSquare():isOutside() == true 
			then return
			else 
				--this check fixes a weird error on the escalators
				if pl:getCurrentSquare():getRoom() == nil or pillowmod.building == nil then return
				else 
					pillowmod.plbuilding = pl:getCurrentSquare():getRoom():getBuilding();
					tile = pillowmod.building:getRandomRoom():getRandomSquare();
					print(tile);
				end
		end 

		if pillowmod.direstart or pillowmod.brutalstart
			then  
			pillowmod.firechance = ZombRand(2)+1;
			else
			pillowmod.firechance = ZombRand(3) + 1; 
		end 
		print("fire chance check");



		--dont start a fire on the player, and only do it if the player is in the mall
		if pl:getCurrentSquare() ~= tile 
		and pillowmod.plbuilding == pillowmod.building
		and pillowmod.firechance == 2
		then
			if tile == nil then
			return end
			tile:explode();
			print("setting a fire!");
			pl:playSound("SmallExplosion");
			pl:playSound("LightbulbBurnedOut");
			FireSale.FireDialogue();
			--encourage the nearby zombies to come taste the player.
			addSound(getPlayer(), tile:getX(), tile:getY(), tile:getZ(), 100, 100); 
		else 
			print("fire roll failed")
		end --end fire roll

		--force alarm first 10 mins if brutal
		if pillowmod.brutalstart 
			and pillowmod.wasalarmed == false
			and pillowmod.plbuilding == pillowmod.building
		then
			pillowmod.plbuilding:getDef():setAlarmed(true);
			pillowmod.wasalarmed = true;
			print("set alarm");
			pl:Say("what is that?!?")
		else end

	end 
--if it's the first day getPlayer():getModData()["IsNight"]
--start fire not in same room as player
--roll 1 to 3

end -- end of every 10 mins

FireSale.EveryHours= function ()

		pl = getPlayer();
		pillowmod = pl:getModData();

	if getPlayer():getHoursSurvived()>24 
		then return
	else 
		pillowmod.alarmdecrement = pillowmod.alarmdecrement -1;

		if pl:getCurrentSquare():isOutside() == true 
			or pl:getCurrentSquare():getRoom() == nil
			then return
			else 
				pillowmod.plbuilding = pl:getCurrentSquare():getRoom():getBuilding();
		end 

		if pillowmod.direstart
			and pillowmod.wasalarmed == false
			then pillowmod.alarmchance = 0;
				print("alarm chance:" .. pillowmod.alarmchance);
			elseif pillowmod.wasalarmed ==false then
			pillowmod.alarmchance = ZombRand(5) - pillowmod.alarmdecrement;
			print("alarm chance:" .. pillowmod.alarmchance);
		end 

		print("alarm check");
		if pillowmod.alarmchance <= 0
		and pillowmod.plbuilding == pillowmod.building
		and pillowmod.wasalarmed == false
		then 
			pillowmod.plbuilding:getDef():setAlarmed(true);
			pillowmod.wasalarmed = true;
			print("set alarm");
			pl:Say("what is that?!?")
		end 
	end -- first day check

end --end of every hours


FireSale.RemovePlayer = function(p)

end

FireSale.AddPlayer = function(p)

end

FireSale.Render = function()

end

--spawns to be set at secluded locations
--dressingrooms by east entrance 13873x5844
FireSale.spawns = {
		{xcell = 46, ycell = 19, x = 90, y = 187, z = 2}, --southwest bathroom
		{xcell = 46, ycell = 19, x = 171, y = 157, z = 2}, --dept store changing room floor 2
		{xcell = 46, ycell = 19, x = 175, y = 113, z = 2}, --changing room, small clothing store floor 2
		{xcell = 46, ycell = 19, x = 93, y = 104, z = 2}, --northwest bathroom

}



local spawnselection = ZombRand(4)+1;
local xcell = FireSale.spawns[spawnselection].xcell;
local ycell = FireSale.spawns[spawnselection].ycell;
local x = FireSale.spawns[spawnselection].x;
local y = FireSale.spawns[spawnselection].y;
local z = FireSale.spawns[spawnselection].z;
FireSale.cardinal = FireSale.spawns[spawnselection].cardinal; -- this doesn't seem to work out.



FireSale.id = "FireSale";
FireSale.image = "media/lua/client/LastStand/FireSale.png";
FireSale.gameMode = "FireSale";
FireSale.world = "Muldraugh, KY";
FireSale.xcell = xcell;
FireSale.ycell = ycell;
FireSale.x = x;
FireSale.y = y;
FireSale.z = z;


FireSale.hourOfDay = 7;


Events.OnChallengeQuery.Add(FireSale.Add)

