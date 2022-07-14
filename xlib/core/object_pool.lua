xlib = xlib or {}

-- ------------------------------------------------
-- object pool
xlib.core.object_pool = class()
local object_pool = xlib.core.object_pool

function object_pool:ctor(_class, pool_object_handler)
    self._pool = xlib.core.array.new();
    self._handler = (pool_object_handler or xlib.core.object_pool_handler).new(_class);
end

function object_pool:get()
    local pool = self._pool
    local ret = nil;
    if pool:size() == 0 then
        ret = self._handler:create_object()
    else
        ret = pool:pop();
        self._handler:on_rest_object(ret)
    end
    return ret;
end

function object_pool:put(val)
    self._handler:on_reconvery_object(val);
    self._pool:push(val)
end
