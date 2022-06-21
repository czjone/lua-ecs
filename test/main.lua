require("xlib.core")
local test = xlib.core.test.new()
-- core unit test
test:put("test.core.class")
test:put("test.core.memory")
test:put("test.core.table_extention_test")
-- -- ecs unit test
-- test:put("test.ecs.component")
-- test:put("test.ecs.entity")
-- test:put("test.ecs.context")
-- test:put("test.ecs.matcher")
-- test:put("test.ecs.system")
-- test:put("test.ecs.reactive_system")
-- test:put("test.ecs.group")
-- test:put("test.ecs.collector")
-- -- ecs test
-- test:put("test.ecs.feature")

test:run();