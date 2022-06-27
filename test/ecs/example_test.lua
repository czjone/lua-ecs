require("xlib.core.base")

---------------------------------------------
-- component
---------------------------------------------
local position_com = class(xlib.ecs.component)
position_com.x = 1;
position_com.y = 1;
position_com.z = 1;

local car_com = class(xlib.ecs.component)
car_com.id = 0
car_com.rgb = 0.3
car_com.a = 0.5

---------------------------------------------
-- entites
---------------------------------------------
local game_entity = class(xlib.ecs.entity)
local input_entity = class(xlib.ecs.entity)

---------------------------------------------
-- systems
---------------------------------------------
-- init system
local init_system = class(xlib.ecs.system)
-- move system
local move_system = class(xlib.ecs.reactive_system)
-- destroy system
local destroy_system = class(xlib.ecs.reactive_system)
-- input_system
local input_system = class(xlib.ecs.reactive_system)
-- game system
local game_system = class(xlib.ecs.system)
function game_system:ctor(name, context)
    local ctx = self.context
    self:add_system(init_system.new("init_system", ctx))
    self:add_system(move_system.new("move_system", ctx))
    self:add_system(destroy_system.new("destroy_system", ctx))
end
-- feature
local feature = class(xlib.ecs.feature)
function feature:ctor(name)
    local ctx = self.context
    self:add_system(input_system.new("input_system", ctx))
    self:add_system(game_system.new("game_system", ctx))
end

---------------------------------------------
-- test
---------------------------------------------
local example_test = class(xlib.core.test_base)
example_test.name = "ecs system example  test"

function example_test:execute()
    local ret = true;
    local _feature = feature.new("ecs demo feture");
    _feature:initialize()
    -- loop exeucte on every frame.
    for i = 1, 1000, 1 do
        _feature:execute()
    end
    return ret;
end

return example_test
