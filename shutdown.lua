local wibox = require('wibox')
local awful = require('awful')

module('shutdown')


function show_dialog(script_path)
    awful.util.spawn(script_path .. 'shutdown.sh')
end


function widget(color, script_path)
    local shutdown = wibox.widget.textbox()

    shutdown:set_markup("<span font='Monospace Bold' color='" .. color .. "'> ⏻ </span>")
    shutdown:connect_signal("press", function ()
        show_dialog(script_path)
    end)

    return shutdown
end

