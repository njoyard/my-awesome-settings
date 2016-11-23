local awful = require('awful')
local wibox = require('wibox')
local bashets = require('bashets')

module('dpms')


function widget(script_path)
    local dpms_widget = wibox.widget.textbox()

    dpms_widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function()
            awful.util.spawn_with_shell(script_path .. 'dpms.sh toggle')
            
        end)
    ))

    function update_dpms(data)
        local color = '#dddd33'
        local glyph = '☼'

        if data[1] == 'enabled' then
            color = '#3333dd'
            glyph = '☽'
        end
        
        dpms_widget:set_markup("<span font='Monospace Bold 16' color='" .. color .. "'>" .. glyph .."</span>")
    end

    bashets.register('dpms.sh', { callback=update_dpms, update_time=1 })

    return dpms_widget
end
    
function remove_client(tabl, c)
    local index = awful.util.table.hasitem(tabl, c)
    if index then
        table.remove(tabl, index)
        if #tabl == 0 then
	    set_dpms(true)
        end             
    end
end

function start()
    client.connect_signal("property::fullscreen",
        function(c)
            if c.fullscreen then
                table.insert(fullscreened_clients, c)
                if #fullscreened_clients > 0 then
                    set_dpms(false)
                end
            else
                remove_client(fullscreened_clients, c)
            end
        end)
    
    client.connect_signal("unmanage",
        function(c)
            if c.fullscreen then
                remove_client(fullscreened_clients, c)
            end
        end)
end

