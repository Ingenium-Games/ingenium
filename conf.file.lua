-- ====================================================================================--

conf.file = {}
--[[
NOTES
    - For files rather than saving to a database. For ones that are often spammed, 
    - and these dont "need" to be updated every time someone makes a new one, just
    - on a cycle, be it 2 minutes, 5 minutes etc, that way they can have a semi persistant state.
]] --
-- ====================================================================================--
conf.file.gsr = "GSR"
conf.file.jobs = "Jobs"
conf.file.items = "Items"
conf.file.notes = "Notes"
conf.file.names = "Names"
conf.file.drops = "Drops"
conf.file.scenes = "Scenes"
conf.file.pickups = "Pickups"
--
conf.file.save = conf.min -- after 5 minutes, save the file agian
conf.file.cleanup = 3600 -- after x seconds pass - (1 hour)
