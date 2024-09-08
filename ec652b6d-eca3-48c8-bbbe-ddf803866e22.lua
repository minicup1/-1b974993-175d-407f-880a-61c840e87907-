local commands = {
	["BB Byte Method"] = function(obj)
		local code = obj.Source

		local thing = code

		local encode = thing:gsub(".", function(bb) return "\\" .. bb:byte() end) or thing .. "\\"

		return `loadstring("{encode}")()`
	end,
	["LuaSeel"] = function(obj)
		local code = obj.Source
		
		local function Obfuscate(b)
			local c = "function IllIlllIllIlllIlllIlllIll(IllIlllIllIllIll) if (IllIlllIllIllIll==(((((919 + 636)-636)*3147)/3147)+919)) then return not true end if (IllIlllIllIllIll==(((((968 + 670)-670)*3315)/3315)+968)) then return not false end end; "
			local d = c
			local e = ""
			local f = {"IllIllIllIllI","IIlllIIlllIIlllIIlllII","IIllllIIllll"}
			local g = [[local IlIlIlIlIlIlIlIlII = {]]
			local h = [[local IllIIllIIllIII = loadstring]]
			local i = [[local IllIIIllIIIIllI = table.concat]]
			local j = [[local IIIIIIIIllllllllIIIIIIII = "''"]]
			local k = "local "..f[math.random(1,#f)].." = (7*3-9/9+3*2/0+3*3);"
			local l = "local "..f[math.random(1,#f)].." = (3*4-7/7+6*4/3+9*9);"
			local m = "--// Obfuscated with LuaSeel 1.1 \n\n"
			for n=1,string.len(b) do
				e = e.."'\\"..string.byte(b,n).."',"
			end
			local o = "function IllIIIIllIIIIIl("..f[math.random(1,#f)]..")"
			local p = "function "..f[math.random(1,#f)].."("..f[math.random(1,#f)]..")"
			local q = "local "..f[math.random(1,#f)].." = (5*3-2/8+9*2/9+8*3)"
			local r = "end"
			local s = "IllIIIIllIIIIIl(900283)"
			local t = "function IllIlllIllIlllIlllIlllIllIlllIIIlll("..f[math.random(1,#f)]..")"
			local q = "function "..f[math.random(1,#f)].."("..f[math.random(1,#f)]..")"
			local u = "local "..f[math.random(1,#f)].." = (9*0-7/5+3*1/3+8*2)"
			local v = "end"
			local w = "IllIlllIllIlllIlllIlllIllIlllIIIlll(9083)"
			local x = m..d..k..l..i..";"..o.." "..p.." "..q.." "..r.." "..r.." "..r..";"..s..";"..t.." "..q.." "..u.." "..v.." "..v..";"..w..";"..h..";"..g..e.."}".."IllIIllIIllIII(IllIIIllIIIIllI(IlIlIlIlIlIlIlIlII,IIIIIIIIllllllllIIIIIIII))()"

			return x
		end

		local obfuscatedCode = Obfuscate(code)

		return obfuscatedCode
	end,
	["Rename Variable"] = function(obj)
		local code = obj.Source

		-- Function to rename variables
		local function renameVariables(code)
			local varMap = {}
			local varCounter = 0

			-- Generate a new variable name (e.g., v1, v2, etc.)
			local function generateVarName()
				varCounter = varCounter + 1
				return "v" .. varCounter
			end

			-- Patterns for local variable declarations and function definitions
			local declarationPattern = "local%s+([%w_]+)%s*="
			local functionPattern = "local%s+function%s+([%w_]+)%s*%("

			-- Lua keywords that should not be renamed
			local luaKeywords = {
				["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true,
				["end"] = true, ["false"] = true, ["for"] = true, ["function"] = true, ["if"] = true,
				["in"] = true, ["local"] = true, ["nil"] = true, ["not"] = true, ["or"] = true,
				["repeat"] = true, ["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
				["while"] = true
			}

			-- Collect all variable and function names that need renaming
			for varName in code:gmatch(declarationPattern) do
				if not varMap[varName] and not luaKeywords[varName] then
					varMap[varName] = generateVarName()
				end
			end

			for funcName in code:gmatch(functionPattern) do
				if not varMap[funcName] and not luaKeywords[funcName] then
					varMap[funcName] = generateVarName()
				end
			end

			-- Replace all variable and function names in the code with the new names
			code = code:gsub("([%w_]+)", function(name)
				return varMap[name] or name
			end)

			return code
		end

		-- Rename variables in the provided code
		local renamedCode = renameVariables(code)

		return renamedCode
	end,
	["Minify Code"] = function(obj)
		local code = obj.Source

		-- Function to minify the code
		local function minifyCode(code)
			-- Remove comments (both single-line and block comments)
			code = code:gsub("%-%-%[%[.-%]%]", "") -- Remove block comments
			code = code:gsub("%-%-.-\n", "") -- Remove single-line comments

			-- Remove unnecessary whitespace (leading/trailing spaces and extra spaces between tokens)
			code = code:gsub("%s+", " ") -- Replace multiple spaces with a single space
			code = code:gsub("%s*([%(%),=%+%-%*/{}%[%]])%s*", "%1") -- Remove spaces around symbols

			-- Remove unnecessary newlines
			code = code:gsub("\n+", "") -- Remove all newlines
			code = code:gsub("^%s+", "") -- Remove leading whitespace
			code = code:gsub("%s+$", "") -- Remove trailing whitespace

			return code
		end

		-- Minify the provided code
		local minifiedCode = minifyCode(code)

		return minifiedCode
	end,
	["Remove Comments"] = function(obj)
		local code = obj.Source

		-- Function to remove comments from code, without affecting strings
		local function removeComments(code)
			local inString = false
			local escaped = false
			local result = ""
			local i = 1

			while i <= #code do
				local char = code:sub(i, i)
				local nextChar = code:sub(i + 1, i + 1)

				-- Handle string start/end, taking escape characters into account
				if char == '"' and not escaped then
					inString = not inString
					result = result .. char
				elseif char == "\\" and not escaped then
					-- Handle escape sequences (e.g., \", \n)
					escaped = true
					result = result .. char
				else
					escaped = false

					-- Handle comments only when we're not inside a string
					if not inString then
						-- Block comment (e.g., --[[ comment ]])
						if char == "-" and nextChar == "-" then
							if code:sub(i + 2, i + 3) == "[[" then
								-- Skip block comment
								local commentEnd = code:find("%]%]", i + 4) or #code
								i = commentEnd + 2
							else
								-- Skip single-line comment
								local commentEnd = code:find("\n", i + 2) or #code
								i = commentEnd
							end
						else
							result = result .. char
						end
					else
						result = result .. char
					end
				end
				i = i + 1
			end

			-- Trim leading/trailing whitespace from the final result
			result = result:gsub("^%s+", ""):gsub("%s+$", "")

			return result
		end

		-- Remove comments from the provided code
		local codeWithoutComments = removeComments(code)

		return [[-- CLICK FORMAT SELECTION IN SCRIPT SECTION AND FORMAT DOCUMENT
		]]..codeWithoutComments
	end,
}

return commands
