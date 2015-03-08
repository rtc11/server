local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
local lastSound = 0
function onThink()
	if lastSound < os.time() then
		lastSound = (os.time() + 5)
		if math.random(100) < 25 then
			Npc():say("Passages to Edron, Thais, Venore, Darashia, Ankrahmun, Yalahar and Port Hope.", TALKTYPE_SAY)
		end
	end
	npcHandler:onThink()
end

-- Travel
local function addTravelKeyword(keyword, cost, destination, text)
	if keyword == 'goroma' then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Never heard about a place like this.'}, function(player) return player:getStorageValue(Storage.TheShatteredIsles.AccessToGoroma) ~= 1 end)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text or 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('edron', 170, Position(33173,31764, 6))
addTravelKeyword('venore', 180, Position(32954,32022, 6))
addTravelKeyword('port hope', 50, Position(32527,32784, 6))
addTravelKeyword('darashia', 200, Position(33289,32480, 6))
addTravelKeyword('ankrahmun', 90, Position(33092,32883, 6))
addTravelKeyword('goroma', 500, Position(32161,32558, 6), 'Ugh. You really want to go back to Goroma? I\'ll surely have to repair my ship afterwards, so I won\'t charge. Okay?')
addTravelKeyword('yalahar', 275, Position(32816,31272, 6))

-- Thais
local travelKeyword = keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to Thais for |TRAVELCOST|?', cost = 180, discount = 'postman'})
	local childTravelKeyword = travelKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'I have to warn you - we might get into a tropical storm on that route. I\'m not sure if my ship will withstand it. Do you really want to travel to Thais?'})
		childTravelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, cost = 180, discount = 'postman', destination = function(player) return math.random(8) == 1 and Position(32161, 32558, 6) or Position(32310, 32210, 6) end})
		childTravelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'We would like to serve you some time.'})
	travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'We would like to serve you some time.'})

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32275, 32892, 6), Position(32276, 32891, 6), Position(32277, 32895, 6)}})

-- Basic
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Edron}, {Thais}, {Venore}, {Darashia}, {Ankrahmun}, {Yalahar} or {Port Hope}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Edron}, {Thais}, {Venore}, {Darashia}, {Ankrahmun}, {Yalahar} or {Port Hope}?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Jack Fate from the Royal Tibia Line.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this sailing ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this sailing ship.'})
keywordHandler:addKeyword({'liberty bay'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s where we are.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, Sir |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:addModule(FocusModule:new())
