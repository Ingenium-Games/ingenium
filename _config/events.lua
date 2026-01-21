-- ====================================================================================--
-- Events configuration
-- ====================================================================================--

-- Event registration and tracking
conf.events = conf.events or {}

-- Whether to generate and save registered events to JSON file
-- This creates a events.json file with all registered interact events and their allowed jobs
-- Useful for developers to see what events are available and which jobs can trigger them
conf.events.generateRegistry = true

-- Whether to log event registrations
conf.events.logRegistrations = true