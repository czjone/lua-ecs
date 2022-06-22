require("xlib.core.base")

local test = class(xlib.core.test_base)

test.name = "class test"

function test:execute()
    local expect_val = 1
    local c = class({val = expect_val})
    local d = class(c)

    local c_instance = c.new()
    local d_instance = d.new()

    local ret = true
    ret = self.test:expect_true(d_instance.val == expect_val, "d_instance.val == ret") and ret
    ret = self.test:expect_true(c_instance.val == expect_val, "c_instance.val == ret") and ret
    return ret
end

return test
