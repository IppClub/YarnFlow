# YarnFlow: Yarn Spinner to Lua Compiler

## Description

YarnFlow is a compiler that translates Yarn Spinner scripts into Lua code and uses Lua as the script runtime, allowing you to seamlessly integrate interactive story elements from Yarn Spinner into Lua-based projects. Whether you're developing a game, an interactive app, or any Lua-powered project, YarnFlow simplifies the process of leveraging Yarn Spinner’s intuitive story-based scripting language with the power and flexibility of Lua.

## About YarnFlow

YarnFlow is a sub-project developed and maintained as part of the Dora SSR open-source game engine project. It provides a seamless way to integrate Yarn Spinner's narrative capabilities into Lua-based games and applications built with Dora SSR.

For more information about the Dora SSR game engine project, please visit [Dora SSR on GitHub](https://github.com/ippclub/dora-ssr).

## Key Features

- **Simple Integration:** Easily integrate interactive narratives into your Lua projects.
- **Easy Yarn Spinner to Lua Conversion:** Take your Yarn Spinner scripts and compiles them into clean, executable Lua code.
- **Compact & Extensible:** Designed to be compact and easy to extend with Lua functions.
- **Open-Source:** YarnFlow is an open-source project, welcoming contributions and improvements from the community.

## Installation

To install YarnFlow via LuaRocks:

```
luarocks install yarnflow
```

## Usage

1. Write your story using Yarn Spinner syntax.
2. Use YarnFlow to load your Yarn script in Lua.
3. Execute the loaded script with the yarnflow runner.

Example:

```lua
local yarnCode = [[
title: Start
---
<<set $heart to 0>>
Narrator: Hi, I'm the narrator for this beginner's guide!
Narrator: I'm talking to you with Yarn Spinner!
Narrator: What do you think of all this, then?
-> It's alright, I guess.
	<<set $heart to $heart - 1>>
	<<jump Alright>>
-> It's great. I love it.
	<<set $heart to $heart + 1>>
	<<jump Love>>
===

title: Alright
---
<<dot 4>>
Narrator: Well, that's not very nice.
Narrator: I'm trying my best here.
-> Are you really? I don't think so.
	<<set $heart to $heart - 1>>
	<<jump Alright>>
-> Oh, OK. I'm sorry.
	<<set $heart to $heart + 1>>
	<<jump Love>>
===

title: Love
---
<<dot 5>>
Narrator: Oh, you're too kind.
Narrator: I'm just doing my job.
-> You're doing a great job.
	<<set $heart to $heart + 2>>
	Narrator: Oh, stop it, you.
	Narrator: You're making me blush.
-> You're a natural.
	<<set $heart to $heart + 3>>
	Narrator: Oh, you.
	Narrator: I'm but a humble narrator.
===
]]

local yarnflow = require("yarnflow")
local variables = {}
local commands = {
	dot = function(count)
		print(("."):rep(count))
	end,
}
local runner = yarnflow(yarnCode, "Start", variables, commands)

local function printHeart()
	print("Heart: " .. variables.heart)
end

-- The advance function takes an optional integer representing the player's choice index.
-- For the first call or when no choice is needed, we pass nil.
local function advance(option)
	-- First, we call runner:advance(option) to get the next part of the Yarn script.
	-- This returns two values: an action type and a result.
	local action, result = runner:advance(option)
	-- Handle the result based on the action type.
	if action == "Text" then
		-- If the action is "Text", the result will be a TextResult object,
		-- containing the text and any associated markers (e.g., character names).
		-- Check the markers, extract the character's name (if present), and print the text.
		local characterName = ""
		local marks = result.marks
		if marks then
			for i = 1, #marks do
				local mark = marks[i]
				if mark.name == "char" then
					characterName = mark.attrs.name .. ": "
				end
			end
		end
		print(characterName .. result.text)
	elseif action == "Option" then
		-- If the action is "Option", the result will be an OptionResult object,
		-- containing one or more options. Iterate over the options and print them,
		-- allowing the player to select them later.
		for i, op in ipairs(result) do
			if op then
				print("[" .. tostring(i) .. "]: " .. op.text)
			end
		end
	else
		-- For other actions (like errors), print the result directly.
		print(result)
		-- If the action is nil, it means the story is finished.
		if action == nil then
			printHeart()
			os.exit(0)
		end
	end
end

-- Start the story
advance()

repeat
	local input = io.read()
	if input then
		advance(tonumber(input))
	end
until input == "exit"
```

## License

YarnFlow is released under the [MIT License](LICENSE).
