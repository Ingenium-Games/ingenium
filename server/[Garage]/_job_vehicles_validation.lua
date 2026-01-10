-- ====================================================================================--
-- Job Vehicles Validation Script
-- This script validates the job_vehicles.json configuration
-- Run this on resource start to catch configuration errors early
-- ====================================================================================--

CreateThread(function()
    -- Wait for resource to fully load
    Wait(2000)
    
    print("^3[Job Vehicles] Running configuration validation...^0")
    
    local validationErrors = 0
    local validationWarnings = 0
    
    -- Load job vehicles config
    local jobVehiclesFile = LoadResourceFile(GetCurrentResourceName(), "data/job_vehicles.json")
    if not jobVehiclesFile then
        print("^1[Job Vehicles] ✗ FATAL: Cannot load data/job_vehicles.json^0")
        return
    end
    
    local jobVehiclesConfig = json.decode(jobVehiclesFile)
    if not jobVehiclesConfig then
        print("^1[Job Vehicles] ✗ FATAL: Invalid JSON in data/job_vehicles.json^0")
        return
    end
    
    print("^2[Job Vehicles] ✓ job_vehicles.json loaded successfully^0")
    
    -- Load jobs data for validation
    local jobsFile = LoadResourceFile(GetCurrentResourceName(), "data/jobs.json")
    if not jobsFile then
        print("^1[Job Vehicles] ✗ FATAL: Cannot load data/jobs.json^0")
        return
    end
    
    local jobsData = json.decode(jobsFile)
    if not jobsData then
        print("^1[Job Vehicles] ✗ FATAL: Invalid JSON in data/jobs.json^0")
        return
    end
    
    print("^2[Job Vehicles] ✓ jobs.json loaded successfully^0")
    
    -- Validate each job's vehicles
    for jobId, vehicles in pairs(jobVehiclesConfig) do
        print("^3[Job Vehicles] Validating job: " .. jobId .. "^0")
        
        -- Check if job exists in jobs.json
        if not jobsData[jobId] then
            print("^1[Job Vehicles] ✗ ERROR: Job '" .. jobId .. "' not found in jobs.json^0")
            validationErrors = validationErrors + 1
        else
            print("^2[Job Vehicles]   ✓ Job exists in jobs.json^0")
        end
        
        -- Validate vehicles array
        if type(vehicles) ~= "table" then
            print("^1[Job Vehicles] ✗ ERROR: Vehicles for job '" .. jobId .. "' must be an array^0")
            validationErrors = validationErrors + 1
        else
            print("^2[Job Vehicles]   ✓ Found " .. #vehicles .. " vehicle(s)^0")
            
            -- Validate each vehicle
            for i, vehicle in ipairs(vehicles) do
                print("^3[Job Vehicles]   Validating vehicle #" .. i .. ": " .. (vehicle.name or "unnamed") .. "^0")
                
                -- Required fields
                if not vehicle.model then
                    print("^1[Job Vehicles]     ✗ ERROR: Missing 'model' field^0")
                    validationErrors = validationErrors + 1
                else
                    print("^2[Job Vehicles]     ✓ Model: " .. vehicle.model .. "^0")
                end
                
                if not vehicle.name then
                    print("^3[Job Vehicles]     ⚠ WARNING: Missing 'name' field^0")
                    validationWarnings = validationWarnings + 1
                else
                    print("^2[Job Vehicles]     ✓ Name: " .. vehicle.name .. "^0")
                end
                
                -- Validate minGrade if specified
                if vehicle.minGrade then
                    if type(vehicle.minGrade) ~= "number" then
                        print("^1[Job Vehicles]     ✗ ERROR: minGrade must be a number^0")
                        validationErrors = validationErrors + 1
                    elseif vehicle.minGrade < 1 then
                        print("^3[Job Vehicles]     ⚠ WARNING: minGrade < 1 may cause issues^0")
                        validationWarnings = validationWarnings + 1
                    else
                        print("^2[Job Vehicles]     ✓ Min Grade: " .. vehicle.minGrade .. "^0")
                    end
                end
                
                -- Validate allowedRoles if specified
                if vehicle.allowedRoles then
                    if type(vehicle.allowedRoles) ~= "table" then
                        print("^1[Job Vehicles]     ✗ ERROR: allowedRoles must be an array^0")
                        validationErrors = validationErrors + 1
                    else
                        print("^2[Job Vehicles]     ✓ Allowed Roles: " .. #vehicle.allowedRoles .. "^0")
                        
                        -- Validate each role exists in jobs.json
                        if jobsData[jobId] then
                            for _, roleName in ipairs(vehicle.allowedRoles) do
                                if not jobsData[jobId][roleName] then
                                    print("^1[Job Vehicles]       ✗ ERROR: Role '" .. roleName .. "' not found in jobs.json for job '" .. jobId .. "'")
                                    validationErrors = validationErrors + 1
                                else
                                    print("^2[Job Vehicles]       ✓ Role '" .. roleName .. "' exists^0")
                                end
                            end
                        end
                    end
                end
                
                -- Optional fields info
                if vehicle.description then
                    print("^2[Job Vehicles]     ✓ Description: " .. string.sub(vehicle.description, 1, 30) .. "...^0")
                end
            end
        end
        
        print("^3[Job Vehicles] ---^0")
    end
    
    -- Print summary
    print("^3[Job Vehicles] ======================^0")
    print("^3[Job Vehicles] Validation Summary^0")
    print("^3[Job Vehicles] ======================^0")
    
    if validationErrors == 0 and validationWarnings == 0 then
        print("^2[Job Vehicles] ✓ All checks passed!^0")
        print("^2[Job Vehicles] Configuration is valid and ready to use^0")
    else
        if validationErrors > 0 then
            print("^1[Job Vehicles] ✗ Found " .. validationErrors .. " error(s)^0")
            print("^1[Job Vehicles] Please fix errors before using job vehicles^0")
        end
        if validationWarnings > 0 then
            print("^3[Job Vehicles] ⚠ Found " .. validationWarnings .. " warning(s)^0")
            print("^3[Job Vehicles] System will work but may behave unexpectedly^0")
        end
    end
    
    print("^3[Job Vehicles] ======================^0")
    
    -- Register validation command
    RegisterCommand("validatejobvehicles", function()
        -- Re-run validation
        ExecuteCommand("refresh")
        print("^3[Job Vehicles] To re-validate, restart the resource^0")
    end, false)
    
    print("^2[Job Vehicles] Validation complete^0")
end)
