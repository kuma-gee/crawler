local Button = require 'lib.node.control.button'
local Container = require 'lib.node.control.container'
local Label = require 'lib.node.control.label'
local Theme = require 'lib.node.control.theme'

local Player = require "src.player"
local Dungeon = require 'src.dungeon'

Logger.setLoggingLevel(Logger.Level.DEBUG)

local root =
    Container(Vector.DOWN):setTheme(Theme({ background = { 1, 0, 0, 1 }, padding = 5 }))
    :addChild(Button()
        :setTheme({ background = { 0, 0, 1, 0.5 }, padding = 5 })
        :addChild(Label("First")))
    :addChild(
        Button()
        :setTheme({ background = { 0, 1, 0, 0.5 }, padding = 5 })
        :addChild(Label("Second"))
        :addChild(Label("Second.2"))
    )

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0.14, 0.10, 0.08)



    -- math.randomseed(os.time())

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
    Dungeon:draw()
    root:draw()
end

function love.update(dt)
    root:update()
end

function love.keypressed(key)
    Player:keypressed(key)
end

function love.mousepressed(...)
    root:mousepressed(...)
end

function love.mousereleased(...)
    root:mousereleased(...)
end
