-------------------------------------------------------------
-- xlib.ecs.matcher_for_entity_class
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = xlib.ecs.matcher or class({})
local matcher = xlib.ecs.matcher

function matcher:ctor(com_types)
    self._com_types = com_types
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
