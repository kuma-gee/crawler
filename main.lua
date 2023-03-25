local Input = require 'lib.input'
local Game = require 'src.game'

local push = require 'lib.push'
local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth / 2, windowHeight / 2, { fullscreen = false, resizable = true })
Unit.setScreenSize(gameWidth, gameHeight)
Logger.setLoggingLevel(Logger.Level.DEBUG)


local root = Game()

function love.load()
    love.graphics.setNewFont(24)
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
    push:resize(w, h)
end
