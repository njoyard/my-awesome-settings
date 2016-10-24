local awful = require('awful')
local io = require('io')
local string = require('string')
local wibox = require('wibox')

local utils = require('utils')

module('volume')

vol_bg = '#ff0000'
vol_fg = '#00ff00'
muted_bg = '#ff00ff'
muted_fg = '#00ffff'

volbar = nil
micstate = wibox.widget.textbox()

function setup(bg, fg, mbg, mfg)
    vol_bg = bg
    vol_fg = fg
    muted_bg = mbg
    muted_fg = mfg

    volbar = utils.vbar(bg, fg)

    amixer('get Master')
    amixer('get Capture')
end

function amixer(cmd)
    local h = io.popen('amixer ' .. cmd)

    for line in h:lines() do
        if string.match(line, 'Front Left: Playback') then
            if string.find(line, 'on]') then
                volbar:set_color(vol_fg)
                volbar:set_background_color(vol_bg)
            else
                volbar:set_color(muted_fg)
                volbar:set_background_color(muted_bg)
            end

            local vol_str = string.match(line, '[0-9]+%%')
            local vol_num = string.match(vol_str, '[0-9]+') + 0
           
            volbar:set_value(vol_num)

            break
        elseif string.match(line, 'Front Left: Capture') then
            local mictext = '⊀'
            
            if string.find(line, 'on]') then
                mictext = ' '
            end

            local markup = "<span font='Monospace 14'>" .. mictext .. "</span>"
            micstate:set_markup(markup)
        end
    end

    io.close(h)
end


function toggle_mute()
    amixer('set Master toggle')
end

function toggle_mic()
    amixer('set Capture toggle')
end

function increase()
    amixer('set Master 5%+')
end

function decrease()
    amixer('set Master 5%-')
end

function widget()
    local container = wibox.layout.fixed.horizontal()

    container:add(micstate)
    container:add(volbar)

    return container
end

