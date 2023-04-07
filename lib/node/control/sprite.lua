local Control = require 'lib.node.control'
local Sprite = Control:extend()

function Sprite:new(img)
    Sprite.super.new(self, Vector.ZERO)
    self:setImage(img)
end

function Sprite:setImage(img)
    self._image = img
    local size = self:getMinSize()
    local imageSize = Vector(img:getWidth(), img:getHeight())
    self:setMinSize(size:max(imageSize))
end

function Sprite:draw()
    Sprite.super.draw(self)

    local pos = self:getTopLeftCorner()
    love.graphics.draw(self._image, pos.x, pos.y)
end

return Sprite
