-- NOTE: if the resolution below is not supported by the screen
-- and fullscreen = true, love will fail to load. however if fullscreen = false
-- everything works fine and you can even toggleFullscreen
WIDTH = 1920/2
HEIGHT = 1080/2

function love.conf(t)
	t.title = "Super Turtle Riding Cat"        -- The title of the window the game is in (string)
	t.author = "O/m"        -- The author of the game (string)
	t.identity = nil            -- The name of the save directory (string)
	t.version = "0.8.0"               -- The L�VE version this game was made for (number)
	t.console = true and false           -- Attach a console (boolean, Windows only)
	t.release = false           -- Enable release mode (boolean)
	t.screen.width = WIDTH        -- The window width (number)
	t.screen.height = HEIGHT       -- The window height (number)
	t.screen.fullscreen = true and false -- Enable fullscreen (boolean)
	t.screen.vsync = false       -- Enable vertical sync (boolean)
	t.screen.fsaa = 0           -- The number of FSAA-buffers (number)
	t.modules.joystick = false   -- Enable the joystick module (boolean)
	t.modules.audio = true   -- Enable the keyboard module (boolean)
	t.modules.event = true      -- Enable the event module (boolean)
	t.modules.image = true      -- Enable the image module (boolean)
	t.modules.graphics = true   -- Enable the graphics module (boolean)
	t.modules.timer = true      -- Enable the timer module (boolean)
	t.modules.mouse = true      -- Enable the mouse module (boolean)
	t.modules.sound = true      -- Enable the sound module (boolean)
	t.modules.physics = false    -- Enable the physics module (boolean)
end
