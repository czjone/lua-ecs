xlib = xlib or {}
-- --------------------------------------------------
-- memory
xlib.memory = xlib.memory or class()

function xlib.memory:reset()
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
end

function xlib.memory:get_size()
    return collectgarbage("count");
end

function xlib.memory:monitor(func, name)
    self:reset();
    local start = self:get_size();

    local ret = func()
    self:reset();
    -- log:info("MEMORY LEAK:", collectgarbage("count") - start, string.format("  [%s]", name))
    log:info("MEMORY LEAK:", (self:get_size() - start) * 1000, " BYTES");
    return ret
end
