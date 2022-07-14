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

function dector(_self)

end

function is_destroy(_self)
    return not _self.__is_alive;
end

function is_type(_self, __class)
    if type(__class) == "string" then
        __class = require(__class);
    end
    return _self.__class_type == __class
end

--- func is_type_fast
function is_type_fast(_self, __class)
    return _self.__class_type == __class
end
--- func get_class
function get_class(_self, __class)
    return _self.__class_type;
end

--- func 
function is_instance(_self)
    return self:get_class();
end

function destroy(_self)
    if type(_self) ~= "table" then
        return;
    end
    _self.__is_alive = nil;
    if (_self.dector) then
        _self.__class_type = nil
        _self:dector()
    else
        for k, v in pairs(_self) do
            _self[k] = nil
            destroy(v);
        end
    end
end

function class(super)

    super = to_class(super) or {}

    local class_type = {}
    class_type.ctor = false
    class_type.super = super
    -- functions
    class_type.super.dector = class_type.super.dector or dector
    class_type.is_type = class_type.is_type or is_type
    class_type.destroy = class_type.destroy or destroy;
    class_type.is_destroy = class_type.is_destroy or is_destroy
    class_type.is_type_fast = class_type.is_type_fast or is_type_fast
    class_type.get_class = class_type.get_class or get_class
    class_type.is_instance = class_type.is_instance or is_instance

    --- func new
    class_type.new = function(...)
        local obj = {}
        setmetatable(obj, {
            __index = class_type,
            -- 5.2 or later.
            __gc = function()
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
