xlib = xlib or {}
-- ---------------------------------------------------
-- test
xlib.core.test_base = xlib.core.test_base or class()
local test_base = xlib.core.test_base

function test_base:ctor(test, name)
    self.test = test
    self.name = name
end

function test_base:execute()
    error("not implements test execute.")
end
