local isServer = IsDuplicityVersion()

local icons = require 'data.font_awesome_icons'
function getRelevantIconBasic(string)
    for _, icon in ipairs(icons) do
        if string.find(icon, str) then
            return icon
        end
    end
    return icons[math.random(#icons)]
end


function getRelevantIconAdv_OLD(str, additional_context, callback)
    str = string.lower(str)

    local function ass(words)
        local best_match = nil
        local best_score = 0

        for i = 1, #icons do
            if icons[i] == str then
                best_match = icons[i]
                break
            end
        end
        if best_match then return best_match, 99999999 end

        -- Create a lookup table for words
        local wordLookup = {}
        for i = 1, #words do
            if string.len(words[i].word) >= 3 then
                wordLookup[words[i].word] = words[i].score
            end
        end

        
        for k, icon in ipairs(icons) do
            local score = 0
            local icon_tokens = split(icon, '-')  -- assuming icon names are separated by hyphens

            local foundInWords = {}
            local relevance = {}
            for _, token in ipairs(icon_tokens) do
                if string.len(token) >= 3 and wordLookup[token] then
                    foundInWords[icon] = (foundInWords[token] or 0) + 1
                    relevance[icon] = (relevance[icon] or 0) + wordLookup[token]
                end
            end

            for _, token in ipairs(icon_tokens) do
                if not foundInWords[icon] or foundInWords[icon] <= 0 then
                    if string.find(str, token) then
                        score = score + 1 * #token
                        if string.sub(token, 1, 1) == string.sub(str, 1, 1) then
                            score = score + 3
                        end
                    end
                end
            end

            if foundInWords[icon] and foundInWords[icon] > 0 then
                score = score + 1 * foundInWords[icon]
                score = score + relevance[icon]
            end

            if score > best_score then
                best_match = icon
                best_score = score
            end
        end
        return best_match, best_score
    end

    getRelatedWordsCall(str, function(words)

        local ac = {}

        if not additional_context then additional_context = {} end
        for _, word in ipairs(additional_context) do
            local ac_tokens = split(word, ' ')
            for _, token in ipairs(ac_tokens) do
                table.insert(ac, token)
            end
        end

        for _, word in ipairs(additional_context or {}) do
            getRelatedWordsCall(word, function(related_words)
                for i = 1, #related_words do
                    table.insert(words, related_words[i])
                end
            end)
        end

        for _, word in ipairs(ac) do
            getRelatedWordsCall(word, function(related_words)
                for i = 1, #related_words do
                    table.insert(words, related_words[i])
                end
            end)
        end

        print(#words, 'words')

        words = removeDuplicates(words)

        local best_match, best_score = ass(words)

        print(best_match, best_score)

        callback((best_match or icons[math.random(#icons)]), best_score)
    end)
end

function getRelevantIconAdv(str, additional_context, callback)
    str = string.lower(str)

    local function ass(words)
        local best_match = nil
        local best_score = 0

        for i = 1, #icons do
            if icons[i] == str then
                best_match = icons[i]
                break
            end
        end
        if best_match then return best_match, 99999999 end

        -- Create a lookup table for words
        local wordLookup = {}
        for i = 1, #words do
            if string.len(words[i].word) >= 3 then
                wordLookup[words[i].word] = words[i].score
            end
        end

        
        for k, icon in ipairs(icons) do
            local score = 0
            local icon_tokens = split(icon, '-')  -- assuming icon names are separated by hyphens

            local foundInWords = {}
            local relevance = {}
            for _, token in ipairs(icon_tokens) do
                if string.len(token) >= 3 and wordLookup[token] then
                    foundInWords[icon] = (foundInWords[token] or 0) + 1
                    relevance[icon] = (relevance[icon] or 0) + wordLookup[token]
                end
            end

            for _, token in ipairs(icon_tokens) do
                if not foundInWords[icon] or foundInWords[icon] <= 0 then
                    if string.find(str, token) then
                        score = score + 1 * #token
                        if string.sub(token, 1, 1) == string.sub(str, 1, 1) then
                            score = score + 3
                        end
                    end
                end
            end

            if foundInWords[icon] and foundInWords[icon] > 0 then
                score = score + 1 * foundInWords[icon]
                score = score + relevance[icon]
            end

            if score > best_score then
                best_match = icon
                best_score = score
            end
        end
        return best_match, best_score
    end

    for _, additional_context_word in ipairs(additional_context or {}) do
        str = str .. '+' .. string.gsub(additional_context_word, " ", "+")
    end

    getRelatedWordsCall(str, function(words)
        words = removeDuplicates(words)
        local best_match, best_score = ass(words)
        callback((best_match or icons[math.random(#icons)]), best_score)
    end)

end

function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end
local thread = nil

function getRelatedWords(word, callback)
    local words = {}
    word = string.gsub(word, " ", "+")
    local url = "https://api.datamuse.com/words?ml=" .. word
    thread = coroutine.running()
    
    PerformHttpRequest(url, function(code, response, headers)
        if code == 200 then
            local data = json.decode(response)
            for k,v in pairs(data) do
                -- print(v.word)
                words[#words+1] = {word = v.word, score = v.score}
            end
        else
            print('Failed to get related words')
        end
        -- Resume the coroutine when the request is done
        coroutine.resume(thread)
        -- Call the callback function with the words
        callback(words)
    end, 'GET', '', {['Content-Type'] = 'application/json'})

    -- Yield the coroutine until the request is done
    coroutine.yield()
end

function getRelatedWordsCall(word, callback)
    if isServer then
        getRelatedWords(word, callback)
    end
end

if isServer then
    lib.callback.register('CreatorV:getRelatedWords', function(player, word, context)
        getRelevantIconAdv(word, context or {}, function(icon, score)
            lib.callback('CreatorV:getRelatedWords', player, function() end, word, icon, score)
        end)
    end)
else
    local icons = {}

    lib.callback.register('CreatorV:getRelatedWords', function(og, word, score)
        icons[og] = word
    end)

    function getRelevantIconAdv(str, additional_context)
        if icons[str] then
            return icons[str]
        end
        lib.callback('CreatorV:getRelatedWords', false, function() end, str, additional_context)
        local loaded = lib.waitFor(function()
            return icons[str]
        end, 'failed to load icon', 3000)
        return loaded
    end
    exports('getRelevantIconAdv', getRelevantIconAdv)
end

RegisterCommand('icon', function(source, args)
    local word = args[1]
    local t = table.remove(args, 1) and args
    getRelevantIconAdv(word, t, function(icon, score)
        print('icon', icon)
    end)

end)

function removeDuplicates(t)
    local hash = {}
    local res = {}

    for _, v in ipairs(t) do
        if not hash[v] then
            res[#res+1] = v
            hash[v] = true
        end
    end

    return res
end

function findDuplicates(t)
    local hash = {}
    local duplicates = {}

    for _, v in ipairs(t) do
        if hash[v] then
            duplicates[v] = true
        else
            hash[v] = true
        end
    end

    return duplicates
end