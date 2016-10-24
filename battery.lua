local beautiful = require('beautiful')
local wibox = require('wibox')
local utils = require('utils')
local bashets = require('bashets')
local naughty = require('naughty')

module('battery')

function tonum(s)
    -- TODO: find out why builtin tonumber is nil here
    return s + 0
end

function widget(options)
    local batteries = wibox.layout.fixed.horizontal()
    local bat0bar = utils.vbar(options.bg, options.fg, 100)
    local bat1bar = utils.vbar(options.bg, options.fg, 100)
    local baticon = wibox.widget.textbox()

    batteries:add(baticon)
    batteries:add(bat0bar)
    batteries:add(bat1bar)
    
    markup = "<span font='Monospace Bold 16'> </span>"
    baticon:set_markup(markup)

    local bat_blink = 0
    local bat_notify_handle = nil

    function notify(clear)
        local timeout = 0
        if clear == true then
            timeout = 1
            if bat_notify_handle == nil then
                return
            end
        elseif bat_notify_handle ~= nil then
            return
        end

        bat_notify_handle = naughty.notify({
            title='Battery below ' .. options.danger_threshold .. '% !',
            text='Please charge ASAP or kittens will be eaten.',
            timeout=timeout,
            fg='#ff0000',
            replaces_id=bat_notify_handle
        }).id

        if clear == true then
            bat_notify_handle = nil
        end
    end

    function batstate(data)
        local text = '?'
        local color = '#ff00ff'

        if data[1] == 'AC' then
            text = '⚡'
            color = options.fg
            notify(true)
        else
            if tonum(data[2]) < options.warning_threshold then
                text = '!'
                color = options.danger

                if tonum(data[2]) < options.danger_threshold then
                    text = '‼'

                    notify(false)
                    if bat_blink == 0 then
                        color = options.danger
                    else
                        color = beautiful.bg_normal
                    end
                    bat_blink = 1 - bat_blink
                else
                    notify(true)
                end
            else
                notify(true)
                text = ' '
            end
        end

        markup = "<span font='Monospace Bold 16' color='" .. color .. "'>" .. text .. "</span>"
        baticon:set_markup(markup)
    end

    bashets.register("battery.sh state", {update_time=1, callback=batstate})
    bashets.register("battery.sh BAT0", {widget = bat0bar, update_time=10, format='$1'})
    bashets.register("battery.sh BAT1", {widget = bat1bar, update_time=10, format='$1'})

    return batteries
end
