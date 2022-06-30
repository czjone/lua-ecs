local move_system = class(xlib.ecs.reactive_system)

function move_system:get_entites_collector()
    local matcher = function(matcher, entity)
        return entity:is_type(sample.entites.game_entity) or entity:is_type(sample.entites.input_entity)
    end
    return self.context:get_entites_collector(matcher);
end

function move_system:filter(entity)
    return true;
end

function move_system:execute(entites)

end

return move_system
