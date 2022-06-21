xlib = xlib or {}

xlib.version = "0.0.1"

-- ==========================================================================
-- xlib.class
function class(super)
    if (type(super) == "string") then
        super = require(super) -- import model
    end
    if (super == nil) then
        super = {}
    end
    local class_type = {}
    class_type.ctor = false
    class_type.super = super
    class_type.new = function(...)
        local obj = {}
        setmetatable(
            obj,
            {
                __index = class_type,
                -- 5.2 or later.
                __gc = function()
                    if (obj.dector) then
                        obj:dector()
                    end
                end
            }
        )
        do
            local create = nil
            local callsuper = nil
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.ctor then
                    c.ctor(obj, ...)
                end
            end
            create(class_type, ...)
        end
        return obj
    end
    if super then
        setmetatable(
            class_type,
            {
                __index = function(t, k)
                    local ret = super[k]
                    return ret
                end
            }
        )
    end
    return class_type
end

-- ==========================================================================
-- xlib.core
xlib.core = xlib.core or {}
xlib.core.base = class()
local base = xlib.core.base
function base:ctor(...)
    self.is_xobj = true
end

function base:dector()
    for k, _ in pairs(self) do
        self[k] = nil
    end
end
