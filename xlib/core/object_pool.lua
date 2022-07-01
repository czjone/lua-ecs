xlib = xlib or {}

-- ------------------------------------------------
-- object pool
xlib.core.object_pool = class()
local object_pool = xlib.core.object_pool

function object_pool:ctor(_class, pool_object_handler)
    self._pool = {}
    self._handler = (pool_object_handler or xlib.core.object_pool_handler).new(_class);
end

function object_pool:get()
    local pool = self._pool
    local get_val = nil;
    if #self._pool == 0 then
        get_val = self._handler:create_object()
    else
        get_val = pool[1]
        self._handler:rest_object(get_val)
    end
    return get_val;
end

function object_pool:put(val)
    self._handler:reconvery_object(val);
    table.insert(self._pool, val);
end
