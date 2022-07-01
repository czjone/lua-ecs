xlib = xlib or {}

xlib.version = "0.0.1"

-- ==========================================================================
-- xlib.class
function to_class(_class)
    if type(_class) == "string" then
        return require(_class);
    end
    return _class;
end

function to_classes(_classes)
    local classes = {}
    for _, v in pairs(_classes) do
        table.insert(classes, to_class(v));
    end
    return classes
end

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
    --- func dector
    class_type.super.dector = class_type.super.dector or function(_self)
    end

    --- func is_type
    class_type.is_type = function(_self, __class)
        return _self.__class_type == to_class(__class)
    end

    --- func is_type_fast
    class_type.is_type_fast = function(_self, __class)
        return _self.__class_type == __class
    end
    --- func get_class
    class_type.get_class = function(_self, __class)
        return _self.__class_type;
    end

    --- func new
    class_type.new = function(...)
        local obj = {}
        setmetatable(obj, {
            __index = class_type,
            -- 5.2 or later.
            __gc = function()
                if (obj.dector) then
                    obj.__class_type = nil
                    obj:dector()
                end
            end
        })
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

        obj.__class_type = class_type

        return obj
    end
    if super then
        setmetatable(class_type, {
            __index = function(t, k)
                local ret = super[k]
                return ret
            end
        })
    end
    return class_type
end

--[[
    {
        handler_value1 = handler_func1,
        handler_value2 = handler_func2,
        handler_value3 = handler_func3,
    }
]]
function switch(arg, handler)
    for k, v in pairs(handler) do
        if k == arg then
            v();
            break
        end
    end
end

function create(model, ...)
    local t = type(model)
    local ret = nil
    local args = {...}
    switch(t, {
        string = function()
            local model = require(model)
            log:assert(type(model) == "table", "model must a class.")
            ret = model.new(table.unpack(args))
        end,
        table = function()
            ret = model.new(table.unpack(args))
        end
    })
    return ret;
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
