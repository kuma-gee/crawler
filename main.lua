Vector = require "lib.vector"
Signal = require "lib.signal"

local Player = require "src.player"
local Dungeon = require 'src.dungeon'

local text

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0.14, 0.10, 0.08)


    text = "Nothing yet"

    -- math.randomseed(os.time())

    Player.move:register(function(dir)
        Dungeon:move(dir)

        local room = Dungeon:activeRoom()
        text = tostring(room.pos) .. "\n"

        for _, d in ipairs(room.doors) do
            text = text .. tostring(d) .. ", "
        end
    end)
end

function love.draw()
    love.graphics.print(text, 0, 0)

    Dungeon:draw()
end

function love.update(dt)
end

function love.keypressed(key)
    Player:keypressed(key)
end
