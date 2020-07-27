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
	--1in2 is dire, and 1in4 of those is brutal.
	if pillowmod.diffcheckdone == nil
		and ZombRand(2)+1 == ZombRand(2)+1 
		then 
			--dire variables
			pillowmod.direstart = true;
			pillowmod.brutalstart = false;
			pillowmod.diffcheckdone = true;
			pillowmod.difficultymodifier = ZombRand(5,10);
			pillowmod.injurytimemodifier = ZombRand(10,20);
			pillowmod.drunkmodifier = 25;
			if ZombRand(4)+1 == ZombRand(4)+1
			then
				--brutal variables
			 	pillowmod.brutalstart = true;
				pillowmod.direstart = false;
				pillowmod.diffcheckdone = true;
				pillowmod.difficultymodifier = ZombRand(10,20);
				pillowmod.injurytimemodifier = ZombRand(10,30);
				pillowmod.drunkmodifier = 50;
			else 
				pillowmod.brutalstart = false;
			end
		else 
				--normal variables
				pillowmod.direstart = false;
				pillowmod.brutalstart = false;
				pillowmod.diffcheckdone = true;
				pillowmod.difficultymodifier = 0;
				pillowmod.injurytimemodifier = 0;
				pillowmod.drunkmodifier = 0;
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
			--:getMinutes() <= 1 
			--and getGameTime():getHour() == getGameTime():getStartTimeOfDay()
			--and getGameTime():getYear() == getGameTime():getStartYear() 
			--get player info
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

HospitalChallenge.spawns = {
		{worldX = 39, worldY = 23, posX = 171, posY = 12}, -- West Point,  dr office, exam room ID:114
		{worldX = 39, worldY = 22, posX = 187, posY = 283}, -- West Point,  dentist office 2, exam room ID:133
		{worldX = 36, worldY = 33, posX = 77, posY = 129}, -- Muldraugh,  cortman medical, exam room ID:298
		{worldX = 33, worldY = 42, posX = 255, posY = 150}, -- March Ridge, dr office, exam room ID:341
		{worldX = 26, worldY = 38, posX = 287, posY = 130}, -- Rosewood, dr office exam room ID:413
		{worldX = 18, worldY = 31, posX = 97, posY = 286}, -- Isolated Areas,  dr office lobby ID:637


}

HospitalChallenge.hourOfDay = 7;

Events.OnChallengeQuery.Add(HospitalChallenge.Add)

