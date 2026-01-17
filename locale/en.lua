Locales["en"] = {
    -- Chat Suggestions (Commands)
    ["switch"] = "Use to change your character(s).",
    ["setjob"] = "Mod Permission(s) Required.",
    ["revive"] = "Mod Permission(s) Required.",
    ["heal"] = "Mod Permission(s) Required.",
    ["car"] = "Admin Permission(s) Required.",
    ["ban"] = "Admin Permission(s) Required.",
    ["kick"] = "Admin Permission(s) Required.",
    ["bring"] = "Admin Permission(s) Required.",
    ["return"] = "Admin Permission(s) Required.",
    ["freeze"] = "Admin Permission(s) Required.",
    ["fx"] = "Developer Permission(s) Required.",
    ["noclip"] = "Developer Permission(s) Required.",
    ["cam"] = "Developer Permission(s) Required.",
    ["addoor"] = "Developer Permission(s) Required.",
    
    -- Deferral/Connection Messages
    ["defer_checking_account"] = "Checking User Account: Please Wait...",
    ["defer_welcome"] = "Welcome %s",
    ["defer_loading"] = "\n...",
    ["defer_rules_agreement"] = "By joining, you have agreed to our rules as found on our website.",
    ["defer_stuck_message"] = "If you get stuck here, please open Discord and try again...",
    ["defer_loading_server"] = "Loading Awesome Server: Please Wait...",
    ["defer_click_to_join"] = " 👋 - Click to Join",
    ["defer_click_to_leave"] = " ✋ - Click to Leave",
    ["defer_rejection_message"] = "You saw the reasons a moment ago, on an adaptive card. It renders all the reasons why you cannot join.",
    ["defer_issue"] = "Issue ⁉️",
    ["defer_forbidden_characters"] = "Your name contains forbidden characters.",
    ["defer_banned"] = "You have been banned by command or automatic event.",
    ["defer_no_discord"] = string.format("You have not joined our discord, please join with this link: %s", conf.discord.invitelink) or "Tell owner to add link in conf.discord.invitelink",
    
    -- Inventory Messages
    ["inv_no_item_found"] = "No Item Found...",
    ["inv_not_useable_quickslot"] = "Item is not useable via quickslot: %s",
    ["inv_no_item_quickslot"] = "No Item in Quickslot id: %s",
    ["inv_manipulation_detected"] = "Inventory manipulation detected: %s",
    ["inv_item_found"] = "Found a %s.",
    ["inv_items_found"] = "Found %d %s",
    
    -- Character Messages
    ["char_no_selection"] = "You don't have a character selected, this is impossible, bye.",
    ["char_deleted"] = "Character with id: %s was deleted successfully, please rejoin.",
    ["char_create_required"] = "Actually make a character...",
    ["char_downed"] = "You have been downed, you must wait for someone to assist you.",
    ["char_downed_warning"] = "If you do not wait, or leave, you will be unable to use this character for 7 days.",
    
    -- Banking Messages
    ["bank_loan_deduction_info"] = "Pulls all characters with loans and deducts money to pay the loan, can go negative.",
    ["bank_interest_info"] = "Updates the character's loan to add the interest on the outstanding amount each day.",
    ["bank_negative_balance"] = "Your Bank account is in negative.\nCurrent Balance is: $%d\nPlease deposit at an ATM or visit a bank to clear your balance or it will continue to grow.",
    ["bank_cash_display"] = "Cash: $%d",
    
    -- Appearance System
    ["appearance_default_shop"] = "Default Shop",
    ["appearance_updated_free"] = "Appearance updated (no charge)",
    ["appearance_hair_style"] = "Hair Style Change",
    ["appearance_overlay"] = "Overlay %d",
    ["appearance_accessory"] = "Accessory %d",
    ["appearance_tattoo"] = "Tattoo",
    
    -- General Messages
    ["player_not_found"] = "Player not found",
    ["nope"] = "Nope",
    ["please_wait"] = "Please wait a while before trying again.",
    ["transaction_too_fast"] = "Transaction too fast. Please wait.",
    ["no_cash"] = "You don't have the cash...",
    
    -- Developer Commands
    ["dev_pos_added"] = "Added pos to pos.lua",
    ["dev_cam_added"] = "Added cam to cams.lua",
    ["dev_parking_added"] = "Added Spot to parkingspots.lua",
    ["dev_props_added"] = "Added coords to props.lua",
    ["dev_vehicles_created"] = "Created vehicles_list.lua",
    ["dev_door_added"] = "Added to doors.lua",
    
    -- Security Messages
    ["security_violation"] = "Critical security violation detected",
    ["security_exploit_attempt"] = "StateBag exploit attempt detected",
    
    -- Validation Messages
    ["validation_invalid_inventory"] = "Invalid inventory in transfer",
    ["validation_item_mismatch"] = "Item mismatch or not found in source inventory",
    ["validation_insufficient_quantity"] = "Insufficient quantity in source inventory",
    ["validation_item_transferred"] = "Item transferred: %s x%d",



}
