--------------------------------------------------------------
-- auto generate code by xtool,don't change it.
--------------------------------------------------------------
local feature = class(xlib.ecs.feature)

function feature:ctor(name)
    -- add system for logic.
    self:add_system("sample.logic.loading");
    self:add_system("sample.logic.choose_level");
    self:add_system("sample.logic.fight");
end

return feature
