-- [yue]: YarnDev/YarnFlow.yue
local tonumber = _G.tonumber -- 1
local tostring = _G.tostring -- 1
local error = _G.error -- 1
local setmetatable = _G.setmetatable -- 1
local coroutine = _G.coroutine -- 1
local load = _G.load -- 1
local pairs = _G.pairs -- 1
local getmetatable = _G.getmetatable -- 1
local math = _G.math -- 1
local _module_0 = nil -- 1
local rewriteError -- 9
rewriteError = function(err, luaCode, title) -- 9
	local line, msg = err:match(".*:(%d+):%s*(.*)") -- 10
	line = tonumber(line) -- 11
	local current = 1 -- 12
	local lastLine = 1 -- 13
	local lineMap = { } -- 14
	for lineCode in luaCode:gmatch("([^\r\n]*)\r?\n?") do -- 15
		local num = lineCode:match("--%s*(%d+)%s*$") -- 16
		if num then -- 17
			lastLine = tonumber(num) -- 17
		end -- 17
		lineMap[current] = lastLine -- 18
		current = current + 1 -- 19
	end -- 19
	line = lineMap[line] or line -- 20
	return tostring(title) .. ":" .. tostring(line) .. ": " .. tostring(msg) -- 21
end -- 9
local extractYarnText -- 23
extractYarnText = function(yarnCode) -- 23
	local nodes = { } -- 24
	local count = 1 -- 25
	for body in yarnCode:gmatch("(.-)%s*===%s*(.-)$") do -- 26
		local meta, nodeBody = body:match("(.-)%s*---%s*\n(.*)") -- 27
		if meta and nodeBody then -- 28
			local title = meta:match("title%s*:%s*(%S+)") -- 29
			local node = { -- 30
				title = title, -- 30
				body = nodeBody:match("^%s*(.-)%s*$") -- 30
			} -- 30
			nodes[#nodes + 1] = node -- 31
		else -- 33
			error("missing title for node " .. tostring(count)) -- 33
		end -- 28
		count = count + 1 -- 34
	end -- 34
	return nodes -- 34
end -- 23
local YarnRunner -- 36
do -- 36
	local _class_0 -- 36
	local _base_0 = { -- 36
		gotoStory = function(self, title) -- 37
			local storyFunc = self.funcs[title] -- 38
			if not storyFunc then -- 39
				local yarnCode = self.codes[title] -- 40
				if not yarnCode then -- 41
					local err = "node \"" .. tostring(title) .. "\" is not exist" -- 42
					if self.startTitle then -- 43
						return false, err -- 44
					else -- 46
						coroutine.yield("Error", err) -- 46
						return -- 47
					end -- 43
				end -- 41
				local luaCode, err = self.__class.compile(yarnCode) -- 48
				if not luaCode then -- 49
					if self.startTitle then -- 50
						return false, tostring(title) .. ":" .. tostring(err) -- 51
					else -- 53
						coroutine.yield("Error", tostring(title) .. ":" .. tostring(err)) -- 53
						return -- 54
					end -- 50
				end -- 49
				self.codes[title] = luaCode -- 55
				local luaFunc -- 56
				luaFunc, err = load(luaCode, title) -- 56
				if not luaFunc then -- 57
					err = rewriteError(err, luaCode, title) -- 58
					if self.startTitle then -- 59
						return false, err -- 60
					else -- 62
						coroutine.yield("Error", err) -- 62
						return -- 63
					end -- 59
				end -- 57
				storyFunc = luaFunc() -- 64
				self.funcs[title] = storyFunc -- 65
			end -- 39
			local visitedCount -- 66
			do -- 66
				local _exp_0 = self.visited[title] -- 66
				if _exp_0 ~= nil then -- 66
					visitedCount = _exp_0 -- 66
				else -- 66
					visitedCount = 0 -- 66
				end -- 66
			end -- 66
			self.visited[title] = 1 + visitedCount -- 67
			do -- 68
				local _obj_0 = self.stories -- 68
				_obj_0[#_obj_0 + 1] = { -- 68
					title, -- 68
					coroutine.create(function() -- 68
						return storyFunc(title, self.state, self.command, self.yarn, (function() -- 69
							local _base_1 = self -- 69
							local _fn_0 = _base_1.gotoStory -- 69
							return _fn_0 and function(...) -- 69
								return _fn_0(_base_1, ...) -- 69
							end -- 69
						end)()) -- 69
					end) -- 68
				} -- 68
			end -- 70
			return true -- 71
		end, -- 99
		advance = function(self, choice) -- 99
			if self.startTitle then -- 100
				local success, err = self:gotoStory(self.startTitle) -- 101
				self.startTitle = nil -- 102
				if not success then -- 103
					return "Error", err -- 103
				end -- 103
			end -- 100
			if choice then -- 104
				if not self.option then -- 105
					return "Error", "there is no option to choose" -- 106
				end -- 105
				local title, branches -- 107
				do -- 107
					local _obj_0 = self.option -- 107
					title, branches = _obj_0.title, _obj_0.branches -- 107
				end -- 107
				if not (1 <= choice and choice <= #branches) then -- 108
					return "Error", "choice " .. tostring(choice) .. " is out of range" -- 109
				end -- 108
				local optionBranch = branches[choice] -- 110
				self.option = nil -- 111
				local _obj_0 = self.stories -- 112
				_obj_0[#_obj_0 + 1] = { -- 112
					title, -- 112
					coroutine.create(optionBranch) -- 112
				} -- 112
			elseif self.option then -- 113
				return "Error", "required a choice to continue" -- 114
			end -- 104
			local title -- 115
			local success, resultType, body, branches -- 116
			do -- 116
				local storyItem = self.stories[#self.stories] -- 116
				if storyItem then -- 116
					local story -- 117
					title, story = storyItem[1], storyItem[2] -- 117
					success, resultType, body, branches = coroutine.resume(story) -- 118
				end -- 116
			end -- 116
			if not success and #self.stories > 0 then -- 119
				self.stories = { } -- 120
				local err = rewriteError(resultType, self.codes[title], title) -- 121
				return "Error", err -- 122
			end -- 119
			if not resultType then -- 123
				if #self.stories > 0 then -- 124
					self.stories[#self.stories] = nil -- 125
					return self:advance() -- 126
				end -- 124
			end -- 123
			if "Dialog" == resultType then -- 128
				return "Text", body -- 129
			elseif "Option" == resultType then -- 130
				self.option = { -- 131
					title = title, -- 131
					branches = branches -- 131
				} -- 131
				return "Option", body -- 132
			elseif "Goto" == resultType then -- 133
				return self:advance() -- 134
			elseif "Command" == resultType then -- 135
				return "Command", body -- 136
			elseif "Error" == resultType or "Stop" == resultType then -- 137
				self.stories = { } -- 138
				return "Error", body -- 139
			else -- 141
				return nil, "end of the story" -- 141
			end -- 141
		end -- 36
	} -- 36
	if _base_0.__index == nil then -- 36
		_base_0.__index = _base_0 -- 36
	end -- 141
	_class_0 = setmetatable({ -- 36
		__init = function(self, yarnCode, startTitle, state, command) -- 73
			local nodes = extractYarnText(yarnCode) -- 74
			if not (#nodes > 0) then -- 75
				error("failed to load yarn code") -- 75
			end -- 75
			self.codes = { } -- 77
			self.funcs = { } -- 78
			self.state = state -- 79
			do -- 81
				local _tab_0 = { -- 81
					stop = function() -- 81
						return coroutine.yield("Stop") -- 81
					end -- 81
				} -- 82
				local _idx_0 = 1 -- 82
				for _key_0, _value_0 in pairs(command) do -- 82
					if _idx_0 == _key_0 then -- 82
						_tab_0[#_tab_0 + 1] = _value_0 -- 82
						_idx_0 = _idx_0 + 1 -- 82
					else -- 82
						_tab_0[_key_0] = _value_0 -- 82
					end -- 82
				end -- 82
				self.command = _tab_0 -- 81
			end -- 81
			setmetatable(self.command, getmetatable(command)) -- 84
			self.stories = { } -- 85
			self.visited = { } -- 86
			self.yarn = { -- 88
				dice = function(num) -- 88
					return math.random(num) -- 88
				end, -- 88
				random = function() -- 89
					return math.random() -- 89
				end, -- 89
				random_range = function(start, stop) -- 90
					return math.random(start, stop) -- 90
				end, -- 90
				visited = function(name) -- 91
					return (self.visited[name] ~= nil) -- 91
				end, -- 91
				visited_count = function(name) -- 92
					local _exp_0 = self.visited[name] -- 92
					if _exp_0 ~= nil then -- 92
						return _exp_0 -- 92
					else -- 92
						return 0 -- 92
					end -- 92
				end -- 92
			} -- 87
			self.startTitle = startTitle -- 94
			for _index_0 = 1, #nodes do -- 95
				local node = nodes[_index_0] -- 95
				local title, body = node.title, node.body -- 96
				self.codes[title] = body -- 97
			end -- 97
		end, -- 36
		__base = _base_0, -- 36
		__name = "YarnRunner" -- 36
	}, { -- 36
		__index = _base_0, -- 36
		__call = function(cls, ...) -- 36
			local _self_0 = setmetatable({ }, _base_0) -- 36
			cls.__init(_self_0, ...) -- 36
			return _self_0 -- 36
		end -- 36
	}) -- 36
	_base_0.__class = _class_0 -- 36
	YarnRunner = _class_0 -- 36
end -- 141
_module_0 = function(mod) -- 143
	YarnRunner.__class.compile = mod.compile -- 144
	setmetatable(mod, { -- 145
		__call = function(_self, yarnCode, startTitle, state, command) -- 145
			if state == nil then -- 145
				state = { } -- 145
			end -- 145
			if command == nil then -- 145
				command = { } -- 145
			end -- 145
			return YarnRunner(yarnCode, startTitle, state, command) -- 146
		end -- 145
	}) -- 145
end -- 143
return _module_0 -- 146
