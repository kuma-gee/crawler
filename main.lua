local Button = require 'lib.ui.button'
local Container = require 'lib.ui.container'
local Label = require 'lib.ui.label'

local Player = require "src.player"
local Dungeon = require 'src.dungeon'

local text
local root =
Container.new()
    :setPadding({ 10, 20 })
    :addChild(
        Button.new()
        :setPadding({ 10 })
        :addChild(Label.new("Hello"))
        :addChild(Label.new("World"))
    )


function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(0.14, 0.10, 0.08)


    -- text = "Nothing yet"
    root:update()

    -- math.randomseed(os.time())

    Player.onMove:register(function(dir)
        Dungeon:move(dir)

        -- local room = Dungeon:activeRoom()
        -- text = tostring(room.pos) .. "\n"

        -- for _, d in ipairs(room.doors) do
        --     text = text .. tostring(d) .. ", "
        -- end
    end)
end

function love.draw()
    -- love.graphics.print(text, 0, 0)

    Dungeon:draw()
    root:draw()
end

function love.update(dt)
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
