-- -- ==========================================================================
-- -- xlib.ecs
xlib.ecs = xlib.ecs or {}
xlib.ecs.contexts = class({})
local contexts = xlib.ecs.contexts;

function contexts:ctor()
    self._contexts = {}
    self._entites = {}
end

function contexts:get_contexts()
    return self._contexts;
end

function contexts:_create(context_class)
    local name = context_class.name
    if self._contexts[name] then
        log:error("Add context to contexts repeatedly.");
    end
    self._contexts[name] = context_class.new();
    return self._contexts[name];
end

function contexts:get_context(name)
    return self._contexts[name];
end
