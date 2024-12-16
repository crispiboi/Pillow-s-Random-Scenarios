AbandonedSoldier = {}



AbandonedSoldier.Add = function()
	addChallenge(AbandonedSoldier);
end

AbandonedSoldier.OnGameStart = function()

    		
Events.OnGameStart.Add(AbandonedSoldier.OnNewGame);
Events.OnCreatePlayer.Add(AbandonedSoldier.DireCheck);

end



AbandonedSoldier.DifficultyCheck = function()
local pl = getPlayer();
pillowmod = pl:getModData();

	if ModOptions and ModOptions.getInstance then
		--ModOptions:getInstance(SETTINGS)
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
			pillowmod.difficultymodifier = ZombRand(4)+1;
			pillowmod.difficultyloops = ZombRand(4)+1;
			pillowmod.zombcount = 50 + ZombRand(100);
	elseif pillowmod.brutalstart == true
		then
			--brutal variables
			pillowmod.difficultymodifier = ZombRand(6)+1;
			pillowmod.difficultyloops = ZombRand(6)+1;
			pillowmod.zombcount = 50 + ZombRand(200);
	else
			pillowmod.difficultymodifier = 1;
			pillowmod.difficultyloops = 1;
			pillowmod.zombcount = 50 ;
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

	print("horde params- difficulty modifier:" .. pillowmod.difficultymodifier  .. " zombcount:" .. pillowmod.zombcount .. " dire loops:" .. pillowmod.difficultyloops);
	pillowmod.zombcount = pillowmod.zombcount * pillowmod.difficultymodifier;

end -- end difficulty check 


AbandonedSoldier.SpawnHordes = function()
--create zombies outside
			local pl = getPlayer();
			local pillowmod = pl:getModData();

			local northx = 0;
			local northy = 0;
			local southx = 0;
			local southy = 0;
			local eastx = 0;
			local easty = 0;
			local westx = 0;
			local westy = 0;
			sq = pl:getCurrentSquare();
			sq = getCell():getGridSquare(pl:getX(), pl:getY(), pl:getZ());
			
			--check for outside squares
			-- minus y goes north, plus y goes south. east is plus x,  west is minus x
			while getCell():getGridSquare(sq:getX()+northx,sq:getY()-northy,sq:getZ()):isOutside() == false do
				--northx=northx+1;
				northy=northy+4;
				print("north check");
				print(getCell():getGridSquare(sq:getX()+northx,sq:getY()-northy,sq:getZ()):isOutside());
			end
			

			while getCell():getGridSquare(sq:getX()-southx,sq:getY()+southy,sq:getZ()):isOutside() == false do
				--southx=southx+1;
				southy=southy+4;
				print("south check");
				print(getCell():getGridSquare(sq:getX()-southx,sq:getY()+southy,sq:getZ()):isOutside());
			end

			while getCell():getGridSquare(sq:getX()+eastx,sq:getY()+easty,sq:getZ()):isOutside() == false do
				eastx=eastx+4;
				--easty=easty+1;
				print("east check");
				print(getCell():getGridSquare(sq:getX()+eastx,sq:getY()+easty,sq:getZ()):isOutside());
			end

			while getCell():getGridSquare(sq:getX()-westx,sq:getY()-westy,sq:getZ()):isOutside() == false do
				westx=westx+4;
				--westy=westy+1;
				print("west check");
				print(getCell():getGridSquare(sq:getX()-westx,sq:getY()-westy,sq:getZ()):isOutside());
			end



			spawnvariance = 0;
			print("Spawning Hordes:");

			for i = 0 , pillowmod.difficultyloops do

				createHordeFromTo(sq:getX()+northx-10-spawnvariance, sq:getY()-northy, pl:getX(), pl:getY(), pillowmod.zombcount);

				createHordeFromTo(sq:getX()+southx-10-spawnvariance, sq:getY()+southy, pl:getX(), pl:getY(), pillowmod.zombcount);

				createHordeFromTo(sq:getX()-westx, sq:getY()-westy-10-spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);

				createHordeFromTo(sq:getX()+eastx, sq:getY()-easty+10+spawnvariance, pl:getX(), pl:getY(), pillowmod.zombcount);
				spawnvariance = spawnvariance + 10;
			end

			


			addSound(getPlayer(), getPlayer():getX(), getPlayer():getY(), 0, 500, 500); 

end -- end spawn hordes


AbandonedSoldier.OnNewGame = function()
--moved this stuff from onGameStart. 
local pl = getPlayer();
		--check if it's a new game

		print(pl:getHoursSurvived());
		if getPlayer():getHoursSurvived()<=1 then
			AbandonedSoldier.DifficultyCheck();

			--set setstats
			pl:LevelPerk(Perks.Fitness);
			pl:LevelPerk(Perks.Reloading);
			pl:LevelPerk(Perks.Reloading);
			pl:LevelPerk(Perks.Reloading);
			pl:LevelPerk(Perks.Sprinting);
			pl:LevelPerk(Perks.Strength);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			pl:LevelPerk(Perks.Aiming);
			luautils.updatePerksXp(Perks.Fitness, pl);
			luautils.updatePerksXp(Perks.Reloading, pl);
			luautils.updatePerksXp(Perks.Strength, pl);
			luautils.updatePerksXp(Perks.Aiming, pl);
			pl:getStats():setThirst(0.15); -- from 0 to 1
			pl:getStats():setHunger(0.35); -- from 0 to 1

			--reset inventory
			pl:clearWornItems();
		    pl:getInventory():clear();

			local inv = pl:getInventory();
			local bag = pl:getInventory():AddItem("Base.Bag_ALICEpack_Army");

			--player stuff 
			--give player a hoodie and hat
			AbandonedSoldier.clothes = {"Base.Shoes_ArmyBoots","Base.Trousers_CamoGreen","Base.Shirt_CamoGreen","Base.Hat_Army","Base.Jacket_ArmyCamoGreen"}
			for i , item in pairs(AbandonedSoldier.clothes) do
				clothes = inv:AddItem(item);
				pl:setWornItem(clothes:getBodyLocation(), clothes);
			end

			--belt and holster are exclusive items
			holster = inv:AddItem("Base.HolsterSimple");
			pl:setWornItem(holster:getBodyLocation(), holster);
			belt = inv:AddItem("Base.Belt2");
			pl:setWornItem(belt:getBodyLocation(),belt);

			--add rifle, set ammo, chamber it, and wield it
			wpn = inv:AddItem("Base.AssaultRifle");
			wpn:setAttachedSlot(1);
			wpn:setCurrentAmmoCount(29);
			wpn:setContainsClip(true);
			wpn:setRoundChambered(true);
			pl:setPrimaryHandItem(wpn);
			pl:setSecondaryHandItem(wpn);

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
			AbandonedSoldier.supplies = {"Base.CannedTomato2","Base.CannedPotato2","Base.CannedChili","Base.TinnedSoup","Base.TunaTin","Base.WaterBottleFull","Base.PopBottle","Base.556Box","Base.Bullets9mmBox","Base.Bandage","Base.AlcoholWipes"};
			

			--static stuff main inv
			inv:AddItem("Base.WaterBottleFull");
			inv:AddItem("Base.Lighter");
			inv:AddItem("Base.KeyRing");
			-- static stuff bag
			bag:getItemContainer():AddItem("camping.CampingTentKit");
			bag:getItemContainer():AddItem("Base.TinOpener");
			bag:getItemContainer():AddItem("Base.HandAxe");
			--bag:getItemContainer():AddItems("Base.556Box",2); -- mved to supplies array
			--bag:getItemContainer():AddItem("Base.Bullets9mmBox"); -- moved to supplies array


			--2 clips in bag and 2 in main inventory 9 mm clips are to be empty
			for i=1 , 2 do
				local giveit = ZombRand(2)+1 ;
				if giveit == 1 then 
					bag:getItemContainer():AddItem("Base.556Clip"):setCurrentAmmoCount(30);
					bag:getItemContainer():AddItem("Base.9mmClip");
				end
			end
				for i=1 , 2 do
				local giveit = ZombRand(2)+1 ;
				if giveit == 1 then 	
					inv:AddItem("Base.556Clip"):setCurrentAmmoCount(30);
					inv:AddItem("Base.9mmClip"):setCurrentAmmoCount(15);
				end
			end

			--fill bag with stuff randomly.
			for i , item in pairs(AbandonedSoldier.supplies) do
				local giveit = ZombRand(2)+1 ;
				if giveit == 1 then 
				local amt = ZombRand(4) + 1;
				bag:getItemContainer():AddItems(item,amt);
				end
			end
			--wear bag
			pl:setClothingItem_Back(bag);

			AbandonedSoldier.SpawnHordes();
			
		else end	

end


AbandonedSoldier.OnInitWorld = function()
	Events.OnGameStart.Add(AbandonedSoldier.OnGameStart);
	AbandonedSoldier.setSandBoxVars();
end

AbandonedSoldier.setSandBoxVars = function()


end


AbandonedSoldier.RemovePlayer = function(p)

end

AbandonedSoldier.AddPlayer = function(p)

end

AbandonedSoldier.Render = function()

end

AbandonedSoldier.spawns = {
		{xcell = 38, ycell = 32, x = 135, y = 55, z = 0}, -- railyard office north
		{xcell = 33, ycell = 36, x = 179, y = 100, z = 0}, -- lunchroom, factory in muldraugh adjacent industrial zone
		{xcell = 18, ycell = 19, x = 204, y = 286, z = 0}, -- warehouse west of riverside
		{xcell = 42, ycell = 15, x = 27, y = 232, z = 0} -- warehouse north in valley station
}



local spawnselection = ZombRand(4)+1;
local xcell = AbandonedSoldier.spawns[spawnselection].xcell;
local ycell = AbandonedSoldier.spawns[spawnselection].ycell;
local x = AbandonedSoldier.spawns[spawnselection].x;
local y = AbandonedSoldier.spawns[spawnselection].y;
AbandonedSoldier.cardinal = AbandonedSoldier.spawns[spawnselection].cardinal; -- this doesn't seem to work out.



AbandonedSoldier.id = "AbandonedSoldier";
AbandonedSoldier.image = "media/lua/client/LastStand/AbandonedSoldier.png";
AbandonedSoldier.gameMode = "Abandoned Soldier";
AbandonedSoldier.world = "Muldraugh, KY";
AbandonedSoldier.xcell = xcell;
AbandonedSoldier.ycell = ycell;
AbandonedSoldier.x = x;
AbandonedSoldier.y = y;
AbandonedSoldier.z = 0;
AbandonedSoldier.enableSandbox = true;


Events.OnChallengeQuery.Add(AbandonedSoldier.Add)

