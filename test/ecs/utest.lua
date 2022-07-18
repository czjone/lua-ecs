local utest = class(xlib.core.test_base)

function utest:ctor(test)
    self._test = test
    self.name = "ecs unit test"
end

function utest:execute()

    local ret = true;

    ------------------------------------------------------------
    -- make component
    local make_component = xlib.ecs.component.make
    local position = make_component({"w", "x", "y", "z"})
    local movable = make_component({"speed"})
    local person = make_component({"name", "age"})

    ------------------------------------------------------------
    -- entity
    do
        local entity = xlib.ecs.entity.new()
        local make_value = xlib.ecs.component.make_value

        entity:activate()
        entity:add(position, nil, 1, 4, 5)
        ret = ret and self.test:expect_true(entity:has(position), "entity:has");
        ret = ret and self.test:expect_true(entity:has_any(position, person), "entity:has_any");

        local pos = entity:get(position)
        ret = ret and self.test:expect(pos.x, 1, "entity get pos.x");
        ret = ret and self.test:expect(pos.y, 4, "entity get pos.y");
        ret = ret and self.test:expect(pos.z, 5, "entity get pos.z");

        entity:add(person, {
            name = "solyess",
            age = 18
        })

        local p = entity:get(person)
        ret = ret and self.test:expect(p.name, "solyess", "entity get p.name");
        ret = ret and self.test:expect(p.age, 18, "entity get p.age");

        entity:replace(position, nil, 5, 6)
        entity:replace(person, {
            name = "wang"
        })

        ret = ret and self.test:expect(pos.x, 5, "entity get person.x  affer replace dynamic parameter");
        ret = ret and self.test:expect(pos.y, 6, "entity get person.y  affer replace dynamic parameter");
        ret = ret and self.test:expect(p.name, "wang", "entity get person.name affer replace with table");
        ret = ret and self.test:expect(p.age, 18, "entity get person.age affer replace with table");

        entity:remove(position)
        ret = ret and self.test:expect_false(entity:has(position), true, "entity:has after remove");

        entity:add(position)
        entity:add(movable, 0.56)
        ret = ret and self.test:expect_true(entity:has_all(position, movable), "entity:has_all")
        entity:remove(position)
        ret = ret and self.test:expect_false(entity:has_all(position, movable), "entity:has_all")
        ret = ret and self.test:expect_true(entity:has_any(position, movable), "entity:has_all")
        entity:remove(movable)
        ret = ret and self.test:expect_false(entity:has_any(position, movable), "entity:has_all")
    end

    -- ------------------------------------------------------------
    -- -- context
    do
        local _context = xlib.ecs.context.new()

        ret = ret and self.test:has_api(_context.create_entity, "check api:_context.create_entity")
        ret = ret and self.test:has_api(_context.has_entity, "check api:_context.has_entity")
        ret = ret and self.test:has_api(_context.destroy_entity, "check api:_context.destroy_entity")
        ret = ret and self.test:has_api(_context.get_group, "check api:_context.get_group")
        ret = ret and self.test:has_api(_context.set_unique_component, "check api:_context.set_unique_component")
        ret = ret and self.test:has_api(_context.get_unique_component, "check api:_context.get_unique_component")
        ret = ret and self.test:has_api(_context.entity_size, "check api:_context.entity_size")

        local _entity = _context:create_entity()

        ret = ret and self.test:expect_true(_context:has_entity(_entity), "_context has entity")
        ret = ret and self.test:expect(_context:entity_size(), 1, "_context entity_size")

        _context:destroy_entity(_entity)
        ret = ret and self.test:expect_false(_context:has_entity(_entity), "_context destroy entity")

        -- re use
        local _e2 = _context:create_entity()
        ret = ret and self.test:expect_true(_context:has_entity(_entity), "_context has entity")
        ret = ret and self.test:expect(_context:entity_size(), 1, "_context entity_size")

        local player = make_component({"id", "token", "nice_name"})

        _context:set_unique_component(player, {
            id = 101,
            token = "134ec41edf7c1d3de31dfe78cd134ec41edf7c1d3de31dfe78cd",
            nice_name = "player01"
        })
        local com = _context:get_unique_component(player)
        ret = ret and self.test:expect(com.id, 101, "_context get_unique_component")
        _context:destroy_entity(com)
        ret = ret and self.test:expect_false(_context:has_entity(player), "_context destroy")
    end

    -------------------------------------------
    -- matcher
    local matcher = xlib.ecs.matcher
    do
        local matcher_a = matcher.new(position);
        local matcher_b = matcher.new(position);
        local matcher_c = matcher.new(movable);
        local matcher_d = matcher.new(movable, position);

        ret = ret and self.test:expect_true(matcher_a == matcher_b, "matcher a == b")
        ret = ret and self.test:expect_false(matcher_a == matcher_c, "matcher a ~= c")
        ret = ret and self.test:expect_false(matcher_a == matcher_d, "matcher a ~= d")
    end

    ------------------------------------------------------------
    -- group

    do
        local _context = xlib.ecs.context.new()
        local _entity = _context:create_entity()

        _entity:add(movable, 1)

        local _matcher1 = matcher.new(movable)
        local _matcher2 = matcher.new(movable)
        local _matcher3 = matcher.new(movable, position)

        local _group = _context:get_group(_matcher1)
        local _group2 = _context:get_group(_matcher2)

        ret = ret and self.test:expect_true(_group == _group2, "group match result comparison")
        ret = ret and self.test:expect(_group:get_entites():size(), 1, "group match entites size")
        ret = ret and self.test:expect_true(_group:get_single_entity():has(movable), 1, "group match single_entity has")
        ret = ret and self.test:expect(_group:get_single_entity(), _entity, "group single_entity")

        _entity:replace(movable, 2)
        ret = ret and self.test:expect(_group:get_single_entity(), _entity, "group replace single_entity")

        _entity:remove(movable)
        ret = ret and self.test:expect(_group:get_single_entity(), _entity, "group remove single_entity")

        _entity:add(movable, 3)

        local _entity2 = _context:create_entity()
        _entity2:add(movable, 10)

        ret = ret and self.test:expect(_group:get_entites():size(), 2, "group match entites size")
        local entities = _group.entities

        ret = ret and self.test:expect_true(entities:has(_entity), "group has entity")
        ret = ret and self.test:expect_true(entities:has(_entity2), "group has entity")
    end
    ------------------------------------------------------------
    -- entity collector
    do
        local context = context.new()
        local collector = xlib.ecs.collector
        local group = context:get_group(matcher({position}))
        local pair = {}
        pair[group] = group.event.added | group.event.remove
        local collector = collector.new(pair)
        local _entity = context:create_entity()
        _entity:add(position, 1, 2, 3)
        lu.assertEquals(collector.entities:size(), 1)
        context:destroy_entity(_entity)
        lu.assertEquals(collector.entities:size(), 0)
        collector:clear_entities()
        collector:deactivate()
    end

    ------------------------------------------------------------
    --  etity index
    do
        local context = Context.new()
        local group = context:get_group(Matcher({Person}))
        local index = EntityIndex.new(Person, group, 'age')
        context:add_entity_index(index)
        local adam = context:create_entity()
        adam:add(Person, 'Adam', 42)
        local eve = context:create_entity()
        eve:add(Person, 'Eve', 42)

        local idx = context:get_entity_index(Person)
        local entities = idx:get_entities(42)

        assert(entities:has(adam))
        assert(entities:has(eve))
    end

    ------------------------------------------------------------
    --  example
    -------------------------------------------
    do
        local StartGame = class("StartGame")
        function StartGame:ctor(context)
            self.context = context
        end

        function StartGame:initialize()
            print("StartGame initialize")
            local entity = self.context:create_entity()
            entity:add(Movable, 123)
        end

        -------------------------------------------
        local EndSystem = class("EndSystem")
        function EndSystem:ctor(context)
            self.context = context
        end

        function EndSystem:tear_down()
            print("EndSystem tear_down")
        end

        -------------------------------------------
        local MoveSystem = class("MoveSystem", ReactiveSystem)

        function MoveSystem:ctor(context)
            MoveSystem.super.ctor(self, context)
        end

        local trigger = {{Matcher({Movable}), GroupEvent.ADDED | GroupEvent.UPDATE}}

        function MoveSystem:get_trigger()
            return trigger
        end

        function MoveSystem:filter(entity)
            return entity:has(Movable)
        end

        function MoveSystem:execute(es)
            es:foreach(function(e)
                print("ReactiveSystem: add entity with component Movable.", e)
            end)
        end

        local _context = Context.new()
        local systems = Systems.new()
        systems:add(StartGame.new(_context))
        systems:add(MoveSystem.new(_context))
        systems:add(EndSystem.new(_context))

        systems:initialize()

        systems:execute()

        systems:tear_down()
    end

    return true;
end

return utest

