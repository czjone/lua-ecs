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

function object_pool_handler:rest_object(obj)

end

function object_pool_handler:reconvery_object(obj)

end
