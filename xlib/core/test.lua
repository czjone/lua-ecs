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
    local test_instance = nil
    switch(t, {
        string = function()
            local model = require(test)
            log:assert(type(model) == "table", "test model must a object.")
            test_instance = model.new(self, name or model.name)
        end,
        table = function()
            test_instance = test.new(self, name or test_instance.name)
        end
    })
    -- if t == "string" then
    --     local model = require(test)
    --     log:assert(type(model) == "table", "test model must a object.")
    --     test_instance = model.new(self, name or model.name)
    -- end

    -- if t == "table" then
    --     test_instance = test.new(self, name or test_instance.name)
    -- end
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
            log:fail(des, " fail, expect value:", tag_val, "get value:", out_val)
            log:fail(debug.traceback())
        else
            log:fail("fail,expect value:", tag_val, " get value:", out_val)
            log:fail(debug.traceback())
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

function test:run()
    log:info("===================================================")
    log:info("      author:      ", "solyess")
    log:info("      version:     ", xlib.version)
    log:info("      Lua runtime: ", _VERSION)
    log:info("      modify time: ", "2020-06-21")
    log:info("===================================================")

    local memory = xlib.memory.new()
    local count, success, fail = #self._test, 0, 0
    for _, vt in ipairs(self._test) do
        log:info("--------------------------------")
        log:info(string.format("[%s]", vt.name))
        if (not memory:monitor(vt.f, vt.name)) then
            log:fail("----- [" .. vt.name .. "] fail -----")
            log:fail(debug.traceback())
            fail = fail + 1
        else
            success = success + 1
        end
        -- log:info("-----------------------------")
    end
    log:info("")
    log:info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    log:info("total:   ", count)
    log:info("success: ", success)
    log:info("fail:    ", fail)
    -- log:fail(string.format("execute:%u success:%u fail:%u", count, success, fail))
    log:info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    memory = nil
end
