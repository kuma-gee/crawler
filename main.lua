local Input = require 'lib.input'
local Game = require 'src.game'
local Timer = require 'lib.timer'

love.graphics.setDefaultFilter('nearest', 'nearest')
love.graphics.setLineStyle('rough')

local push = require 'lib.push'
local gameWidth, gameHeight = 1920 / 2, 1080 / 2
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth / 2, windowHeight / 2, { fullscreen = false, resizable = true, stencil = false })
Unit.setScreenSize(gameWidth, gameHeight)
Logger.setLoggingLevel(Logger.Level.DEBUG)


local root = Game()

function love.load()
    love.graphics.setNewFont('jackeyfont.ttf', 12)
    -- math.randomseed(os.time())

    Input.onInput:register(function(ev) root:input(ev) end)
    Input:load()

    root:load()
end

function love.draw()
    push:start()
    root:draw()
    push:finish()
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
    push:resize(w, h)
end
