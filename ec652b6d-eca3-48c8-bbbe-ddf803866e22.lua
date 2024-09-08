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
	["Code Generation"] = function(obj)
	    local function generateCode(code)
	        return "local function generate() return function() " .. code .. " end end\n" ..
	               "local func = generate()\nfunc()"
	    end
	
	    local code = obj.Source
	    return generateCode(code)
	end,
	["Complex Data Structures"] = function(obj)
	    local function obfuscateWithComplexStructures(code)
	        return "local data = {\n" ..
	               "    ['key1'] = { 'nested1', 'nested2' },\n" ..
	               "    ['key2'] = { ['innerKey'] = function() " .. code .. " end }\n" ..
	               "}\n" ..
	               "data['key2']['innerKey']()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithComplexStructures(code)
	end,
	["Indirect Function Calls"] = function(obj)
	    local function obfuscateWithIndirectCalls(code)
	        return "local funcTable = { func1 = function() " .. code .. " end }\n" ..
	               "local function callIndirect() funcTable['func1']() end\n" ..
	               "callIndirect()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithIndirectCalls(code)
	end,
	["String Encryption with Metatables"] = function(obj)
	    local function encrypt(str)
	        local key = 5
	        return (str:gsub('.', function(c)
	            return string.char(((string.byte(c) - 32 + key) % 95) + 32)
	        end))
	    end
	
	    local function decrypt(str)
	        local key = 5
	        return (str:gsub('.', function(c)
	            return string.char(((string.byte(c) - 32 - key + 95) % 95) + 32)
	        end))
	    end
	
	    local function obfuscateWithEncryption(code)
	        local encryptedCode = encrypt(code)
	        return string.format(
	            "local mt = {__index = function(t, k) return function() return %s end end}\n" ..
	            "local t = setmetatable({}, mt)\nlocal function decryptedCode() return %s end\n" ..
	            "loadstring(decryptedCode())()",
	            encryptedCode, encryptedCode
	        )
	    end
	
	    local code = obj.Source
	    return obfuscateWithEncryption(code)
	end,
	["Randomized Tables"] = function(obj)
	    local function obfuscateWithRandomTables(code)
	        local tableName = "data" .. math.random(1000, 9999)
	        local randomTable = "{"
	        for i = 1, 10 do
	            randomTable = randomTable .. string.format('["%d"] = "%s", ', i, math.random(1, 100))
	        end
	        randomTable = randomTable .. "}"
	
	        return string.format(
	            "local %s = %s\nlocal function accessTable(key) return %s[key] end\n" ..
	            "local function originalFunc() %s end\noriginalFunc()",
	            tableName, randomTable, tableName, code
	        )
	    end
	
	    local code = obj.Source
	    return obfuscateWithRandomTables(code)
	end,
	["Metatable Obfuscation"] = function(obj)
	    local function obfuscateWithMetatables(code)
	        return "local mt = {__index = function(t, k) return function() return 'obfuscated' end end}\n" ..
	               "local t = setmetatable({}, mt)\n" ..
	               "local function originalFunc() " .. code .. " end\n" ..
	               "originalFunc()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithMetatables(code)
	end,
	["Fake Function Definitions"] = function(obj)
	    local function obfuscateWithFakeFunctions(code)
	        return "local function fakeFunc1() end\n" ..
	               "local function fakeFunc2() end\n" ..
	               "local function realFunc() " .. code .. " end\n" ..
	               "realFunc()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithFakeFunctions(code)
	end,
	["String Concatenation Obfuscation"] = function(obj)
	    local function obfuscateStringConcatenation(code)
	        return code:gsub('"[^"]+"', function(str)
	            return '"' .. str:sub(2, -2):gsub('.', function(c)
	                return '\\' .. string.byte(c)
	            end) .. '"'
	        end)
	    end
	
	    local code = obj.Source
	    return obfuscateStringConcatenation(code)
	end,
	["Variable Obfuscation through Indexing"] = function(obj)
	    local function obfuscateWithIndexing(code)
	        return "local vars = { a = 1, b = 2 }\n" ..
	               "local function useVar() return vars['a'] end\n" ..
	               "print(useVar())"
	    end
	
	    local code = obj.Source
	    return obfuscateWithIndexing(code)
	end,
	["Control Flow Obfuscation"] = function(obj)
	    local function obfuscateControlFlow(code)
	        return "local function obfuscatedFlow()\n" ..
	               "if true then\n" ..
	               "    " .. code .. "\n" ..
	               "else\n" ..
	               "    print('This will never be printed')\n" ..
	               "end\n" ..
	               "obfuscatedFlow()"
	    end
	
	    local code = obj.Source
	    return obfuscateControlFlow(code)
	end,
	["Code Injection via Metatables"] = function(obj)
	    local function obfuscateWithInjection(code)
	        return "local mt = {__index = function(t, k) " .. code .. " end}\n" ..
	               "local t = setmetatable({}, mt)\n" ..
	               "local function run() t['anyKey'] end\n" ..
	               "run()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithInjection(code)
	end,
	["Dynamic Variable Assignment"] = function(obj)
	    local function obfuscateWithDynamicAssignment(code)
	        return "local function dynamicAssign() " ..
	               "local a = loadstring('return 1')() " ..
	               "local b = loadstring('return 2')() " ..
	               "return a + b end\n" ..
	               "local result = dynamicAssign()\n" ..
	               "print(result)"
	    end
	
	    local code = obj.Source
	    return obfuscateWithDynamicAssignment(code)
	end,
	["Function Name Mangling"] = function(obj)
	    local function obfuscateWithNameMangling(code)
	        return "local function mangledName() " .. code .. " end\n" ..
	               "local function getFunction() return mangledName end\n" ..
	               "getFunction()()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithNameMangling(code)
	end,
	["Obfuscated Table Access"] = function(obj)
	    local function obfuscateTableAccess(code)
	        return "local tbl = {}\n" ..
	               "tbl[1] = function() " .. code .. " end\n" ..
	               "local function accessTable() return tbl[1]() end\n" ..
	               "accessTable()"
	    end
	
	    local code = obj.Source
	    return obfuscateTableAccess(code)
	end,
	["Function Proxying"] = function(obj)
	    local function obfuscateWithProxies(code)
	        return "local function proxyFunction() " .. code .. " end\n" ..
	               "local function mainFunction() return proxyFunction() end\n" ..
	               "mainFunction()"
	    end
	
	    local code = obj.Source
	    return obfuscateWithProxies(code)
	end,
}

return commands
