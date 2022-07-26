local Weapon = RegisterClientCallback({
    eventName = "Client:Item:Weapon",
    eventCallback = function(data)
        local Name = data.Name
        local Meta = data.Meta
        local Data = data.Data
        
    end
})

local Consumeable = RegisterClientCallback({
    eventName = "Client:Item:Consumeable",
    eventCallback = function(data)
        local Name = data.Name
        local Meta = data.Meta
        local Data = data.Data
        
    end
})