local input_system = class(xlib.ecs.system)

function input_system:ctor(name, context)
    self._input_data = 0;
    self._group = context:get_group_for_entites_class("sample.entites.input_entity");
end

function input_system:execute()
    -- set input data
    self._input_data = self._input_data + 1;
    -- modify entites
    local entites = self._group:get_entites();
    for _, e in ipairs(entites) do
        local com = e:get_com(input_component)
        e.replace_base_speed(self._input_data);
    end
end

return input_system
