xlib = xlib or {}
-- --------------------------------------------------
-- memory
xlib.memory = xlib.memory or class()

function xlib.memory:monitor(func, name)
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    local start = collectgarbage("count")
    local ret = func()
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    -- log:info("MEMORY LEAK:", collectgarbage("count") - start, string.format("  [%s]", name))
    log:info("MEMORY LEAK:", (collectgarbage("count") - start) * 1000," BYTES");
    return ret
end
