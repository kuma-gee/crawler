Button = require 'lib.ui.button'

local Player = require "src.player"
local Dungeon = require 'src.dungeon'

local text
local btn = Button.new()

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0.14, 0.10, 0.08)


    text = "Nothing yet"

    btn.text = "Test"
    btn.onClick:register(function() print("click") end)
    btn.y = 200

    -- math.randomseed(os.time())

    Player.onMove:register(function(dir)
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
    btn:draw()
end

function love.update(dt)
    btn:update()
end

function love.keypressed(key)
    Player:keypressed(key)
end

function love.mousepressed(...)
    btn:mousepressed(...)
end

function love.mousereleased(...)
    btn:mousereleased(...)
end
