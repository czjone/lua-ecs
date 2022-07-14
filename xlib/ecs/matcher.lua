-------------------------------------------------------------
-- xlib.ecs.matcher_for_entity_class
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = class({})
local matcher = xlib.ecs.matcher

function matcher:ctor()
end

function matcher:match(entity)
    return true;
end

-------------------------------------------------------------
-- matcher for entity type
-- xlib.ecs.matcher.type_matcher = xlib.ecs.matcher.type_matcher or class(matcher)
-- local type_matcher = xlib.ecs.matcher.type_matcher

-- function matcher:match(entity)
--     return true;
-- end
