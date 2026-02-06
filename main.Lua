local gameState = "menu"

function love.load()
    arenaWidth = 800
    arenaHeight = 600
    love.graphics.setDefaultFilter("nearest", "nearest")

    success = love.window.setMode(600, 500)

    Background = love.graphics.newImage("Assets/Space5.png")
    Menu = love.graphics.newImage("Assets/Menu.png")
    GameOverScreen = love.graphics.newImage("Assets/LOSER.png")

    Sounds = {}
    Sounds.Bounce = love.audio.newSource("Sounds/Explosion6.wav", "static")
    Sounds.Collect = love.audio.newSource("Sounds/Collect3.wav", "static")
    Sounds.Menu = love.audio.newSource("Sounds/MenuV2.wav", "stream")
    Sounds.GameOver = love.audio.newSource("Sounds/LostV2.wav", "stream")
    Sounds.inGame = love.audio.newSource("Sounds/inGame.wav", "stream")
    Sounds.Bounce:setVolume(0.5)
    Sounds.Collect:setVolume(0.3)
    Sounds.inGame:setVolume(0.2)
    
    --Sammy
    Sammy = {}
    Sammy.x, Sammy.y = love.mouse.getPosition()
    Sammy.Sprites = love.graphics.newImage("Assets/Sammy.png")

    --Alien1
    Alien1 = {}
    Alien1.x = 0
    Alien1.y = 0
    Alien1.Radius = 20
    Alien1.angle = love.math.random() * (2 * math.pi)
    Alien1.Sprites = love.graphics.newImage("Assets/Alien1.png")

    --Alien2
    Alien2 = {}
    Alien2.x = 0
    Alien2.y = 500
    Alien2.Radius = 15
    Alien2.angle = love.math.random() * (2 * math.pi)
    Alien2.Sprites = love.graphics.newImage("Assets/Alien2.png")

    --Alien3
    Alien3 = {}
    Alien3.x = 600
    Alien3.y = 500
    Alien3.Radius = 40
    Alien3.angle = love.math.random() * (2 * math.pi)
    Alien3.Sprites = love.graphics.newImage("Assets/Alien3.png")

    --DeadSam
    DeadSam = {}
    DeadSam.x = Sammy.x
    DeadSam.y = Sammy.y
    DeadSam.Radius = 20
    DeadSam.angle = love.math.random() * (2 * math.pi)
    DeadSam.Sprites = love.graphics.newImage("Assets/DeadSam.png")


    --Coin
    Coin = {}
    Coin.x = math.random(0, 600)
    Coin.y = math.random(0, 500)
    Coin.Radius = 15
    Coin.Sprites = love.graphics.newImage("Assets/Coin.png")

    --score
    scoreFont = love.graphics.newFont(40)
    score = 0

    gameOverFont = love.graphics.newFont(25)

    love.mouse.setVisible(false)
end

function love.update(dt)
if gameState == "menu" then
    Sounds.Menu:play()
    if love.keyboard.isDown("space") then
        gameState = "playing"
    end
end

    if gameState == "playing" then
    Sounds.Menu:stop()
    Sounds.GameOver:stop()
    Sounds.inGame:play()
    Sammy.x, Sammy.y = love.mouse.getPosition()
    DeadSam.x = Sammy.x
    DeadSam.y = Sammy.y

    SammyToCoin = distanceBetween(Sammy.x, Sammy.y, Coin.x, Coin.y) * 0.5
    if SammyToCoin < Coin.Radius then
        score = score + 1
        Sounds.Collect:play()
        Coin.x = math.random(0, 600)
        Coin.y = math.random(0, 500)
    end
end

if gameState == "playing" or gameState == "gameOver" then
     --Alien1
    local Alien1Speed = 220
    Alien1.x = (Alien1.x + math.cos(Alien1.angle) * Alien1Speed * dt)
    Alien1.y = (Alien1.y + math.sin(Alien1.angle) * Alien1Speed * dt)

    --Alien2
    local Alien2Speed = 380
    Alien2.x = (Alien2.x + math.cos(Alien2.angle) * Alien2Speed * dt)
    Alien2.y = (Alien2.y + math.sin(Alien2.angle) * Alien2Speed * dt)

    --Alien3
    local Alien3Speed = 150
    Alien3.x = (Alien3.x + math.cos(Alien3.angle) * Alien3Speed * dt)
    Alien3.y = (Alien3.y + math.sin(Alien3.angle) * Alien3Speed * dt)

    CheckWallsHit(Alien1)
    CheckWallsHit(Alien2)
    CheckWallsHit(Alien3)

    SammyHitAlien(Alien1, Alien1.x, Alien1.y)
    SammyHitAlien(Alien2, Alien2.x, Alien2.y)
    SammyHitAlien(Alien3, Alien3.x, Alien3.y)
end

if gameState == "gameOver" then
    Sounds.inGame:stop()
    Sounds.GameOver:play()
    local DeadSamSpeed = 220
    DeadSam.x = (DeadSam.x + math.cos(DeadSam.angle) * DeadSamSpeed * dt)
    DeadSam.y = (DeadSam.y + math.sin(DeadSam.angle) * DeadSamSpeed * dt)

    CheckWallsHit(DeadSam)
    if love.keyboard.isDown("space") then
        gameState = "playing"
        resetGame()
    end
end
end

function love.draw()
    love.window.setTitle("Alien Of The Unknown")

    --Background
    love.graphics.setBackgroundColor(0,0,0.1)
    if gameState == "menu" then
        love.graphics.draw(Menu, 0, 0)
    end

    if gameState == "playing" or gameState == "gameOver" then
        love.graphics.draw(Background, 0, 0)
    end

    if gameState == "playing" then
    --Coin
    love.graphics.setColor(1,1,0)
    love.graphics.draw(Coin.Sprites, Coin.x, Coin.y,0,1,1,15,15)

    --Sammy
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Sammy.Sprites, Sammy.x, Sammy.y,0,1,1,20,20)
    end

    if gameState == "playing" or gameState == "gameOver" then
    --Alien1
    love.graphics.setColor(0,1,0)
    love.graphics.draw(Alien1.Sprites, Alien1.x, Alien1.y,0,1,1,20,20)

    --Alien2
    love.graphics.setColor(0,0,1)
    love.graphics.draw(Alien2.Sprites, Alien2.x, Alien2.y,0,1,1,15,15)

    --Alien3
    love.graphics.setColor(1,0,0)
    love.graphics.draw(Alien3.Sprites, Alien3.x, Alien3.y,0,1.35,1.35,30,30)

    --score
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(scoreFont)
    love.graphics.print(score, 285, 0)
    
    end

    if gameState == "gameOver" then
        --DeadSam
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.draw(DeadSam.Sprites, DeadSam.x, DeadSam.y,0,1,1,20,20)

        --GameOverScreen
        love.graphics.setColor(1,1,1)
        love.graphics.draw(GameOverScreen, 0, 0, 0, 0.6, 0.6, -45, -330)
    end

     --Debug Stuff
    love.graphics.setColor(1,1,1)
    --love.graphics.print("Mouse Coordinates: " .. Sammy.x .. ", " .. Sammy.y, 10, 10)lll
   -- love.graphics.print("Alien1 Coordinates: " .. Alien1.x .. ", " .. Alien1.y, 10, 40)
   --love.graphics.print("SammyToCoin: " .. SammyToCoin .. ", Coin.Radius " .. Coin.Radius, 10, 400)
   --love.graphics.print("DeadoSam x: ".. DeadSam.x .. ", DeadoSam y: ".. DeadSam.y)
end

function CheckWallsHit(Alien)
         if Alien.x < 0 then
             Alien.x = 0
             Sounds.Bounce:play()
             Alien.angle = love.math.random() * (2 * math.pi)
         end

        if Alien.x > 600 then
             Alien.x = 600
             Sounds.Bounce:play()
             Alien.angle = love.math.random() * (2 * math.pi)
         end

        if Alien.y < 0 then
             Alien.y = 0
             Sounds.Bounce:play()
             Alien.angle = love.math.random() * (2 * math.pi)
         end

        if Alien.y > 500 then
             Alien.y = 500
             Sounds.Bounce:play()
             Alien.angle = love.math.random() * (2 * math.pi)
         end
end

function distanceBetween(x1, y1, x2, y2)
   return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
end

function SammyHitAlien(Alien ,Alien_X, Alien_Y)
       local SammyToAlien = distanceBetween(Sammy.x, Sammy.y, Alien_X, Alien_Y)
    if SammyToAlien < Alien.Radius then
        gameState = "gameOver"
    end
end

function resetGame()
score = 0

    Alien1.x = 0
    Alien1.y = 0

    Alien2.x = 0
    Alien2.y = 500

    Alien3.x = 600
    Alien3.y = 500
end