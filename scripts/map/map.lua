local map = {}

local sti = require("lib.sti")

local collision = require("scripts.collision.collision")

package.path = "./scripts/tools/tools.lua"
local tools = require("scripts.tools.tools")

map.loaded = false
map.active = false

--local parede = {}

function map.load()
    DebugMap = sti("maps/dungeon.lua")

    if DebugMap.layers["paredes"] then
        for i, obj in pairs(DebugMap.layers["paredes"].objects) do
            collision.create(obj.x+obj.width/2+1, obj.y+obj.height/2, obj.height, obj.width, 0, 0, 255, "parede", math.random(), false, collision.collisions.paredes)
        end
    end

    map.loaded = true
end

function map.unload()
    sti:flush()
    map.loaded = false
end

function map.collision_bullets()
    for i in pairs(collision.collisions.paredes) do
        local col = collision.collisions.paredes[i]
        collision.check(col.xbox, col.ybox, col.wbox, col.hbox, collision.collisions.bullets)
    end
end

function map.drawmap()
    DebugMap:draw()
    --love.graphics.print("Colisões paredes: "..tools.tablelength(collision.collisions.paredes), 500, 65)
    map.active = true
end


return map