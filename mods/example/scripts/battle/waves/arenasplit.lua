--WARNING: HORRIBLE CODE
local ArenaSplit, super = Class(Wave)

function ArenaSplit:init()
    super.init(self)
    self.padding = 20
    self.lines = {}
    self.ran = false
end

function ArenaSplit:onStart()
    self.ran = true
    self.time = 12
    self.orig_middle_x = Game.battle.arena.x
    self.orig_middle_y = Game.battle.arena.y
    self.orig_width = Game.battle.arena.width
    self.orig_height = Game.battle.arena.height
    Game.battle.arena.sprite.visible = false
    self.arena_sprite = ArenaSpriteSplit(Game.battle.arena, 0, 0, self.padding)
    -- self.arena_sprite.padding = self.padding
    -- Game.battle.arena.sprite = self.arena_sprite
    Game.battle.arena:addChild(self.arena_sprite)
    local width, height = self:getWidth(), self:getHeight()
    -- self:getVertices() = {{0, 0}, {width, 0}, {width, height}, {0, height}}
    self.collider_1 = PolygonCollider(self, self:getVertices(true))
    self.collider_2 = PolygonCollider(self, self:getVertices(true))
    self.collider_1_orig_points = self:getVertices(true)
    self.collider_2_orig_points = self:getVertices(true)
    -- self.collider_1 = CircleCollider(self, 0, 0, 25)
    -- self:addChild(self.collider_1)
    -- Kristal.Console:log('time: ' .. self.timer

    -- Kristal.Console:log('orig_middle = ' .. self.orig_middle_x)

    self.split_x = 0
    self.split_y = 0
    self.split_angle_start = 0
    self.split_angle_dest = 0
    self.new_split_angle_dest = 0
    self.split_angle = 0
    self.split_timer = 0
    self.splitting = false
    self.split_direction = ''
    self.new_split_direction = '' -- Updated earlier than split_direction

    self.arena_split_timer = 0

    self.arena_init_width = Game.battle.arena.width
    self.arena_init_height = Game.battle.arena.height

    self.splittable_directions = {'horizontal', 'vertical', 'diagonal1', 'diagonal2'}
    -- self.splittable_directions = {'diagonal1'}

    self.segment_1_offset = {0, 0}
    self.segment_2_offset = {0, 0}

    -- Kristal.Console:log(self.split_x)

    local function newSplit()
        if self:getRemainingTime() > 2 then
            self.new_split_direction = Utils.pick(self.splittable_directions)
            self.split_angle_dest = math.rad(Utils.random(-10, 10))
            if self.new_split_direction == 'vertical' then
                self.split_angle_dest = self.split_angle_dest + math.rad(90)
            elseif self.new_split_direction == 'diagonal1' then
                self.split_angle_dest = self.split_angle_dest + math.rad(45)
            elseif self.new_split_direction == 'diagonal2' then
                self.split_angle_dest = self.split_angle_dest + math.rad(135)
            end

            self.split_x = self.orig_middle_x + Utils.random(0, 20)
            self.split_y = self.orig_middle_y + Utils.random(0, 20)
            self.split_timer = 0
            -- self.split_angle_dest = math.rad(45)
            self.split_angle_start = self.split_angle_dest + math.rad(Utils.pick({-20, 20}))
            self.split_angle = self.split_angle_start
            self.splitting = true
        end
    end

    newSplit()

    self.timer:every(1.5, newSplit)

    self.last_change = {0, 0}
end

function ArenaSplit:getVertices(packed)
    local width, height = self:getWidth(), self:getHeight()
    local value_to_return = {0, 0, width, 0, width, height, 0, height}
    value_to_return = Utils.map(value_to_return, function(value, index)
        if index % 2 ~= 0 then return value + self.orig_middle_x - width / 2
        else return value + self.orig_middle_y - height / 2 end
    end)
    if packed then value_to_return = Utils.group(value_to_return, 2) end

    return value_to_return

end

function ArenaSplit:getRemainingTime()
    return self.time - Game.battle.wave_timer
end

function ArenaSplit:getArenaTopLeft()
    local origin_exact_x, origin_exact_y = Game.battle.arena:getOriginExact()
    return Game.battle.arena.x - origin_exact_x, Game.battle.arena.y - origin_exact_y
end


function ArenaSplit:updatePolygonPoints()
    local width, height = self.orig_width, self.orig_height
    self.collider_1.points = Utils.copy(self.collider_1_orig_points, true)
    local x, y = self:getArenaTopLeft()
    local origin_exact_x, origin_exact_y = Game.battle.arena:getOriginExact()
    local x_change, y_change = width / 2 - origin_exact_x, height / 2 - origin_exact_y
    self.last_change = {x_change, y_change}
    for index, point in ipairs(self.collider_1_orig_points) do
        -- Kristal.Console:log('abc = ' .. Utils.dump(self.collider_1_orig_points[index]))
        -- self.collider_1.points[index][1] = x + self.collider_1_orig_points[index][1] - self.padding + self.segment_1_offset[1]
        -- self.collider_1.points[index][2] = y + self.collider_1_orig_points[index][2] - self.padding + self.segment_1_offset[2]
        self.collider_1.points[index][1] = self.collider_1_orig_points[index][1] + self.segment_1_offset[1] + x_change
        self.collider_1.points[index][2] = self.collider_1_orig_points[index][2] + self.segment_1_offset[2] + y_change
    end

    self.collider_2.points = Utils.copy(self.collider_2_orig_points, true)
    for index, point in ipairs(self.collider_2_orig_points) do
        -- Kristal.Console:log('abc = ' .. Utils.dump(self.collider_1_orig_points[index]))
        self.collider_2.points[index][1] = self.collider_2_orig_points[index][1] + self.segment_2_offset[1]+ x_change
        self.collider_2.points[index][2] = self.collider_2_orig_points[index][2] + self.segment_2_offset[2]+ y_change
    end
end

function ArenaSplit:getWidth()
    return Game.battle.arena.width + self.padding * 2
end

function ArenaSplit:getHeight()
    return Game.battle.arena.height + self.padding * 2
end

function ArenaSplit:getSplitPoints()
    local x_diff, y_diff = self.split_x, self.split_y
Kristal.Console:log('abc = ' .. Utils.dump({self.split_x, self.split_y}))
    local half_length = 600
    
    local start_x, start_y = x_diff + math.cos(self.split_angle_dest) * half_length, y_diff + math.sin(self.split_angle_dest) * half_length
    local end_x, end_y = x_diff - math.cos(self.split_angle_dest) * half_length, y_diff - math.sin(self.split_angle_dest) * half_length

    local width, height = self:getWidth(), self:getHeight()

    -- start_x = start_x + Game.battle.arena.width / 2
    -- start_y = start_y + Game.battle.arena.height / 2
    -- end_x = end_x + Game.battle.arena.width / 2
    -- end_y = end_y + Game.battle.arena.height / 2

    -- start_x = start_x + width / 2
    -- start_y = start_y + height / 2
    -- end_x = end_x + width / 2
    -- end_y = end_y + height / 2

    start_x = math.floor(start_x)
    start_y = math.floor(start_y)
    end_x = math.floor(end_x)
    end_y = math.floor(end_y)

    -- start_x = Utils.round(start_x)
    -- start_y = Utils.round(start_y)
    -- end_x = Utils.round(end_x)
    -- end_y = Utils.round(end_y)

    -- self.collider_1_last_pos = {}
    -- self.collider_2_last_pos = {}

    return start_x, start_y, end_x, end_y
end

function ArenaSplit:getPointsOfLine(index)
    local width, height = self:getWidth(), self:getHeight()
    local vertices = self:getVertices()
    -- Kristal.Console:log('vertices = ' .. Utils.dump(vertices))
    local index_second = index % (#vertices / 2) + 1
    return vertices[2 * index - 1], vertices[2 * index], vertices[2 * index_second - 1], vertices[2 * index_second]
end

function ArenaSplit:getPolygonPoints(start_x, start_y, end_x, end_y)
    local intersects = {}

    for i = 1, 4 do
        local start_x_2, start_y_2, end_x_2, end_y_2 = self:getPointsOfLine(i)
        -- Kristal.Console:log('wae = ' .. Utils.dump({start_x, start_y, end_x, end_y}))
        -- Kristal.Console:log('wae = ' .. Utils.dump({start_x_2, start_y_2, end_x_2, end_y_2}))
        table.insert(self.lines, {start_x_2, start_y_2, end_x_2, end_y_2})
        table.insert(intersects, {Utils.getLineIntersect(start_x, start_y, end_x, end_y, start_x_2, start_y_2, end_x_2, end_y_2, false, true)})
    end

    local booleans = {true, true, true, true} -- True = Original points, False = Intersections
    local points = self:getVertices(true)
    -- Kristal.Console:log('intersects = ' .. Utils.dump(intersects))
    -- Kristal.Console:log('vertices = ' .. Utils.dump(self:getVertices()))
    -- Kristal.Console:log('points = ' .. Utils.dump(points))
    -- Kristal.Console:log(Utils.dump(intersects))
    local intersects_dupe_check = {}
    for i = 4, 1, -1 do
        -- Kristal.Console:log(Utils.dump(intersects[i]))
        if intersects[i][1] ~= false then
            local point = {intersects[i][1], intersects[i][2]}
            local function containsValue(table, value_to_check)
                for _, value in ipairs(table) do
                    if value[1] == value_to_check[1] and value[2] == value_to_check[2] then
                        -- Kristal.Console:log('true: ' .. Utils.dump(value) .. Utils.dump(value_to_check))
                        return true
                    end
                end
                return false
            end
            if not containsValue(intersects_dupe_check, point) then
                table.insert(points, i + 1, point)
            -- table.insert(points, 2 * i + 1, intersects[i][1])
                table.insert(booleans, i + 1, false)
                table.insert(intersects_dupe_check, point)
            end
        end
    end
    -- Kristal.Console:log('points = ' .. Utils.dump(points))

    local check = false
    local polygon_1_points = {}
    local polygon_2_points = {}
    local points_until_first_intersect = 0
    local intersected = false
    for index = 1, #points do
        local boolean_index = index --math.ceil(index / 2)
        if booleans[boolean_index] == false then
            check = not check
            table.insert(polygon_1_points, points[boolean_index])
            table.insert(polygon_2_points, points[boolean_index])
            -- table.insert(polygon_1_points, points[index + 1])
            -- table.insert(polygon_2_points, points[index])
            -- table.insert(polygon_2_points, points[index + 1])
            intersected = true
        elseif booleans[boolean_index] == true then
            if check == false then
                table.insert(polygon_1_points, points[boolean_index])
                -- table.insert(polygon_1_points, points[index])
                -- table.insert(polygon_1_points, points[index + 1])
            else
                table.insert(polygon_2_points, points[boolean_index])
                -- table.insert(polygon_2_points, points[index])
                -- table.insert(polygon_2_points, points[index + 1])
            end
            if check == false and not intersected then points_until_first_intersect = points_until_first_intersect + 1 end
        end
    end
    -- Kristal.Console:log('boolean = ' .. Utils.dump(booleans))
    -- Kristal.Console:log('poly1 = ' .. Utils.dump(polygon_1_points))
    polygon_1_points = self:unpack(Utils.removeDuplicates(polygon_1_points))
    polygon_2_points = self:unpack(Utils.removeDuplicates(polygon_2_points))

    local width, height = self:getWidth(), self:getHeight()

    -- polygon_1_points = Utils.map(polygon_1_points, function(value, index)
    --     if index % 2 ~= 0 then return value -(- width / 2 + self.orig_middle_x)
    --     else return value -(- height / 2 + self.orig_middle_y) end
    -- end)

    -- polygon_2_points = Utils.map(polygon_2_points, function(value, index)
    --     if index % 2 ~= 0 then return value -(- width / 2 + self.orig_middle_x)
    --     else return value -(- height / 2 + self.orig_middle_y) end
    -- end)
    for i = 1, #polygon_1_points - 2, 2 do
        table.insert(self.lines, {polygon_1_points[i], polygon_1_points[i+1], polygon_1_points[i+2], polygon_1_points[i+3], 4})
    end

    return polygon_1_points, polygon_2_points, points_until_first_intersect
end

function ArenaSplit:unpack(tbl)
    local to_return = {}
    for _, value in ipairs(tbl) do
        -- Kristal.Console:log(type(value))
        if type(value) == 'table' then
            for _, subvalue in ipairs(self:unpack(value)) do
                table.insert(to_return, subvalue)
            end
        else
            table.insert(to_return, value)
        end
    end
    return to_return
end

function ArenaSplit:spawnBulletCircle()
    local speed = {4, 8}
    local last_bullet_speed = {}
    for i = 0, 360, 15 do
        local x = self.orig_middle_x
        local y = self.orig_middle_y

        local choice = Utils.pick({1, 2})
        local length = #last_bullet_speed
        if length >= 2 and last_bullet_speed[length - 1] == last_bullet_speed[length] then choice = 3 - last_bullet_speed[length] end
        table.insert(last_bullet_speed, choice)
        local bullet = self:spawnBullet("smallbullet", x, y, math.rad(i), speed[choice] + Utils.random(-1, 1))
    end
end

function ArenaSplit:spawnBulletVertical()
    local speed = {4, 8}
    local last_bullet_speed = {}
    local x = self.orig_middle_x
    local y = self.orig_middle_y
    local line_length = 200 -- total height of the line
    local num_bullets = 9
    for i = 0, num_bullets - 1 do
        local offset = (i - (num_bullets - 1) / 2) * (line_length / (num_bullets - 1))
        local bullet_y = y + offset
        local choice = Utils.pick({1, 2})
        local length = #last_bullet_speed
        if length >= 2 and last_bullet_speed[length - 1] == last_bullet_speed[length] then
            choice = 3 - last_bullet_speed[length]
        end
        table.insert(last_bullet_speed, choice)
        -- Spawn bullet going right
        self:spawnBullet("smallbullet", x, bullet_y, 0, speed[choice] + Utils.random(-1, 1))
        -- Spawn bullet going left (mirrored)
        self:spawnBullet("smallbullet", x, bullet_y, math.pi, speed[choice] + Utils.random(-1, 1))
    end
end

function ArenaSplit:spawnBulletHorizontal()
    local speed = {4, 8}
    local last_bullet_speed = {}
    local x = self.orig_middle_x
    local y = self.orig_middle_y
    local line_length = 200 -- total width of the line
    local num_bullets = 9
    for i = 0, num_bullets - 1 do
        local offset = (i - (num_bullets - 1) / 2) * (line_length / (num_bullets - 1))
        local bullet_x = x + offset
        local choice = Utils.pick({1, 2})
        local length = #last_bullet_speed
        if length >= 2 and last_bullet_speed[length - 1] == last_bullet_speed[length] then
            choice = 3 - last_bullet_speed[length]
        end
        table.insert(last_bullet_speed, choice)
        -- Spawn bullet going up
        self:spawnBullet("smallbullet", bullet_x, y, -math.pi/2, speed[choice] + Utils.random(-1, 1))
        -- Spawn bullet going down (mirrored)
        self:spawnBullet("smallbullet", bullet_x, y, math.pi/2, speed[choice] + Utils.random(-1, 1))
    end
end


function ArenaSplit:update()
    if not self.ran then return end

    self.split_angle = Ease.outQuart(self.split_timer, self.split_angle_start, self.split_angle_dest - self.split_angle_start, 30)

    local width, height = self:getWidth(), self:getHeight()
    self.split_timer = math.min(self.split_timer + DTMULT, 30)
    if self.split_timer == 30 and self.splitting == true then
        self.lines = {}
        self.splitting = false
        self.arena_sprite.splitting = true
        self.split_direction = self.new_split_direction
        local start_x, start_y, end_x, end_y = self:getSplitPoints()
        table.insert(self.lines, {start_x, start_y, end_x, end_y})
        self.arena_sprite:updateSplitPoints(start_x+ width / 2 - self.orig_middle_x, start_y+ height / 2 - self.orig_middle_y, end_x+ width / 2 - self.orig_middle_x, end_y+ height / 2 - self.orig_middle_y)
        local points_1, points_2, amount = self:getPolygonPoints(start_x, start_y, end_x, end_y)
        local reverse_order = amount >= 2 and self.split_direction == 'diagonal1'
        -- local collider_1_points = Utils.map(points_1, function(value, index)
        --     if index % 2 ~= 0 then return value -(- width / 2 + self.orig_middle_x)
        --     else return value -(- height / 2 + self.orig_middle_y) end
        -- end)
        -- local collider_2_points = Utils.map(points_2, function(value, index)
        --     if index % 2 ~= 0 then return value -(- width / 2 + self.orig_middle_x)
        --     else return value -(- height / 2 + self.orig_middle_y) end
        -- end)
        if reverse_order then
            self.collider_1_orig_points = Utils.group(points_1, 2)
            self.collider_2_orig_points = Utils.group(points_2, 2)
        else
            self.collider_1_orig_points = Utils.group(points_2, 2)
            self.collider_2_orig_points = Utils.group(points_1, 2)
        end

       -- Kristal.Console:log(Utils.dump({width,height,self.orig_middle_x,self.orig_middle_y}))
      --  Kristal.Console:log(Utils.dump(points_1))
      --  Kristal.Console:log(Utils.dump({width,height}))

        local canvas_points = Utils.map(points_1, function(value, index)
            if index % 2 ~= 0 then return value -(- width / 2 + self.orig_middle_x)
            else return value -(- height / 2 + self.orig_middle_y) end
            
        end)
     --   Kristal.Console:log(Utils.dump(canvas_points))

        self.arena_sprite:split(canvas_points, reverse_order)
        -- self.arena_sprite:split(math.floor(start_x), math.floor(start_y), math.floor(end_x), math.floor(end_y), self.split_direction)
    if self.split_direction == 'horizontal' then
        Assets.playSound("rudebuster_hit")
        self:spawnBulletHorizontal()
    elseif self.split_direction == 'vertical' then
        Assets.playSound("rudebuster_hit")
        self:spawnBulletVertical()
    elseif self.split_direction == 'diagonal1' then
        Assets.playSound("rudebuster_hit")
        self:spawnBulletCircle()
    elseif self.split_direction == 'diagonal2' then
        Assets.playSound("rudebuster_hit")
        self:spawnBulletCircle()
    end
end

    if self.arena_sprite.splitting then
        self.arena_split_timer = math.min(self.arena_split_timer + DTMULT, 30)
        local last_segment_1_offset = Utils.copy(self.segment_1_offset, true)
        local last_segment_2_offset = Utils.copy(self.segment_2_offset, true)
        local last_change = Utils.copy(self.last_change, true)

        local wiggle = math.sin(self.arena_split_timer) / 2
        if self.split_direction == 'horizontal' then
            -- Kristal.Console:log(math.sin(math.rad(self.arena_split_timer * 6)) * 40)
            -- self.segment_1_offset = {0, -math.sin(math.rad(self.arena_split_timer * 6)) * 70}
            self.segment_2_offset = {0, 0}
            self.segment_1_offset = {0, 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70}
            Game.battle.arena:setSize(self.arena_init_width, self.arena_init_height + 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70)
            -- Game.battle.arena.y = Game.battle.arena.init_x - math.sin(math.rad(self.arena_split_timer * 6)) * 70
            -- Game.battle.arena.height = self.arena_init_width + 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70
        elseif self.split_direction == 'vertical' then
            self.segment_2_offset = {0, 0}
            self.segment_1_offset = {2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70, 0}
            Game.battle.arena:setSize(self.arena_init_width + 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70, self.arena_init_height)
        elseif self.split_direction == 'diagonal1' then
            local offset = 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70 / math.sqrt(2)
            self.segment_2_offset = {0, offset}
            self.segment_1_offset = {offset, 0}
            Game.battle.arena:setSize(self.arena_init_width + offset, self.arena_init_height + offset)
        elseif self.split_direction == 'diagonal2' then
            local offset = 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70 / math.sqrt(2)
            self.segment_2_offset = {0, 0}
            self.segment_1_offset = {offset, offset}
            Game.battle.arena:setSize(self.arena_init_width + offset, self.arena_init_height + offset)
        end

        self:updatePolygonPoints()

        local pos_change = {last_change[1] - self.last_change[1], last_change[2] - self.last_change[2]}
        local segment_1_change = {self.segment_1_offset[1] - last_segment_1_offset[1] - pos_change[1], self.segment_1_offset[2] - last_segment_1_offset[2] - pos_change[2]}
        local segment_2_change = {self.segment_2_offset[1] - last_segment_2_offset[1] - pos_change[1], self.segment_2_offset[2] - last_segment_2_offset[2] - pos_change[2]}

        local inside_collider_1 = self.collider_1:collidesWith(Game.battle.soul.collider)
        local inside_collider_2 = self.collider_2:collidesWith(Game.battle.soul.collider)
        -- Kristal.Console:log('Inside 1 = ' .. tostring(inside_collider_1))
        -- Kristal.Console:log('Inside 2 = ' .. tostring(inside_collider_2))
        if inside_collider_1 and not inside_collider_2 then
            Game.battle.soul.x = Game.battle.soul.x + segment_1_change[1]
            Game.battle.soul.y = Game.battle.soul.y + segment_1_change[2]
        elseif inside_collider_2 and not inside_collider_1 then
            Game.battle.soul.x = Game.battle.soul.x + segment_2_change[1]
            Game.battle.soul.y = Game.battle.soul.y + segment_2_change[2]
        end

        if self.split_direction == 'horizontal' then
            -- Kristal.Console:log(math.sin(math.rad(self.arena_split_timer * 6)) * 40)
            -- self.segment_1_offset = {wiggle, -math.sin(math.rad(self.arena_split_timer * 6)) * 70}
            self.segment_2_offset = {wiggle, 0}
            self.segment_1_offset = {-wiggle, 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70}
            Game.battle.arena:setSize(self.arena_init_width, self.arena_init_height + 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70)
            -- Game.battle.arena.y = Game.battle.arena.init_x - math.sin(math.rad(self.arena_split_timer * 6)) * 70
            -- Game.battle.arena.height = self.arena_init_width + 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70
        elseif self.split_direction == 'vertical' then
            self.segment_2_offset = {0, wiggle}
            self.segment_1_offset = {2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70, -wiggle}
            Game.battle.arena:setSize(self.arena_init_width + 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70, self.arena_init_height)
        elseif self.split_direction == 'diagonal1' then
            local offset = 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70 / math.sqrt(2)
            self.segment_2_offset = {-wiggle, offset + wiggle}
            self.segment_1_offset = {offset - wiggle, wiggle}
            Game.battle.arena:setSize(self.arena_init_width + offset, self.arena_init_height + offset)
        elseif self.split_direction == 'diagonal2' then
            local offset = 2 * math.sin(math.rad(self.arena_split_timer * 6)) * 70 / math.sqrt(2)
            self.segment_2_offset = {-wiggle, wiggle}
            self.segment_1_offset = {offset - wiggle, offset + wiggle}
            Game.battle.arena:setSize(self.arena_init_width + offset, self.arena_init_height + offset)
        end

        self.arena_sprite.canvas_2_offset = self.segment_2_offset
        self.arena_sprite.canvas_1_offset = self.segment_1_offset
       

        if self.arena_split_timer == 30 then
            self.arena_sprite.splitting = false
            self.arena_split_timer = 0
            self.arena_sprite:merge(self.split_direction)
            if self:getRemainingTime() < 2 then
                Game.battle.wave_timer = self.time -- Instantly ends the turn
            end
        end
    end

    super.update(self)
end

function ArenaSplit:draw()
    -- if not self.ran then return end`self:getHeight()
    -- love.graphics.rectangle("fill", -width/2, -height/2, width, height)
    -- if self.collider_1 then self.collider_1:draw(1, 1, 1, 0.5) end
    -- if self.collider_2 then self.collider_2:draw(1, 1, 1, 0.5) end
    if self.splitting then
        local width = Ease.outQuart(self.split_timer, 60, -60, 30)
        love.graphics.setLineWidth(width)
        -- Draw.setColor(0, 1, 0, 1)
        -- love.graphics.rectangle("fill", self.orig_middle_x - 1, self.orig_middle_y - 1, 2, 2)
        Draw.setColor(1, 0, 0, 0.5)
        local half_length = math.min(4800 / width, 2400) / 2
        local start_x, start_y = self.split_x + math.cos(self.split_angle) * half_length, self.split_y + math.sin(self.split_angle) * half_length
        local end_x, end_y = self.split_x - math.cos(self.split_angle) * half_length, self.split_y - math.sin(self.split_angle) * half_length
        love.graphics.line(start_x, start_y, end_x, end_y)
    end
    -- love.graphics.points(0, 0)

    -- for _, line in ipairs(self.lines) do
    --     if line[5] then love.graphics.setLineWidth(line[5])
    --     else love.graphics.setLineWidth(2) end
    --     love.graphics.line(line[1], line[2], line[3], line[4])
    -- end
end

return ArenaSplit