local Control = require 'lib.node.control'
local Sprite = Control:extend()

function Sprite:new(img)
    Sprite.super.new(self, Vector.ZERO)
    self:setImage(img)
end

function Sprite:setImage(img)
    self._image = img
    self:setSize(Vector(img:getDimensions()))
end

function Sprite:draw()
    local pos = self:getTopLeftCorner()
    love.graphics.draw(self._image, pos.x, pos.y)

    Sprite.super.draw(self)
end

return Sprite
