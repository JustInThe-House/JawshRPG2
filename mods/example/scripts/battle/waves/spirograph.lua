local starshot, super = Class(Wave)

function starshot:init()
    super.init(self)
        self.time = 10
        self.siner = 0
        self.linesteps = 50
        self.linetable = {}
        self.pen = 2
        self.n= 1
        self.fixed_radius = 175

        self.r1 = 100
        self.r2 = 40
        self.a1 = 0
        self.a2 = 0
        self.a1Inc = 5
        self.a2Inc = 1
        self.dtime = 0
        self.tablemax = 100



        self.centerx = SCREEN_WIDTH/2
        self.centery = SCREEN_HEIGHT/3
        self.circlecount = 16
        self.circleradiusout = 40
        self.circleradius = 140
        self.circleshape = 0
        self.spirograph_alpha = 0
        self.timer:tween(2, self, {spirograph_alpha = 0.4})
end

function starshot:update()
    self.siner = self.siner + DT
    self.dtime = self.dtime + DT

    --[[for i = 1,self.linesteps do
        --local t = self.n*i
        local x1 = 300 + self.r1 * math.cos(self.a1)
        local y1 = 200+  self.r1 * math.sin(self.a1)
        local x2 = x1 + self.r2 * math.cos(self.a2)
        local y2 = y1 + self.r2 * math.sin(self.a2) -- set to cos for ellipse
        --table.insert(self.linetable, x1)
        --table.insert(self.linetable, y1)
table.insert(self.linetable, x2)
        table.insert(self.linetable, y2)
        if #self.linetable > self.tablemax then
            table.remove(self.linetable,1)
                        table.remove(self.linetable,1)

        end
        
        self.a1 = self.a1 + self.a1Inc*DTMULT*10/self.tablemax
        self.a2 = self.a2 + self.a2Inc*DTMULT*10/self.tablemax

       self.a1 = self.a1 + DT*math.random(1,5)
        self.a2 = self.a2 + DT*math.random(1,5)
        -- this makes a cool effect that kinda looks like an attack effect

       -- table.insert(self.linetable,200+(self.fixed_radius-self.siner)*math.cos(t)+self.pen*math.cos(t*(self.fixed_radius-self.siner)/self.siner))
       -- table.insert(self.linetable,200+(self.fixed_radius-self.siner)*math.sin(t)+self.pen*math.sin(t*(self.fixed_radius-self.siner)/self.siner))
    end]]

    self.circleradius = self.circleradius - DT*2
    self.circleshape = self.circleshape + DT

    super.update(self)
end

function starshot:draw()
love.graphics.setLineWidth(2)
love.graphics.setColor(1,1,1,self.spirograph_alpha)
    --[[if self.dtime > 1 then
        love.graphics.line(self.linetable)
    end]]

    if self.dtime > 0 then
        for i = 1,self.circlecount do
            local angle = self.siner + i*2*math.pi/self.circlecount
            love.graphics.circle("line", self.centerx+self.circleradiusout*math.cos(angle),self.centery+self.circleradiusout*math.sin(angle),self.circleradius)
            -- love.graphics.circle("line", self.centerx+self.circleradiusout*math.cos(angle),self.centery+self.circleradiusout*math.sin(angle),self.circleradius,2) THIS LOOKS SO COOL

        end
    end


    super.draw(self)
end



return starshot
