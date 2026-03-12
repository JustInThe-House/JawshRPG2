return function(cutscene)

local choice = cutscene:choicer({"Go on X\n(Progress)", "Loaf Around"})
if choice == 1 then
   -- cutscene:text("* Fahaha, I, um, hope so!", "some_portrait_idk", "noelle")
else
   -- cutscene:text("* T-Togore?", "some_portrait_idk", "noelle")
end

end