---@class ChaserEnemy : Object
---@field hidden         boolean    *[Property `hidden`]* should the enemy be hidden?
---@field sound         string    *[Property `sound`]* sound to play on encounter. defaults to Deltarune horn
---@field particles     string     *[Property `particles`]* object particle/animation to play on encounter

local ChaserEnemy, super = HookSystem.hookScript(ChaserEnemy)

function ChaserEnemy:init(actor, x, y, properties)
    super.init(self, actor, x, y, properties)
    if properties["hidden"] then
        self.visible = false
    end
    if properties["sound"] then
        self.sound = properties["sound"]
    end
    if properties["particles"] then
        self.particles = properties["particles"]
    end
end

function ChaserEnemy:onCollide(player)
    if self:isActive() and player:includes(Player) then
        self.encountered = true
        if not self.visible then
            self.visible = true
        end
        local encounter = self.encounter ---@type string|Encounter
        if not encounter and Registry.getEnemy(self.enemy or self.actor.id) then
            encounter = Encounter()
            encounter:addEnemy(self.actor.id)
        end
        if encounter then
            self.world.encountering_enemy = true
            self.sprite:setAnimation("hurt")
            self.sprite.aura = false
            Game.lock_movement = true
            self.world.timer:script(function(wait)
                --[[if self.particles ~= nil then
                    local particles = Sprite("particles/minecraft_explosion/explosion",self.x,self.y)
                    particles:play(1 / 45, false, function()
                        particles:remove()
                    end)
                    Game.stage:addChild(particles)
                end]] -- for if i ever get particles to work right

                if self.sound == nil then
                    Assets.playSound("tensionhorn")
                    wait(8 / 30)
                    local src = Assets.playSound("tensionhorn")
                    src:setPitch(1.1)
                    wait(12 / 30)
                else
                    Assets.playSound(self.sound)
                    wait(20 / 30)
                end

                self.world.encountering_enemy = false
                Game.lock_movement = false
                local enemy_target = self ---@type ChaserEnemy|table[]
                if self.enemy then
                    enemy_target = { { self.enemy, self } }
                end
                Game:encounter(encounter, true, enemy_target, self)
            end)
        end
    end
end

return ChaserEnemy
