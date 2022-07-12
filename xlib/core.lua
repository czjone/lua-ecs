require("xlib.core.object")
require("xlib.core.array")
require("xlib.core.set")
require("xlib.core.switcher")
require("xlib.core.eventdispatcher")
require("xlib.core.loger")
require("xlib.core.memory")
require("xlib.core.table")
require("xlib.core.test")
require("xlib.core.test_base")
require("xlib.core.object_pool")
require("xlib.core.object_pool_handler")
require("xlib.core.environment")

-- check env.
xlib.core.environment.new():check();
