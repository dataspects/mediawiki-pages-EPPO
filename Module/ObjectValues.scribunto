local p = {}

-- https://github.com/SemanticMediaWiki/SemanticScribunto/blob/master/docs/mw.smw.getQueryResult.md

function p.show(frame)

  local selectingStatement = frame.args[1]
  
  if not mw.smw then
    return "mw.smw module not found"
  end

  local propertiesQuery = mw.smw.getQueryResult(selectingStatement)

  if propertiesQuery == nil then
    return "(no values)"
  end

  objectValues = {}
  
  if type( propertiesQuery ) == "table" then
    for k,v in pairs( propertiesQuery.results ) do
      property = split(v.fulltext, ":")
      propertyWithoutMWNamespace = property[2] .. ":" .. property[3]
      collectObjectValues(propertyWithoutMWNamespace)
    end
    return table.concat(objectValues, ';')
  end

end

function collectObjectValues(property)
	local objectValuesQuery = mw.smw.getQueryResult("[[" .. property .. "::+]]|?" .. property)
	local predicateAndItsObjects = {}
	if type( objectValuesQuery ) == "table" then
		for pageName, pageData in pairs( objectValuesQuery.results ) do
		    table.insert(predicateAndItsObjects, pageData["printouts"])
		end
	end
	
	for _, paios in pairs( predicateAndItsObjects ) do
	    for predicateName, objects in pairs( paios ) do
	        table.insert(objectValues, objects[1])
	    end
	end
	objectValues = arrayUnique(objectValues)
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
