-------------------------------------------------------------
-- xlib.ecs.matcher_for_entity_class
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = class({})
local matcher = xlib.ecs.matcher

function matcher:ctor(_context_entites)
    self._context_entites = _context_entites
end

function matcher:get_entites()
    return self._match_entites;
end

function matcher:match(entity)
    return true;
end
