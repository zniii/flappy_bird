push = require'push'

Class = require 'class'

require 'StateMachine'

require '/states/BaseState'
require '/states/CountdownState'
require '/states/PlayState'
require '/states/ScoreState'
require '/states/TitleScreenState'

require 'Pipe'
require 'Bird'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('/images/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('/images/ground.png')
local groundScroll = 0

--speed of the scroll of the images
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 30

--point in which the background will loop
local BACKGROUND_LOOPING_POINT = 413

--global variable to scroll the map
scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --seed the RNG
    math.randomseed(os.time())

    love.window.setTitle('Flappy Bird')

    smallFont = love.graphics.newFont('/font/font.ttf', 8)
    mediumFont = love.graphics.newFont('/font/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('/font/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('/font/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

     -- kick off music
     sounds['music']:setLooping(true)
     sounds['music']:play()
 

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        vsync =  true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    --initializing input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    --adding keypressed table in the frame
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end