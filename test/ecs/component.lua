require("xlib.ecs")

local ecs_component_test = class(xlib.core.test_base)
ecs_component_test.name = "ecs component test"

function ecs_component_test:execute()
    -- component a
    local test_com_a_id = "test_com_a"
    local test_com_a = class(xlib.ecs.component)
    function test_com_a:ctor()
        self.com_type_id = test_com_a_id
    end
    test_com_a.id = nil
    test_com_a.name = nil
    test_com_a.des = nil

    -- component b
    local test_com_b_id = "test_com_b"
    local test_com_b = class(xlib.ecs.component)
    function test_com_b:ctor()
        self.com_type_id = test_com_b_id
    end
    test_com_b.id = nil
    test_com_b.message = nil

    local a, aa, b = test_com_a.new(), test_com_a.new(), test_com_b.new()

    a.id, aa.id, b.id = 1, 2, 3
    b.message = "b message."
    -- test
    local ret = true
    ret = self.test:expect_true(a ~= b, "component equals") and ret
    ret = self.test:expect_true(a.com_type_id == aa.com_type_id, "component type") and ret

    return ret
end

return ecs_component_test
