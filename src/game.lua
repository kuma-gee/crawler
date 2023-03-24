local Player = require "src.player"
local Dungeon = require 'src.dungeon'
local MainContainer = require 'src.main-container'
local Map = require 'src.map'


local Node = require 'lib.node'
local Game = Node:extend()

local player = Player()
local dungeon = Dungeon(10, 10, player)
local ui = MainContainer():addChild(Map(dungeon))

function Game:new()
	Game.super.new(self)
	self:addChild(player, dungeon, ui)
end

return Game
