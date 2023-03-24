local Node = require 'lib.node'

local Input = require 'lib.input'

local Player = require "src.player"
local Dungeon = require 'src.dungeon'
local MainContainer = require 'src.main-container'

Logger.setLoggingLevel(Logger.Level.DEBUG)


local root = Node():addChild(
    Dungeon,
    Player,
    MainContainer
)

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0.14, 0.10, 0.08)

    -- math.randomseed(os.time())

    Input.onInput:register(function(ev) root:input(ev) end)

    Player.onMove:register(function(dir)
        Dungeon:move(dir)

        -- local room = Dungeon:activeRoom()
        -- positionText:setText(room.pos)

        -- local move = ""
        -- for _, d in ipairs(room.doors) do
        --     move = move .. tostring(d) .. ", "
        -- end
        -- movableText:setText(move)
    end)
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
