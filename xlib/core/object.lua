xlib = xlib or {}

xlib.version = "0.0.1"

-- ==========================================================================
-- xlib.class
function to_class(_class)
    if _class == nil then
        return nil
    end
    if type(_class) == "string" then
        return require(_class);
    end
    return _class;
end

local function to_class__(_class)
    -- if type(_class) == string_ then
    --     return require(_class);
    -- end
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

    super = to_class(super) or {}

    local class_type = {}
    class_type.ctor = false
    class_type.super = super
    --- func dector
    class_type.super.dector = class_type.super.dector or function(_self)
    end

    --- func is_type
    class_type.is_type = function(_self, __class)
        if type(__class) == "string" then
            __class = require(__class);
        end
        return _self.__class_type == __class
    end
    -- func destory
    class_type.destroy = class_type.destroy or function(_self)
        _self.__is_alive = nil;
        if (_self.dector) then
            _self.__class_type = nil
            _self:dector()
        else
            for k, _ in pairs(_self) do
                _self[k] = nil
            end
        end
    end
    -- func is destroy
    class_type.is_destroy = function(_self)
        return not _self.__is_alive;
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
                -- if (obj.dector) then
                --     obj.__class_type = nil
                --     obj:dector()
                -- end
                if (obj.destroy) then
                    obj:destroy();
                end
            end
        })
        obj.__is_alive = true;
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

function create(model, ...)
    local t = type(model)
    local ret = to_class(model).new(...)
    return ret;
end

xlib = xlib or {}
xlib.core = xlib.core or {}
