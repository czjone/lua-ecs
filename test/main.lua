require("xlib.core")
local test = xlib.core.test.new()
-- core unit test
test:put("test.core.class_test")
test:put("test.core.memory_test")
test:put("test.core.table_extention_test")
test:put("test.core.object_pool_test")
-- ecs test
test:put("test.ecs.sample_test")
test:run();
