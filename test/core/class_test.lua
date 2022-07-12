local test = class(xlib.core.test_base)

test.name = "class test"

function test:ctor(test, name)
    self.expect_val = 1
    self.c = class({
        val = self.expect_val
    })
    self.d = class(self.c)
end

function test:execute()

    local loop, create_class_loop, allow_times_ms = 1000000, 50000, 200

    local expect_val = self.expect_val;
    local c = self.c
    local d = self.d

    local ret = true

    self.test:performance(create_class_loop, function()
        local c_instance = self.c.new()
        local d_instance = self.d.new()
    end, "class instance", allow_times_ms);

    local c_instance = self.c.new()
    local d_instance = self.d.new()

    ret = self.test:expect_true(c_instance:get_class() == self.c, "type test") and ret
    ret = self.test:expect_true(d_instance:get_class() == self.d, "type test") and ret
    ret = self.test:expect_true(d_instance.val == expect_val, "d_instance.val") and ret
    ret = self.test:expect_true(c_instance.val == expect_val, "c_instance.val") and ret
    ret = self.test:expect_true(c_instance:is_type(c), "c instance is c type") and ret
    ret = self.test:expect_false(c_instance:is_type(d), "c instance is not d type") and ret

    -- -------------------------------------------------------------
    -- -- performance  is type

    self.test:performance(loop, function()
    end, "IS_TYPE:empty function invork.", allow_times_ms);

    self.test:performance(loop, function()
        local f = function()
        end
        f();
    end, "IS_TYPE:nesting empty function invork.", allow_times_ms);

    self.test:performance(loop, function()
        c_instance:is_type(c)
    end, "IS_TYPE:type is test.", allow_times_ms);

    self.test:performance(loop, function()
        c_instance:is_type_fast(c)
    end, "IS_TYPE:type is test fast.", allow_times_ms);

    ret = self.test:expect_false(c_instance:is_destroy(), "c destroy status test") and ret
    ret = self.test:expect_false(d_instance:is_destroy(), "c destroy status test") and ret
    c_instance:destroy();
    ret = self.test:expect_true(c_instance:is_destroy(), "destroy status test") and ret
    ret = self.test:expect_false(d_instance:is_destroy(), "destroy status test") and ret
    return ret
end

return test
