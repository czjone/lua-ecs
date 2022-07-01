-------------------------------------------------------------
-- xlib.ecs.matcher_for_entity_class
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = class({})
local matcher = xlib.ecs.matcher

function matcher:ctor(_context_entites)
    self._context_entites = _context_entites
    self._match_entites = {}
end

function matcher:get_entites()
    return self._match_entites;
end

function matcher:re_match()
    table.remove_all_for_array(self._match_entites);
    local entites = self._context_entites
    local func = self._match
    for _, entity in ipairs(entites) do
        if func(self, entity) then
            table.insert(entites, entity)
        end
    end
end

function matcher:_match(entity)
    return true;
end
