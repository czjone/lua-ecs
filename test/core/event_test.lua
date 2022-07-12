local core_event_test = class(xlib.core.test_base)

core_event_test.name = "core event test "

function core_event_test:execute()
    local in_data, out_data = 0, 1;
    local exp_val = nil
    -- dispatcher
    local dispatcher = class(xlib.core.eventdispatcher)
    dispatcher.event = {
        on_changed = 1
    };

    -- listner
    local listener = class()
    
    function listener:ctor()
        self._dispatcher = dispatcher.new();
        -- add event listener test
        self._dispatcher:add_eventlistener(dispatcher.event.on_changed, self._onchanged)
        self._dispatcher:dispatch(dispatcher.event.on_changed, out_data);
    end
    
    function listener:dector()
        -- remove listener test
        self._dispatcher:remove_listener(dispatcher.event.on_changed, self._onchanged)
        self._dispatcher:dispatch(dispatcher.event.on_changed, nil);
    end
    
    function listener:_onchanged(val)
        exp_val = val
    end
    
    function listener:get_dispatcher()
        return self._dispatcher
    end
    
    -- run test.
    local l = listener.new();
    
    
    local ret = true;
    ret = self.test:expect_true(exp_val == out_data, "event dispather test") and ret
    return ret
end

return core_event_test;
