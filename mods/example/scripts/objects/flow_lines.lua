local flow_lines, super = Class(Sprite, "flow_lines")

function flow_lines:init(x, y)
    super.init(self, "bullets/flow_lines", x, y)
    self.wrap_texture_x = true
    self.wrap_texture_y = true

self.start_x = 450
self.start_y = 170
self.move = 0
    self.mesh_length = 5
    self.mesh_width = 3
    self.mesh = love.graphics.newMesh({
                                          { 0,  0,    0, 0, 1, 1, 1, 1 },
                                          { -1, 0.5,  0, 0, 1, 1, 1, 0 },
                                          { -1, -0.5, 0, 0, 1, 1, 1, 0 },
                                      }, "fan", "dynamic")
end
--love.graphics.setColor(self.phase_color)
function flow_lines:update()
    self.move = self.move + 65 * DTMULT
    self.x = self.x - 65 * DTMULT
    super.update(self)
end

function flow_lines:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.stencil(function ()
                              love.graphics.setShader(Kristal.Shaders["Mask"])
                              love.graphics.draw(self.mesh, self.start_x+self.move, self.start_y, 0, self.mesh_length, self.mesh_width)
                              love.graphics.setShader()
                          end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.setBlendMode("add")
    super.draw(self)
    love.graphics.setBlendMode("alpha")
    love.graphics.setStencilTest()
end

return flow_lines
