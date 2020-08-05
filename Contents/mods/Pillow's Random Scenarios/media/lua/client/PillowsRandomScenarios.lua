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

  --function opt1:onUpdateMainMenu(val)
  --  self:resetLua() -- Reload all mods.
  --  opt1:set(true)
  --end

  --function opt2:onUpdateMainMenu(val)
  --  self:resetLua() -- Reload all mods.
  --  opt2:set(true)
  --end

end



-- Check actual options at game loading.
Events.OnGameStart.Add(function()
  print("always dire = ", PillowModOptions.options.alwaysdire)
  print("always brutal = ", PillowModOptions.options.alwaysbrutal)
end)