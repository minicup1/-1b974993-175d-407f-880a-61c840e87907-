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

		local function renameVariables(code)
			local varMap = {}
			local varCounter = 0

			local function generateVarName()
				varCounter = varCounter + 1
				return "v" .. varCounter
			end

			local declarationPattern = "local%s+([%w_]+)%s*="
			local functionPattern = "local%s+function%s+([%w_]+)%s*%("

			local luaKeywords = {
				["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true,
				["end"] = true, ["false"] = true, ["for"] = true, ["function"] = true, ["if"] = true,
				["in"] = true, ["local"] = true, ["nil"] = true, ["not"] = true, ["or"] = true,
				["repeat"] = true, ["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
				["while"] = true
			}

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

			code = code:gsub("([%w_]+)", function(name)
				return varMap[name] or name
			end)

			return code
		end

		local renamedCode = renameVariables(code)

		return renamedCode
	end,
	["Minify Code"] = function(obj)
		local code = obj.Source

		local function minifyCode(code)
			code = code:gsub("%-%-%[%[.-%]%]", "") 			code = code:gsub("%-%-.-\n", "") 
			code = code:gsub("%s+", " ") 			code = code:gsub("%s*([%(%),=%+%-%*/{}%[%]])%s*", "%1") 
			code = code:gsub("\n+", "") 			code = code:gsub("^%s+", "") 			code = code:gsub("%s+$", "") 
			return code
		end

		local minifiedCode = minifyCode(code)

		return minifiedCode
	end,
	["Remove Comments"] = function(obj)
		local code = obj.Source

		local function removeComments(code)
			local inString = false
			local escaped = false
			local result = ""
			local i = 1

			while i <= #code do
				local char = code:sub(i, i)
				local nextChar = code:sub(i + 1, i + 1)

				if char == '"' and not escaped then
					inString = not inString
					result = result .. char
				elseif char == "\\" and not escaped then
					-- Handle escape sequences (e.g., \", \n)
					escaped = true
					result = result .. char
				else
					escaped = false

					if not inString then
						if char == "-" and nextChar == "-" then
							if code:sub(i + 2, i + 3) == "[[" then
								local commentEnd = code:find("%]%]", i + 4) or #code
								i = commentEnd + 2
							else
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

			result = result:gsub("^%s+", ""):gsub("%s+$", "")

			return result
		end

		local codeWithoutComments = removeComments(code)

		return [[-- CLICK FORMAT SELECTION IN SCRIPT SECTION AND FORMAT DOCUMENT
		]]..codeWithoutComments
	end,
	["Beautify Code"] = function(obj)
	    local code = obj.Source
	
	    local function beautifyCode(code)
	        -- Remove leading/trailing spaces
	        code = code:gsub("^%s+", "")
	        code = code:gsub("%s+$", "")
	
	        -- Ensure there is exactly one space around operators
	        code = code:gsub("([%+%-%*/%%<>~!=])%s*", " %1 ") -- handles + - * / % < > ~ !=
	        code = code:gsub("%s*([%+%-%*/%%<>~!=])", " %1 ") -- handles spacing before/after operators
	        code = code:gsub("(%a)%s*([=<>~])%s*([=])", "%1 %2%3 ") -- handles combined operators like ==, >=, <=, etc.
	        code = code:gsub("%s+", " ") -- Normalize multiple spaces into one
	
	        -- Add line breaks after key statements
	        code = code:gsub("([;{}])", "%1\n") -- Ensure ;, {, and } are followed by new lines
	        code = code:gsub("(%b())", function(parens) -- Ensure new lines for anonymous functions
	            return parens:gsub(",", ", ")
	        end)
	
	        -- Add new lines for keywords
	        local keywords = {
	            "then", "end", "return", "break", 'do", "end)",
	        }
	
	        for _, keyword in ipairs(keywords) do
	            code = code:gsub(keyword .. " ", "\n" .. keyword .. " ") -- Ensure keyword begins on a new line
	        end
	
	        -- Fix indentation based on blocks (handling "end", "do", etc.)
	        local indent = 0
	        local beautifiedCode = code:gsub("[^\r\n]+", function(line)
	            if line:find("end") or line:find("}") then
	                indent = indent - 1
	            end
	
	            local formattedLine = string.rep("    ", indent) .. line
	            if line:find("do") or line:find("then") or line:find("{") then
	                indent = indent + 1
	            end
	
	            return formattedLine
	        end)
	
	        return beautifiedCode
	    end
	
	    local beautifiedCode = beautifyCode(code)
	
	    return beautifiedCode
	end,
}

return commands
