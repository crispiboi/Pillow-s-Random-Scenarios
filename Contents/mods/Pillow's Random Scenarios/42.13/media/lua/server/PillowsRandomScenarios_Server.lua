local MODULE = "PillowsRandomScenarios"

local function applyBodyDamageOps(playerObj, ops)
	if playerObj == nil or ops == nil then
		return
	end

	local bodyDamage = playerObj:getBodyDamage()
	if bodyDamage == nil then
		return
	end

	for _, op in ipairs(ops) do
		if type(op) == "table" and type(op.partIndex) == "number" then
			local bodyPart = bodyDamage:getBodyPart(BodyPartType.FromIndex(op.partIndex))
			if bodyPart ~= nil then
				if op.op == "AddDamage" then
					bodyPart:AddDamage(op.amount or 0)
				elseif op.op == "setFractureTime" then
					bodyPart:setFractureTime(op.time or 0)
				elseif op.op == "setSplint" then
					bodyPart:setSplint(op.enabled == true, op.strength or 0)
				elseif op.op == "setBandaged" then
					bodyPart:setBandaged(op.bandaged == true, op.life or 0, op.alcoholic == true, op.bandageType)
				elseif op.op == "setBurnTime" then
					bodyPart:setBurnTime(op.time or 0)
				elseif op.op == "setDeepWounded" then
					bodyPart:setDeepWounded(op.enabled == true)
				elseif op.op == "setDeepWoundTime" then
					bodyPart:setDeepWoundTime(op.time or 0)
				elseif op.op == "setBleedingTime" then
					bodyPart:setBleedingTime(op.time or 0)
				elseif op.op == "setHaveGlass" then
					bodyPart:setHaveGlass(op.enabled == true)
				elseif op.op == "SetScratchedWindow" then
					bodyPart:SetScratchedWindow(op.enabled == true)
				elseif op.op == "SetScratchedWeapon" then
					bodyPart:SetScratchedWeapon(op.enabled == true)
				elseif op.op == "setCut" then
					bodyPart:setCut(op.enabled == true)
				elseif op.op == "setCutTime" then
					bodyPart:setCutTime(op.time or 0)
				end
			end
		end
	end
end

local function startSquareFireAt(x, y, z)
	if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
		return
	end

	local square = getCell():getGridSquare(x, y, z)
	if square == nil then
		return
	end

	if square.explode ~= nil then
		local ok = pcall(function()
			square:explode()
		end)
		if ok then
			return
		end
	end

	if IsoFireManager ~= nil and IsoFireManager.StartFire ~= nil then
		if pcall(IsoFireManager.StartFire, square, true, 80, 0) then
			return
		end
		pcall(IsoFireManager.StartFire, square, true, 80)
	end
end

Events.OnClientCommand.Add(function(module, command, playerObj, args)
	if module ~= MODULE then
		return
	end

	if command == "ApplyBodyDamageOps" and args ~= nil and type(args.ops) == "table" then
		applyBodyDamageOps(playerObj, args.ops)
	elseif command == "StartSquareFire" and args ~= nil then
		startSquareFireAt(args.x, args.y, args.z)
	end
end)
