love.graphics.setDefaultFilter("nearest", "nearest")
enemy = {}
enemyImage = love.graphics.newImage("assets/img/spcInvdr.png")
playerImage = love.graphics.newImage("assets/img/ship.png")
enemiesController = {}
enemiesController.enemies = {}

function love.load()
    player = {}
    player.x = 0
    player.y = 550
    player.w = 48
    player.h = 48
    player.speed = 200
    player.bulletSpeed = 100
    player.fireSfx = love.audio.newSource("assets/sfx/laserShoot.wav", "static")
    player.bullets = {}
    player.initialCooldown = 0.25
    player.cooldown = player.initialCooldown
    
    player.fire = function()
        player.cooldown = player.initialCooldown
        player.fireSfx:play()
        bullet = {}
        bullet.w = 8
        bullet.h = 8
        bullet.x = player.x + player.w / 2 - bullet.w / 2
        bullet.y = player.y + player.h / 2 - bullet.h / 2
        table.insert(player.bullets, bullet)
    end
    enemiesController:spawnEnemy(10, 10)
    enemiesController:spawnEnemy(90, 10)
end

function love.update(dt)
    player.cooldown = player.cooldown - dt

    if love.keyboard.isDown('right') then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown('left') then
        player.x = player.x - player.speed * dt
    end

    if love.keyboard.isDown('space') and player.cooldown < 0 then
        player.fire()
    end

    for i, v in ipairs (player.bullets) do
        if v.y < -10 then
            table.remove(player.bullets, i)
        end
        v.y = v.y - player.bulletSpeed * dt
    end

    for i, v in ipairs (enemiesController.enemies) do
        v.y = v.y + enemy.ySpeed * dt
    end

end

function love.draw()    
    love.graphics.setColor(255, 255, 255, 255)
    for _, v in pairs (player.bullets) do
        love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
    end

    love.graphics.setColor(0, 191, 0, 255)
    for _, v in pairs (enemiesController.enemies) do
        -- love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
        love.graphics.draw(enemyImage, v.x, v.y, 0, 4, 4, 0, 0, 0, 0)
    end

    love.graphics.setColor(0, 191, 191, 255)
    -- love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
    love.graphics.draw(playerImage, player.x, player.y, 0, 4, 4, 0, 0, 0, 0)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function enemy:fire()
    if self.cooldown < 0 then
        self.cooldown = self.initialCooldown
        bullet = {}
        bullet.w = 10
        bullet.h = 10
        bullet.x = self.x + self.w / 2 - bullet.w / 2
        bullet.y = self.y + self.h / 2 - bullet.h / 2
        table.insert(self.bullets, bullet)
    end
end

function enemiesController:spawnEnemy(x, y)
    enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.w = 48
    enemy.h = 48
    enemy.ySpeed = 25
    enemy.bulletSpeed = 100
    enemy.bullets = {}
    enemy.initialCooldown = 0.25
    enemy.cooldown = enemy.initialCooldown
    table.insert(self.enemies, enemy)
end