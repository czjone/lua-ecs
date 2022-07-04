xlib.ecs = xlib.ecs or {}
-------------------------------------------------------------
-- xlib.ecs.matcher_for_entity_class
log.assert(xlib.ecs.matcher, "xlib.ecs.matcher is nil")
xlib.ecs.matcher_for_entity_class = class(xlib.ecs.matcher)
local matcher_for_entity_class = xlib.ecs.matcher_for_entity_class

function matcher_for_entity_class:ctor(_context_entites, __entites_class)
    self.__entites_class = __entites_class;
end
function matcher_for_entity_class:match(entity)
    return entity:is_type_fast(self.__entites_class);
end

return matcher_for_entity_class
