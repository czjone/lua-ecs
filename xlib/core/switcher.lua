xlib.core.switcher = xlib.core.switcher or class()
local switcher = xlib.core.switcher

function switcher:ctor(switch_tb)
    self._switcher = switch_tb or {}
end

function switcher:execute(k)
    local execute = self._switcher[k]
    if execute then
        return execute.func(execute.obj);
    end
    return nil;
end

function switcher:add(k, func, obj)
    if (self._switcher[k]) then
        log:error("exist switcher key:", k);
    end
    self._switcher[k] = {
        func = func,
        obj = obj
    }
end

return switcher
