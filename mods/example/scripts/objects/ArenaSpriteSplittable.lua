local ArenaSpriteSplittable, super = Class(ArenaSprite, "ArenaSpriteSplittable")
local super_obj = Class(Object)

function ArenaSpriteSplittable:init(arena, x, y, padding)
    super.init(self, arena, x, y)
    self.padding = padding
    self:setOriginExact(self.width / 2, self.height / 2)
    self.x = self.x + self.width / 2
    self.y = self.y + self.height / 2

    self.canvas = love.graphics.newCanvas(self.width + self.padding * 2, self.height + self.padding * 2)
    self.canvas_1 = love.graphics.newCanvas(self.width + self.padding * 2, self.height + self.padding * 2)
    self.canvas_2 = love.graphics.newCanvas(self.width + self.padding * 2, self.height + self.padding * 2)
    -- i think these are the graphics that allow the splits. Note that it is only created in initiailization: this means any direct changes to it are permanent! (i think)

    --[[local width = self.width + self.padding * 2
    local height = self.height + self.padding * 2]]

    self.og_arena_center_x, self.og_arena_center_y = Game.battle.arena:getCenter()
    self.og_arena_topleft_x, self.og_arena_topleft_y = Game.battle.arena:getTopLeft()
    self.og_arena_topright_x, self.og_arena_topright_y = Game.battle.arena:getTopRight()
    self.og_arena_botleft_x, self.og_arena_botleft_y = Game.battle.arena:getBottomLeft()
    self.og_arena_botright_x, self.og_arena_botright_y = Game.battle.arena:getBottomRight()

    --[[self.vertices2 = {
        { 0,     0 },
        { width, 0 },
        { width, height },
        { 0,     height }
    }]]

    self.vertices = {
        { self.og_arena_topleft_x-self.padding,  self.og_arena_topleft_y-self.padding },
        { self.og_arena_topright_x+self.padding, self.og_arena_topright_y-self.padding },
        { self.og_arena_botright_x+self.padding, self.og_arena_botright_y+self.padding },
        { self.og_arena_botleft_x-self.padding,  self.og_arena_botleft_y+self.padding }
    }
        -- padding must be added so the arena border draw lines are included in the cut
    --Kristal.Console:log(Utils.dump(self.vertices))

    self.slash_half_1 = {}
    self.slash_half_2 = {}

    self.drawn = false
    self.canvas_1_offset = { 0, 0 }
    self.canvas_2_offset = { 0, 0 }

    self.splitting = false
    self.end_x = 0
    self.end_y = 0

    self.splitting = false

    self.start_x = 0
    self.start_y = 0
    self.end_x = 0
    self.end_y = 0

end

function ArenaSpriteSplittable:updateSplitPoints(start_x, start_y, end_x, end_y)
    self.start_x = start_x
    self.start_y = start_y
    self.end_x = end_x
    self.end_y = end_y
end

function ArenaSpriteSplittable:setSplitDirection(direction, split_point_1, split_point_2, width, height, angle)
    self.slash_half_1 = {}
    self.slash_half_2 = {}
    self.line_points = {}
      self.line_points_unpacked = {}
    self.slash_half_sorted_unpacked = {}
    local dx, dy = split_point_2[1] - split_point_1[1], split_point_2[2] - split_point_1[2]
    for _, point in ipairs(self.vertices) do
        local px, py = point[1] - split_point_1[1], point[2] - split_point_1[2]
        local cross = dx * py - dy * px
        local side = (cross > 0)
        if dx ~= 0 then
            if dy / dx < 0 then
                side = not side
            end
        end
       -- Kristal.Console:log(Utils.dump(point))
        if side then
            table.insert(self.slash_half_1, point)
        else
            table.insert(self.slash_half_2, point)
        end
        -- cross product magic
    end
    table.insert(self.slash_half_1, split_point_1)
    table.insert(self.slash_half_1, split_point_2)
    table.insert(self.line_points, split_point_1)
    table.insert(self.line_points, split_point_2)

    local point_avg_x, point_avg_y = 0, 0
    local point_dotproduct = {}
    for _, vertex in ipairs(self.slash_half_1) do
        point_avg_x = point_avg_x + vertex[1]
        point_avg_y = point_avg_y + vertex[2]
    end
    point_avg_x = point_avg_x / #self.slash_half_1
    point_avg_y = point_avg_y / #self.slash_half_1

    table.sort(self.slash_half_1,
        function (a, b) return Utils.angle(a[1], a[2], point_avg_x, point_avg_y) >
            Utils.angle(b[1], b[2], point_avg_x, point_avg_y) end)
    -- there is some way to use the dot product for this, but for some reason i wouldnt get a convex polygon. i think its how the coordinate system is set up. for now use angles.
    --    table.sort(self.slash_half_1, function(a,b) return a[1] * point_avg_x - a[2] * point_avg_y > b[1] * point_avg_x - b[2] * point_avg_y end)

   -- Kristal.Console:log(Utils.dump(self.slash_half_1))

    -- then unpack
    for _, vertex in ipairs(self.slash_half_1) do
        table.insert(self.slash_half_sorted_unpacked, vertex[1])
        table.insert(self.slash_half_sorted_unpacked, vertex[2])
    end
        for _, vertex in ipairs(self.line_points) do
        table.insert(self.line_points_unpacked, vertex[1])
        table.insert(self.line_points_unpacked, vertex[2])
    end
    
    self.slash_half_sorted_unpacked = Utils.map(self.slash_half_sorted_unpacked, function (value, index)
        if index % 2 ~= 0 then
            return value - (-width / 2 + self.og_arena_center_x)
        else
            return value - (-height / 2 + self.og_arena_center_y)
        end
    end)

        self.line_points_unpacked = Utils.map(self.line_points_unpacked, function (value, index)
        if index % 2 ~= 0 then
            return value - (-width / 2 + self.og_arena_center_x)
        else
            return value - (-height / 2 + self.og_arena_center_y)
        end
    end)

    Kristal.Console:log(Utils.dump(self.line_points_unpacked))
end

function ArenaSpriteSplittable:split(reverse_canvas_order)
    if reverse_canvas_order then
        Draw.pushCanvas(self.canvas_1)
    else
        Draw.pushCanvas(self.canvas_2)
    end
    love.graphics.clear()
    love.graphics.stencil(function ()
                              love.graphics.polygon("fill", self.slash_half_sorted_unpacked)
                          end, "replace", 1)
    love.graphics.setStencilTest("equal", 1)
    love.graphics.draw(self.canvas)
    Draw.popCanvas()

    if reverse_canvas_order then
        Draw.pushCanvas(self.canvas_2)
    else
        Draw.pushCanvas(self.canvas_1)
    end
    love.graphics.clear()
    love.graphics.stencil(function ()
                              love.graphics.polygon("fill", self.slash_half_sorted_unpacked)
                          end, "replace", 1)
    love.graphics.setStencilTest("equal", 0)
    love.graphics.draw(self.canvas)
    Draw.popCanvas()
    love.graphics.setStencilTest()
end

function ArenaSpriteSplittable:merge(direction)
    Draw.pushCanvas(self.canvas)
    love.graphics.clear()
    local x_offset_1, x_offset_2, y_offset_1, y_offset_2 = 0, 0, 0, 0
    local range = 2
    if Utils.containsValue({ 'horizontal_slash', 'forward_slash', 'back_slash' }, direction) then  
         x_offset_1 = Utils.random(-range, range) -- these offsets are what move the final placement of the area line after
           x_offset_2 = Utils.random(-range, range)
    end
    if Utils.containsValue({ 'vertical_slash', 'forward_slash', 'back_slash' }, direction) then
          y_offset_1 = Utils.random(-range, range)
         y_offset_2 = Utils.random(-range, range)
    end
    love.graphics.draw(self.canvas_1, x_offset_1, y_offset_1) -- this is what draws the box, i think
    love.graphics.draw(self.canvas_2, x_offset_2, y_offset_2)

    Draw.setColor(0, 0.25, 0)
    local shader = Kristal.Shaders["Mask"]
    love.graphics.setShader(shader)
    love.graphics.stencil(function ()
                              love.graphics.draw(self.canvas_1, x_offset_1, y_offset_1) -- this is what erases the original background
                              love.graphics.draw(self.canvas_2, x_offset_1, y_offset_2)
                          end, "replace", 1)
    love.graphics.setShader(last_shader)
    love.graphics.setStencilTest("equal", 1)
    love.graphics.setLineWidth(1)
    love.graphics.line(self.line_points_unpacked) -- this creates the green line
    love.graphics.setStencilTest()
    Draw.popCanvas()
end

function ArenaSpriteSplittable:drawBackground()
    for _, triangle in ipairs(self.arena.triangles) do
        local function offsetValue(value)
            return value + self.padding
        end
        love.graphics.polygon("fill", Utils.unpack(Utils.map(triangle, offsetValue)))
    end
end

function ArenaSpriteSplittable:drawDefaultArena()
    Draw.pushCanvas(self.canvas)
    if self.background then
        Draw.setColor(self.arena:getBackgroundColor())
        self:drawBackground() -- this draws the arena
    end

    local r, g, b, a = self:getDrawColor()
    local arena_r, arena_g, arena_b, arena_a = self.arena:getDrawColor()

    Draw.setColor(r * arena_r, g * arena_g, b * arena_b, a * arena_a)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(self.arena.line_width)

    local function offsetValue(value)
        return value + self.padding
    end

    love.graphics.line(Utils.unpack(Utils.map(self.arena.border_line, offsetValue)))
    Draw.popCanvas()
end

function ArenaSpriteSplittable:draw()
    super_obj.draw(self)


    if not self.drawn then
        self:drawDefaultArena()
        self.drawn = true
    end

    if self.splitting then
        Draw.draw(self.canvas_1, -self.padding + self.canvas_1_offset[1], -self.padding + self.canvas_1_offset[2])
        Draw.draw(self.canvas_2, -self.padding + self.canvas_2_offset[1], -self.padding + self.canvas_2_offset[2])
        --love.graphics.polygon("fill",self.slash_half_sorted_unpacked)
        --[[local function offsetValue(value)
            return value + self.padding
        end
        love.graphics.polygon("fill", Utils.unpack(Utils.map(self.slash_half_sorted_unpacked, offsetValue)))]]
    else
        Draw.draw(self.canvas, -self.padding, -self.padding)
    end
end

return ArenaSpriteSplittable
