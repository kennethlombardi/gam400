local MessageManager = {
	listeners = {},
	messageQueue = {},
	messageTypes = {},
}

function MessageManager:listen(messageType, callback)
	self.listeners[messageType] = self.listeners[messageType] or {};
	table.insert(self.listeners[messageType], callback);
end

function MessageManager:register(messageType)
	self.messageTypes[messageType] = messageType;
end

function MessageManager:send(messageType, payload)
	if self.messageTypes[messageType] == nil then
		print("Message type", messageType, "does not exist");
		return;
	end
	self.messageQueue[messageType] = self.messageQueue[messageType] or {};
	table.insert(self.messageQueue[messageType], payload);
end

function MessageManager:shutdown()
	self.listeners = nil;
	self.messageQueue = nil;
	self.messageTypes = nil;
end

function MessageManager:update(dt)
	for messageType, payload in pairs(self.messageQueue) do
		for _, callback in pairs(self.listeners[messageType]) do
			callback(payload)
		end
	end
	self.messageQueue = {};
end

MessageManager:register("GAME_INITIALIZED");
MessageManager:register("CLICKED_PLAY_BUTTON");

return MessageManager