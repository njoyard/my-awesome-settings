local beautiful = require('beautiful')
local bashets = require('bashets')
local wibox = require('wibox')
local awful = require('awful')

local utils = require('utils')
local battery = require('battery')
local volume = require('volume')
local network = require('network')
local backlight = require('backlight')
local shutdown = require('shutdown')
local dpms = require('dpms')
local redshift = require("redshift")

module('perso')

beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.border_width = 1
beautiful.border_focus = '#8888ee'
beautiful.border_normal = '#666666'
beautiful.wallpaper = '/home/njoyard/Images/wall/wallpaper-487504.jpg'

mem_bg = '#595300'
mem_fg = '#e0d100'

bat_bg = '#004349'
bat_fg = '#00a4db'
bat_danger = '#e80000'

disk_bg = '#005927'
disk_fg = '#00e061'

cpu_fg = '#d14900'
cpu_bg = '#5c2000'

light_fg = '#c0cbcf'
light_bg = '#515557'
light_gamma = 1/2
light_steps = 20

vol_fg = '#be8ccf'
vol_bg = '#423147'
muted_fg = '#616161'
muted_bg = '#373737'

network_font = '6'
connected_color = '#00bb88'
disconnected_color = '#bb0000'

logout_color = '#cc3333'

-- }}}


-- Settings
-- {{{

statusbar_height = 24
vbars_width = 6

bat_options = {
    fg = bat_fg,
    bg = bat_bg,
    danger = bat_danger,
    charged_threshold = 95,
    warning_threshold = 15,
    danger_threshold = 8
}

redshift_config = '/home/njoyard/.config/redshift.conf'
script_path = '~/.config/awesome/scripts/'
clock_format = " %a %d %b <span font='bold'>%H:%M</span> "
tags = {
    names  = {
        -- main screen
        { "work", "web", "irc", "subl", 5, 6, "mail", "pers", "pweb" },

        -- secondary screen
        { 1 }
    }
}

-- }}}


-- Start/stop functions
-- {{{

function start()
    bashets.start()
    awful.util.spawn_with_shell('xcompmgr -F &')
end

function stop()
    bashets.stop()
end

-- }}}


-- Widget generation
-- {{{

function get_widgets()
    local container = wibox.layout.fixed.horizontal()

    -- Volume
    container:add(volume.widget())

    -- Backlight
    container:add(backlight.widget(light_bg, light_fg, light_gamma, light_steps))

    -- Network
    container:add(network.widget(connected_color, disconnected_color, network_font))

    -- CPU
    container:add(utils.script_bar(cpu_bg, cpu_fg, 'cpu.sh', 1))
    
    -- Mem
    container:add(utils.script_bar(mem_bg, mem_fg, 'mem.sh', 5))

    -- Disk
    container:add(utils.script_bar(disk_bg, disk_fg, 'disk.sh', 5))

    -- Batteries
    container:add(battery.widget(bat_options))

    -- Clock
    container:add(awful.widget.textclock(clock_format))

    -- DPMS button
    container:add(dpms.widget(script_path))
    
    -- Logout button
    container:add(shutdown.widget(logout_color, script_path))

    return container
end

-- }}}


-- Shortcut keys
-- {{{

keys = awful.util.table.join(
    awful.key({}, 'XF86AudioMute', volume.toggle_mute),
    awful.key({}, 'XF86AudioRaiseVolume', volume.increase),
    awful.key({}, 'XF86AudioLowerVolume', volume.decrease),
    awful.key({}, 'XF86AudioMicMute', volume.toggle_mic),
    awful.key({}, 'XF86MonBrightnessDown', backlight.decrease),
    awful.key({}, 'XF86MonBrightnessUp', backlight.increase),
    awful.key({}, 'XF86Explorer', function() shutdown.show_dialog(script_path) end),
    awful.key({ 'Mod1' }, 'Print', function() awful.util.spawn_with_shell('gnome-screenshot -i') end)
)

-- }}}

-- Initial setup

bashets.set_script_path(script_path)
utils.setup(vbars_width, statusbar_height, beautiful.bg_normal)
volume.setup(vol_bg, vol_fg, muted_bg, muted_fg)
redshift.init("-c " .. redshift_config, 1)


