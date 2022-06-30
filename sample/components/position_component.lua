local position_component = class(xlb.ecs.component)
-- set entites
position_component.entites = {"input", "game"}
-- set data
position_component.x = 0;
position_component.y = 0;
position_component.z = 0;

return position_component
