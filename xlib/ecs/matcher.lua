-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = class({})
local matcher = xlib.ecs.matcher

function matcher:ctor(entites, compare_func)
    self._compare = compare_func
    self._entites = entites
    self._match_entites = {}
end

function matcher:get_entites()
    return self._match_entites;
end

function matcher:re_match()

end
