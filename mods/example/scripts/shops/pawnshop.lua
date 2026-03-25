local PawnShop, super = Class(Shop)

function PawnShop:init()
    super.init(self)
    self.encounter_text = "* Hey,\n[wait:5]how's it goin'?"
    self.shop_text = "* Thanks for visiting my l!!ittle old place."
    self.leaving_text = "* Hope to see you again!"
    self.buy_menu_text = "Here's\nwhat I got."
    self.buy_confirmation_text = "How about\n%s ?"
    self.buy_refuse_text = "No deal?"
    self.buy_text = "Good deal!"
    self.buy_storage_text = "Good deal!"
    self.buy_too_expensive_text = "Not\nenough\nmunees."
    self.buy_no_space_text = "Sell some\nother stuff\nfirst!"
    self.sell_no_price_text = "...Mind if I call an expert?"
    self.sell_menu_text = "What do we got here?"
    self.sell_nothing_text = "Nothin' there."
    self.sell_confirmation_text = "%s is the best I can do."
    self.sell_refuse_text = "No deal?"
    -- Shown when you sell something
    self.sell_text = "We've got a deal!"
    -- Shown when you have nothing in a storage
    self.sell_no_storage_text = "You've got nothin' to pawn!"
    -- Shown when you enter the talk menu.
    self.talk_text = "You got\na story?"

    self.sell_options_text = {}
    self.sell_options_text["items"]   = "I know a guy who knows these."
    self.sell_options_text["weapons"] = "I know a guy who knows these."
    self.sell_options_text["armors"]  = "I know a guy who knows these."
    self.sell_options_text["storage"] = "I know a guy who knows these."

    self.background = "shops/pawnshop_background"

    self.shopkeeper:setActor("shopkeepers/rick")
    self.shopkeeper.sprite:setPosition(0, 8)
    self.shopkeeper.sprite:setScale(1)
    self.shopkeeper.slide = true

    self.shop_music = "pawn_stars"

    self:registerItem("tensionbit")

    self:registerTalk("About Yourself")
    self:registerTalk("About This World")

    self:registerTalkAfter("How to Leave", 5)
    self:registerTalkAfter("Picture Frame", 2, "talk_2", 1)
    self:registerTalkAfter("Together", 2, "talk_2", 2)
end

function PawnShop:postInit()
    super.postInit(self)
    self.shopkeeper:setLayer(SHOP_LAYERS["above_boxes"])
end

function PawnShop:startTalk(talk)
    if talk == "About Yourself" then
        self:startDialogue({"[emote:idle]* I'm Rick Harrison,[wait:3] and [speed:0.6]this[wait:7][speed:1] is my pawn shop.", "[emote:idle]* I work here with my old man and my son, \"Big Hoss.\"", "[emote:treasure]* Everything in here has a story and a price. One thing I've learned after 21 years - you never know what is gonna come through that door."})
    elseif talk == "Cheese?" then
        self:startDialogue({"[emote:left]* I, [wait:5]um, [wait:5]really like cheese.\n[wait:5]* It's just the perfect food.", "[emote:explaining]* Wh-[wait:5]no, [wait:5]I'm not addicted, [wait:5]I can stop any time I want, [wait:5]alright?"})
    elseif talk == "About Wall Guardian" then
        self:setFlag("talk_2", 1)
        self:startDialogue({"[emote:left]* Wallie? [wait:5]He's a good friend of mine.\n[wait:5]* He's been here for as long as I can remember, [wait:5]even showed me around when I first got here."})
    elseif talk == "Picture Frame" then
        self:setFlag("talk_2", 2)
        self:startDialogue({"[emote:left]* Oh, [wait:5]ehehe...\n[wait:5]* I keep forgetting I put that there.", "[emote:idle]* Pay no attention to it,[wait:5] it's just..."})
    elseif talk == "About This World" then
        self:startDialogue({"[emote:idle]* Leave? This is the first time I've seen you around here, and you already want to leave?", "[emote:lesson]* I can't tell ya, kid. None of us have ever thought of leavin'.", "[emote:idle]* Heck, most of use have never left the hub!", "[emote:point]* The only person I can think of is the strange-looking \"guide\" oustide.", "[emote:lesson]* He may be ugly, but he knows this place forward and backward."})
    end
end

return PawnShop