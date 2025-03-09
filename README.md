# YarnFlow: Yarn Spinner to Lua Compiler

[![IppClub](https://img.shields.io/badge/IppClub-Certified-11A7E2?logo=data%3Aimage%2Fsvg%2Bxml%3Bcharset%3Dutf-8%3Bbase64%2CPHN2ZyB2aWV3Qm94PSIwIDAgMjg4IDI3NCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWw6c3BhY2U9InByZXNlcnZlIiBzdHlsZT0iZmlsbC1ydWxlOmV2ZW5vZGQ7Y2xpcC1ydWxlOmV2ZW5vZGQ7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS1taXRlcmxpbWl0OjIiPjxwYXRoIGQ9Im0xNDYgMzEgNzIgNTVWMzFoLTcyWiIgc3R5bGU9ImZpbGw6I2Y2YTgwNjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0xNjkgODYtMjMtNTUgNzIgNTVoLTQ5WiIgc3R5bGU9ImZpbGw6I2VmN2EwMDtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Ik0yNiAzMXY1NWg4MEw4MSAzMUgyNloiIHN0eWxlPSJmaWxsOiMwN2ExN2M7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMTA4IDkydjExMmwzMS00OC0zMS02NFoiIHN0eWxlPSJmaWxsOiNkZTAwNWQ7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMCAyNzR2LTUyaDk3bC0zMyA1MkgwWiIgc3R5bGU9ImZpbGw6I2Y2YTgwNjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im03NyAyNzQgNjctMTA3djEwN0g3N1oiIHN0eWxlPSJmaWxsOiNkZjI0MzM7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMTUyIDI3NGgyOWwtMjktNTN2NTNaIiBzdHlsZT0iZmlsbDojMzM0ODVkO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTE5MSAyNzRoNzl2LTUySDE2N2wyNCA1MloiIHN0eWxlPSJmaWxsOiM0ZTI3NWE7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMjg4IDEwMGgtMTdWODVoLTEzdjE1aC0xN3YxM2gxN3YxNmgxM3YtMTZoMTd2LTEzWiIgc3R5bGU9ImZpbGw6I2M1MTgxZjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0yNiA4NiA1Ni01NUgyNnY1NVoiIHN0eWxlPSJmaWxsOiMzMzQ4NWQ7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNOTMgMzFoNDJsLTMwIDI5LTEyLTI5WiIgc3R5bGU9ImZpbGw6IzExYTdlMjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Ik0xNTggMTc2Vjg2bC0zNCAxNCAzNCA3NloiIHN0eWxlPSJmaWxsOiMwMDU5OGU7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJtMTA2IDU5IDQxLTEtMTItMjgtMjkgMjlaIiBzdHlsZT0iZmlsbDojMDU3Y2I3O2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0ibTEyNCAxMDAgMjItNDEgMTIgMjctMzQgMTRaIiBzdHlsZT0iZmlsbDojNGUyNzVhO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0ibTEwNiA2MCA0MS0xLTIzIDQxLTE4LTQwWiIgc3R5bGU9ImZpbGw6IzdiMTI4NTtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0xMDggMjA0IDMxLTQ4aC0zMXY0OFoiIHN0eWxlPSJmaWxsOiNiYTAwNzc7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJtNjUgMjc0IDMzLTUySDBsNjUgNTJaIiBzdHlsZT0iZmlsbDojZWY3YTAwO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTc3IDI3NGg2N2wtNDAtNDUtMjcgNDVaIiBzdHlsZT0iZmlsbDojYTgxZTI0O2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTE2NyAyMjJoNThsLTM0IDUyLTI0LTUyWiIgc3R5bGU9ImZpbGw6IzExYTdlMjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0yNzAgMjc0LTQ0LTUyLTM1IDUyaDc5WiIgc3R5bGU9ImZpbGw6IzA1N2NiNztmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Ik0yNzUgNTVoLTU3VjBoMjV2MzFoMzJ2MjRaIiBzdHlsZT0iZmlsbDojZGUwMDVkO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTE4NSAzMWg1N3Y1NWgtMjVWNTVoLTMyVjMxWiIgc3R5bGU9ImZpbGw6I2M1MTgxZjtmaWxsLXJ1bGU6bm9uemVybyIvPjwvc3ZnPg%3D%3D&labelColor=fff)](https://ippclub.org)

## Description

YarnFlow is a compiler that translates Yarn Spinner scripts into Lua code and uses Lua as the script runtime, allowing you to seamlessly integrate interactive story elements from Yarn Spinner into Lua-based projects. Whether you're developing a game, an interactive app, or any Lua-powered project, YarnFlow simplifies the process of leveraging Yarn Spinner’s intuitive story-based scripting language with the power and flexibility of Lua.

## About YarnFlow

YarnFlow is a sub-project developed and maintained as part of the Dora SSR open-source game engine project. It provides a seamless way to integrate Yarn Spinner's narrative capabilities into Lua-based games and applications built with Dora SSR.

For more information about the Dora SSR game engine project, please visit [Dora SSR on GitHub](https://github.com/ippclub/dora-ssr).

And there is a visual novel framework built on top of Dora SSR showing the power of YarnFlow, you can visit [Dora Story](https://github.com/ippclub/dora-story) for more information.

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

Or you can build `yarnflow.so` file with

```bash
make LUAI=/your-path/lua/include LUAL=/your-path/lua/lib
```

Then get the binary file from path `lib/yarnflow.so`.

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
local variables = {
  heart = 0,
}
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
