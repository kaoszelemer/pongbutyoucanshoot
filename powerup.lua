POWERUP = {

 

    speedUp = {

        pickUp = function (who)
                     
            if who == "bu" then
                BULLET.x = 0
                isShooting = false
            elseif who == "en" then
                ENEMYBULLET.x = SCREENWIDTH
                isEnemyShooting = false
            elseif who == "ba" then    
            
            end
            POWERUP.speedUp.isOnMap = false
        end,

        img = love.graphics.newImage("speedup.png"),
        x = love.math.random(50, SCREENWIDTH - 50),
        y = love.math.random(50, SCREENHEIGHT - 50),
        dur = 5,
        timer = love.timer.getTime(),
        isOnMap = false,

        action = function ()
            if PLAYER.vel <= 6 then
                PLAYER.vel = PLAYER.vel + POWERUP.speedUp.modifier
            end
            resetPowerUp("su")
        end

    },

    speedDown = {

        pickUp = function (who)
            if who == "bu" then
                BULLET.x = 0
                isShooting = false
            elseif who == "en" then
                ENEMYBULLET.x = SCREENWIDTH
                isEnemyShooting = false
            elseif who == "ba" then    
            
            end
           
            POWERUP.speedDown.isOnMap = false
           
        end,

        img = love.graphics.newImage("speeddown.png"),
        x = love.math.random(50, SCREENWIDTH - 50),
        y = love.math.random(50, SCREENHEIGHT - 50),
        dur = 5,
        timer = love.timer.getTime(),
        isOnMap = false,

        action  = function ()
            if PLAYER.vel > 2 then
                PLAYER.vel = PLAYER.vel + POWERUP.speedDown.modifier
            end
            resetPowerUp("sd")
        end

    },

    ballSpeedUp = {

        action = function ()
            if BALL.vel.x > 0 and BALL.vel.x <= 8 then
                BALL.vel.x = BALL.vel.x + POWERUP.speedUp.modifier
            elseif BALL.vel.x < 0 and BALL.vel.x >= -8 then
                BALL.vel.x = BALL.vel.x - POWERUP.speedUp.modifier
            end
            resetPowerUp("su")
            
        end
    },

    ballSpeedDown = {

        action = function ()
            if BALL.vel.x > 0 then
                BALL.vel.x = BALL.vel.x + POWERUP.speedDown.modifier
                if BALL.vel.x == 0 then
                    BALL.vel.x = 1
                end
            elseif BALL.vel.x < 0 then
                BALL.vel.x = BALL.vel.x - POWERUP.speedDown.modifier
                if BALL.vel.x == 0 then
                    BALL.vel.x = 1
                end
            end
            resetPowerUp("sd")
        end

    },

    enemySpeedUp = {
        action = function ()
            if ENEMY.vel <= 6 then
                ENEMY.vel = ENEMY.vel + POWERUP.speedUp.modifier
            end
            resetPowerUp("su")
        end
    },

    enemySpeedDown = {
        action = function ()
            if ENEMY.vel > 2 then
                ENEMY.vel = ENEMY.vel + POWERUP.speedDown.modifier
            end
            resetPowerUp("sd")
            
        end
    },

    playSFX = {
        action = function ()
            local instance = powerupSFX:play()
        end
    },

    double = {

        img = love.graphics.newImage('double.png'),
        x = love.math.random(50, SCREENWIDTH - 50),
        y = love.math.random(50, SCREENHEIGHT - 50),
        dur = 5,
        timer = love.timer.getTime(),
        isOnMap = false,

        action = function(who)
            
            if who == "pl" then
                PLAYER.doubleShoot = true
            elseif who == "en" then
                ENEMY.doubleShoot = true
            elseif who == "ball" then
                BALL.doubleball = true
            end
            
            
        end
    }
}


return POWERUP