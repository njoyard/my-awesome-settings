local awful = require('awful')
local bashets = require('bashets')

module('utils')

local bar_width = 6
local bar_height = 24
local bar_border = '#000000'

function setup(w, h, border)
    bar_width = w
    bar_height = h
    bar_border = border
end

function vbar(bg, fg)
    local bar = awful.widget.progressbar()

    bar:set_width(bar_width)
    bar:set_height(bar_height)
    bar:set_vertical(true)
    bar:set_background_color(bg)
    bar:set_border_color(bar_border)
    bar:set_color(fg)
    bar:set_max_value(100)
    bar:set_value(0)

    return bar
end

function script_bar(bg, fg, script, interval)
    local bar = vbar(bg, fg)
    bashets.register(script, { widget = bar, update_time = interval, format = '$1' })
    return bar
end

