local bashets = require('bashets')
local wibox = require('wibox')

module('network')


function widget(ok_color, ko_color, font)
    local container = wibox.layout.fixed.horizontal()
    local space = wibox.widget.textbox()
    local wireless = wibox.widget.textbox()
    local ethernet = wibox.widget.textbox()

    space:set_text(' ')
    wireless:set_markup("<span font='" .. font .. "' color='" .. ko_color .. "'>W: off\n </span>")
    ethernet:set_markup("<span font='" .. font .. "' color='" .. ko_color .. "'>E: off\n </span>")

    container:add(space)
    container:add(wireless)
    container:add(space)
    container:add(ethernet)
    container:add(space)

    function update_wireless(data)
        local text = 'off'
        local ip = ' '
        local color = ko_color

        if data[1] ~= 'off' then
            text = data[1]
            ip = data[3]
            color = ok_color
        end

        wireless:set_markup("<span font='" .. font .. "' color='" .. color .. "'>W: " .. text .. "\n" .. ip .. "</span>")
    end

    bashets.register('wlan.sh wlp4s0', { callback=update_wireless, update_time=2 })

    return container
end


