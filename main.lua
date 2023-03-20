Vector = require "library.vector"
Signal = require "library.signal"

local Player = require "src.player"

local text

function love.load()
    love.graphics.setNewFont(12)
    text = "Nothing yet"

    Player.move:register(function(dir) text = tostring(dir) end)
end

function love.draw()
    love.graphics.print(text, 330, 300)
end

function love.update(dt)
end

function love.keypressed(key)
    Player:keypressed(key)
end
