xlib = xlib or {}
-- --------------------------------------------------
-- memory
xlib.memory = xlib.memory or class()

function xlib.memory:_start()
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    log:info("start performance memory")
end

function xlib.memory:get_size()
    return collectgarbage("count");
end

function xlib.memory:_end()
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
end

function xlib.memory:monitor(func, name)
    self:_start();
    local start = self:get_size();

    local ret = func()
    self:_end();
    -- log:info("MEMORY LEAK:", collectgarbage("count") - start, string.format("  [%s]", name))
    local leak = self:get_size() - start;
    if leak <= 0 then
        leak = 0
        log:ok("performance memory end:(LEAK " .. tostring(leak * 1000) .. " bytes)");
    else
        log:error("performance memory end:(LEAK " .. tostring(leak * 1000) .. " bytes)");
    end

    return ret
end
