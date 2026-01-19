import json

# Complete jobs structure with all current jobs
jobs = {
    "none": {
        "label": "Unemployed",
        "description": "Not currently employed",
        "boss": None,
        "grades": {
            "Unemployed": {"org": "Unemployed", "rank": 1, "pay": 0, "isBoss": False}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": False}
    },
    "police": {
        "label": "Police Department",
        "description": "Law enforcement agency serving the city",
        "boss": None,
        "grades": {
            "Cadet": {"org": "Police Department", "rank": 1, "pay": 17, "isBoss": False},
            "Junior Officer": {"org": "Police Department", "rank": 2, "pay": 20, "isBoss": False},
            "Officer": {"org": "Police Department", "rank": 3, "pay": 22, "isBoss": False},
            "Senior Officer": {"org": "Police Department", "rank": 4, "pay": 26, "isBoss": False},
            "Cheif of Police": {"org": "Police Department", "rank": 5, "pay": 33, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "medic": {
        "label": "Emergency Medical Services",
        "description": "Emergency medical response and hospital services",
        "boss": None,
        "grades": {
            "Trainee": {"org": "Emergency Medical Services", "rank": 1, "pay": 16, "isBoss": False},
            "Paramedic": {"org": "Emergency Medical Services", "rank": 2, "pay": 21, "isBoss": False},
            "Doctor": {"org": "Emergency Medical Services", "rank": 3, "pay": 28, "isBoss": False},
            "Cheif Medical Officer": {"org": "Emergency Medical Services", "rank": 4, "pay": 35, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "pdm": {
        "label": "Premium Motor Sport",
        "description": "Luxury and performance vehicle dealership",
        "boss": None,
        "grades": {
            "Pre-Delivery": {"org": "Premium Motor Sport", "rank": 1, "pay": 18, "isBoss": False},
            "Floor Sales": {"org": "Premium Motor Sport", "rank": 2, "pay": 23, "isBoss": False},
            "Sales Expert": {"org": "Premium Motor Sport", "rank": 3, "pay": 28, "isBoss": False},
            "Operations Director": {"org": "Premium Motor Sport", "rank": 4, "pay": 35, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "mechanic": {
        "label": "Benny's Original Motorworks",
        "description": "Vehicle repair and customization services",
        "boss": None,
        "grades": {
            "Apprentice": {"org": "Benny's Original Motorworks", "rank": 1, "pay": 15, "isBoss": False},
            "Mechanic": {"org": "Benny's Original Motorworks", "rank": 2, "pay": 22, "isBoss": False},
            "Import Logistics": {"org": "Benny's Original Motorworks", "rank": 3, "pay": 28, "isBoss": False},
            "Boss Man": {"org": "Benny's Original Motorworks", "rank": 4, "pay": 35, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "news": {
        "label": "Weazel News",
        "description": "News broadcasting and journalism",
        "boss": None,
        "grades": {
            "Intern": {"org": "Weazel News", "rank": 1, "pay": 14, "isBoss": False},
            "Camera Crew": {"org": "Weazel News", "rank": 2, "pay": 18, "isBoss": False},
            "Reporter": {"org": "Weazel News", "rank": 3, "pay": 24, "isBoss": False},
            "DJ Mixer": {"org": "Weazel News", "rank": 4, "pay": 28, "isBoss": False},
            "News Anchor": {"org": "Weazel News", "rank": 5, "pay": 35, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "garbage": {
        "label": "Desperado's Waste Services",
        "description": "Waste collection and recycling services",
        "boss": None,
        "grades": {
            "Waste Colector": {"org": "Desperado's Waste Services", "rank": 1, "pay": 14, "isBoss": False},
            "Heavy Colections": {"org": "Desperado's Waste Services", "rank": 2, "pay": 18, "isBoss": False},
            "Renew Technition": {"org": "Desperado's Waste Services", "rank": 3, "pay": 24, "isBoss": False},
            "Service Logistic Manager": {"org": "Desperado's Waste Services", "rank": 4, "pay": 30, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "vargos": {
        "label": "Vargos",
        "description": "Vargos street organization",
        "boss": None,
        "grades": {
            "Repin Yellow": {"org": "Vargos", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "ballers": {
        "label": "Ballers",
        "description": "Ballers street organization",
        "boss": None,
        "grades": {
            "Repin Purple": {"org": "Ballers", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "famillies": {
        "label": "Families",
        "description": "Families street organization",
        "boss": None,
        "grades": {
            "Repin Green": {"org": "Famillies", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "aztecas": {
        "label": "Aztecas",
        "description": "Aztecas street organization",
        "boss": None,
        "grades": {
            "Repin Red": {"org": "Aztecas", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "pepe": {
        "label": "Pepe's Pizzaria",
        "description": "Pizza delivery and restaurant services",
        "boss": None,
        "grades": {
            "Delivery Driver": {"org": "Pepe's Pizzaria", "rank": 1, "pay": 15, "isBoss": False},
            "Pizza Chef": {"org": "Pepe's Pizzaria", "rank": 2, "pay": 20, "isBoss": False},
            "Franchisee": {"org": "Pepe's Pizzaria", "rank": 3, "pay": 30, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "postal": {
        "label": "Go Postal",
        "description": "Package and mail delivery services",
        "boss": None,
        "grades": {
            "Delivery Driver": {"org": "Go Postal", "rank": 1, "pay": 16, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "mining": {
        "label": "Caveat Cutters Union",
        "description": "Mining and resource extraction operations",
        "boss": None,
        "grades": {
            "Miner": {"org": "Caveat Cutters Union", "rank": 1, "pay": 18, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "lumber": {
        "label": "Chippy Chop'ns Wood Shop'n",
        "description": "Lumber harvesting and processing",
        "boss": None,
        "grades": {
            "Wood Cutter": {"org": "Chippy Chop'ns Wood Shop'n", "rank": 1, "pay": 16, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "chicken": {
        "label": "Cluckin' Bell",
        "description": "Poultry processing facility",
        "boss": None,
        "grades": {
            "Chicken Packer": {"org": "Cluckin' Bell", "rank": 1, "pay": 14, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "bank": {
        "label": "Fleeca",
        "description": "Financial services and banking",
        "boss": None,
        "grades": {
            "Associate": {"org": "Fleeca", "rank": 1, "pay": 25, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "city": {
        "label": "State Department",
        "description": "City government and administration",
        "boss": None,
        "grades": {
            "Major": {"org": "State Department", "rank": 1, "pay": 40, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "logistics": {
        "label": "OP Logistics",
        "description": "Freight and logistics management",
        "boss": None,
        "grades": {
            "Driver": {"org": "OP Logistics", "rank": 1, "pay": 20, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    },
    "altruists": {
        "label": "Altruists",
        "description": "Altruist cult organization",
        "boss": None,
        "grades": {
            "Repin Nude": {"org": "Altruists", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "lostsc": {
        "label": "Lost Santos Chapter",
        "description": "Lost Santos Chapter motorcycle club",
        "boss": None,
        "grades": {
            "Repin Bikes": {"org": "Lost SC", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "marabunta": {
        "label": "Marabunta Grande",
        "description": "Marabunta Grande organization",
        "boss": None,
        "grades": {
            "Repin Things": {"org": "Marabuntas", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "triads": {
        "label": "Triads",
        "description": "Triads criminal organization",
        "boss": None,
        "grades": {
            "Repin Golden Dragons": {"org": "Triads", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "lostmc": {
        "label": "Lost Motorcycle Club",
        "description": "Lost Motorcycle Club",
        "boss": None,
        "grades": {
            "Repin Bikes": {"org": "Lost MC", "rank": 1, "pay": 0, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": False, "allowEmployeeActions": True}
    },
    "taxi": {
        "label": "Taxi Service",
        "description": "Taxi and transportation services",
        "boss": None,
        "grades": {
            "Driver": {"org": "Taxi Service", "rank": 1, "pay": 18, "isBoss": True}
        },
        "members": [],
        "prices": {},
        "locations": {"sales": [], "delivery": [], "safe": None},
        "memos": [],
        "settings": {"showFinancials": True, "allowEmployeeActions": True}
    }
}

# Write to file
with open('../data/jobs.json', 'w') as f:
    json.dump(jobs, f, indent=2)

print("✅ Jobs.json created with new structure")
print(f"✅ Total jobs: {len(jobs)}")
print("✅ Structure includes:")
print("   - label: Display name")
print("   - description: Job description")
print("   - boss: Character ID of owner (null by default)")
print("   - grades: Object with grade details (org, rank, pay, isBoss)")
print("   - members: Array of Character IDs")
print("   - prices: Object for item pricing")
print("   - locations: sales[], delivery[], safe")
print("   - memos: Array of staff memos")
print("   - settings: showFinancials, allowEmployeeActions")
