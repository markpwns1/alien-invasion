local class = require "middleclass"

Enemy = class("Enemy")
StrafingEnemy = class("StrafingEnemy", Enemy)

Projectile = class("Projectile")

ShakeEffect = class("ShakeEffect")

Player = { }

UI = { }

ParticleEffect = class("ParticleEffect")
BackgroundStar = class("BackgroundStar")

retroEngine = { }

GameState = class("GameState")
PlayingState = class("PlayingState", GameState)
MainMenuState = class("MainMenuState", GameState)
GameOverState = class("GameOverState", GameState)

AudioManager = { }