local flow, super = Class(Sprite, "tractor_beam")

function flow:init(x, y)
    super.init(self, "bullets/flow_bg", x, y)

    
 --   super.init(self, x, y)
    self.alpha = 0.8
    self.mesh_length = 500
    self.mesh_width = 3

    self.mesh = love.graphics.newMesh({
                                          { 0,    0,   0, 0, 0.8, 0, 0.8, 1 },
                                          { 0.5,  1.0, 0, 0, 0.8, 0, 0.8, 0 },
                                          { -0.5, 1.0, 0, 0, 0.8, 0, 0.8, 0 },
                                      }, "fan", "dynamic"
    )

end

function flow:update()
    super.update(self)
end

function flow:draw()
   -- love.graphics.setBlendMode("add")
    love.graphics.draw(self.mesh)
        super.draw(self)

    --love.graphics.setBlendMode("alpha")
   -- love.graphics.setStencilTest()
end

return flow
