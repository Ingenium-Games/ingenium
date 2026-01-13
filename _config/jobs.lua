-- ====================================================================================--
-- Job Configuration
-- Defines all job properties including payroll settings
-- ====================================================================================--

if not conf then conf = {} end

-- Job System Toggles
conf.enablepayroll = true       -- Enable job payroll system
conf.enablejobcentre = false    -- Enable job center (job selection system)
conf.enableduty = true          -- Enable duty system for jobs

-- Job Definitions and Payroll Configuration
-- Payment processing occurs every 30 minutes for on-duty employees
conf.jobs = {} 

conf.jobs.payroll = {
    -- Police Department
    ['police'] = {
        enabled = true,
        payment_amount = 35.00,
        minimum_duty_minutes = 20
    },
    
    -- Sheriff Office
    ['sheriff'] = {
        enabled = true,
        payment_amount = 35.00,
        minimum_duty_minutes = 20
    },
    
    -- Fire Department / EMS
    ['fire'] = {
        enabled = true,
        payment_amount = 35.00,
        minimum_duty_minutes = 20
    },
    
    ['medic'] = {
        enabled = true,
        payment_amount = 35.00,
        minimum_duty_minutes = 20
    },
    
    -- Mechanics
    ['mechanic'] = {
        enabled = true,
        payment_amount = 25.00,
        minimum_duty_minutes = 20
    },
    
    -- Business
    ['business'] = {
        enabled = true,
        payment_amount = 25.00,
        minimum_duty_minutes = 20
    },
    
    -- Government
    ['government'] = {
        enabled = true,
        payment_amount = 45,
        minimum_duty_minutes = 20
    },
    
    -- Courts
    ['courts'] = {
        enabled = true,
        payment_amount = 45,
        minimum_duty_minutes = 20
    },
    
    -- Taxi
    ['taxi'] = {
        enabled = true,
        payment_amount = 20,
        minimum_duty_minutes = 20
    },
    
    -- Delivery / Postal
    ['postal'] = {
        enabled = true,
        payment_amount = 20,
        minimum_duty_minutes = 20
    },
    
    -- Job examples - uncomment to enable
    -- ['families'] = {enabled = true, payment_amount = 60.00, minimum_duty_minutes = 20},
    -- ['ballers'] = {enabled = true, payment_amount = 60.00, minimum_duty_minutes = 20},
    -- ['ls_mafia'] = {enabled = true, payment_amount = 65.00, minimum_duty_minutes = 20},
}
