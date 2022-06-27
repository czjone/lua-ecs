require("xlib.core")
local test = xlib.core.test.new()
-- core unit test
test:put("test.core.class_test")
test:put("test.core.memory_test")
test:put("test.core.table_extention_test")
test:put("test.core.object_pool_test")
-- -- ecs unit test
test:put("test.ecs.component_test")
-- test:put("test.ecs.entity_test")
-- test:put("test.ecs.context_test")
-- test:put("test.ecs.matcher_test")
-- test:put("test.ecs.system_test")
-- test:put("test.ecs.reactive_system_test")
-- test:put("test.ecs.group_test")
-- test:put("test.ecs.collector_test")
-- ecs test
test:put("test.ecs.generator_test")

test:run();
