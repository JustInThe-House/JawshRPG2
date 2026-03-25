local RedditPost, super = Class(Object, "RedditPost")

-- remove offscreen
-- spawn and move in one direction
--image of reddit
-- make it a partially random size. will need to make sure all sizes of og images work

function RedditPost:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) -- change w and h to sprite size
    self.physics.speed = MathUtils.random(6,10)
    if math.random(0,1) == 0 then
        self.physics.direction = 0
        self.x = 0 --add offset
    else
        self.physics.direction = math.pi
        self.x = SCREEN_WIDTH--add offset
    end
    self.y = MathUtils.random(0+20, SCREEN_HEIGHT - 20)
    self.timer_life = 0
end

function RedditPost:update()
    self.timer_life = self.timer_life + DT
    super.update(self)
end

return RedditPost
