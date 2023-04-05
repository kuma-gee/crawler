require 'src.theme'

local Input  = require 'lib.input'
local Game   = require 'src.game'
local Screen = require 'lib.screen'

local Test   = require 'test.test'

Logger.setLoggingLevel(Logger.Level.DEBUG)

local root = Screen(1920 / 10, 1080 / 10, true):addChild(Game())

function love.load()
    love.graphics.setNewFont('TeenyTinyPixls-o2zo.ttf', 5)
    -- math.randomseed(os.time())

    root:load()

    Input.onInput:register(function(ev) root:input(ev) end)
    Input:load()
end

function love.draw()
    root:draw()
end

function love.update(dt)
    root:update(dt)
    Timer.update(dt)
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

function love.mousemoved(...)
    Input:mousemoved(...)
end

function love.resize(w, h)
    Input:resize(w, h)
end
