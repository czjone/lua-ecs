require("xlib.core.base")

local core_event_test = class(xlib.core.test_base)

core_event_test.name = "core event test "


function core_event_test:execute()
    
    xlib.log:assert(xlib.core.eventdispather,"xlib.core.eventdispather is nil")

    local in_data =  0;
    local out_data = 1
    local ret = nil;
    -- dispatcher
    local dispatcher = class(xlib.core.eventdispather)
    dispatcher.event = {on_changed = 1};
    -- listner
    local listener = class({})

    function listener:ctor()
        self._dispatcher = dispatcher.new();
        -- add event listener test
        self._dispatcher:add_eventlistener(dispatcher.event.on_changed,self._onchanged)
        self._dispatcher:dispatch(dispatcher.event.on_changed,out_data);
        -- remove listener test
        self._dispatcher:remove_listener(dispatcher.event.on_changed,self._onchanged)
        self._dispatcher:dispatch(dispatcher.event.on_changed,nil);
    end

    function listener:_onchanged(val)
        ret = val
    end

    -- run test.
    listener.new();

    return ret == out_data
end

return core_event_test;