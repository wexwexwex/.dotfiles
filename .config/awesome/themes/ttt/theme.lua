local config 
do
	local dir = os.getenv("XDG_CONFIG_HOME")
	if dir then
		config = dir .. "/awesome"
	else
		config = os.getenv("HOME") .. "/.config/awesome"
	end
end

local theme = {}

theme.font = "Tewi 7"

theme.bg_light    = "#19161a"
theme.bg_normal   = "#19161a"
theme.bg_focus    = "#19161a"
theme.bg_urgent   = "#19161a"
theme.bg_minimize = "#19161a"
theme.bg_systray  = "#19161a"

theme.fg_normal   = "#b9b1ba"
theme.fg_focus    = "#f4eef5"
theme.fg_urgent   = "#ffaba5"
theme.fg_minimize = "#4c484d"

theme.fg_modebox   = "#e0bfda"
theme.fg_delimiter = "#4c484d"

theme.fg_dmenu     = "#7b92d4"
theme.fg_dmenu_foc = "#d4ddff"
theme.bg_dmenu     = "#19161a"
theme.bg_dmenu_foc = "#19161a"

theme.border_width  = 1
theme.border_normal = "#232124"
theme.border_light  = "#4c484d"
theme.border_marked = "#d4ddff"

theme.taglist_fg_focus    = "#f4eef5"
theme.taglist_fg_urgent   = "#ffaba5"
theme.taglist_fg_occupied = "#d4ddff"

theme.tasklist_fg_focus  = "#f4eef5"
theme.tasklist_fg_urgent = "#ffaba5"
theme.tasklist_fg_normal = "#b9b1ba"

theme.tasklist_disable_icon = true

theme.taglist_squares_sel   = config .. "/themes/ttt/taglist/squarefw.png"
theme.taglist_squares_unsel = config .. "/themes/ttt/taglist/squarew.png"

theme.tasklist_floating             = "+ "
theme.tasklist_ontop                = "^ "
theme.tasklist_sticky               = "* "
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

theme.menu_submenu_icon = config .. "/themes/ttt/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "80"

theme.layout = {
	fairh      = "",
	fairv      = "",
	floating   = "",
	max        = "",
	spiral     = "",
	tilebottom = "",
	tileleft   = "",
	tile       = "",
	tiletop    = "tiletopw",
	fullscreen = "fullscreenw",
	dwindle    = "dwindlew",
	magnifier  = "magnifier",
}

theme.awesome_icon = config .. "/icons/awesome16.png"
theme.icon_theme = "Faenza"

return theme
