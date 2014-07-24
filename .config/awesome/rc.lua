-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local daze = require("daze")
local vicious = require("vicious")
local benis = require("benis")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			 return
		end
		in_error = true
		naughty.notify({ 
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = err })
		in_error = false
	end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/akari/.config/awesome/themes/benis/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
browser = os.getenv("BROWSER") or "firefox"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
scrot = "scrot"
shutdown = "sudo shutdown -h now"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	daze.layout.dtile,
}

-- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
	tags[s] = awful.tag({ "⮫", "⮬", "⮭", "⮮", "⮯" }, s, layouts[1])
end

awful.layout.set(awful.layout.suit.floating, tags[1][1])                                             
awful.tag.setmwfact(0.538, tags[1][1])

-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { 
	{ "⮩     term", terminal },
	{ "⮠    nitro", "nitrogen" },
	{ "⮤    scrot", "scrot" },
--{ "⮶⮶⮶⮶⮶⮶⮶⮶⮶⮶", },
	{ "⮗  restart", awesome.restart },
	{ "⮪     quit", awesome.quit }
}

})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- {{{ Tasklist

tasklist = {}
tasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else 
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
		client.focus = c
		c:raise()
		end
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then 
			client.focus:raise() 
		end
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then
			client.focus:raise() 
		end
	end)
)

--}}}


-- {{{ Wibox



-- time widget
mytextclock = awful.widget.textclock("<span color='#dfdfdf' background='#30303a'> ⮖ </span> %R ")
daze.widgets.calendar.register(mytextclock)



-- mpd widget
mpdwidget = wibox.widget.textbox()                                                                                                                   
daze.widgets.mpd.register(mpdwidget)

vicious.register(mpdwidget, vicious.widgets.mpd,
function (widget, args)
	if args["{state}"] == "Stop" then 
		return "<span color='#dfdfdf' background='#30303a'> ⮕ </span> not playing anything "
	elseif args["{state}"] == "Pause" then
		return '<span color="#dfdfdf" background="#30303a"> ⮔ </span> '.. args["{Artist}"]..'<span color="#d2d2d2"> - </span>'.. args["{Title}"]..' '
	else
		return '<span color="#dfdfdf" background="#30303a"> ⮓ </span> '.. args["{Artist}"]..'<span color="#d2d2d2"> - </span>'.. args["{Title}"]..' '
	end
end, 1)


--volume widget
volwidget = wibox.widget.textbox()
daze.widgets.vol.register(volwidget)

vicious.register(volwidget, vicious.widgets.volume,
function (widget, args)
	if (args[2] ~= "♩" ) then
		if tonumber(args[1]) > 99 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶⮶⮶⮶⮶⮶⮶</span><span color='#66666a'> </span>"
		elseif tonumber(args[1]) > 90 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶⮶⮶⮶⮶⮶</span><span color='#66666a'>⮶ </span>"
		elseif tonumber(args[1]) > 80 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶⮶⮶⮶⮶</span><span color='#66666a'>⮶⮶ </span>"
		elseif tonumber(args[1]) > 70 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶⮶⮶⮶</span><span color='#66666a'>⮶⮶⮶ </span>"
		elseif tonumber(args[1]) > 60 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶⮶⮶</span><span color='#66666a'>⮶⮶⮶⮶ </span>"
		elseif tonumber(args[1]) > 50 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶⮶</span><span color='#66666a'>⮶⮶⮶⮶⮶ </span>"
		elseif tonumber(args[1]) > 40 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶⮶</span><span color='#66666a'>⮶⮶⮶⮶⮶⮶ </span>"
		elseif tonumber(args[1]) > 30 then
			volbar = "<span color='#b4b4b4'>⮶⮶⮶</span><span color='#66666a'>⮶⮶⮶⮶⮶⮶⮶ </span>"
		elseif tonumber(args[1]) > 20 then
			volbar = "<span color='#b4b4b4'>⮶⮶</span><span color='#66666a'>⮶⮶⮶⮶⮶⮶⮶⮶ </span>"
		elseif tonumber(args[1]) > 10 then
			volbar = "<span color='#b4b4b4'>⮶</span><span color='#66666a'>⮶⮶⮶⮶⮶⮶⮶⮶⮶ </span>"
		else
			volbar = "<span color='#b4b4b4'></span><span color='#66666a'>⮶⮶⮶⮶⮶⮶⮶⮶⮶⮶ </span>"
		end 
		return '<span color="#dfdfdf" background="#30303a"> ⮜ </span> '.. volbar ..' '
	else
		return '<span color="#dfdfdf" background="#30303a"> ⮜ </span> muted  '
	end 
end, 1, "Master")

separator = wibox.widget.textbox()
spacer1 = wibox.widget.textbox("     ")
spacer = wibox.widget.textbox(" ")
separator:set_text("")


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = false
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- create a text layout widget
    mylayoutbox[s] = benis.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a tag list
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 10 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(spacer)
    left_layout:add(mylayoutbox[s])
    left_layout:add(spacer)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spacer1)
    right_layout:add(separator)
    right_layout:add(mpdwidget)
    right_layout:add(spacer)
    right_layout:add(spacer)
    right_layout:add(volwidget)
    right_layout:add(separator)
    -- right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(mytextclock)

-- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
end
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
-- awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
	-- awful.key({ modkey, }, "j",  awful.tag.viewprev ),
	-- awful.key({ modkey, }, "k",  awful.tag.viewnext ),
	awful.key({ modkey, }, "Escape", awful.tag.history.restore),
	
	
	-- move/resize clients
	-- to do: incorporate both floating move/resize and tiled wfact into one keybinding
	awful.key({ modkey, "Shift" }, "j",    
		function (lyt)
			awful.client.moveresize(  0,  10,   0,   0) 
		end),
	awful.key({ modkey, "Shift" }, "k",    
		function () 
			awful.client.moveresize(  0, -10,   0,   0) 
		end),
	awful.key({ modkey, "Shift" }, "h",    
		function () 
			awful.client.moveresize(-10,   0,   0,   0) 
		end),
	awful.key({ modkey, "Shift" }, "l",    
		function () 
			awful.client.moveresize( 10,   0,   0,   0) 
		end),
	awful.key({ modkey, "Shift" }, "s", function () awful.client.moveresize(  0,   0,   0, -10) end),
	awful.key({ modkey, "Shift" }, "d", function () awful.client.moveresize(  0,   0,   0,  10) end),
	awful.key({ modkey, "Shift" }, "a", function () awful.client.moveresize(  0,   0, -10,   0) end),
	awful.key({ modkey, "Shift" }, "f", function () awful.client.moveresize(  0,   0,  10,   0) end),
	awful.key({ modkey, }, "'", function () awful.tag.incmwfact( 0.010) end),
	awful.key({ modkey, }, ";", function () awful.tag.incmwfact(-0.010) end),
	
	
	--shift focused/swap client
	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey, "Shift"    }, "o",
		function ()
			awful.client.swap.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey, "Shift"    }, "i",
		function ()
			awful.client.swap.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	
	
	-- Layout manipulation
	awful.key({ "Mod4", }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ "Mod4", "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
	
	
	-- Standard program
	awful.key({ modkey, "Shift" }, "q", awesome.quit),
	awful.key({ modkey, }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey, }, "r", awesome.restart),
	
	
	-- dmenu
	 awful.key({ modkey }, "d", function ()
	-- awful.key({ modkey }, "d", function () mypromptbox[mouse.screen]:run() end),

	 awful.util.spawn("dmenu_run" .. 
	-- awful.util.spawn("dmenu_run -i -x 700 -y 400 -w 200 -h 15 -dim 0.05 -l 4 -nb '" .. 

		beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
		"' -fn '" .. beautiful.font_alt ..
		"' -sb '" .. beautiful.bg_special .. 
		"' -sf '" .. beautiful.fg_focus .. "'") 
	end),
	
	
	-- Personal hotkeys
	awful.key({ modkey, }, "n", function () awful.util.spawn("firefox") end),
	awful.key({ "Control" }, "l", function () awful.util.spawn("mpc next") end), 
	-- awful.key({ "Control" }, "j", function () awful.util.spawn("amixer -q set Master 4%- unmute") end),
	-- awful.key({ "Control" }, "k", function () awful.util.spawn("amixer -q set Master 4%+ unmute") end),
	awful.key({ "Control" }, "h",  function () awful.util.spawn("mpc prev") end),
	awful.key({ modkey, }, "p", function () awful.util.spawn("mpc toggle") end),
	-- awful.key({ modkey, }, "p", function () awful.util.spawn("dmenu_run") end),
	awful.key({ "Mod4" }, "k", function () awful.util.spawn("xbacklight -inc 10") end),
	awful.key({ "Mod4" }, "j", function () awful.util.spawn("xbacklight -dec 10") end)
)


-- Client control keys
clientkeys = awful.util.table.join(
	awful.key({ modkey, }, "c", function (c) c:kill() end),
	awful.key({ modkey, }, "t", awful.client.floating.toggle ),
	awful.key({ modkey, }, "m", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey, }, "y", function (c) c.ontop = not c.ontop end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
	keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewonly(tags[screen][i])
				end
			end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewtoggle(tags[screen][i])
				end
			end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.movetotag(tags[client.focus.screen][i])
				end
			end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.toggletag(tags[client.focus.screen][i])
				end
			end)
	)
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
	{ rule = { },
		properties = { 
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			keys = clientkeys,
			buttons = clientbuttons,
			size_hints_honor = false 
		} 
	},
	
	--{ rule = { }, properties = { }, callback = awful.client.setslave },
	
	{ rule = { name = "ImageMagick:" },
		properties = { floating = true } 
	},
	
	{ rule = { class = "feh" },
		properties = { 
			border_color = beautiful.border_normal,
			focus = true,
			floating = true } 
	},
	
	{ rule = { class = "pinentry" },
		properties = { floating = true } 
	},
	
	{ rule = { class = "sun-awt-X11-XWindowPeer", "com-group_finity-mascot-Main" },
		properties = { floating = true, border_width = 0 } 
	},
	
	{ rule = { instance = "Download" },
		properties = { floating = true } 
	},
	
	{ rule = { instance = "Devtools" },
		properties = { floating = true } 
	},
}
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.center_horizontal(c)
            awful.placement.center_vertical(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
