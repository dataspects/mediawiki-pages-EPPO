local p = {}

-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md
-- https://localhost/w/api.php?action=smwbrowse&browse=subject&params={%22subject%22:%22C0480574661%22,%20%22ns%22:0}

function p.list(frame)
	local propertiesMatchingSelectingStatement = propertiesMatchingSelectingStatement(frame)
	nodes = {}
	edges = {}
	local listOfNodeNamesHavingLabelFromSpecifiedPredicate = {}
	for k, property in pairs(propertiesMatchingSelectingStatement) do
		collectPages(property) -- pages will turn up multiple times!
	end
	for name, data in pairs(nodes) do
		table.insert(listOfNodeNamesHavingLabelFromSpecifiedPredicate, '\n* <b>[[' .. name .. '|' .. grammarlyNoun(name) .. ']]</b>&hellip; \'\'' .. getPropertyValue(name, "Ds0:hasDescription") .. '\'\'')
		for _, propertyLink in ipairs(data["properties"]) do
			table.insert(listOfNodeNamesHavingLabelFromSpecifiedPredicate, '\n** <i>&hellip; they ' .. getPropertyValue(propertyLink["fullPropertyPageName"], "Ds0:hasStoryDescription") .. '</i> (predicate "[[' .. propertyLink["fullPropertyPageName"] .. '|' .. propertyLink["formattedPredicateName"] .. "]]\" in namespace \"[[" .. split(propertyLink["fullPropertyPageName"], ":")[2] .. "]]\")")
		end
		-- THIS IS TERRIBLE BUT THE GOAL IS TO OUTSOURCE THIS TO A CANONICAL SERVICE!
		for _, data in pairs(edges) do
			if data["subject"] == name then
				table.insert(listOfNodeNamesHavingLabelFromSpecifiedPredicate, '\n** <i>&hellip; they ' .. getPropertyValue(data["predicate"]["fullPropertyPageName"], "Ds0:hasStoryDescription") .. '</i> (predicate "[[' .. data["predicate"]["fullPropertyPageName"] .. "|" .. data["predicate"]["formattedPredicateName"] .. "]]\" in namespace \"[[" .. split(data["predicate"]["fullPropertyPageName"], ":")[2] .. "]]\" pointing to pages of type \"<b>[[" .. data["object"] .. "]]</b>\")")
			end
		end
	end
	return table.concat(arrayUnique(listOfNodeNamesHavingLabelFromSpecifiedPredicate), "")
end

function p.graph(frame)
	local propertiesMatchingSelectingStatement = propertiesMatchingSelectingStatement(frame)
	nodes = {}
	edges = {}
	gd = {}
	for k, property in pairs(propertiesMatchingSelectingStatement) do
		collectPages(property) -- pages will turn up multiple times!
	end
	for name, data in pairs(nodes) do
		table.insert(gd, mermaidNode(name, data))
	end
	for _, edge in ipairs(edges) do
		table.insert(gd, edge["mermaidEdge"])
	end
	table.insert(gd, "classDef default text-align:left")
	return table.concat(gd, "\n")
end

function getPropertyValue(page, property)
	local propertiesQuery = mw.smw.getQueryResult("[[" .. page .. "]]|?" .. property)
	if propertiesQuery == nil then
		return "(no values)"
	end
	if type( propertiesQuery ) == "table" then
		value = propertiesQuery.results[1]["printouts"][property][1]
		if value then
			return value
		end
	end
	return "No description"
end

function propertiesMatchingSelectingStatement(frame)
	local selectingStatement = frame.args[1]
	nodeLabelFromPredicate = frame.args[2]
	return collectProperties(selectingStatement)
end

function collectProperties(selectingStatement)
	if not mw.smw then
		return "mw.smw module not found"
	end
	local propertiesQuery = mw.smw.getQueryResult(selectingStatement)
	if propertiesQuery == nil then
		return "(no values)"
	end

	propertiesMatchingSelectingStatement = {}
	if type( propertiesQuery ) == "table" then
		for k,v in pairs( propertiesQuery.results ) do
			property = split(v.fulltext, ":")
			if property[3] then
				propertyWithoutMWNamespace = property[2] .. ":" .. property[3]
			else
				-- non-namespaced predicate
				propertyWithoutMWNamespace = property[2]
			end
			table.insert(propertiesMatchingSelectingStatement, propertyWithoutMWNamespace)
		end
	end

	return propertiesMatchingSelectingStatement
end

function filterIn(predicateName)
	if predicateName == "Eppo0:hasContext" then
		return true
	end
	if split(predicateName, ":")[1] ~= "Eppo0" then -- filter out eppo0 in case it was used as nodeLabelFromPredicate
		return true
	end
	return false
end

function collectPages(property)
	local query = mw.smw.getQueryResult("[[" .. property .. "::+]]|?" .. property .. "|?" .. nodeLabelFromPredicate)
	if type( query ) == "table" then
		-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md
		for k, result in pairs( query.results ) do
			local subjectNodeData = getPageData(result, nodeLabelFromPredicate)
			local subjectNodeProperties = {}
			for predicateName, objects in pairs( result["printouts"] ) do
				if filterIn(predicateName) then
					for _, object in ipairs(objects) do
						if pageExists (object) then
							-- it's a relationship
							insertRelationship(subjectNodeData, predicateName, nodeLabelFromPredicate, object)
						else
							table.insert(subjectNodeProperties, { 
								fullPropertyPageName = "Property:" .. predicateName,
								htmlAnchorTag = '<a href=\'./Property:' .. predicateName .. "'>" .. formatPredicateName(predicateName, "hideNamespace") .. "</a>",
								formattedPredicateName = formatPredicateName(predicateName, "hideNamespace")
							})
						end
					end
				end
			end
			if split(subjectNodeData[1], "__")[1] ~= "Property" then -- exclude pages from namespace Property
				insertSubjectNode(subjectNodeData, result, subjectNodeProperties)
			end
		end
	end
end

function pageExists(pageName)
	if pageName == nil then
		return false
	else
		if type ( pageName ) == "string" then
			local query = mw.smw.getQueryResult("[[" .. pageName .. "]]")
			if type( query ) == "table" then
				if next (query.results) == nil then
					return false
				end
				if query.results[1].exists == "" then
					return false
				end
				return true
			end
			return false
		else
			-- FIXME: pageName type = table
			-- {
  				-- ["raw"] = "1/2021/1/15",
  				-- ["timestamp"] = "1610668800",
			-- }
		end
	end
end

function getSinglePageProperties(pageName, property)
	local query = mw.smw.getQueryResult("[[" .. pageName .. "]]|?" .. property)
	if type( query ) == "table" then
		for k, result in pairs( query.results ) do
			subjectNodeData = getPageData(result, property)
			return subjectNodeData
		end
	end
end


function getPageData(result, nodeLabelFromPredicate) -- nodeLabelFromPredicate e.g. = Eppo0:hasEntityType
	pageName = result.fulltext
	nodeLabel = pageName -- SET: by default the nodeLabel = pageName
	for predicateName, objects in pairs( result["printouts"] ) do
		if type ( objects[1] ) ~= "table" then
			if predicateName == nodeLabelFromPredicate then
				-- FACT: 	the current page always features a Eppo0:hasEntityType because
				--			it's requested in the query!
				if objects[1] then
					nodeLabel = objects[1] -- SET: the nodeLabel is set to Eppo0:hasEntityType's value
				end
			end
		end
	end
	subjectTitle = pageName -- SET: by default the subjectTitle = pageName

	if nodeLabel == pageName then
		if result.displaytitle ~= "" then
			-- FACT: the current page features a displaytitle
			subjectTitle = result.displaytitle
		end
	else
		subjectTitle = nodeLabel
		pageName = nodeLabel
	end
	local nodeData = { pageName:gsub(":", "__"):gsub(" ", "_"), subjectTitle }
	return nodeData
end

function insertSubjectNode(subjectNodeData, result, subjectNodeProperties)
	if nodes[subjectNodeData[1]] then
		for _, prop in ipairs(subjectNodeProperties) do
			if not arrayContainsSimpleValue(nodes[subjectNodeData[1]]["properties"], prop) then
				table.insert(nodes[subjectNodeData[1]]["properties"], prop)
			end
		end
	else
		nodes[subjectNodeData[1]] = { title = subjectNodeData[2], properties = subjectNodeProperties }
	end
end

function insertRelationship(subjectNodeData, predicateName, nodeLabelFromPredicate, object)
	-- FIXME: the object title must correspond with nodeLabelFromPredicate
	objectNodeData = getSinglePageProperties(object, nodeLabelFromPredicate)
    local edge = {
		subject = subjectNodeData[1],
		predicate = {
			fullPropertyPageName = "Property:" .. predicateName,
			htmlAnchorTag = '<a href=\'./Property:' .. predicateName .. "'>" .. formatPredicateName(predicateName, "hideNamespace") .. "</a>",
			formattedPredicateName = formatPredicateName(predicateName, "hideNamespace")
		},
		object = objectNodeData[1],
		mermaidEdge = subjectNodeData[1] .. '-->|\"<a href=\'./Property:' .. predicateName .. "'>" .. formatPredicateName(predicateName, "hideNamespace") .. "</a>\"|" .. objectNodeData[1]
	}
    if not arrayContainsMermaidEdge(edges, edge) then
        table.insert(edges, edge)
    end
	
end


function formatPredicateName(predicateName, format)
	if format == "hideNamespace" then
		return split(predicateName, ":")[2]
	end
	return predicateName
end


function mermaidNode(name, data)
	nps = table.concat(arrayFromPropertyHashKey(data["properties"], "htmlAnchorTag"), "<br/>")
	return name:gsub(":", "__"):gsub(" ", "_") .. '["<b><a href=\'' .. name .. '\'>' .. data["title"]:gsub("\"", '&quot;') .. '</a></b><br/>' .. nps .. '"]'
end

function arrayFromPropertyHashKey(hash, key)
	array = {};
	for _, propertyHash in ipairs(hash) do
		for k, value in pairs(propertyHash) do
			if k == key then
				table.insert(array, value);
			end
		end
	end
	return arrayUnique(array);
end

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function arrayUnique(array)
    local hash = {}
    local res = {}
    for _,v in ipairs(array) do
        if (not hash[v]) then
            res[#res+1] = v
            hash[v] = true
        end
    end
    return res
end

-- FIXME with API
function grammarlyNoun(str)
	return str .. "s"
end

function arrayContainsSimpleValue(array, x)
	for _, v in pairs(array) do
		if v == x then return true end
	end
	return false
end

function arrayContainsMermaidEdge(array, edge)
	for _, h in pairs(array) do
		if h["mermaidEdge"] == edge["mermaidEdge"] then return true end
	end
	return false
end


return p
