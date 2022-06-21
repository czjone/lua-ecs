-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = class({})
local matcher = xlib.ecs.matcher
function matcher:ctor(entites, compare_func)
    self._compare = compare_func
    self._entites = entites
end

function matcher:get_entites()
    local entites = self._entites
    local compare = self._compare
    local match_entites = {}
    for i, entity in ipairs(entites) do
        if (compare()) then
            table.insert(match_entites, entity)
        end
    end
end
