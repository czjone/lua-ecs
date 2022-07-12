local set_test = class(xlib.core.test_base)

function set_test:ctor(test)
    self._test = test
    self.name = "set test"
end

function set_test:execute()
    local ret = true;
    local set = xlib.core.set.new()

    local loop, allow_times_ms = 100000, 200

    local i = 0;
    local function set_value()
        i = i + 1;
        set:set_value(i);
    end

    self.test:performance(loop, set_value, "set loop set value", allow_times_ms);

    i = 0;
    local function each_item(k, v)
        i = i + 1;
        -- do sth.
    end

    self.test:performance(1, function()
        set:foreach(each_item)
    end, "_array foreach all items", allow_times_ms);

    return ret;
end

return set_test;
