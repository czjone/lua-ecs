xlib = xlib or {}

-- ==========================================================================
-- xlib.class
function class(super)
    if (type(super) == "string") then
        super = require(super); -- import model
    end
    if (super == nil) then
        super = {}
    end
    local class_type = {}
    class_type.ctor = false
    class_type.super = super
    class_type.new = function(...)
        local obj = {}
        setmetatable(obj, {
            __index = class_type,
            -- 5.2 or later.
            __gc = function()
                if (obj.dector) then
                    obj:dector()
                end
            end
        })
        do
            local create = nil
            local callsuper = nil
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.ctor then
                    c.ctor(obj, ...)
                end
            end
            create(class_type, ...)
        end
        return obj
    end
    if super then
        setmetatable(class_type, {
            __index = function(t, k)
                local ret = super[k]
                return ret
            end
        })
    end
    return class_type
end

-- ==========================================================================
-- table.extention
function table.indexof(_table, val)
    for pos, v in ipairs(_table) do
        if v == val then
            return pos, v;
        end
    end
    return -1, nil;
end

function table.remove_all_for_array(array)
    for _, v in ipairs(array) do
        table.remove(v)
    end
end

function table.remove_item(_table, val)
    local pos = -1;
    for _pos, v in ipairs(_table) do
        if v == val then
            pos = _pos
        end
    end
    table.remove(pos);
end

-- ==========================================================================
-- xlib.core
xlib.core = xlib.core or {}
xlib.core.base = class()
local base = xlib.core.base;
function base:ctor(...)
    self.is_xobj = true
end

function base:dector()
    for k, v in pairs(self) do
        self[k] = nil;
    end
end
------------------------------------------------
-- xlib.core.eventdispather
xlib.core.eventdispather = class(xlib.core.base)
local eventdispather = xlib.core.eventdispather
function eventdispather:ctor(...)
    self._events = {}
end

function eventdispather:addeventlistener(key, func, obj, unique)
    local pos, find = self:_findevent(key, func);
    if pos > 0 then
        return
    end
    local events = self._events;
    obj = obj or self
    -- 唯一性检查
    if unique then
        for _, evt in ipairs(events) do
            if (evt.k == key and evt.f == func and evt.o == obj) then
                return;
            end
        end
    end
    table.insert(events, {
        k = key,
        f = func,
        o = obj
    });
end

function eventdispather:_findevent(key, func)
    local events = self._events;
    for pos, v in ipairs(events) do
        if key == v.k and func == v.f and obj == v.o then
            return pos, v;
        end
    end
    return -1, nil;
end

function eventdispather:removelistener(key, func)
    local pos, find = self:_findevent(key, func)
    if pos > 0 then
        table.remove(self._events, pos)
    end
end

function eventdispather:dispatch(key, ...)
    local events = self._events;
    for i, v in ipairs(events) do
        if v.k == key then
            v.f(v.o, ...);
        end
    end
end

------------------------------------------------
-- loger
xlib.logger = class()
function xlib.logger:ctor()
    self._print = print;
    print = nil;
end

function xlib.logger:info(...)
    self._print("[INFO]", ...)
end

function xlib.logger:error(...)
    self._print("[ERROR]", ...)
    error(...);
end

function xlib.logger:fail(...)
    self._print("[FAIL]", ...)
end

function xlib.logger:assert(exp, des)
    if (exp == false) then
        self:error(des)
    end
end

--------------------------------------------------
-- memory
xlib.memory = xlib.memory or class()

function xlib.memory:monitor(func, name)
    local start = collectgarbage("count");
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    local ret = func();
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
    xlib.log:info(name .. "(memory leak):", collectgarbage("count") - start);
    return ret;
end

---------------------------------------------------
-- test
xlib.test = xlib.test or class()
function xlib.test:ctor()
    self._test = {}
end
function xlib.test:put(func, des)
    table.insert(self._test, {
        f = func,
        msg = des
    });
    return self;
end

function xlib.test:run()
    local memory = xlib.memory.new();
    local count, success, fail = #self._test, 0, 0
    for _, vt in ipairs(self._test) do
        if (not memory:monitor(vt.f, vt.msg)) then
            xlib.log:fail(vt.msg);
            fail = fail + 1
        else
            success = success + 1
        end
    end
    xlib.log:info(string.format("execute:%u success:%u fail:%u", count, success, fail));
    memory = nill
end

-- ==========================================================================
-- xlib.ecs
xlib.ecs = xlib.ecs or {}

xlib.ecs.context = class({})
local context = xlib.ecs.context;

function context:ctor(entity_type)
    self._entites = {}
    self._entity_type = entity_type;
end

function context:create_entity()
    local entity = self._entity_type.new();
    table.insert(self._entites, entity);
    return entity;
end

function context:create_collector(group_matchers, group_events)

end

function context:destroy_entity(entity)
    table.remove_item(self._entites, entity);
end

function context:has_entity(entity)
    local pos, val = table.indexof(entity)
    return pos > 0
end

function context:get_entites()
    return self._entites;
end

function context:get_group(matcher)
end

xlib.ecs.entity = class({})
local entity = xlib.ecs.entity
function entity:add(com)
end
function entity:remove(com)
end
function entity:replace(com)
end

xlib.ecs.component = class({})
local component = xlib.ecs.component
function component:ctor(t_id)
    self.tid = t_id
end

xlib.ecs.matcher = class({})
local matcher = xlib.ecs.matcher
function matcher:ctor(entites,compare_func)
    self._compare = compare_func
    self._entites = entites;
end

function matcher:get_entites()
    local entites = self._entites
    local compare = self._compare;
    local match_entites = {}
    for i, entity in ipairs(entites) do
        if(compare()) then
            table.insert(match_entites,entity)
        end
    end
end

xlib.ecs.system = class({})
local system = xlib.ecs.system
function system:ctor(name, context)
    self.name = name;
    self.context = context
    self._systems = {}
end

function system:iniztion()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        system:initialize();
    end
end
function system:execute()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        -- reactive_system _execute call execute.
        local exec = system._execute or system.execute;
        exec(system);
    end
end
function system:activate()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        system:activate();
    end
end
function system:deactivate()
    local systems = self._systems;
    for _, system in ipairs(systems) do
        system:deactivate();
    end
end
function system:clear()
    table.remove_all_for_array(self._systems);
end

xlib.ecs.reactive_system = class({})
local reactive_system = xlib.ecs.reactive_system

function reactive_system:ctor(name, context)
    self.name = name
    self.context = context
    self._execute_buf = {}
    self._collector = self:get_collector();
end

function reactive_system:get_collector()
    return context:create_collector({}, {});
end

function reactive_system:filter(entity)
    return true;
end

function reactive_system:_execute()
    local entities = self._execute_buf;
    local collect_entities = self._collector:get_collected_entities();
    for _, entity in ipairs(collect_entities) do
        if (self:filter(entity)) then
            table.insert(entities, entity)
        end
    end
    self:execute(entities);
    table.remove_all_for_array(entities);
end
function reactive_system:execute(entities)
    error("not execute implements for reactive_system.");
end
function reactive_system:activate()
    self._collector:activate();
end
function reactive_system:deactivate()
    self._collector:deactivate();
end
function reactive_system:clear()
    self._collector:clear();
end

xlib.ecs.group = class(xlib.core.eventdispather)
local group = xlib.ecs.group

group.event = group.event or {}
group.event.on_entity_added = 1
group.event.on_entity_removed = 2

function group:has_entity(entity)
end
function group:get_entites()
end

xlib.ecs.collector = class({})
local collector = xlib.ecs.collector;
function collector:ctor(groups, group_events)
    self._groups = groups;
    self._group_events = group_events;
    self._collectedEntities = {};
end
function collector:get_collected_entities()
end
function collector:activate(entities)
    local groups = self._groups
    for _, group in ipairs(groups) do
        group:removelistener(group.event.on_entity_added, self._add_entity)
        group:addeventlistener(group.event.on_entity_added, self._add_entity)
    end
end
function collector:deactivate(entities)
    local groups = self._groups
    for _, group in ipairs(groups) do
        group:removelistener(group.event.on_entity_added, self._add_entity)
    end
end
function collector:clear()
    table.remove_all(self._collectedEntities);
end

function collector:_add_entity(entity)
    local pos, _ = table.indexof(self._collectedEntities, entity)
    if (pos > 0) then
        return
    end
    table.insert(self._collectedEntities, entity);
end

function collector:_remove_enity(entity)
    table.remove_item(self._collectedEntities, entity);
end

-- -- ==========================================================================
-- -- xlib.unity
-- xlib.unity = xlib.unity or {}
-- xlib.unity.assets = class(xlib.core.eventdispather)
-- xlib.unity.application = class({})
-- xlib.unity.util = class({})

-- -- ==========================================================================
-- -- xlib.mvcvm
-- xlib.mvcvm = xlib.mvcvm or {}
-- -- xlib.mvcvm
-- xlib.mvcvm.base = class(xlib.core.eventdispather)
-- xlib.mvcvm.context = class(xlib.core.eventdispather)
-- xlib.mvcvm.application = class(xlib.core.eventdispather)
-- xlib.mvcvm.model = class(xlib.mvcvm.base)
-- xlib.mvcvm.view = class(xlib.mvcvm.base)
-- xlib.mvcvm.controller = class(xlib.mvcvm.base)
-- xlib.mvcvm.view_model = class(xlib.mvcvm.base)

--------------------------------------------------
-- check env.
xlib.log = xlib.logger.new();
xlib.log:assert(_VERSION == "Lua 5.2" or _VERSION == "Lua 5.3" or _VERSION == "Lua 5.4", "lua env must 5.2 or later") -- check env.
xlib.log:info(tostring(_VERSION)) -- out env

-- ==========================================================================
-- test class.

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
    self:add(com_player.new())
    self:add(com_player_info.new())
    self:add(com_player_view.new())
    self:add(com_remote_host.new())
end
-- end test entity

-- logic sysetm
local ui_init_system = class(xlib.ecs.system);
function ui_init_system:ctor()
    self._name = "ui_init_system"
end

local player_system = class(xlib.ecs.system);
function player_system:ctor()
    self.name = "player_system"
end

local ui_render_system = class(xlib.ecs.system);
function ui_render_system:ctor()
    self.name = "ui_render_system"
end

local ui_input_system = class(xlib.ecs.system);
function ui_input_system:ctor()
    self.name = "ui_input_system"
end

local ui_destory_system = class(xlib.ecs.system);
function ui_destory_system:ctor()
    self.name = "ui_input_system"
end

local network_connect_sytem = class(xlib.ecs.system);
function network_connect_sytem:ctor()
    self.name = "network_connect_sytem"
end

local network_write_system = class(xlib.ecs.system);
function network_write_system:ctor()
    self.name = "network_write_system"
end

local network_read_system = class(xlib.ecs.system);
function network_read_system:ctor()
    self.name = "network_read_system"
end

local ui_system = class(xlib.ecs.feature);
function ui_system:ctor()
    self.name = "ui_system"
    self:add(ui_init_system.new())
    self:add(ui_render_system.new())
    self:add(ui_input_system.new())
    self:add(ui_destory_system.new())
end

local network_system = class(xlib.ecs.feature);
function network_system:ctor()
    self.name = "network_system";
    self:add(network_connect_sytem.new())
    self:add(network_write_system.new())
    self:add(network_read_system.new())
end

local feature_test = class(xlib.ecs.feature)
function feature_test:ctor()
    self.name = "feature_test"
    self:add(ui_system.new())
    self:add(network_system.new())
end

-- function feature_test:dector()
--     feature_test.super.dector(self);
-- end

--------------------------------------------------
-- test case.
local test = xlib.test.new()
test:put(function()
    for i = 1, 100000, 1 do
        local com = xlib.ecs.component.new();
        com.id = 13;
        com.ref = {};
    end
    return true;
end, "class memory")

test:put(function()
    local feature = feature_test.new()
    feature:initialize();
    feature:execute();
    feature:cleanup();
    return true;
end, "ECS A")

test:put(function()
    local feature = feature_test.new()
    feature:initialize();
    feature:execute();
    feature:cleanup();
    return true;
end, "ECS B")

test:put(function()
    local feature = feature_test.new()
    feature:initialize();
    feature:execute();
    feature:cleanup();
    return true;
end, "ECS C")

test:put(function()
    local feature = feature_test.new()
    feature:initialize();
    feature:execute();
    feature:cleanup();
    return true;
end, "ECS D")
test:run()

return xlib.ecs
