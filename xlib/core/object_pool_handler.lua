xlib = xlib or {}

-- ------------------------------------------------
-- object pool
xlib.core.object_pool_handler = class()
local object_pool_handler = xlib.core.object_pool_handler

function object_pool_handler:ctor(_class)
    self._class = _class;
end

function object_pool_handler:create_object()
    return self._class.new()
end

function object_pool_handler:on_rest_object(obj)
    if obj.rest then
        obj:rest()
    end
end

function object_pool_handler:on_reconvery_object(obj)
    if obj.reconvery then
        obj:reconvery();
    end
end
