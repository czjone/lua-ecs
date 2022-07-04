local init_system = class(xlib.ecs.system)

function init_system:initialize()
    init_system.super.initialize(self);
    self.context:create_entity("sample.entites.game_entity")
    self.context:create_entity("sample.entites.input_entity")
end

return init_system
