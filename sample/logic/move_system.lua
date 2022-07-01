local move_system = class(xlib.ecs.reactive_system)

move_system.follow_entites = {
    game = to_class("sample.entites.game_entity"),
    input = to_class("sample.entites.input_entity")
}

function move_system:get_entites_collector()
    return self.context:get_collector_with_groups(move_system.follow_entites);
end

function move_system:filter(entity)
    return entity:is_type(move_system.follow_entites.game);
end

function move_system:execute(entites)
    for _, e in ipairs(entites) do
        local e_pos_com, e_speed_com = e.position, e.speed
        local x, y, z = e_pos_com.x + e.speed, e_pos_com.y, e_pos_com.z
        e.replace_postion(x, y, z);
    end
end

return move_system
