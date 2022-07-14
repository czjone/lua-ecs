xlib.core.array = xlib.core.array or class()
local array = xlib.core.array

function array:ctor()
    self._data = {}
end

function array:size()
    return #self._data
end

function array:pop()
    local size = self:size()
    local ret = self:get(size)
    table.remove(self._data, size);
    return ret;
end

function array:get(index)
    if index > #self._data then
        log:error("Index out of range exception!");
    end
    return self._data[index];
end

function array:get_buf()
    return self._data;
end

function array:push(val)
    self:insert(#self._data + 1, val);
end

function array:insert(pos, val)
    table.insert(self._data, pos, val)
end

function array:replace(pos, val)
    self._data[pos] = val;
end

function array:has(val)
    local data = self._data
    for _, v in ipairs(data) do
        if v == val then
            return true
        end
    end
    return false;
end

function array:remove(val)
    local data = self._data
    local pos = -1;
    for p, v in ipairs(data) do
        if v == val then
            pos = p;
            break
        end
    end
    if pos > 0 then
        table.remove(self._data, pos);
    end
end

function array:clear()
    for i = 1, #self._data, 1 do
        table.remove(self._data, 1);
    end
end

function array:find(func)
    for i = 1, #self._data, 1 do
        local v = self._data[i]
        if func(v) then
            return i, v;
        end
    end
    return -1, nil
end

function array:copy()
    local data = self._data;
    local arr = array.new();
    for i, item in ipairs(data) do
        table.insert(arr, item);
    end
    return arr;
end

function array:foreach(func)
    local d = self._data;
    for _, v in ipairs(d) do
        func(v)
    end
end

return array;
