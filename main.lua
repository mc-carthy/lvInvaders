love.graphics.setDefaultFilter("nearest", "nearest")
enemy = {}
enemyImage = love.graphics.newImage("assets/img/spcInvdr.png")
playerImage = love.graphics.newImage("assets/img/ship.png")
enemiesController = {}
enemiesController.enemies = {}
particleSystem = {}
particleSystem.list = {}
particleSystem.img = love.graphics.newImage("assets/img/particle.png")

function checkCollisions(enemies, bullets)
    for i, e in ipairs(enemies) do
        for j, b in ipairs(bullets) do
            if b.y <= e.y + e.h and b.x > e.x and b.x < e.x + e.w then
                particleSystem:spawn(e.x, e.y)
                table.remove(enemies, i)
                table.remove(bullets, j)
            end
        end
    end
end

function love.load()
    local music = love.audio.newSource('assets/music/music.mp3')
    music:setLooping(true)
    love.audio.play(music)
    
    gameOver = false
    gameWin = false
    backgroundImage = love.graphics.newImage("assets/img/background.png")
    player = {}
    player.x = 0
    player.y = 550
    player.w = 48
    player.h = 48
    player.speed = 200
    player.bulletSpeed = 200
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
    for i = 1, 9 do
        enemiesController:spawnEnemy(15 + (90 * (i - 1)), 10)
        enemiesController:spawnEnemy(15 + (90 * (i - 1)), 60)
    end
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

    if #enemiesController.enemies <= 0 then
        gameWin = true
    end
    
    for i, v in ipairs (enemiesController.enemies) do
        v.y = v.y + enemy.ySpeed * dt
        if v.y >= love.graphics.getHeight() then
            gameOver = true
        end
    end

    particleSystem:update(dt)

    checkCollisions(enemiesController.enemies, player.bullets)

end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    if gameOver then
        love.graphics.print("Game Over!")
        return
    end

    love.graphics.draw(backgroundImage, 0, 0, 0, 5, 5)

    if gameWin then
        love.graphics.print("You Won!", 10, 10)
    end

    for _, v in pairs (player.bullets) do
        love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
    end

    love.graphics.setColor(0, 191, 0, 255)
    for _, v in pairs (enemiesController.enemies) do
        -- love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
        love.graphics.draw(enemyImage, v.x, v.y, 0, 4, 4, 0, 0, 0, 0)
    end

    particleSystem:draw()

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
    enemy.h = 40
    enemy.ySpeed = 25
    enemy.bulletSpeed = 100
    enemy.bullets = {}
    enemy.initialCooldown = 0.25
    enemy.cooldown = enemy.initialCooldown
    table.insert(self.enemies, enemy)
end

function particleSystem:spawn(x, y)
    local p = {}
    p.x = x
    p.y = y
    p.ps = love.graphics.newParticleSystem(particleSystem.img, 32)
    p.ps:setParticleLifetime(1, 2)
    p.ps:setEmissionRate(5)
    p.ps:setSizeVariation(1)
    p.ps:setLinearAcceleration(-40, -40, 40, 40)
    p.ps:setColors(100, 255, 100, 255, 0, 255, 0, 255)
    table.insert(particleSystem.list, p)
end

function particleSystem:update(dt)
    for _, v in pairs(particleSystem.list) do
        v.ps:update(dt)
    end
end

function particleSystem:draw()
    for _, v in pairs(particleSystem.list) do
        love.graphics.draw(v.ps, v.x, v.y)
    end
end