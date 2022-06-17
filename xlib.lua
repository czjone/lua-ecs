xlib = xlib or {}

---------------------------------------------------
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

---------------------------------------------------
-- table.extention
function table.indexof(_table, val)
    for pos, v in ipairs(_table) do
        if v == val then
            return pos, v;
        end
    end
    return -1, nil;
end

---------------------------------------------------
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
---------------------------------------------------
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
---------------------------------------------------
xlib.ecs = xlib.ecs or {}
-- xlib.ecs.base
xlib.ecs.base = class(xlib.core.eventdispather)
local ecsbase = xlib.ecs.base;
function ecsbase:ctor(context)
    self._context = context;
end

function ecsbase:getcontext()
    return self._context
end

-- xlib.ecs.entity
xlib.ecs.entity = class(xlib.ecs.base)
local entity = xlib.ecs.entity
entity.event = {
    on_add_component = 1,
    on_remove_component = 2,
    on_replace_component = 3,
    on_release_entity = 4,
    on_destroy_entity = 5
}
function entity:ctor()
    self._coms = {}
end
function entity:dector()
    self:dispatch(self.event.on_destroy_entity);
    entity.super.dector(self)
end
function entity:add(com)
    table.insert(self._coms, com);
    self:dispatch(self.event.on_add_component, com);
    return self;
end

function entity:replace(com)
    local index, val = table.indexof(self._coms, com);
    if val ~= com then
        self._coms[index] = com;
        self:dispatch(self.event.on_add_component, com);
    end
    return self;
end

-- xlib.ecs.component
xlib.ecs.component = class(xlib.ecs.base)
local component = xlib.ecs.component
function component:ctor()
    self._typeid = -1;
end

-- xlib.ecs.componentPool
xlib.ecs.component_pool = class(xlib.ecs.base)
local component_pool = xlib.ecs.component_pool
function component_pool:ctor()
    self._pool = {}
end

function component_pool:put(component)
    local pool = self._pool[component._typeid];
    if pool == nil then
        pool = {};
        self._pool[component._typeid] = pool;
    end
    table.indexof(pool, component)
    return self;
end

function component_pool:get(component)
    local pool = self._pool[component._typeid];
    if pool ~= nil and #pool > 0 then
        local ret = pool[#pool];
        table.remove(pool, #pool);
        return ret;
    end
    return nil;
end

-- xlib.ecs.system
xlib.ecs.system = class(xlib.ecs.base)
local system = xlib.ecs.system;

function system:ctor(name)
    self._name = name
    self._inited = false
    self._child_system = {}
end

function system:add(sys)
    table.insert(self._child_system, sys)
    return self;
end

function system:remove(sys)
    local type = type(sys)
    local is_table = type == "table"
    local is_string = type == "string"
    for i = #self._child_system, 1, -1 do
        local _sys = self._child_system[i];
        if (is_table and _sys == sys) or (is_string and _sys._name == sys._name) then
            table.remove(self._child_system, i);
        end
    end
end

function system:initialize()
    for _, sys in pairs(self._child_system) do
        if not sys._inited then
            sys:initialize();
        end
    end
end

function system:execute()
    if not self._inited then
        self:initialize();
    end
    for _, sys in pairs(self._child_system) do
        sys:execute();
    end
end

function system:cleanup()
    for _, sys in pairs(self._child_system) do
        sys:cleanup();
    end
    self._child_system = nil
end

-- xlib.ecs.feature
xlib.ecs.feature = class(xlib.ecs.system)
local feature = xlib.ecs.feature

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

xlib.log = xlib.logger.new();
-- check env.
xlib.log:assert(_VERSION == "Lua 5.2" or _VERSION == "Lua 5.3" or _VERSION == "Lua 5.4", "lua env must 5.2 or later")
-- out env
xlib.log:info(tostring(_VERSION))
--------------------------------------------------
-- memory
xlib.memory = xlib.memory or class()

function xlib.memory:monitor(func, name)
    local start = collectgarbage("count");
    collectgarbage("collect")
    local ret = func();
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
function xlib.test:put(exp, des)
    table.insert(self._test, {
        f = exp,
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

--------------------------------------------------
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
xlib.test.new():put(function()
    return true;
end, "class"):put(function()
    return true;
end, "loger"):put(function()
    local loop = 3 -- min = 1
    local feature = xlib.ecs.feature.new()
    feature:add(ui_system.new()):add(network_system.new())
    feature:initialize();
    for i = 1, loop, 1 do
        feature:execute()
    end
    feature:cleanup();
    return true;
end, "ecs"):run()

return xlib.ecs
