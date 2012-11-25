local UserDataManager = { userData = {} }
local FileSystem = require "FileSystem";
local ResourceManager = require "ResourceManager";

function UserDataManager:get(key)
    return self.userData[key];
end

function UserDataManager:set(key, value)
    self.userData[key] = value;
end

function UserDataManager:shutdown()
    local file = io.open("../userData/userData.lua", "wt");
    s = "deserialize (";
    file:write(s);
    s = pickle(self.userData);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();
end

function init()
    local userData = ResourceManager:load("UserData", "userData.lua");
    for k,v in pairs(userData) do 
        UserDataManager:set(k, v);
    end
end

init();

return UserDataManager