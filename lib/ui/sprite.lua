local Sprite = Class:extend()

function Sprite:new(img)
    self:setImage(img)
    self.x, self.y = 0, 0
end

function Sprite:setImage(img)
    self._image = img
end

function Sprite:setPosition(x, y)
    self.x, self.y = x, y
end

function Sprite:draw()
    love.graphics.draw(self._image, self.x, self.y)
end

return Sprite
