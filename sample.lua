-- test components

local com_player = class(xlib.ecs.component)
com_player.coin = 0;
com_player.gem = 0;
com_player.lv = 0;
com_player.free_exp = 0;

local com_player_info = class(xlib.ecs.component)
com_player_info.name = nil;
com_player_info.id = nil;
com_player_info.token = nil;

local com_player_view = class(xlib.ecs.component)
com_player_view.blood_slider = nil
com_player_view.name_text = nil

local com_remote_host = class(xlib.ecs.component)
com_remote_host.host = nil
com_remote_host.port = nil
-- end test components

-- test entity
local game_entity = class(xlib.ecs.entity)
function game_entity:ctor()
    self:add(com_player):add(com_player_info):add(com_player_view):add(com_remote_host)
end
-- end test entity

-- logic sysetm
local ui_init_system = class(xlib.ecs.system);
local player_system = class(xlib.ecs.system);
local ui_render_system = class(xlib.ecs.system);
local ui_input_system = class(xlib.ecs.system);
local ui_destory_system = class(xlib.ecs.system);

local network_connect_sytem = class(xlib.ecs.system);
local network_write_system = class(xlib.ecs.system);
local network_read_system = class(xlib.ecs.system);

local ui_system = class(xlib.ecs.feature);
function ui_system:ctor()
    self:add(ui_init_system.new()):add(ui_render_system.new()):add(ui_input_system.new()):add(ui_destory_system.new())
end

local network_system = class(xlib.ecs.feature);
function network_system:ctor()
    self:add(network_connect_sytem.new()):add(network_write_system.new()):add(network_read_system.new())
end

--------------------------------------------------
-- test case.
-- xlib.test.new():put(function()
--     return true;
-- end, "class"):put(function()
--     return true;
-- end, "loger"):put(function()
--     local loop = 3 -- min = 1
--     local feature = xlib.ecs.feature.new()
--     feature:add(ui_system.new()):add(network_system.new())
--     feature:initialize();
--     for i = 1, loop, 1 do
--         feature:execute()
--     end
--     feature:cleanup();
--     return true;
-- end, "ecs"):run()

function main() 
    local loop = 3 -- min = 1
    local feature = xlib.ecs.feature.new()
    feature:add(ui_system.new()):add(network_system.new())
    feature:initialize();
    for i = 1, loop, 1 do
        feature:execute()
    end
    feature:cleanup();
    return true;
end
