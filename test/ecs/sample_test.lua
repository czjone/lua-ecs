local sample = class(xlib.core.test_base)

function sample:ctor(test)
    self._test = test
    self.name = "ecs test"
end

function sample:execute()
    local world_class = require("sample.ecs_world")
    local app = world_class.new();
    
    local app_event = app.event
    app:dispatch_event(app_event.on_init);
    for i = 1, 10, 1 do
        app:dispatch_event(app_event.on_update);
    end
    app:dispatch_event(app_event.destory);
    return true;
end

return sample

