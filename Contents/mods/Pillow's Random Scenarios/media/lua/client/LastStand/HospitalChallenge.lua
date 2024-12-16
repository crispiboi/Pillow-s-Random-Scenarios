--require "PillowsRandomScenarios.lua"

HospitalChallenge = {}

HospitalChallenge.Add = function()
	addChallenge(HospitalChallenge);
end

HospitalChallenge.OnGameStart = function()

	Events.OnGameStart.Add(HospitalChallenge.OnNewGame);

end

HospitalChallenge.DifficultyCheck = function()
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
			if  ZombRand(4)+1 == ZombRand(4)+1
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


	--change to do dire roll, then assign variables. This where override always dire/brutal.
	if pillowmod.direstart == true
		then
			--dire variables
			pillowmod.brutalstart = false;
			pillowmod.difficultymodifier = ZombRand(5,10);
			pillowmod.injurytimemodifier = ZombRand(10,20);
			pillowmod.drunkmodifier = 25;
	elseif  pillowmod.brutalstart == true
		then
			--brutal variables
			pillowmod.direstart = false;
			pillowmod.difficultymodifier = ZombRand(10,20);
			pillowmod.injurytimemodifier = ZombRand(10,30);
			pillowmod.drunkmodifier = 50;
	else
			--normal variables
			pillowmod.difficultymodifier = 0;
			pillowmod.injurytimemodifier = 0;
			pillowmod.drunkmodifier = 0;
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


end -- end DifficultyCheck

HospitalChallenge.ApplyInjuries = function() 
	local pl = getPlayer();
	--random injury
	local injury = ZombRand(8)+1;
	damage = pillowmod.difficultymodifier + 20;
	injurytime = 25+ pillowmod.injurytimemodifier;
		if injury == 1 then
			pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_R):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_R):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_R):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_R):setBandaged(true, 5, true, "Base.AlcoholBandage");
	    elseif injury == 2 then
	    	pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_L):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_L):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_L):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerLeg_L):setBandaged(true, 5, true, "Base.AlcoholBandage");
	    elseif injury == 3 then
	    	pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_R):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_R):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_R):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_R):setBandaged(true, 5, true, "Base.AlcoholBandage");
	    elseif injury == 4 then
	    	pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_L):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_L):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_L):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperLeg_L):setBandaged(true, 5, true, "Base.AlcoholBandage");
		elseif injury == 5 then
	    	pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_L):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_L):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_L):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_L):setBandaged(true, 5, true, "Base.AlcoholBandage");
	    elseif injury == 6 then
	    	pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_L):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_L):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_L):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_L):setBandaged(true, 5, true, "Base.AlcoholBandage");
	    elseif injury == 7 then
	    	pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_R):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_R):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_R):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.UpperArm_R):setBandaged(true, 5, true, "Base.AlcoholBandage");
		else 
			pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_R):AddDamage(damage);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_R):setFractureTime(injurytime);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_R):setSplint(true, .8);
	        pl:getBodyDamage():getBodyPart(BodyPartType.LowerArm_R):setBandaged(true, 5, true, "Base.AlcoholBandage");
	    end 
end --end ApplyInjuries

HospitalChallenge.MakeItSpicy = function()
	local pl = getPlayer();
	pillowmod = pl:getModData();
	plbuilding = pl:getCurrentSquare():getRoom():getBuilding();	
	tile = plbuilding:getRandomRoom():getRandomSquare();

	spice = ZombRand(3) +1;
	if pillowmod.spiceadded == nil
			then 
		if spice == 1 then
			plbuilding:getDef():setAlarmed(true);	
			print("Spice is an alarm.");
		elseif spice == 2 then
			tile:explode();
			print("Spice is a fire.");
		else
			addZombiesInOutfit(pl:getX() + 12 ,pl:getY()+12, 0, 12, None, 0);
			addSound(getPlayer(), getPlayer():getX(), getPlayer():getY(), 0, 500, 500); 
			print("Spice is a horde.");
		end 
		pillowmod.spiceadded = true
	end 

end -- end make it spicy

HospitalChallenge.OnNewGame = function()
--moved this stuff from onGameStart. 
		--check if it's a new game
		local pl = getPlayer();
		pillowmod = pl:getModData();
		--check if it's a new game
		print(pl:getHoursSurvived());
		if pillowmod.startconditionsset == nil
			and getPlayer():getHoursSurvived()<=1 then
			HospitalChallenge.DifficultyCheck();
			local inv = pl:getInventory();

			--remove all clothes and give player a hospital gown
			pl:clearWornItems();
		    pl:getInventory():clear();
			clothes = inv:AddItem("Base.HospitalGown");
			inv:AddItem("Base.KeyRing");
			pl:setWornItem(clothes:getBodyLocation(), clothes);

			--set stats 
			pl:getStats():setDrunkenness(50+pillowmod.drunkmodifier); -- 0 to 100
			pl:getStats():setThirst(0.25); -- from 0 to 1
			pl:getStats():setHunger(0.25); -- from 0 to 1
			pl:getStats():setFatigue(0.25); -- from 0 to 1

			HospitalChallenge.ApplyInjuries();
			if pillowmod.brutalstart then
				HospitalChallenge.MakeItSpicy();
			else end 
			pillowmod.startconditionsset = true;

		else 
		end 
end

HospitalChallenge.OnCreatePlayer = function()

end

HospitalChallenge.OnInitWorld = function()
	
	Events.OnGameStart.Add(HospitalChallenge.setSandBoxVars);

	Events.OnGameStart.Add(HospitalChallenge.OnGameStart);

end

HospitalChallenge.setSandBoxVars = function()

end


HospitalChallenge.RemovePlayer = function(p)

end

HospitalChallenge.AddPlayer = function(p)

end

HospitalChallenge.Render = function()

--~ 	getTextManager():DrawStringRight(UIFont.Small, getCore():getOffscreenWidth() - 20, 20, "Zombies left : " .. (EightMonthsLater.zombiesSpawned - EightMonthsLater.deadZombie), 1, 1, 1, 0.8);

--~ 	getTextManager():DrawStringRight(UIFont.Small, (getCore():getOffscreenWidth()*0.9), 40, "Next wave : " .. tonumber(((60*60) - EightMonthsLater.waveTime)), 1, 1, 1, 0.8);
end

local ss = ZombRand(6)+1;
local xcell = 1
local ycell = 1
local x = 1
local y = 1
if ss == 1 then 
	xcell = 33; ycell = 42; x = 255; y = 150;-- March Ridge, dr office, exam room ID:341
elseif ss == 2 then
	xcell = 39; ycell = 23;x = 171; y = 12; -- West Point,  dr office, exam room ID:114
elseif ss == 3 then
	xcell = 39; ycell = 22;x = 187; y = 283; -- West Point,  dentist office 2, exam room ID:133
elseif ss == 3 then
	xcell = 36; ycell = 33;x = 77; y = 129;  -- Muldraugh,  cortman medical, exam room ID:298
elseif ss == 4 then
	xcell = 26; ycell = 38;x = 287; y = 130;  -- Rosewood, dr office exam room ID:413
elseif ss == 5 then
	xcell = 18; ycell = 31;x = 97; y = 286;  -- Isolated Areas,  dr office lobby ID:637
else
	xcell = 24; ycell = 27; x = 96; y = 292; -- Ekron,  dr office, exam room ID:495
end

HospitalChallenge.id = "HospitalChallenge";
HospitalChallenge.image = "media/lua/client/LastStand/HospitalChallenge.png";
HospitalChallenge.gameMode = "HospitalChallenge";
HospitalChallenge.world = "Muldraugh, KY";
HospitalChallenge.xcell = xcell;
HospitalChallenge.ycell = ycell;
HospitalChallenge.x = x;
HospitalChallenge.y = y;
HospitalChallenge.z = 0;
HospitalChallenge.enableSandbox = true;

HospitalChallenge.spawns = {
		{worldX = 39, worldY = 23, posX = 171, posY = 12}, -- West Point,  dr office, exam room ID:114
		{worldX = 39, worldY = 22, posX = 187, posY = 283}, -- West Point,  dentist office 2, exam room ID:133
		{worldX = 36, worldY = 33, posX = 77, posY = 129}, -- Muldraugh,  cortman medical, exam room ID:298
		{worldX = 33, worldY = 42, posX = 255, posY = 150}, -- March Ridge, dr office, exam room ID:341
		{worldX = 26, worldY = 38, posX = 287, posY = 130}, -- Rosewood, dr office exam room ID:413
		{worldX = 18, worldY = 31, posX = 97, posY = 286}, -- Isolated Areas,  dr office lobby ID:637


}

Events.OnChallengeQuery.Add(HospitalChallenge.Add)

