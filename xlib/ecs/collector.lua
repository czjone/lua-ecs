-- ==========================================================================
-- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.collector = class({})
local collector = xlib.ecs.collector;

function collector:ctor(groups)
    self._groups = xlib.core.array.new()
    self._entites_buf = xlib.core.array.new();
end

function collector:_collect_entites()
    local _entites_buf = self._entites_buf
    _entites_buf:clear();
    local groups = self._groups;
    for _, group in ipairs(groups) do
        local entites = group:get_entites();
        _entites_buf:push(entites)
    end
end

function collector:_collect_clear()

end

function collector:get_entites_array()
    self:_collect_entites();
    local entites_array = self._collect_entites:copy()
    return entites_array
end

function collector:get_groups_array()
    return self._groups
end
