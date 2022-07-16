POWERUP = {
    speedUp = {

        img = love.graphics.newImage("speedup.png"),

        action = function ()
            if PLAYER.vel <= 5 then
                PLAYER.vel = PLAYER.vel + POWERUP.speedUp.modifier
            end
            resetPowerUp("su")
        end

    },

    speedDown = {
        img = love.graphics.newImage("speeddown.png"),

        action  = function ()
            if PLAYER.vel > 1 then
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
            if ENEMY.vel <= 4 then
                ENEMY.vel = ENEMY.vel + POWERUP.speedUp.modifier
            end
            resetPowerUp("su")
        end
    },

    enemySpeedDown = {
        action = function ()
            if ENEMY.vel > 1 then
                ENEMY.vel = ENEMY.vel + POWERUP.speedDown.modifier
            end
            resetPowerUp("sd")
            
        end
    },

    playSFX = {
        action = function ()
            local instance = powerupSFX:play()
        end
    }
}








return POWERUP