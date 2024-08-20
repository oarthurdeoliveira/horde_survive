-- Variaveis globais usam maisculo no começo

-- Player Packages
local player = require "scripts.player.player"
local inventario = require("scripts.player.inventario")
local teclado = require("scripts.player.teclado")
local mouse = require("scripts.player.mouse")

local tools      = require("scripts.tools.tools")

-- Enemy Packages

local dummy = require "scripts.enemy.dummy"

local gunner = require "scripts.enemy.gunner"

local ondas = require("scripts.map.ondas")


-- Map and Objects

local map = require("scripts.map.map")

local menu = require("scripts.menu.menu")

-- Guns Packages
local guns = require("scripts.guns.guns")


local pistol = require("scripts.guns.pistol")

local submachinegun = require("scripts.guns.submachinegun")

-- Collision

local collision = require("scripts.collision.collision")


local global = require("scripts.global")



function love.update(dt)
  mouse.update()
  if menu.main_menu == true then
      menu.update()
      map.active = false
      player.status.spawn = false
      ondas.reset()
      map.unload()
      guns.unload()
      gunner.unload()
      player.reset()
  end

  if map.loaded == false and menu.main_menu == false then
      map.load()
  end

  if map.active == true then
      map.collision_bullets()

      if player.status.morto == true then
        menu.pause('player', ondas.score.ondas_sobrevividas, ondas.score.inimigos_mortos)
      else
        menu.pause('esc', 0, 0)
      end
      
      teclado.update()
      if player.status.spawn == false then
          player.spawn(500, 500)
      end

      if menu.pausado == false then

        if tools.tablelength(collision.collisions.gunners) > 0 then
          gunner.update(dt)
        end
        
        gunner.spawn_update()
        guns.bulletupdate(dt)
        player.update(dt)
        ondas.update(dt)

        if player.status.spawn == true and player.status.morto == false then
          if inventario.guns.pistol.equipado == true then
            pistol.update(dt)
          elseif inventario.guns.submachinegun.equipado == true then
            submachinegun.update(dt)
          end
        end
      end
  end

end


function love.draw()
    
  if menu.main_menu == true then
      menu.draw()
  end

  if map.loaded == true and menu.main_menu == false then
      map.drawmap()
  end


  if map.active == true then
      player.draw()

      if menu.pausado == true then
        menu.draw()
      end

      if tools.tablelength(collision.collisions.gunners) > 0 then
        gunner.draw()
      end

      gunner.spanw_draw()
      
      if player.status.spawn == true and player.status.morto == false then
        if inventario.guns.pistol.equipado == true then
          pistol.draw()
        elseif inventario.guns.submachinegun.equipado == true then
          submachinegun.draw()
        end
      end
      
      ondas.draw()
      guns.bulletdraw()
  end

  if global.debug == true then
    collision.draw()
  end

end