local speed_component = class(xlb.ecs.component)
-- set entites
speed_component.entites = {"input", "game"}
-- set data
speed_component.speed = 0;
speed_component.acceleration = 0;

return speed_component
