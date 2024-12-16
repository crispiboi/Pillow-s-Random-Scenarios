-- These are the settings.
PillowModOptions = {
  options = { 
    alwaysdire = false,
    alwaysbrutal = false,
  },
  names = {
    alwaysdire = "Always Dire",
    alwaysbrutal = "Always Brutal",
  },
  mod_id = "PillowsRandomScenarios",
  mod_shortname = "Pillow's Random Scenarios",
}

-- Connecting the settings to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then
  ModOptions:getInstance(PillowModOptions)

  local opt1 = PillowModOptions.options_data.alwaysdire
    local opt2 = PillowModOptions.options_data.alwaysbrutal

    function opt1:onUpdate(val)
    if val then
      opt2:set(false) -- disable the second option if the first option is set
    end
  end
  function opt2:onUpdate(val)
    if val then
      opt1:set(false) -- disable the first option if the second option is set
    end
  end

end



-- Check actual options at game loading.
Events.OnGameStart.Add(function()
  print("always dire = ", PillowModOptions.options.alwaysdire)
  print("always brutal = ", PillowModOptions.options.alwaysbrutal)
end)



local orig_clickPlay = NewGameScreen.clickPlay

--2024-12-16 add this stuff from Immersive Scenarios for sandbox settings
function NewGameScreen:clickPlay()
    self:setVisible(false);

    MainScreen.instance.charCreationProfession.previousScreen = "NewGameScreen";
    getWorld():setGameMode(self.selectedItem.mode);

    MainScreen.instance:setDefaultSandboxVars()

    if self.selectedItem.mode == "Challenge" then
        getWorld():setDifficulty("Hardcore");
        LastStandData.chosenChallenge = self.selectedItem.challenge;
        
        if LastStandData.chosenChallenge and LastStandData.chosenChallenge.enableSandbox == true then                     
            local worldName = LastStandData.chosenChallenge.id.."-"..ZombRand(100000)..ZombRand(100000)..ZombRand(100000)..ZombRand(100000);
            doChallenge(self.selectedItem.challenge);
            getWorld():setWorld(sanitizeWorldName(worldName));
            
            local globalChallenge = LastStandData.chosenChallenge;
            globalChallenge.OnInitWorld();
            --Events.OnGameStart.Add(globalChallenge.OnGameStart); -- Direct call. Normally called by OnInitWorld()
            
            getWorld():setMap("DEFAULT")
            MainScreen.instance.createWorld = true                  
            MapSpawnSelect.instance:useDefaultSpawnRegion()
            
            getWorld():setGameMode("Sandbox")
            MainScreen.instance.sandOptions:setVisible(true, self.joyfocus)
    
            return
        end
    end

    orig_clickPlay(self)
end

local orig_onOptionMouseDown = SandboxOptionsScreen.onOptionMouseDown

-- Override to back button for Sandbox Options
function SandboxOptionsScreen:onOptionMouseDown(button, x, y)

    if button.internal == "BACK" and LastStandData.chosenChallenge and LastStandData.chosenChallenge.enableSandbox == true then     
        self:setVisible(false);
        MainScreen.instance.soloScreen:setVisible(true, self.joyfocus)
    else
        orig_onOptionMouseDown(self, button, x, y)
    end 
    
end
