DEBUG = false

SCREENWIDTH = 720
SCREENHEIGHT = 520

gameStartTimer = love.timer.getTime()

ripple = require('ripple')
POWERUP = require('powerup')

local t, shakeDuration, shakeMagnitude = 0, -1, 0

local function startShake(duration, magnitude)
    
    t, shakeDuration, shakeMagnitude = 0, duration or 1, magnitude or 5
end

local function loadSounds()

    local pongsrc = love.audio.newSource('pong.wav', 'static')
    pongSFX = ripple.newSound(pongsrc)
    
    local pingsrc = love.audio.newSource('ping.wav', 'static')
    pingSFX = ripple.newSound(pingsrc)

    local hitsrc = love.audio.newSource('hit.wav', 'static')
    hitSFX = ripple.newSound(hitsrc)
    
    local powerupsrc = love.audio.newSource('powerup.wav', 'static')
    powerupSFX = ripple.newSound(powerupsrc)
    
    local shootsrc = love.audio.newSource('shoot.wav', 'static')
    shootSFX = ripple.newSound(shootsrc)

    local goalsrc = love.audio.newSource('goal.wav', 'static')
    goalSFX = ripple.newSound(goalsrc)



end

local function shoot(y)

    isShooting = true

    BULLET.y = y

    if BULLET.x > SCREENWIDTH then
        BULLET.x = 0
        BULLET.y = 0
        isShooting = false
    end

    local instance = shootSFX:play()

end

local function enemyShoot(y)
    ENEMYBULLET.y = y
    local instance = shootSFX:play()
end

local function start()

    isStarting = false
    local r = love.math.random()
    local a = 1
    if r < 0.5 then
        a = -1
    end
        

    BALL.vel.x = 4*a
    BALL.vel.y = 4*a

end

local function bounce(x, y)
    startShake(0.1,1)
    BALL.vel.x = x * BALL.vel.x
    BALL.vel.y = y * BALL.vel.y

    if BALL.vel.x < 0 then
        local instance = pongSFX:play()
    else
        local instance = pingSFX:play()
    end

end

function resetPowerUp(s)
    if s == "su" then
        POWERUP.speedUp.x = love.math.random(50, SCREENWIDTH - 50)
        POWERUP.speedUp.y = love.math.random(10, SCREENHEIGHT - 50)
    end
    if s == "sd" then
        POWERUP.speedDown.x = love.math.random(50, SCREENWIDTH - 50)
        POWERUP.speedDown.y = love.math.random(10, SCREENHEIGHT - 50)
    end
end

local function checkPowerUpHitbox()      
    if (BULLET.x >= POWERUP.speedUp.x and BULLET.x <= POWERUP.speedUp.x + 32) and (BULLET.y >= POWERUP.speedUp.y and BULLET.y <= POWERUP.speedUp.y + 32) then
        POWERUP.speedUp.pickUp("bu")    
        POWERUP.speedUp.action()
    end

    if (BULLET.x >= POWERUP.speedDown.x and BULLET.x <= POWERUP.speedDown.x + 32) and (BULLET.y >= POWERUP.speedDown.y and BULLET.y <= POWERUP.speedDown.y + 32) then
        POWERUP.speedDown.pickUp("bu")  
        POWERUP.speedDown.action()
    end

    if (ENEMYBULLET.x >= POWERUP.speedUp.x and ENEMYBULLET.x <= POWERUP.speedUp.x + 32) and (ENEMYBULLET.y >= POWERUP.speedUp.y and ENEMYBULLET.y <= POWERUP.speedUp.y + 32) then
        POWERUP.speedUp.pickUp("en")  
        POWERUP.enemySpeedUp.action()
    end

    if (ENEMYBULLET.x >= POWERUP.speedDown.x and ENEMYBULLET.x <= POWERUP.speedDown.x + 32) and (ENEMYBULLET.y >= POWERUP.speedDown.y and ENEMYBULLET.y <= POWERUP.speedDown.y + 32) then
        POWERUP.speedDown.pickUp("en")  
        POWERUP.enemySpeedDown.action()
        ENEMYBULLET.x = SCREENWIDTH
        isEnemyShooting = false
    end

    if (BALL.x >= POWERUP.speedUp.x and BALL.x <= POWERUP.speedUp.x + 32) and (BALL.y >= POWERUP.speedUp.y and BALL.y <= POWERUP.speedUp.y + 32) then
        POWERUP.speedUp.pickUp("ba")  
        POWERUP.ballSpeedUp.action()
    end

    if (BALL.x >= POWERUP.speedDown.x and BALL.x <= POWERUP.speedDown.x + 32) and (BALL.y >= POWERUP.speedDown.y and BALL.y <= POWERUP.speedDown.y + 32) then
        POWERUP.speedDown.pickUp(ba)  
        POWERUP.ballSpeedDown.action() 
    end
end

local function restart(b)

    PLAYER.x = 0
    PLAYER.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    ENEMY.x = SCREENWIDTH - PLAYER.imgWidth
    ENEMY.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    BALL.x = SCREENWIDTH / 2
    BALL.y = SCREENHEIGHT / 2
    PLAYER.vel = 3
    ENEMY.vel = 3
    BALL.vel.x = 4

    if b then
        isStarting = true
        return
    end

    if b == false then
        PLAYER.lives = 3
        ENEMY.HP = 10
        isGameOver = false
    end
end

function love.load()

    isStarting = true
    isShooting = false
    isEnemyShooting = false

    love.window.setMode(SCREENWIDTH, SCREENHEIGHT)
    love.window.setTitle("Pong csak lehet loni")

    bannerImage = love.graphics.newImage("banner.png")
    hpImage = love.graphics.newImage("hp.png")

    loadSounds()

    PLAYER = {}
    PLAYER.img = love.graphics.newImage("player.png")
    PLAYER.imgWidth = PLAYER.img:getWidth()
    PLAYER.imgHeight = PLAYER.img:getHeight()
    PLAYER.score = 0
    PLAYER.lives = 3
    PLAYER.x = 0
    PLAYER.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    PLAYER.vel = 3

    ENEMY = {}
    ENEMY.img = love.graphics.newImage("enemy.png")
    ENEMY.x = SCREENWIDTH - PLAYER.imgWidth
    ENEMY.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    ENEMY.vel = 3
    ENEMY.HP = 10

    BALL = {}
    BALL.img = love.graphics.newImage("ball.png")
    BALL.x = SCREENWIDTH / 2
    BALL.y = SCREENHEIGHT / 2
    BALL.vel = {}
    BALL.vel.x = 3
    BALL.vel.y = 1
    BALL.height = BALL.img:getHeight()
    BALL.width = BALL.img:getWidth()

    BULLET = {}
    BULLET.img = love.graphics.newImage("bullet.png")
    BULLET.x = 0
    BULLET.y = PLAYER.y + PLAYER.imgHeight / 2
    BULLET.vel = 10

    ENEMYBULLET = {}
    ENEMYBULLET.img = love.graphics.newImage("bullet.png")
    ENEMYBULLET.x = SCREENWIDTH
    ENEMYBULLET.y = ENEMY.y + PLAYER.imgHeight / 2
    ENEMYBULLET.vel = 9

    POWERUP.speedUp.modifier = 1
    POWERUP.speedDown.modifier = -1
   
end

function love.update(dt)

    if t < shakeDuration then
        t = t + dt
    end

    if isStarting ~= true and isGameOver ~= true then

        BALL.x = BALL.x + BALL.vel.x
        BALL.y = BALL.y + BALL.vel.y
    

        if isShooting  then
        
            BULLET.x = BULLET.x + BULLET.vel
        

            if BULLET.x > SCREENWIDTH then
                isShooting = false
            end
        
            
        end

        if isEnemyShooting then
        
            ENEMYBULLET.x = ENEMYBULLET.x - ENEMYBULLET.vel

            if ENEMYBULLET.x < 0 then
            
            isEnemyShooting = false
            ENEMYBULLET.x = SCREENWIDTH
            end
        
        end

        --wall bouonce - Y irányú eltírites

        if BALL.y < 0 + BALL.height then
        
            bounce(1, -1)
        end

        if BALL.y >= SCREENHEIGHT - BALL.height then

            bounce(1, -1)
        end

        -- AI

        if BALL.y < ENEMY.y + PLAYER.imgHeight / 2  then
            ENEMY.y = ENEMY.y - ENEMY.vel
        elseif BALL.y > ENEMY.y + PLAYER.imgHeight / 2 then
            ENEMY.y = ENEMY.y + ENEMY.vel
        end

        --paddle bounce - X irány

        if BALL.x < PLAYER.x + BALL.width and BALL.y >= PLAYER.y and BALL.y <= PLAYER.y + PLAYER.imgHeight then
            bounce(-1,1)
            BALL.x = BALL.x + 5
        end

        if BALL.x > ENEMY.x - BALL.width and BALL.y >= ENEMY.y and BALL.y <= ENEMY.y + PLAYER.imgHeight then
            bounce(-1,1)
            BALL.x = BALL.x - 5
        end

        --goal

        if BALL.x > SCREENWIDTH - 5 then
            local instance = goalSFX:play()
            ENEMY.HP = ENEMY.HP - 2
            restart(true)
        elseif BALL.x < 0 then
            local instance = goalSFX:play()
            PLAYER.lives = PLAYER.lives - 1
            restart(true)
        end

        if PLAYER.lives == 0 then
            isGameOver = true
        end

        
        if isShooting then

        
            if BULLET.x >= ENEMY.x and (BULLET.y < ENEMY.y + PLAYER.imgHeight and BULLET.y > ENEMY.y) then
            
                ENEMY.HP = ENEMY.HP - 1
                BULLET.x = 0
                local instance = hitSFX:play()
                isShooting = false
            

                if ENEMY.HP == 0 then
                    isGameOver = true
                end
            end
        end
        
        if ENEMY.y == PLAYER.y and isEnemyShooting == false then 
        
            isEnemyShooting = true
            local y = ENEMY.y + PLAYER.imgHeight / 2
                enemyShoot(y)
        
            
        end

        if isEnemyShooting then
           
            if ENEMYBULLET.x == PLAYER.x and (ENEMYBULLET.y < PLAYER.y + PLAYER.imgHeight and ENEMYBULLET.y > PLAYER.y) then
                PLAYER.lives = PLAYER.lives - 1
                local instance = hitSFX:play()
            end
        end


        checkPowerUpHitbox()
      

        -- billentyuzet


        if love.keyboard.isDown("up") then 
            if PLAYER.y > 0  then
                PLAYER.y = PLAYER.y - PLAYER.vel
            end
        elseif love.keyboard.isDown("down") then
            if PLAYER.y < SCREENHEIGHT - PLAYER.imgHeight then
                PLAYER.y = PLAYER.y + PLAYER.vel
            end
    


        elseif love.keyboard.isDown("r") then
            resetBall()

        elseif isShooting == false and love.keyboard.isDown("s") then
            local y = PLAYER.y + PLAYER.imgHeight / 2
            shoot(y)
        
        end




        -- timerek


        if love.timer.getTime() - POWERUP.speedUp.timer > POWERUP.speedUp.dur then
            POWERUP.speedUp.isOnMap = true
            
        end

        if love.timer.getTime() - POWERUP.speedDown.timer > POWERUP.speedDown.dur then
            POWERUP.speedDown.isOnMap = true
        end

        if love.timer.getTime() - POWERUP.double.timer > POWERUP.double.dur then
            POWERUP.double.isOnMap = true
        end

      

    end
    if love.keyboard.isDown("space") then

        if isStarting then
            start()
        end

        if isGameOver then

            restart(false)
          

            
        end

    end
end

function love.draw()

    if t < shakeDuration then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    love.graphics.draw(bannerImage, SCREENHEIGHT / 2 - bannerImage:getWidth() / 3, 0) 
   -- love.graphics.print("PONG BUT YOU CAN SHOOT", SCREENHEIGHT / 2, 0)
   
   
 
    
    
    love.graphics.draw(PLAYER.img, PLAYER.x, PLAYER.y )
  
    love.graphics.draw(BALL.img, BALL.x, BALL.y)

    love.graphics.draw(ENEMY.img, ENEMY.x, ENEMY.y)
 
    love.graphics.print("HP:"..ENEMY.HP, SCREENWIDTH - 50, 0)
    for i = 1, ENEMY.HP do
        love.graphics.draw(hpImage, ((SCREENWIDTH - SCREENWIDTH / 4) - 16) + i * 16, 1)
    end
    for i = 1, PLAYER.lives do 
        love.graphics.draw(hpImage, 16*i, 1)
    end

    if isGameOver then
        love.graphics.print("PRESS SPACE TO RESTART", SCREENWIDTH / 2 - 65, SCREENHEIGHT / 4)
    end

    if isStarting and PLAYER.lives > 0 then
        love.graphics.print("PRESS SPACE TO START", SCREENWIDTH / 2 - 65, SCREENHEIGHT / 4)
        love.graphics.print("arrows - movement, s - shoot", SCREENWIDTH / 2 - 85, SCREENHEIGHT / 4 + 20)
    end

    if DEBUG then
        love.graphics.print("PL VEL:"..PLAYER.vel, 0, 60)
        love.graphics.print("BL VEL:"..BALL.vel.x, 0, 80)
        love.graphics.print("EN VEL:"..ENEMY.vel, 0, 100)
        love.graphics.print(BULLET.x, BULLET.x - 10, BULLET.y - 10)
        love.graphics.print(BALL.x, BALL.x + 30, BALL.y)
        love.graphics.print(BALL.y, BALL.x + 60, BALL.y)
        love.graphics.print(PLAYER.y, PLAYER.x + 50, PLAYER.y)
        love.graphics.print(ENEMY.y, ENEMY.x - 50, ENEMY.y)
    end

    if isGameOver  then
        love.graphics.print("GAME OVER", SCREENWIDTH / 2, SCREENHEIGHT / 2 - 20)
    end

    if isShooting then
        
        love.graphics.draw(BULLET.img, BULLET.x + 5, BULLET.y + 5)
    end

    if isEnemyShooting then
        love.graphics.draw(ENEMYBULLET.img, ENEMYBULLET.x, ENEMYBULLET.y, math.pi)
    end

    if POWERUP.speedDown.isOnMap then
        love.graphics.draw(POWERUP.speedDown.img, POWERUP.speedDown.x, POWERUP.speedDown.y, 0, 2, 2)
    end

    if POWERUP.speedUp.isOnMap then
        love.graphics.draw(POWERUP.speedUp.img, POWERUP.speedUp.x, POWERUP.speedUp.y, 0, 2, 2)
    end
  --  
    if POWERUP.double.isOnMap then
        love.graphics.draw(POWERUP.double.img, POWERUP.double.x, POWERUP.double.y)
    end

end