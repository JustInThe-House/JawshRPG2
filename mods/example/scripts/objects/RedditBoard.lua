local RedditBoard, super = Class(Object)

function RedditBoard:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.timer_create_post = 0
end

function RedditBoard:update()
    self.timer_create_post = self.timer_create_post + DT
    if self.timer_create_post >= 5 then
        self.timer_create_post = 0
        RedditPost()
    end
    super.update(self)
end

return RedditBoard
