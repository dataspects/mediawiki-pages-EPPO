local p = {}

-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md
-- https://localhost/w/api.php?action=smwbrowse&browse=subject&params={%22subject%22:%22C0480574661%22,%20%22ns%22:0}

function p.show(frame)
	local selectingStatement = frame.args[1]
	nodeLabelFromPredicate = frame.args[2]
	local propertiesMatchingSelectingStatement = collectProperties(selectingStatement)
	nodes = {}
	edges = {}
	gd = {}
	for k, property in pairs(propertiesMatchingSelectingStatement) do
		collectPages(property, nodes, urlPrefix) -- pages will turn up multiple times!
	end
	for name, data in pairs(nodes) do
		table.insert(gd, node(name, data))
	end
	for _, edge in ipairs(edges) do
		table.insert(gd, edge)
	end
	table.insert(gd, "classDef default text-align:left")
	return table.concat(gd, "\n")
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

function collectPages(property, nodes)
	local query = mw.smw.getQueryResult("[[" .. property .. "::+]]|?" .. property .. "|?" .. nodeLabelFromPredicate)
	if type( query ) == "table" then
		-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md
		-- 
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
							table.insert(subjectNodeProperties, '<a href=\'./Property:' .. predicateName .. "'>" .. predicateName .. "</a>")
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
			table.insert(nodes[subjectNodeData[1]]["properties"], prop)
		end
	else
		nodes[subjectNodeData[1]] = { title = subjectNodeData[2], properties = subjectNodeProperties }
	end
end

function insertRelationship(subjectNodeData, predicateName, nodeLabelFromPredicate, object)
	-- FIXME: the object title must correspond with nodeLabelFromPredicate
	objectNodeData = getSinglePageProperties(object, nodeLabelFromPredicate)
	table.insert(edges, subjectNodeData[1] .. '-->|\"<a href=\'./Property:' .. predicateName .. "'>" .. predicateName .. "</a>\"|" .. objectNodeData[1])
end



function node(name, data)
	nps = table.concat(data["properties"], "<br/>")
	return name:gsub(":", "__"):gsub(" ", "_") .. '["<b><a href=\'' .. name .. '\'>' .. data["title"]:gsub("\"", '&quot;') .. '</a></b><br/>' .. nps .. '"]'
end

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- function arrayUnique(array)
--     local hash = {}
--     local res = {}
--     for _,v in ipairs(array) do
--         if (not hash[v]) then
--             res[#res+1] = v
--             hash[v] = true
--         end
--     end
--     return res
-- end

return p
