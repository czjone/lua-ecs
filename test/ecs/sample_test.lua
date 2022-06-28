local sample = class(xlib.core.test_base)

function sample:ctor(test)
    self._test = test
    self.name = "ecs test"
end

function sample:execute()
    local ecs_application = require("sample.ecs_application").new();
    ecs_application:dispatch_event(ecs_application.event.on_init);
    for i = 1, 10, 1 do
        ecs_application:dispatch_event(ecs_application.event.on_update);
    end
    ecs_application:dispatch_event(ecs_application.event.destory);
    return true;
end

return sample

