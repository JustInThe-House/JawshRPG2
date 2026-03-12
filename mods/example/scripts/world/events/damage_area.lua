local DamageArea, super = Class(Event, "damagearea")

function DamageArea:init(data)
    super.init(self, data)
    self.timer_damage = 0
    self.damage = data.properties["damage"] or 10
	self.timer_speed = data.properties["timerspeed"] or 1
end

function DamageArea:onCollide(chara)
    self.timer_damage = self.timer_damage + DT
    if self.timer_damage > self.timer_speed then
        self.timer_damage = 0
        Game.world:hurtParty(self.damage)
    end
end

return DamageArea
