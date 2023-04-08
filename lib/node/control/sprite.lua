local Control = require 'lib.node.control'
local Sprite = Control:extend()

function Sprite:new(img)
    Sprite.super.new(self, Vector.ZERO)
    self:setImage(img)
end

function Sprite:setImage(img)
    self._image = img
    if img then
        self:setSize(Vector(img:getDimensions()))
    end
end

function Sprite:drawLocal()
    if not self._image then
        return
    end

    love.graphics.draw(self._image, 0, 0)
end

return Sprite
