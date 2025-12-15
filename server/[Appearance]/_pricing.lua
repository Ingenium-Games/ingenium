-- ====================================================================================--
-- Server-Side Appearance Pricing Module
-- Handles job-specific pricing for appearance customization
-- ====================================================================================--

c.appearance = c.appearance or {}
c.appearance_pricing = c.appearance_pricing or {}
c.appearance_pricing_dirty = c.appearance_pricing_dirty or {}

-- ====================================================================================--
-- LAZY LOADING
-- ====================================================================================--

---Load pricing data for a specific job
---@param jobName string The name of the job
---@return table|nil Pricing data or nil if not found
function c.appearance.LoadJobPricing(jobName)
    -- Return if already loaded
    if c.appearance_pricing[jobName] then 
        return c.appearance_pricing[jobName] 
    end
    
    -- Construct path to job-specific pricing file
    local path = ("[Jobs]/%s/data/appearance/pricing"):format(jobName)
    
    -- Check if file exists and load it
    if c.json.Exists(path) then
        c.appearance_pricing[jobName] = c.json.Read(path)
        print(string.format("^2[Appearance Pricing] Loaded pricing for job: %s^0", jobName))
        return c.appearance_pricing[jobName]
    end
    
    return nil
end

---Get pricing data for a job, with fallback to default
---@param jobName string|nil The name of the job (nil for default)
---@return table Pricing data
function c.appearance.GetPricing(jobName)
    -- If no job specified, return default
    if not jobName or jobName == "" then
        return c.appearance.GetDefaultPricing()
    end
    
    -- Try to load job-specific pricing
    local pricing = c.appearance.LoadJobPricing(jobName)
    
    -- Fallback to default if job pricing not found
    if not pricing then
        print(string.format("^3[Appearance Pricing] No pricing found for job: %s, using default^0", jobName))
        return c.appearance.GetDefaultPricing()
    end
    
    return pricing
end

---Get default pricing data
---@return table Default pricing data
function c.appearance.GetDefaultPricing()
    -- Load default pricing if not already loaded
    if not c.appearance_pricing["_default"] then
        local path = "appearance/pricing_default"
        if c.json.Exists(path) then
            c.appearance_pricing["_default"] = c.json.Read(path)
            print("^2[Appearance Pricing] Loaded default pricing^0")
        else
            -- Create minimal default if file doesn't exist
            c.appearance_pricing["_default"] = {
                shopInfo = {
                    name = "Default Shop",
                    jobName = "_default"
                },
                pricing = {
                    enabled = false,
                    hair = { enabled = false },
                    clothing = { enabled = false },
                    overlays = { enabled = false },
                    accessories = { enabled = false },
                    tattoos = { enabled = false }
                },
                modifiers = {}
            }
            print("^3[Appearance Pricing] Created minimal default pricing (file not found)^0")
        end
    end
    
    return c.appearance_pricing["_default"]
end

-- ====================================================================================--
-- UPDATE AND SAVE
-- ====================================================================================--

---Update a price for a specific job
---@param jobName string The name of the job
---@param category string The category (e.g., "hair", "clothing")
---@param itemId string|number The item identifier
---@param price number The new price
---@return boolean Success status
function c.appearance.UpdatePrice(jobName, category, itemId, price)
    if not jobName or jobName == "" or jobName == "_default" then
        print("^1[Appearance Pricing] Cannot update default pricing^0")
        return false
    end
    
    -- Load pricing if not already loaded
    local pricing = c.appearance.LoadJobPricing(jobName)
    if not pricing then
        print(string.format("^1[Appearance Pricing] Failed to load pricing for job: %s^0", jobName))
        return false
    end
    
    -- Initialize category if it doesn't exist
    if not pricing.pricing[category] then
        pricing.pricing[category] = { enabled = true, items = {} }
    end
    
    -- Set the price
    if not pricing.pricing[category].items then
        pricing.pricing[category].items = {}
    end
    pricing.pricing[category].items[tostring(itemId)] = price
    
    -- Mark as dirty for periodic save
    c.appearance_pricing_dirty[jobName] = true
    
    print(string.format("^2[Appearance Pricing] Updated %s price for job %s: item %s = $%d^0", 
        category, jobName, tostring(itemId), price))
    
    return true
end

---Save all dirty pricing data
function c.appearance.SaveAllDirtyPricing()
    local saved = 0
    for jobName, _ in pairs(c.appearance_pricing_dirty) do
        if c.appearance_pricing[jobName] and jobName ~= "_default" then
            local path = ("[Jobs]/%s/data/appearance/pricing"):format(jobName)
            c.json.Write(path, c.appearance_pricing[jobName])
            c.appearance_pricing_dirty[jobName] = nil
            saved = saved + 1
        end
    end
    
    if saved > 0 then
        print(string.format("^2[Appearance Pricing] Saved %d dirty pricing file(s)^0", saved))
    end
end

---Save all loaded pricing data (called on resource stop)
function c.appearance.SaveAllPricing()
    local saved = 0
    for jobName, pricingData in pairs(c.appearance_pricing) do
        if jobName ~= "_default" then
            local path = ("[Jobs]/%s/data/appearance/pricing"):format(jobName)
            c.json.Write(path, pricingData)
            saved = saved + 1
        end
    end
    
    print(string.format("^2[Appearance Pricing] Saved %d pricing file(s) on resource stop^0", saved))
end

-- ====================================================================================--
-- PERIODIC SAVE
-- ====================================================================================--

-- Save dirty pricing every 5 minutes
if not c.appearance.PricingSaveThread then
    c.appearance.PricingSaveThread = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(300000) -- 5 minutes
            c.appearance.SaveAllDirtyPricing()
        end
    end)
end

-- ====================================================================================--
-- RESOURCE STOP HANDLER
-- ====================================================================================--

AddEventHandler("onResourceStop", function(resource)
    if GetCurrentResourceName() ~= resource then return end
    print("^3[Appearance Pricing] Saving all pricing data on resource stop...^0")
    c.appearance.SaveAllPricing()
end)

-- ====================================================================================--
-- PRICE CALCULATION AND VALIDATION
-- ====================================================================================--

---Calculate the total cost for appearance changes
---@param jobName string|nil The job name for pricing
---@param oldAppearance table The original appearance
---@param newAppearance table The new appearance
---@return number, table Total cost and itemized breakdown
function c.appearance.CalculateCost(jobName, oldAppearance, newAppearance)
    local pricing = c.appearance.GetPricing(jobName)
    local totalCost = 0
    local itemizedCosts = {}
    
    -- If pricing is disabled, return 0
    if not pricing.pricing or not pricing.pricing.enabled then
        return 0, {}
    end
    
    -- Helper function to add cost
    local function addCost(category, itemId, price, description)
        if price and price > 0 then
            table.insert(itemizedCosts, {
                category = category,
                itemId = itemId,
                price = price,
                description = description
            })
            totalCost = totalCost + price
        end
    end
    
    -- Check hair changes
    if pricing.pricing.hair and pricing.pricing.hair.enabled then
        local oldHair = oldAppearance.hair or {}
        local newHair = newAppearance.hair or {}
        
        if oldHair.style ~= newHair.style or oldHair.color ~= newHair.color or oldHair.highlight ~= newHair.highlight then
            local hairPrice = pricing.pricing.hair.basePrice or pricing.pricing.hair.default or 0
            if pricing.pricing.hair.styles and pricing.pricing.hair.styles[tostring(newHair.style)] then
                hairPrice = pricing.pricing.hair.styles[tostring(newHair.style)]
            end
            addCost("hair", newHair.style, hairPrice, "Hair Style Change")
        end
    end
    
    -- Check clothing components
    if pricing.pricing.clothing and pricing.pricing.clothing.enabled then
        local oldComponents = oldAppearance.components or {}
        local newComponents = newAppearance.components or {}
        
        for _, newComp in ipairs(newComponents) do
            local changed = true
            for _, oldComp in ipairs(oldComponents) do
                if oldComp.component_id == newComp.component_id then
                    if oldComp.drawable == newComp.drawable and oldComp.texture == newComp.texture then
                        changed = false
                        break
                    end
                end
            end
            
            if changed then
                local compId = tostring(newComp.component_id)
                local price = pricing.pricing.clothing.default or 0
                
                if pricing.pricing.clothing.components and pricing.pricing.clothing.components[compId] then
                    local compPricing = pricing.pricing.clothing.components[compId]
                    if type(compPricing) == "table" then
                        price = compPricing[tostring(newComp.drawable)] or compPricing.default or price
                    else
                        price = compPricing
                    end
                end
                
                local compName = "Component " .. compId
                addCost("clothing", compId, price, compName)
            end
        end
    end
    
    -- Check overlays
    if pricing.pricing.overlays and pricing.pricing.overlays.enabled then
        local oldOverlays = oldAppearance.headOverlays or {}
        local newOverlays = newAppearance.headOverlays or {}
        
        for overlayId, newOverlay in pairs(newOverlays) do
            local oldOverlay = oldOverlays[overlayId]
            if not oldOverlay or oldOverlay.style ~= newOverlay.style or oldOverlay.color ~= newOverlay.color then
                local price = pricing.pricing.overlays.default or 0
                if pricing.pricing.overlays.items and pricing.pricing.overlays.items[tostring(overlayId)] then
                    price = pricing.pricing.overlays.items[tostring(overlayId)]
                end
                addCost("overlays", overlayId, price, "Overlay " .. overlayId)
            end
        end
    end
    
    -- Check accessories (props)
    if pricing.pricing.accessories and pricing.pricing.accessories.enabled then
        local oldProps = oldAppearance.props or {}
        local newProps = newAppearance.props or {}
        
        for _, newProp in ipairs(newProps) do
            local changed = true
            for _, oldProp in ipairs(oldProps) do
                if oldProp.prop_id == newProp.prop_id then
                    if oldProp.drawable == newProp.drawable and oldProp.texture == newProp.texture then
                        changed = false
                        break
                    end
                end
            end
            
            if changed and newProp.drawable ~= -1 then
                local propId = tostring(newProp.prop_id)
                local price = pricing.pricing.accessories.default or 0
                
                if pricing.pricing.accessories.items and pricing.pricing.accessories.items[propId] then
                    price = pricing.pricing.accessories.items[propId]
                end
                
                addCost("accessories", propId, price, "Accessory " .. propId)
            end
        end
    end
    
    -- Check tattoos
    if pricing.pricing.tattoos and pricing.pricing.tattoos.enabled then
        local oldTattoos = oldAppearance.tattoos or {}
        local newTattoos = newAppearance.tattoos or {}
        
        -- Count new tattoos
        for _, newTattoo in ipairs(newTattoos) do
            local exists = false
            for _, oldTattoo in ipairs(oldTattoos) do
                if oldTattoo.collection == newTattoo.collection and oldTattoo.hash == newTattoo.hash then
                    exists = true
                    break
                end
            end
            
            if not exists then
                local price = pricing.pricing.tattoos.default or 0
                if pricing.pricing.tattoos.items and pricing.pricing.tattoos.items[newTattoo.hash] then
                    price = pricing.pricing.tattoos.items[newTattoo.hash]
                end
                addCost("tattoos", newTattoo.hash, price, "Tattoo")
            end
        end
    end
    
    -- Apply modifiers (employee discount, etc.)
    if pricing.modifiers and pricing.modifiers.employee_discount then
        totalCost = totalCost * pricing.modifiers.employee_discount
    end
    
    return math.floor(totalCost), itemizedCosts
end

print('^2[Server] Appearance pricing module loaded^0')
