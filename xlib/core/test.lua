xlib = xlib or {}
-- ---------------------------------------------------
-- test
xlib.core.test = xlib.core.test or class()
local test = xlib.core.test

function test:ctor()
    self._test = {}
end

function test:put(test, name)
    local t = type(test)
    local test_instance = to_class(test).new(self, name);
    log:assert(test_instance.execute, "not found execute:" .. test)
    log:assert(test_instance.name, "testor name is nil:" .. test)
    self:_put_testor(test_instance)
end

function test:_put_testor(test_instance)
    table.insert(self._test, {
        o = test_instance,
        name = test_instance.name,
        f = function()
            return test_instance:execute()
        end
    })
    return self
end

function test:expect(out_val, tag_val, des)
    if (out_val ~= tag_val) then
        if des then
            self:_show_fail(des, " fail, expect value:", tag_val, "get value:", out_val)
        else
            self:_show_fail("fail,expect value:", tag_val, " get value:", out_val)
        end
        return false
    else
        log:ok("test", des)
        return true
    end
end

function test:expect_true(out_val, des)
    return self:expect(out_val, true, des)
end

function test:expect_false(out_val, des)
    return self:expect(out_val, false, des)
end

function test:performance(loop, func, des, allow_runtimes_ms)
    local start = os.clock()
    local ret = nil;
    loop = loop or 1
    for i = 1, loop, 1 do
        ret = func();
    end
    local end_t = os.clock()
    local running_time = (end_t - start) * 1000
    if (allow_runtimes_ms ~= nil) then
        log:assert(running_time <= allow_runtimes_ms, "running time more than " .. tostring(allow_runtimes_ms) ..
            " ms,running time:" .. tostring(running_time) .. " MS");
    end
    log:ok("Running time:", running_time, "MS", "loop times:", loop, ":", des)
    return ret;
end

function test:_show_fail(...)
    log:fail(...)
    log:fail(debug.traceback())
end

function test:_show_head(...)
    log:info("===================================================")
    log:info("      author:      ", "solyess")
    log:info("      version:     ", xlib.version)
    log:info("      Lua runtime: ", _VERSION)
    log:info("      modify time: ", "2020-06-21")
    log:info("===================================================")
end

function test:_show_testor(test_name)
    log:info("--------------------------------")
    log:info(string.format("[%s]", test_name))
    log:info()
end

function test:_show_testor_fail(test_name)
    log:fail("----- [" .. test_name .. "] fail -----")
    log:fail(debug.traceback())
end

function test:_show_end(count, success)
    log:info("")
    log:info("=========================================")
    log:info("-----------------------------------------")
    log:info("|     total:   ", count,      "", "", "|")
    log:info("|     success: ", success,    "", "", "|")
    log:info("|     fail:    ", count - success, "", "", "|")
    -- log:fail(string.format("execute:%u success:%u fail:%u", count, success, fail))
    log:info("-----------------------------------------")
end

function test:run()
    self:_show_head();
    local memory = xlib.memory.new()
    local count, success, fail = #self._test, 0, 0
    for _, vt in ipairs(self._test) do
        self:_show_testor(vt.name);
        if (not memory:monitor(vt.f, vt.name)) then
            self:_show_testor_fail(vt.name)
            fail = fail + 1
        else
            success = success + 1
        end
    end
    self:_show_end(count, success);
    memory = nil
end
