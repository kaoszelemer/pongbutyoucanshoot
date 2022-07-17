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

local function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
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

    local musicsrc = love.audio.newSource('pbycs.mp3', 'static')
    local music = ripple.newSound(musicsrc)

    music.loop = true
    local instance = music:play()

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

local function bounce(x, y, db)

    if db == true then
        startShake(0.1,1)
        BALL2.vel.x = x * BALL2.vel.x
        BALL2.vel.y = y * BALL2.vel.y
    
        if BALL.vel.x < 0 then
            local instance = pongSFX:play()
        else
            local instance = pingSFX:play()
        end
    else

        startShake(0.1,1)
        BALL.vel.x = x * BALL.vel.x
        BALL.vel.y = y * BALL.vel.y

        if BALL.vel.x < 0 then
            local instance = pongSFX:play()
        else
            local instance = pingSFX:play()
        end
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
    if s == "db" then
        POWERUP.double.x = SCREENWIDTH / 2
        POWERUP.double.y = love.math.random(10, SCREENHEIGHT - 50)
    end
end

local function checkPowerUpHitbox() 
    
    local yH = POWERUP.speedUp.y + POWERUP.speedUp.img:getHeight()
    local bx = BALL.x + BALL.width
    local by = BALL.y + BALL.height
   
    if POWERUP.speedUp.isOnMap then
        
        local bulletCol = checkCollision(BULLET.x, BULLET.y, BULLET.width, BULLET.height, POWERUP.speedUp.x, POWERUP.speedUp.y, POWERUP.speedUp.img:getWidth(), POWERUP.speedUp.img:getHeight())
        local enemyBulletCol = checkCollision(ENEMYBULLET.x, ENEMYBULLET.y, ENEMYBULLET.width, ENEMYBULLET.height, POWERUP.speedUp.x, POWERUP.speedUp.y, POWERUP.speedUp.img:getWidth(), POWERUP.speedUp.img:getHeight())
        local ballCol = checkCollision(BALL.x, BALL.y, BALL.width, BALL.height, POWERUP.speedUp.x, POWERUP.speedUp.y, POWERUP.speedUp.img:getWidth(), POWERUP.speedUp.img:getHeight())
        
        if bulletCol then
            print("bulletCol")
            POWERUP.speedUp.pickUp("bu")    
            POWERUP.speedUp.action()
            POWERUP.speedUp.timer = love.timer.getTime()
        end


        if enemyBulletCol then
            POWERUP.speedUp.pickUp("en")  
            POWERUP.enemySpeedUp.action()
            POWERUP.speedUp.timer = love.timer.getTime()
        end


        if ballCol then
            POWERUP.speedUp.pickUp("ba")  
            POWERUP.ballSpeedUp.action() 
            POWERUP.speedUp.timer = love.timer.getTime()
        end
 

    end

    if POWERUP.speedDown.isOnMap then

        local bulletCol = checkCollision(BULLET.x, BULLET.y, BULLET.width, BULLET.height, POWERUP.speedDown.x, POWERUP.speedDown.y, POWERUP.speedDown.img:getWidth(), POWERUP.speedDown.img:getHeight())
        local enemyBulletCol = checkCollision(ENEMYBULLET.x, ENEMYBULLET.y, ENEMYBULLET.width, ENEMYBULLET.height, POWERUP.speedDown.x, POWERUP.speedDown.y, POWERUP.speedDown.img:getWidth(), POWERUP.speedDown.img:getHeight())
        local ballCol = checkCollision(BALL.x, BALL.y, BALL.width, BALL.height, POWERUP.speedDown.x, POWERUP.speedDown.y, POWERUP.speedDown.img:getWidth(), POWERUP.speedDown.img:getHeight())


        if bulletCol then
            POWERUP.speedDown.pickUp("bu")  
            POWERUP.speedDown.action()
            POWERUP.speedDown.timer = love.timer.getTime()
        end 

        if enemyBulletCol then
            POWERUP.speedDown.pickUp("en")  
            POWERUP.enemySpeedDown.action()
            ENEMYBULLET.x = SCREENWIDTH
            isEnemyShooting = false
            POWERUP.speedDown.timer = love.timer.getTime()
        end

           
        if ballCol then 
            POWERUP.speedDown.pickUp("ba")  
            POWERUP.ballSpeedDown.action() 
            POWERUP.speedDown.timer = love.timer.getTime()
        end

        
    end

    if POWERUP.double.isOnMap then

        local bulletCol = checkCollision(BULLET.x, BULLET.y, BULLET.width, BULLET.height, POWERUP.double.x, POWERUP.double.y, POWERUP.double.img:getWidth(), POWERUP.double.img:getHeight())
        local enemyBulletCol = checkCollision(ENEMYBULLET.x, ENEMYBULLET.y, ENEMYBULLET.width, ENEMYBULLET.height, POWERUP.double.x, POWERUP.double.y, POWERUP.double.img:getWidth(), POWERUP.double.img:getHeight())
        local ballCol = checkCollision(BALL.x, BALL.y, BALL.width, BALL.height, POWERUP.double.x, POWERUP.double.y, POWERUP.double.img:getWidth(), POWERUP.double.img:getHeight())
        
        if bulletCol and PLAYER.doubleShoot ~= true then
            POWERUP.double.pickUp("bu")
            POWERUP.double.action("bu")
            POWERUP.double.timer = love.timer.getTime()
        elseif bulletCol then
            POWERUP.double.pickUp("bu")
            POWERUP.double.timer = love.timer.getTime()
        end

        if enemyBulletCol and ENEMY.doubleShoot ~= true then
            POWERUP.double.pickUp("en")
            POWERUP.double.action("en")
            POWERUP.double.timer = love.timer.getTime()
        elseif enemyBulletCol then
            POWERUP.double.pickUp("en")
            POWERUP.double.timer = love.timer.getTime()
        end

        if ballCol and BALL.doubleball ~= true then
            POWERUP.double.pickUp("ba")  
            POWERUP.double.action("ba") 
            POWERUP.double.timer = love.timer.getTime()
        elseif ballCol then
            POWERUP.double.pickUp("ba")  
            POWERUP.double.timer = love.timer.getTime()
        end

    end

end

local function restart(b)

    PLAYER.x = 0
    PLAYER.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    ENEMY.x = SCREENWIDTH - PLAYER.imgWidth
    ENEMY.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    BALL.x = SCREENWIDTH / 2
    BALL.y = SCREENHEIGHT / 2
    BULLET.x = 0
    BULLET.y = 0
    ENEMYBULLET.x = 0
    ENEMYBULLET.y = 0
    PLAYER.vel = 3
    ENEMY.vel = 3
    BALL.vel.x = 4
    PLAYER.doubleShoot = false
    ENEMY.doubleShoot = false
    BALL.doubleball = false
    isShooting = false
    isEnemyShooting = false

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

local function updateShoot()
    if isShooting  then
        
        BULLET.x = BULLET.x + BULLET.vel

        if BULLET.x > SCREENWIDTH then
            isShooting = false
        end

    end
   
    if PLAYER.doubleShoot then

        if isShooting  then
            BULLET.x = BULLET.x + BULLET.vel * 2
                
            if BULLET.x > SCREENWIDTH then
                isShooting = false
            end

        end

    end

    if isEnemyShooting then
    
        ENEMYBULLET.x = ENEMYBULLET.x - ENEMYBULLET.vel

        if ENEMYBULLET.x < 0 then
        
        isEnemyShooting = false
        ENEMYBULLET.x = SCREENWIDTH
        end
    
    end

    if ENEMY.doubleShoot then
        
        if isEnemyShooting  then
            
            ENEMYBULLET.x = ENEMYBULLET.x - ENEMYBULLET.vel * 2
                
            if ENEMYBULLET.x < 0 then
                isEnemyShooting = false
            end

        end

    end
end

function love.load()



    isStarting = true
    isShooting = false
    isEnemyShooting = false

    love.window.setMode(SCREENWIDTH, SCREENHEIGHT)
    love.window.setTitle("Pong csak lehet loni")
    COLORS = {

        bg = {43 / 255, 15 / 255, 84 / 255}

    }

    love.graphics.setBackgroundColor(COLORS.bg)

    bannerImage = love.graphics.newImage("banner.png")
    gameOverImage = love.graphics.newImage("gameover.png")
    pressSpaceImage = love.graphics.newImage("pressspace.png")
    pressSpaceRestartImage = love.graphics.newImage("pressspacerestart.png")
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
    PLAYER.doubleShoot = false

    ENEMY = {}
    ENEMY.img = love.graphics.newImage("enemy.png")
    ENEMY.x = SCREENWIDTH - PLAYER.imgWidth
    ENEMY.y = SCREENHEIGHT / 2 - PLAYER.imgHeight / 2
    ENEMY.vel = 3
    ENEMY.HP = 10
    ENEMY.doubleShoot = false

    BALL = {}
    BALL.img = love.graphics.newImage("ball.png")
    BALL.x = SCREENWIDTH / 2
    BALL.y = SCREENHEIGHT / 2
    BALL.vel = {}
    BALL.vel.x = 3
    BALL.vel.y = 1
    BALL.height = BALL.img:getHeight()
    BALL.width = BALL.img:getWidth()
    BALL.doubleball = false

    BALL2 = {}
    BALL2.img = love.graphics.newImage("ball.png")
    BALL2.x = SCREENWIDTH / 2
    BALL2.y = SCREENHEIGHT / 2
    BALL2.vel = {}
    BALL2.vel.x = 3
    BALL2.vel.y = 1
    BALL2.height = BALL.img:getHeight()
    BALL2.width = BALL.img:getWidth()
    

   

    BULLET = {}
    BULLET.img = love.graphics.newImage("bullet.png")
    BULLET.x = 0
    BULLET.y = PLAYER.y + PLAYER.imgHeight / 2
    BULLET.vel = 10
    BULLET.width = BULLET.img:getWidth()
    BULLET.height = BULLET.img:getHeight()


    ENEMYBULLET = {}
    ENEMYBULLET.img = love.graphics.newImage("bullet.png")
    ENEMYBULLET.x = SCREENWIDTH
    ENEMYBULLET.y = ENEMY.y + PLAYER.imgHeight / 2
    ENEMYBULLET.vel = 9
    ENEMYBULLET.width = ENEMYBULLET.img:getWidth()
    ENEMYBULLET.height = ENEMYBULLET.img:getHeight()


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

        if BALL.doubleball then
            BALL2.x = BALL2.x + BALL2.vel.x
            BALL2.y = BALL2.y + BALL2.vel.y
        end
    
        updateShoot()


        --wall bouonce - Y irányú eltírites

        if BALL.doubleball then
            if BALL2.y < 0 + BALL2.height then
        
                bounce(1, -1, true)
            end
    
            if BALL2.y >= SCREENHEIGHT - BALL2.height then
    
                bounce(1, -1, true)
            end
        end

        if BALL.y < 0 + BALL.height then  
            bounce(1, -1)
        end

        if BALL.y >= SCREENHEIGHT - BALL.height then
            bounce(1, -1)
        end

        -- AI
        if BALL.doubleball then
            
            if BALL.x < SCREENWIDTH / 2 and BALL2.x > SCREENWIDTH / 2 then
                if BALL2.y < ENEMY.y + PLAYER.imgHeight / 2  then
                    ENEMY.y = ENEMY.y - ENEMY.vel
                elseif BALL2.y > ENEMY.y + PLAYER.imgHeight / 2 then
                    ENEMY.y = ENEMY.y + ENEMY.vel
                end 
            elseif BALL2.x < SCREENWIDTH / 2 and BALL.x > SCREENWIDTH / 2 then
                if BALL.y < ENEMY.y + PLAYER.imgHeight / 2  then
                    ENEMY.y = ENEMY.y - ENEMY.vel
                elseif BALL.y > ENEMY.y + PLAYER.imgHeight / 2 then
                    ENEMY.y = ENEMY.y + ENEMY.vel
                end
            else
                if BALL.y < ENEMY.y + PLAYER.imgHeight / 2  then
                    ENEMY.y = ENEMY.y - ENEMY.vel
                elseif BALL.y > ENEMY.y + PLAYER.imgHeight / 2 then
                    ENEMY.y = ENEMY.y + ENEMY.vel
                end
            end
        end

        if BALL.doubleball ~= true then

            if BALL.y < ENEMY.y + PLAYER.imgHeight / 2  then
                ENEMY.y = ENEMY.y - ENEMY.vel
            elseif BALL.y > ENEMY.y + PLAYER.imgHeight / 2 then
                ENEMY.y = ENEMY.y + ENEMY.vel
            end
        end




        --paddle bounce - X irány
        if BALL.doubleball then
            local paddle2Col = checkCollision(BALL2.x, BALL2.y, BALL2.width, BALL2.height, PLAYER.x, PLAYER.y, PLAYER.imgWidth, PLAYER.imgHeight)
            local enemyPaddle2Col = checkCollision(BALL2.x, BALL2.y, BALL2.width, BALL2.height, ENEMY.x, ENEMY.y, PLAYER.imgWidth, PLAYER.imgHeight)
            if paddle2Col then
                bounce(-1,1, true)
                BALL2.x = BALL2.x + BALL2.width / 2
            end
    
            if enemyPaddle2Col then
                bounce(-1,1, true)
                BALL2.x = BALL2.x - BALL2.width / 2
            end

        end


        local paddleCol = checkCollision(BALL.x, BALL.y, BALL.width, BALL.height, PLAYER.x, PLAYER.y, PLAYER.imgWidth, PLAYER.imgHeight)
        local enemyPaddleCol = checkCollision(BALL.x, BALL.y, BALL.width, BALL.height, ENEMY.x, ENEMY.y, PLAYER.imgWidth, PLAYER.imgHeight)

        if paddleCol then
            bounce(-1,1)
            BALL.x = BALL.x + BALL.width / 2
        end

        if enemyPaddleCol then
            bounce(-1,1)
            BALL.x = BALL.x - BALL.width / 2
        end

        --goal

        if BALL.doubleball then
            if BALL2.x > SCREENWIDTH - 5 then
               
                local instance = goalSFX:play()
                ENEMY.HP = ENEMY.HP - 2
                restart(true)
            elseif BALL2.x < 0 then
                local instance = goalSFX:play()
                PLAYER.lives = PLAYER.lives - 1
                restart(true)
            end
        end

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


        if POWERUP.speedUp.isOnMap ~= true and love.timer.getTime() - POWERUP.speedUp.timer > POWERUP.speedUp.dur then
            POWERUP.speedUp.isOnMap = true
            
        end

        if POWERUP.speedDown.isOnMap ~= true and love.timer.getTime() - POWERUP.speedDown.timer > POWERUP.speedDown.dur then
            POWERUP.speedDown.isOnMap = true
        end

       
        if POWERUP.double.isOnMap ~= true and love.timer.getTime() - POWERUP.double.timer > POWERUP.double.dur then
         
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

    love.graphics.draw(bannerImage, 0, 0) 
   -- love.graphics.print("PONG BUT YOU CAN SHOOT", SCREENHEIGHT / 2, 0)

    love.graphics.draw(PLAYER.img, PLAYER.x, PLAYER.y )
  
    love.graphics.draw(BALL.img, BALL.x, BALL.y)

    love.graphics.draw(ENEMY.img, ENEMY.x, ENEMY.y)
 
   
    for i = 1, ENEMY.HP do
        love.graphics.draw(hpImage, ((SCREENWIDTH - SCREENWIDTH / 4) - 16) + i * 16, 1)
    end
    for i = 1, PLAYER.lives do 
        love.graphics.draw(hpImage, 16*i, 1)
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


    if isShooting then
        
        love.graphics.draw(BULLET.img, BULLET.x + 5, BULLET.y + 5)
    end

    if isEnemyShooting then
        love.graphics.draw(ENEMYBULLET.img, ENEMYBULLET.x, ENEMYBULLET.y, math.pi)
    end

    if POWERUP.speedDown.isOnMap then
        love.graphics.draw(POWERUP.speedDown.img, POWERUP.speedDown.x, POWERUP.speedDown.y)
    end

    if POWERUP.speedUp.isOnMap then
        love.graphics.draw(POWERUP.speedUp.img, POWERUP.speedUp.x, POWERUP.speedUp.y)
    end
  --  
    if POWERUP.double.isOnMap then
        love.graphics.draw(POWERUP.double.img, POWERUP.double.x, POWERUP.double.y)
    end

    if BALL.doubleball then
        love.graphics.draw(BALL2.img, BALL2.x, BALL2.y)
    end

    
    if isGameOver then
        love.graphics.draw(gameOverImage, SCREENWIDTH / 2 - gameOverImage:getWidth() / 2, SCREENHEIGHT / 2 - gameOverImage:getHeight())
        love.graphics.draw(pressSpaceRestartImage, SCREENWIDTH / 2 - pressSpaceImage:getWidth() / 2, SCREENHEIGHT / 2)
    end

    if isStarting and PLAYER.lives > 0 then
        love.graphics.draw(pressSpaceImage, SCREENWIDTH / 2 - pressSpaceImage:getWidth() / 2, SCREENHEIGHT / 2 - (pressSpaceImage:getHeight()))
    end

end