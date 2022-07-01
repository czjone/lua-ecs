-- ==========================================================================
-- table.extention
function table.index_of(_table, val)
    for pos, v in ipairs(_table) do
        if v == val then
            return pos, v;
        end
    end
    return -1, nil;
end

function table.remove_all_for_array(array)
    for i = #array, 1, -1 do
        table.remove(array)
    end
end

function table.remove_item(_table, val)
    local pos = -1;
    for _pos, v in ipairs(_table) do
        if v == val then
            pos = _pos
        end
    end
    table.remove(_table, pos);
end

function table.get_or_create(_table, key, _class, ...)
    local ret = _table[key];
    if not ret then
        ret = _class.new(...);
        _table[key] = ret;
    end
    return ret;
end
