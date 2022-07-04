-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
local entity_base = {}

-- local function __add_com(entites, com, ...)

-- end

-- setmetatable(entity_base, {
--     __index = function(t, k)
--         -- add
--         log:info(k);
--         -- remove

--         -- replace
--     end
-- })
xlib.ecs.entity = class(entity_base)
local entity = xlib.ecs.entity

function entity:ctor()
    self._compnents = {}
end

function entity:has_compnent(__class)
    return self._compnents[__class] ~= nil;
end

function entity:add_compnent(com)
    local __class = com:get_class();
    if (self:has_compnent(__class)) then
        log:error("Cannot add component '" .. com .. "' to " .. entity .. "!");
    end
    self._compnents[__class] = com;
end

function entity:remove_compnent(com)
    local __class = com:get_class();
    if not (self:has_compnent(__class)) then
        log:error("No component '" .. com .. "' remove from " .. entity .. "!");
    end
    self._compnents[__class] = nil;
end

function entity:get_com(__class)
    if not self:has_compnent(__class) then
        self:add_compnent(__class.new());
    end
    return self._compnents[__class];
end

function entity:reactivate()
end

function entity:deactivate()
end

