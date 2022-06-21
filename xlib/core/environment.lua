-- suports lua environment
local suports = {
    "Lua 5.2",
    "Lua 5.3",
    "Lua 5.4",
    "Lua 5.5",
}
local lua_version = tostring(_VERSION);

log:info(tostring(_VERSION))

local is_support = false
for _, v in ipairs(suports) do
    if(v == lua_version) then
        is_support = true;
        break;
    end
end

log:assert(is_support, "lua env must 5.2 or later") 
