local function consoleCommands()
  if nz.Framework.Environment:isDev() then
    -- Quick Reloads the stage, mostly used for testing/debug
    nz.Framework.newConsoleCommand("qr", function(ply)
      if ply:IsValid() then return end
    	RunConsoleCommand("changelevel", game.GetMap())
    end)

    -- Quick Tests the game, used for testing/debug
    nz.Framework.newConsoleCommand("qt", function(ply)
      if ply:IsValid() then return end
      RunConsoleCommand("test-only", "nzombies5")
    end)
  end
end

local function chatCommands()
  nz.Framework.newChatCommand("create", function(ply, params)
    -- Send it to the controller
    nz.Mode.updateController(ply, {
      ["requestedMode"] = MODE_CREATE,
    })
  end)

  nz.Framework.newChatCommand("play", function(ply, params)
    -- Send it to the controller
    nz.Mode.updateController(ply, {
      ["requestedMode"] = MODE_PLAY,
    })
  end)
end

-- This is the main entry point to the app
local function startServer(includeDir)
  if includeDir == "nzombies/gamemode/modules" then
    -- Annouce it
    print("Starting nZombies Version: v" .. NZ_VERSION)
    -- Load the current enviroment file
    nz.Framework.Config:loadFromFile()
    -- Set the environment from the config
    nz.Framework.Environment:updateFromConfig()
    -- Set all the custom console commands
    consoleCommands()
    -- Set all the custom chat commands
    chatCommands()
    -- While in dev, force the game to start in creative
    nz.Mode:set(MODE_CREATE)
  end
end

hook.Add("realmLoader.Finished", "nz.startServer", startServer)
