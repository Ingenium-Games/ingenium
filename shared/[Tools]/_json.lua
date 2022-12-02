-- ====================================================================================--
c.json = {}
-- ====================================================================================--
function c.json.Exists(file)
    return c.file.Exists(file..".json")
end

function c.json.Read(file)
    local content = c.file.Read(file..".json")
    return json.decode(content)
end
  
function c.json.Write(file, content)
    local data = json.encode(content)
    c.file.Write(file..".json", data)
end