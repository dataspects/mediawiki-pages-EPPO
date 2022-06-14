local p = {}

-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md
-- https://localhost/w/api.php?action=smwbrowse&browse=subject&params={%22subject%22:%22C0480574661%22,%20%22ns%22:0}

function p.show(frame)
	local selectingStatement = frame.args[1]
	nodeLabelFromPredicate = frame.args[2]
	local properties = collectProperties(selectingStatement)
	graphData = {}
	for k, property in pairs(properties) do
		collect(property, graphData, urlPrefix)
	end
	table.insert(graphData, "classDef default text-align:left")
	return table.concat(arrayUnique(graphData), '\n\n')
end

function collect(property, graphData)
	local query = mw.smw.getQueryResult("[[" .. property .. "::+]]|?" .. property .. "|?" .. nodeLabelFromPredicate)
	if type( query ) == "table" then
		-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md
		for k, result in pairs( query.results ) do
			subjectData = getSubjectData(result, nodeLabelFromPredicate)
			subjectNodeProperties = {}
			for predicateName, objects in pairs( result["printouts"] ) do
				if type ( objects[1] ) == "table" then
					-- it's a relationship
					insertObjectNode(subjectData[1], predicateName, objects, graphData)
				else
					table.insert(subjectNodeProperties, predicateName)
				end
			end
			insertSubjectNode(subjectName, subjectData[2], result, subjectNodeProperties, graphData)
		end
	end
end

function getSubjectData(result, nodeLabelFromPredicate)
	subjectName = result.fulltext
	nodeLabel = subjectName
	for predicateName, objects in pairs( result["printouts"] ) do
		if type ( objects[1] ) ~= "table" then
			if predicateName == nodeLabelFromPredicate then
				nodeLabel = objects[1]
			end
		end
	end
	subjectTitle = subjectName
	if nodeLabel == subjectName then
		if result.displaytitle ~= "" then
			subjectTitle = result.displaytitle
		end
	else
		subjectTitle = nodeLabel
		subjectName = nodeLabel
	end
	return {subjectName, subjectTitle}
end

function insertSubjectNode(subjectName, subjectTitle, result, subjectNodeProperties, graphData)
	table.insert(graphData, node(subjectName, subjectTitle, subjectNodeProperties))
end

function insertObjectNode(subjectName, predicateName, objects, graphData)
	objectName = objects[1]["fulltext"]
	-- FIXME: the object title must correspond with nodeLabelFromPredicate
	table.insert(graphData, node(objectName, objects[1]["displaytitle"], {}))
	table.insert(graphData, subjectName .. '-->|\"<a href=\'./Property:' .. predicateName .. "'>" .. predicateName .. "</a>\"|" .. objectName)
end

function collectProperties(selectingStatement)
	if not mw.smw then
		return "mw.smw module not found"
	end
	local propertiesQuery = mw.smw.getQueryResult(selectingStatement)
	if propertiesQuery == nil then
		return "(no values)"
	end

	properties = {}
	if type( propertiesQuery ) == "table" then
		for k,v in pairs( propertiesQuery.results ) do
			property = split(v.fulltext, ":")
			if property[3] then
				propertyWithoutMWNamespace = property[2] .. ":" .. property[3]
			else
				-- non-namespaced predicate
				propertyWithoutMWNamespace = property[2]
			end
			table.insert(properties, propertyWithoutMWNamespace)
		end
	end

	return properties
end

function node(name, title, nodeProperties)
	nps = table.concat(nodeProperties, "<br/>")
	return name:gsub(":", "__"):gsub(" ", "_") .. '["<b><a href=\'' .. name .. '\'>' .. title:gsub("\"", '&quot;') .. '</a></b><br/>' .. nps .. '"]'
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

return p
