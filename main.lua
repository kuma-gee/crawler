local Input = require 'lib.input'
local Game = require 'src.game'

Logger.setLoggingLevel(Logger.Level.DEBUG)


local root = Game()

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0.14, 0.10, 0.08)

    -- math.randomseed(os.time())

    Input.onInput:register(function(ev) root:input(ev) end)
    Input:load()

    root:load()
end

function love.draw()
    root:draw()
end

function love.update(dt)
    root:update(dt)
end

-- Register Inputs

function love.keypressed(key)
    Input:keypressed(key)
end

function love.keyreleased(key)
    Input:keyreleased(key)
end

function love.mousepressed(...)
    Input:mousepressed(...)
end

function love.mousereleased(...)
    Input:mousereleased(...)
end

function love.resize(w, h)
    Input:resize(w, h)
end
