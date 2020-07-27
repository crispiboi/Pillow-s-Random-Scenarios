TheLastFlight = {}



TheLastFlight.Add = function()
	addChallenge(TheLastFlight);
end

TheLastFlight.OnGameStart = function()
    		
Events.OnGameStart.Add(TheLastFlight.OnNewGame);


end

TheLastFlight.DifficultyCheck = function()
	local pl = getPlayer();
	--1in2 is dire, and 1in4 of those is brutal.
	if diffcheckdone == nil
		and ZombRand(2)+1 == ZombRand(2)+1 
		then 
			--dire start settings
			direstart = true;
			brutalstart = false;
			diffcheckdone = true;
			supplychance = 4 ;
			supplymax = 3;
			medsupplychance = 2;
			medsupplymax = 3;
			injuryloops = ZombRand(2,8);
			injuryharshnesschance = ZombRand(1,4);
			injurymodifier = ZombRand(5,10);
			fracturecount = 0;
			totalinjurytime = ZombRand(5,40);
			totalbleedtime = ZombRand(5,40);
			--calculate average bleedtime/injurytime for injuries so the player has a better chance

			--end dire start settings

			--check dire start and make it brutal 1 in 4
			if ZombRand(4)+1 == ZombRand(4)+1
			then brutalstart = true;
				direstart = false;
				diffcheckdone = true;
				supplychance = 6 ;
				medsupplychance = 3;
				supplymax = 2;
				medsupplymax  =2;
				injuryloops = ZombRand(4,8);
				injuryharshnesschance = ZombRand(1,3);
				injurymodifier = ZombRand(5,10);
				fracturecount = 0;
				totalinjurytime = ZombRand(5,40);
				totalbleedtime = ZombRand(5,40);
				--end brutal start settings
			else 
				brutalstart = false;
			end

		else 
				direstart = false;
				brutalstart = false;
				diffcheckdone = true;
				print("Normal Start selected");
				supplychance = 3 ;
				medsupplychance = 1;
				supplymax = 4;
				medsupplymax  =3;
				injuryloops = ZombRand(2,5);
				injuryharshnesschance = ZombRand(1,8);
				injurymodifier = 0;
				fracturecount = 0;
				totalinjurytime = ZombRand(5,40);
				totalbleedtime = ZombRand(5,40);
				--calculate average bleedtime/injurytime for injuries so the player has a better chance
	end 

	--calculate universal stuff
	avginjurytime = (totalinjurytime + injurymodifier) / injuryloops ;
	avgbleedtime  = (totalbleedtime + injurymodifier) / injuryloops ;

	--play the sound
	if direstart then
 		print("Dire Start selected");
		pl:playSound("Thunder");
	elseif brutalstart then
		print("Brutal Start selected");
		pl:playSound("PlayerDied");
	else

	end

	print("injury loops:" .. injuryloops .. " injurymodifier:" .. injurymodifier .. " injuryharshnesschance:" .. injuryharshnesschance);
	print("avgbleedtime:" .. avgbleedtime .. " totalinjurytime:" .. avginjurytime);




end--end difficulty check



TheLastFlight.OnNewGame = function()
--moved this stuff from onGameStart. 
TheLastFlight.DifficultyCheck();
local pl = getPlayer();
		--check if it's a new game

		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then

			--set setstats
			pl:LevelPerk(Perks.Fitness);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Reloading);
			luautils.updatePerksXp(Perks.Fitness, pl);
			luautils.updatePerksXp(Perks.Aiming, pl);
			luautils.updatePerksXp(Perks.Reloading, pl);

			pl:getStats():setThirst(0.15); -- from 0 to 1
			pl:getStats():setHunger(0.35); -- from 0 to 1
			pl:getStats():setFatigue(0.35);

			--reset inventory
			pl:clearWornItems();
		    pl:getInventory():clear();

			local inv = pl:getInventory();
			--local bag = pl:getInventory():AddItem("Base.Bag_ALICEpack_Army");

			--player stuff 
			--give player a hoodie and hat
			TheLastFlight.clothes = {"Base.Shoes_ArmyBoots","Base.Tshirt_ArmyGreen","Base.Hat_SPHhelmet","Base.Boilersuit_Flying","Base.Gloves_LeatherGlovesBlack"}
			for i , item in pairs(TheLastFlight.clothes) do
				clothes = inv:AddItem(item);
				pl:setWornItem(clothes:getBodyLocation(), clothes);
			end

			--belt and holster are exclusive items
			holster = inv:AddItem("Base.HolsterSimple");
			pl:setWornItem(holster:getBodyLocation(), holster);
			belt = inv:AddItem("Base.Belt2");
			pl:setWornItem(belt:getBodyLocation(),belt);


			wpn = inv:AddItem("Base.Pistol");
			wpn:setCurrentAmmoCount(14);
			wpn:setContainsClip(true);
			wpn:setRoundChambered(true);
			pl:setAttachedItem("Holster Right", wpn);
			wpn:setAttachedSlot(4);
			wpn:setAttachedSlotType("HolsterRight");
			wpn:setAttachedToModel("Holster Right");
			--"Base.Pistol"
			--Base.Bullets9mm"
			--Base.BerettaClip -- 15

			wpn = inv:AddItem("Base.HuntingKnife")
			wpn:setAttachedSlot(2);
			pl:setAttachedItem("Belt Left", wpn);
			wpn:setAttachedSlotType("BeltLeft");
			wpn:setAttachedToModel("Belt Left");


			--give player supplies
			--randomized stuff
			TheLastFlight.supplies = {"Base.CannedTomato2","Base.CannedPotato2","Base.CannedChili","Base.TinnedSoup","Base.TunaTin","Base.WaterBottleFull","Base.PopBottle","Base.Bullets9mmBox","Base.Bandage","Base.AlcoholWipes"};
			TheLastFlight.medsupplies = {"Base.AlcoholBandage","Base.Disinfectant","Base.Bandaid","Base.Antibiotics","Base.Pills","Base.SutureNeedle","Base.Tweezers"};

			--static stuff main inv
			inv:AddItem("Base.WaterBottleFull");
			inv:AddItem("Base.Lighter");
			inv:AddItem("Base.KeyRing");
			inv:AddItem("Base.Torch");
			inv:AddItem("Base.DigitalWatch2");



			--up to 4 rounds of giving clips
			for i=1 , 2 do
				local giveit = ZombRand(2)+1 ;
				if giveit == 1 then 	
					inv:AddItem("Base.9mmClip"):setCurrentAmmoCount(15);
				end
			end

			sq = pl:getCurrentSquare();
			sq = getCell():getGridSquare(pl:getX()+4, pl:getY()-3, pl:getZ());
			local bag = sq:AddWorldInventoryItem("Base.Bag_ALICEpack_Army", 0, 0, 0); -- this drops the bag on the ground, cna add stuff after this
			sq = getCell():getGridSquare(pl:getX()+2, pl:getY()-2, pl:getZ());
			local kit = sq:AddWorldInventoryItem("Base.FirstAidKit", 0, 0, 0);

			-- static stuff bag
			bag:getItemContainer():AddItem("camping.CampingTentKit");
			bag:getItemContainer():AddItem("Base.TinOpener");
			bag:getItemContainer():AddItem("Base.HandAxe");
			bag:getItemContainer():AddItem("Base.Saw");
			bag:getItemContainer():AddItems("Base.RippedSheets",3);
			
			--fill bag with stuff randomly.
			for i , item in pairs(TheLastFlight.supplies) do
				if ZombRand(supplychance)+1 == 1 then 
					local amt = ZombRand(supplymax) + 1;
					bag:getItemContainer():AddItems(item,amt);
				end
			end

			--fill medkit
			for i , item in pairs(TheLastFlight.medsupplies) do
				if ZombRand(medsupplychance)+1 == 1 then 
					local amt = ZombRand(medsupplymax) + 1;
					kit:getItemContainer():AddItems(item,amt);
				end
			end




			--do injury after dire calc so I can use the values from it


			for i = 0 , injuryloops do 
				injury = ZombRand(5)+1;
				local bodypart = ZombRand(BodyPartType.ToIndex(BodyPartType.MAX)-1);
				print(BodyPartType.FromIndex(bodypart));
				-- burned
				if injury == 1 then 
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setBurnTime(avginjurytime);
					print("burning ");
				end --end burned

				--deepwound
				if injury == 2 then 
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setDeepWounded(true);
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setDeepWoundTime(avginjurytime);
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setBleedingTime(avgbleedtime);
					print("deep wound ");
					if injuryharshnesschance == 1 then 
						pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setHaveGlass(true);
						print("deep wound add glass ");
					end 
				end  --end deepwound

				--fracture, but not too harsh
				if injury == 3 and fracturecount <= 2 then
					--fractures dont kill as fast so leave this calc as rand
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setFractureTime(ZombRand(5,20)+injurymodifier);
					print("fracture");
					print("fracture count:" .. fracturecount)
				end  -- endfracture

				-- scratch 
				if injury == 4 then 
					if  injuryharshnesschance == 2 then 
						pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):SetScratchedWindow(true);
						pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setBleedingTime(avgbleedtime);
						print("scratch window ");
					else 
						print("cut weapon ");
						pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):SetScratchedWeapon(true);
						pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setBleedingTime(avgbleedtime);
					end

				end --end scratch

				if injury == 5 then --cut 
					print("cut  ");
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setCut(true);
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setCutTime(avginjurytime);
					pl:getBodyDamage():getBodyPart(BodyPartType.FromIndex(bodypart)):setBleedingTime(avgbleedtime);
				end -- end cut

			end -- end dire loops

		else end	--end first day check


end


TheLastFlight.OnInitWorld = function()
--SandboxVars = require "Sandbox/SixMonthsLater"
	Events.OnGameStart.Add(TheLastFlight.OnGameStart);
	TheLastFlight.setSandBoxVars();
end

TheLastFlight.setSandBoxVars = function()
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


TheLastFlight.RemovePlayer = function(p)

end

TheLastFlight.AddPlayer = function(p)

end

TheLastFlight.Render = function()

end

TheLastFlight.spawns = {
		{xcell = 31, ycell = 37, x = 205, y = 88, z = 0}, -- wilderness east of muldraugh industrial site
		{xcell = 25, ycell = 33, x = 210, y = 110, z = 0}, -- random field south of ekron
		{xcell = 24, ycell = 25, x = 111, y = 187, z = 0}, -- random field south of riverside
		{xcell = 38, ycell = 8, x = 245, y = 155, z = 0}, -- highway south of crossroads
		--{xcell = 46, ycell = 19, x = 11, y = 173, z = 0}, -- mall parking lot
		{xcell = 46, ycell = 19, x = 78, y = 170, z = 2}, -- mall roof
		{xcell = 21, ycell = 32, x = 209, y = 72, z = 0} --western fields near scout camp
}



local spawnselection = ZombRand(6)+1;
local xcell = TheLastFlight.spawns[spawnselection].xcell;
local ycell = TheLastFlight.spawns[spawnselection].ycell;
local x = TheLastFlight.spawns[spawnselection].x;
local y = TheLastFlight.spawns[spawnselection].y;
local z = TheLastFlight.spawns[spawnselection].z;
TheLastFlight.cardinal = TheLastFlight.spawns[spawnselection].cardinal; -- this doesn't seem to work out.



TheLastFlight.id = "TheLastFlight";
TheLastFlight.image = "media/lua/client/LastStand/TheLastFlight.png";
TheLastFlight.gameMode = "The Last Flight";
TheLastFlight.world = "Muldraugh, KY";
TheLastFlight.xcell = xcell;
TheLastFlight.ycell = ycell;
TheLastFlight.x = x;
TheLastFlight.y = y;
TheLastFlight.z = z;


TheLastFlight.hourOfDay = 7;


Events.OnChallengeQuery.Add(TheLastFlight.Add)

