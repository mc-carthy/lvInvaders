function love.load()
    player = {}
    player.x = 0
    player.y = 500
    player.w = 80
    player.h = 20
    player.speed = 200
    player.bulletSpeed = 100
    player.bullets = {}
    player.fire = function() 
        bullet = {}
        bullet.w = 10
        bullet.h = 10
        bullet.x = player.x + player.w / 2 - bullet.w / 2
        bullet.y = player.y + player.h / 2 - bullet.h / 2
        table.insert(player.bullets, bullet)
    end
end

function love.update(dt)
    if love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    end

    for i, v in ipairs (player.bullets) do
        if v.y < -10 then
            table.remove(player.bullets, i)
        end
        v.y = v.y - player.bulletSpeed * dt
    end
end

function love.draw()    
    love.graphics.setColor(255, 255, 255, 255)
    for _, v in pairs (player.bullets) do
        love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
    end

    love.graphics.setColor(0, 191, 191, 255)
    love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'space' then
        player.fire()
    end
end