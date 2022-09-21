Bird = Class{}

local GRAVITY = 20

function Bird:init()
    --loading bird image from the disk
    self.image = love.graphics.newImage('/images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --position of the bird
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    --Y velocity
    self.dy = 0
end

function Bird:update(dt)
    --adding gravity to the velcity
    self.dy = self.dy + GRAVITY * dt

    --adding negative gravity when pressed space
    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    --apply velocity to Y position
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end