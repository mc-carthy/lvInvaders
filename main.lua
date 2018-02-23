local speed = 10

function love.load()
    x = 0
    y = 0
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        x = x + speed * dt
    end

    if love.keyboard.isDown("left") then
        x = x - speed * dt
    end

    if love.keyboard.isDown("up") then
        y = y - speed * dt
    end

    if love.keyboard.isDown("down") then
        y = y + speed * dt
    end
end

function love.draw()
    love.graphics.setColor(0, 191, 191, 255)
    love.graphics.rectangle("fill", x, y, 200, 200)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end