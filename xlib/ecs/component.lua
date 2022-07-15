-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.component = class()
local component = xlib.ecs.component
component.__keys = nil;
function component:ctor(...)
    self:set_value(...)
end

function component:_has_key(key)
    for _, k in ipairs(self.__keys) do
        if k == key then
            return true;
        end
    end
    return false;
end

function component:_set_value_for_dynamic_parameter(...)
    local keys = self.__keys;
    local values = {...}
    for i, key in ipairs(keys) do
        if self:_has_key(key) then
            self[key] = values[i]
        end
    end
end

function component:_set_value_for_table(set_table)
    for k, v in pairs(set_table) do
        if self:_has_key(k) then
            self[k] = v
        else
            log:wang("try set value with table,but not found property in component.");
        end
    end
end

function component:set_value(...)
    local values = {...}
    if #values == 1 and type(values[1]) == "table" then
        self:_set_value_for_table(values[1]);
    else
        self:_set_value_for_dynamic_parameter(...);
    end
end

function component.make(properties)
    local _type = class(component);
    _type.__keys = properties;
    return _type;
end

