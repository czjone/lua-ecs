-- suports lua environment
xlib.core.environment = xlib.core.environment or class();
local environment = xlib.core.environment

function environment:ctor()
    self._suports = {"Lua 5.2", "Lua 5.3", "Lua 5.4", "Lua 5.5"}
    -- self._suports = {"Lua 5.4", "Lua 5.5"}
    self._lua_version = tostring(_VERSION);
end

function environment:check()
    local is_support = false
    local lua_version = self._lua_version;
    local suports = self._suports
    for _, v in ipairs(suports) do
        if (v == lua_version) then
            is_support = true;
            break
        end
    end

    if not is_support then
        error("lua env must " .. self._suports[1] .. " or later,current runtime:" .. lua_version);
    end
end
return environment;
