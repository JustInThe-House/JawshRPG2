local Textbox, super = HookSystem.hookScript(Textbox)

function Textbox:init(x, y, width, height, default_font, default_font_size, battle_box)
    super.super.init(self, x, y, width, height)

    self.box = UIBox(0, 0, width, height)
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)

    self.battle_box = battle_box
    if battle_box then
        self.box.visible = false
    end

    if battle_box then
        self.face_x = -4
        self.face_y = 2

        self.text_x = 0
        self.text_y = -2 -- TODO: This was changed 2px lower with the new font, but it was 4px offset. Why? (Used to be 0)
    elseif Game:isLight() then
        self.face_x = 13
        self.face_y = 6

        self.text_x = 2
        self.text_y = -4
    else
        self.face_x = 18
        self.face_y = 6

        self.text_x = 2
        self.text_y = -4 -- TODO: This was changed with the new font but it's accurate anyways
    end

    self.actor = nil

    self.default_font = default_font or "main_mono"
    self.default_font_size = default_font_size

    self.font = self.default_font
    self.font_size = self.default_font_size

    self.face = Sprite(nil, self.face_x, self.face_y, nil, nil, "face")
    --self.face:setScale(2, 2)
    self.face:setScale(0.5, 0.5)


    self.face.getDebugOptions = function(self2, context)
        context = super.super.getDebugOptions(self2, context)
        if Kristal.DebugSystem then
            context:addMenuItem("Change", "Change this portrait to a different one", function()
                Kristal.DebugSystem:setState("FACES", self)
            end)
        end
        return context
    end
    self:addChild(self.face)



    -- Added text width for autowrapping
    self.wrap_add_w = battle_box and 0 or 14

    self.text = DialogueText("", self.text_x, self.text_y, width + self.wrap_add_w, SCREEN_HEIGHT)
    self:addChild(self.text)

    self.reactions = {}
    self.reaction_instances = {}

    self.text:registerCommand("face", function(text, node, dry)
        if self.actor and self.actor:getPortraitPath() then
            self.face.path = self.actor:getPortraitPath()
        end
        self:setFace(node.arguments[1], tonumber(node.arguments[2]), tonumber(node.arguments[3]))
    end)
    self.text:registerCommand("facec", function(text, node, dry)
        self.face.path = "face"
        local ox, oy = tonumber(node.arguments[2]), tonumber(node.arguments[3])
        if self.actor then
            local actor_ox, actor_oy = self.actor:getPortraitOffset()
            ox = (ox or 0) - actor_ox
            oy = (oy or 0) - actor_oy
        end
        self:setFace(node.arguments[1], ox, oy)
    end)

    self.text:registerCommand("react", function(text, node, dry)
                                  local react_data
                                  if #node.arguments > 1 then
                                      react_data = {
                                          text = node.arguments[1],
                                          x = tonumber(node.arguments[2]) or
                                              (self.battle_box and self.REACTION_X_BATTLE[node.arguments[2]] or self.REACTION_X[node.arguments[2]]),
                                          y = tonumber(node.arguments[3]) or
                                              (self.battle_box and self.REACTION_Y_BATTLE[node.arguments[3]] or self.REACTION_Y[node.arguments[3]]),
                                          face = node.arguments[4],
                                          actor = node.arguments[5] and Registry.createActor(node.arguments[5]),
                                      }
                                  else
                                      react_data = tonumber(node.arguments[1]) and
                                          self.reactions[tonumber(node.arguments[1])] or
                                          self.reactions[node.arguments[1]]
                                  end
                                  local reaction = SmallFaceText(react_data.text, react_data.x, react_data.y,
                                                                 react_data.face, react_data.actor)
                                  reaction.layer = 0.1 + (#self.reaction_instances) * 0.01
                                  self:addChild(reaction)
                                  table.insert(self.reaction_instances, reaction)
                              end, { instant = false })

    self.minifaces = {}
    self.miniface_path = "face/mini"

    self.text:registerCommand("miniface", function(text, node, dry)
        local ox = tonumber(node.arguments[2]) or 0
        local oy = tonumber(node.arguments[3]) or 0
        if self.actor then
            local actor_ox, actor_oy = self.actor:getMinifaceOffset()
            ox = actor_ox
            oy = actor_oy
        end
        local x_scale = tonumber(node.arguments[4]) or 2
        local y_scale = tonumber(node.arguments[5]) or 2
        local speed = tonumber(node.arguments[6]) or (4 / 30)
        local y = self.text.state.current_y
        if (not dry) then
            local miniface = Sprite(nil, 0 + ox, y + oy)
            miniface:setScale(x_scale, y_scale)
            miniface:setSprite(self.miniface_path .. "/" .. node.arguments[1])
            miniface:play(speed)
            if #self.minifaces > 0 then
                local last_face = self.minifaces[#self.minifaces]
                last_face:stop()
            end
            self:addChild(miniface)
            table.insert(self.minifaces, miniface)
            if self.actor and self.actor:getMiniface() then
                self.miniface_path = self.actor:getMiniface()
            else
                self.miniface_path = "face/mini"
            end
            self.text.state.indent_mode = true
            self.text.state.indent_length = miniface.width * miniface.scale_x + 15
            self.text.state.current_x = self.text.state.indent_length + self.text.state.spacing
        end
    end)


    self.advance_callback = nil
end

    --[[
function Textbox:update()
    if not self:isTyping() then
        self.face:stop()
        for _, miniface in ipairs(self.minifaces) do
            miniface:stop()
        end
    end

    this is how i did the auto face scaling previously. however, there are issues when switching between faces of different sizes.
    since i dont want this issue, im just gonna set it to the full 256x256 (ie setscale to 0.5,0.5). this can be changed in the future
    the pyro image was 50kb. it was kinda expensive, so i will assume other sprites will be less large. overall it shouldnt be too large.
    has to be on update, which is fine.
    -- the only thing that HAS to be reinforced is that all icon sprites MUST be divisible by 64.
    if self.face.height > 64 then
        local scale_factor = math.ceil(self.face.height / 64)
        self.face:setScale(2 / scale_factor, 2 / scale_factor)
    else
        self.face:setScale(2, 2)
    end
  --  Kristal.Console:log(Utils.dump(self.face.height))
  --  Kristal.Console:log(Utils.dump(self.face.scale_x))

    super.super.update(self)
end
]]

return Textbox
