local object_pool_test = class(xlib.core.test_base)

object_pool_test.name = "object pool test"

function object_pool_test:execute()

    local ret = true;

    local test_class = class()
    local rest_id = 1;

    function test_class:ctor()
        self.id = rest_id;
        self.name = nil
        self.is_free = false;
    end

    -- test pool with default pool handler
    local pool0 = xlib.core.object_pool.new(test_class)
    local obj1_from_pool0 = pool0:get();

    ret = self.test:expect_true(obj1_from_pool0.id == 1, "obj1_from_pool0.id") and ret
    pool0:put(obj1_from_pool0)

    obj1_from_pool0 = pool0:get()
    local obj2_from_pool0 = pool0:get()
    ret = self.test:expect_true(obj1_from_pool0.id == rest_id, "obj1_from_pool0.id") and ret
    ret = self.test:expect_true(obj2_from_pool0.id == rest_id, "obj2_from_pool0.id") and ret

    pool0 = nil;

    local object_pool_handler = class(xlib.core.object_pool_handler)
    -- test pool with default object_pool_handler
    function object_pool_handler:ctor(test_class)

    end
    function object_pool_handler:rest_object(obj)
        obj.id = rest_id;
    end

    function object_pool_handler:reconvery_object(obj)
        -- do sth.set parent to nil for unity.
        -- log:info("---------------------------")
        obj.is_free = true;
    end

    local pool1 = xlib.core.object_pool.new(test_class, object_pool_handler)

    -- create with pool
    local obj1 = pool1:get();
    local obj2 = pool1:get();

    obj1.id = 1
    obj2.id = 2

    ret = self.test:expect_true(obj1.id == 1, "obj1.id") and ret
    ret = self.test:expect_true(obj2.id == 2, "obj2.id") and ret

    -- recovery to pool
    pool1:put(obj1);
    pool1:put(obj2);

    ret = self.test:expect_true(obj1.is_free, "obj1.is_free") and ret
    ret = self.test:expect_true(obj2.is_free, "obj2.is_free") and ret

    -- craete with pool catch.
    obj2 = pool1:get()
    obj1 = pool1:get()

    ret = self.test:expect_true(obj1.id == rest_id, "obj1 get from pool") and ret
    ret = self.test:expect_true(obj2.id == rest_id, "obj2 get from pool") and ret

    return ret;
end

return object_pool_test
