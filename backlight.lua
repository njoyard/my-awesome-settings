local awful = require('awful')
local utils = require('utils')
local bashets = require('bashets')
local io = require('io')
local math = require('math')

module('backlight')

bar = nil
max = 0
gamma = 2.2
steps = 20

function widget(bg, fg, gam, step)
    gamma = gam
    steps = step
    max = run('max')
    cur = run('cur')
    bar = utils.vbar(bg, fg)
    bar:set_value(100*normalize(cur))
    return bar
end


function denormalize(x)
    return math.floor(max*x^(1/gamma))
end

function normalize(c)
    return (c/max)^gamma
end

function run(arg)
    local h = io.popen('~/.config/awesome/scripts/backlight.sh ' .. arg)
    local val = nil

    for line in h:lines() do
        val = line + 0
        break
    end
    io.close(h)

    return val
end

function increase()
    local cur = normalize(run('cur'))
    cur = cur+1/steps

    if cur > 1 then
        cur = 1
    end
    
    bar:set_value(100*cur)
    run(denormalize(cur))
end

function decrease()
    local cur = normalize(run('cur'))
    cur = cur-1/steps

    if cur < 0 then
        cur = 0
    end

    bar:set_value(100*cur)
    run(denormalize(cur))
end


