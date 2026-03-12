local spell, super = Class(Spell, "spiritrelease")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Spirit Release"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Raise\nTP"
 
    -- Menu description
    self.description = "Store energy to create energy.\nRaises TP by 32%."

    -- TP cost
    self.cost = 32

    self.tp_amount = 64

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"tp"}
end

function spell:onCast(user)
  --  self.times_used = self.times_used + 1
    self.tension_given = Game:giveTension(self.tp_amount)
    local sound = Assets.newSound("cardrive")
    sound:setPitch(1.4)
    sound:setVolume(0.8)
    sound:play()
    user:sparkle(1,0.625,0.25)
end
return spell