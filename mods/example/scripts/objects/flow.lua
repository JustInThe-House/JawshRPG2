local flow, super = Class(Sprite, "flow")

function flow:init(x, y)
    super.init(self, "bullets/flow_bg", x, y)
    self.wrap_texture_x = true
    self.wrap_texture_y = true
    self.alpha = 0.8
    self.start_x = 450
    self.start_y = 170
    self.move = 0
    self.grayscale = true

    self.grayscale_FX = love.graphics.newShader([[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 pixel = Texel(texture, texture_coords);

        // Calculate the luminance of the pixel using the NTSC standard
        float gray = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));

        // Return the grayscale color
        return vec4(gray, gray, gray, pixel.a) * color;

    }
]])
    self.mesh_length = 5
    self.mesh_width = 3
    self.mesh = love.graphics.newMesh({
                                          { 0,  0,    0, 0, 1, 1, 1, 1 },
                                          { -1, 0.5,  0, 0, 1, 1, 1, 0 },
                                          { -1, -0.5, 0, 0, 1, 1, 1, 0 },
                                      }, "fan", "dynamic")
end

--love.graphics.setColor(self.phase_color)
function flow:update()
    self.move = self.move + 8 * DTMULT
    self.x = self.x - 8 * DTMULT
    super.update(self)
end

function flow:draw()
    love.graphics.setColor(1, 1, 1, 1)


    --[[love.graphics.setShader(self.grayscale_FX)
            love.graphics.setBlendMode("add")
          --  love.graphics.clear(0, 0, 0, 1)
            super.draw(self)
        love.graphics.setShader()
    love.graphics.setBlendMode("alpha")]]

    love.graphics.stencil(function()
                              love.graphics.setShader(Kristal.Shaders["Mask"])
                              love.graphics.draw(self.mesh, self.start_x + self.move, self.start_y, 0, self.mesh_length,
                                  self.mesh_width)
                              love.graphics.setShader()
                          end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.setBlendMode("add")
    super.draw(self)
    love.graphics.setBlendMode("alpha")
    love.graphics.setStencilTest()
end

return flow
