local array_test = class(xlib.core.test_base)

function array_test:ctor(test)
    self._test = test
    self.name = "array test"
end

function array_test:execute()
    local ret = true;
    local _array = xlib.core.array.new()

    local loop, allow_times_ms = 500000, 300

    local function push_item(item)
        _array:push(1);
    end

    self.test:performance(loop, push_item, "_array loop push", allow_times_ms);

    local function each_item(k, v)
        -- do sth.
    end

    self.test:performance(1, function()
        _array:foreach(each_item)
    end, "_array foreach all items", allow_times_ms);

    local function empty_foreach(item)
        local s = 0;
        for i = 1, loop, 1 do
            s = s + 1
        end
    end

    self.test:performance(1, empty_foreach, "for .. ipairs loop", allow_times_ms);

    return ret;
end

return array_test;
