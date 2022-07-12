xlib = xlib or {}

-- ------------------------------------------------
-- loger
xlib.core.logger = class()
local logger = xlib.core.logger
function logger:ctor()
    self._print = print;
    print = nil;
end

function logger:info(...)
    self._print("[INFO]", ...)
end

function logger:error(...)
    self._print("[ERROR]", ...)
    error(...);
end

function logger:fail(...)
    self._print("[FAIL]", ...)
end

function logger:ok(...)
    self._print("[ OK ]", ...)
end

function logger:assert(exp, des)
    if not exp then
        self:error(des)
    end
end

log = log or logger.new();
