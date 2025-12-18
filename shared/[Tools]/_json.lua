-- ====================================================================================--
ig.json = {}
-- ====================================================================================--
function ig.json.Exists(file)
    return ig.file.Exists(file..".json")
end

function ig.json.Read(file)
    local content = ig.file.Read(file..".json")
    return json.decode(content)
end
  
function ig.json.Write(file, content)
    local data = json.encode(content)
    ig.file.Write(file..".json", data)
end