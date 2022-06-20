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
  end

  allEPPOPages()

  return table.concat(objectValues, ';')
end

function allEPPOPages()
  local pagesQuery = mw.smw.getQueryResult("[[Eppo0:hasEntityType::+]]")
  if type( pagesQuery ) == "table" then
    for pageName, pageData in pairs( pagesQuery.results ) do
		    table.insert(objectValues, pageData["fulltext"])
		end
  end
end

function collectObjectValues(property)
	local objectValuesQuery = mw.smw.getQueryResult("[[" .. property .. "::+]]|?" .. property .. "|link=none")
	local predicateAndItsObjects = {}
	if type( objectValuesQuery ) == "table" then
		for pageName, pageData in pairs( objectValuesQuery.results ) do
		    table.insert(predicateAndItsObjects, pageData["printouts"])
		end
	end
	
	for _, paios in pairs( predicateAndItsObjects ) do
	    for predicateName, objects in pairs( paios ) do
          if type ( objects[1] ) ~= "table" then
            -- these are just the literal object values, page names are handled by allEPPOPages()
            url = objects[1]:match('^https?://(.*)') -- FIXME!
            -- If for now we do not remove ^https?://, then <a href... will be wrapped around and break the form.
            if url then
            	table.insert(objectValues, url)
            else
            	table.insert(objectValues, objects[1])
            end
          end
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
