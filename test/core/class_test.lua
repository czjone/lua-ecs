require("xlib.core.base")

local test = class(xlib.core.test_base)

test.name = "class test"

function test:execute()
    local expect_val = 1
    local c = class({
        val = expect_val
    })
    local d = class(c)

    local c_instance = c.new()
    local d_instance = d.new()

    local ret = true
    ret = self.test:expect_true(d_instance.val == expect_val, "d_instance.val == ret") and ret
    ret = self.test:expect_true(c_instance.val == expect_val, "c_instance.val == ret") and ret

    ret = self.test:expect_true(c_instance:is_type(c), "c instance is c type") and ret
    ret = self.test:expect_false(c_instance:is_type(d), "c instance is not d type") and ret

    -------------------------------------------------------------
    -- performance
    local loop, allow_times_ms = 1000000, 200

    self.test:performance(loop, function()
    end, "empty function invork.", allow_times_ms);

    self.test:performance(loop, function()
        local f = function()
        end
        f();
    end, "nesting empty function invork.", allow_times_ms);

    self.test:performance(loop, function()
        c_instance:is_type(c)
    end, "type is test.", allow_times_ms);

    self.test:performance(loop, function()
        c_instance:is_type_fast(c)
    end, "type is test fast.", allow_times_ms);

    return ret
end

return test
