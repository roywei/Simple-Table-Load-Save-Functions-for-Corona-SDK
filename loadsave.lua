local _ = {}
local json = require("json")
local DefaultLocation = "DocumentsDirectory"
local RealDefaultLocation = DefaultLocation
local ValidLocations = {
   ["DocumentsDirectory"] = true,
   ["CachesDirectory"] = true,
   ["TemporaryDirectory"] = true
}

function _.saveTable(t, filename, location)
    if location and (not ValidLocations[location]) then
     error("Attempted to save a table to an invalid location", 2)
    elseif not location then
      location = DefaultLocation
    end
    
    local path = system.pathForFile( filename, system[location])
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end
 
function _.loadTable(filename, location)
    if location and (not ValidLocations[location]) then
     error("Attempted to load a table from an invalid location", 2)
    elseif not location then
      location = DefaultLocation
    end
    local path = system.pathForFile( filename, system[location])
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        myTable = json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end

function _.changeDefault(location)
	if location and (not ValidLocations[location]) then
		error("Attempted to change the default location to an invalid location", 2)
	elseif not location then
		location = RealDefaultLocation
	end
	DefaultLocation = location
	return true
end

return _
