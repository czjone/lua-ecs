require("xlib.core.base")

local memory = class(xlib.core.test_base)

memory.name = "memory test"

 
function memory:execute()
    local class_a = class()
    local class_b = class(xlib.core.base)

    for i = 1,30, 1 do
        class_a.new()
        class_b.new()
    end

    local class_c = class()
    local class_d = class(xlib.core.base)

    for i = 1,30, 1 do
        class_c.new()
        class_d.new()
    end

    return true
end

return memory
