-------------------------------------------------------------
-- xlib.ecs.matcher_for_entity_class
xlib.ecs = xlib.ecs or {}
xlib.ecs.matcher = xlib.ecs.matcher or class()
local matcher = xlib.ecs.matcher

function matcher:ctor(...)
    self._com_types_array = xlib.core.array.new({...})
    local metatable = getmetatable(self)
    metatable.__eq = function(a, b)
        local a_coms, b_coms = a._com_types_array, b._com_types_array
        if a_coms:size() ~= b_coms:size() then
            return false;
        end
        for _, v in ipairs(a_coms:get_buf()) do
            if not b_coms:has(v) then
                return false;
            end
        end
        return true;
    end
end

function matcher:match(entity)
    local coms = self._com_types_array:get_buf();
    return entity:has_any(table.unpack(coms));
end
