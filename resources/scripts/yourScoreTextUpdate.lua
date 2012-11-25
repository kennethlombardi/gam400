local Script = {
	name = "yourScoreTextUpdate.lua",
};

userData = require("UserDataManager");

function Script.update(prop, dt)
    prop:setText(string.format('Your Score: %d', userData:get("currentScore")));
end

return Script;