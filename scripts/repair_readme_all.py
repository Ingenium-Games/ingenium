#!/usr/bin/env python3
"""
Repair ALL function scope markers in README.md based on actual code locations.
This script uses the verification data to fix all 233 mismatches identified.
"""

import re
import os

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def write_file(path, content):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

def load_actual_scopes():
    """Load actual function scopes from code analysis"""
    # This will be populated by analyzing the codebase
    scopes = {}
    
    # Determine repository root for local vs CI
    env_repo = os.environ.get('GITHUB_WORKSPACE')
    if env_repo and os.path.exists(env_repo):
        repo_root = env_repo
    else:
        repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    # Parse client directory
    client_dir = os.path.join(repo_root, 'client')
    if os.path.exists(client_dir):
        for file in os.listdir(client_dir):
            if file.endswith('.lua'):
                content = read_file(os.path.join(client_dir, file))
                for match in re.finditer(r'function\s+(ig\.\w+\.\w+)\s*\(', content):
                    func_name = match.group(1)
                    if func_name not in scopes:
                        scopes[func_name] = set()
                    scopes[func_name].add('C')

    # Parse server directory
    server_dir = os.path.join(repo_root, 'server')
    if os.path.exists(server_dir):
        for file in os.listdir(server_dir):
            if file.endswith('.lua'):
                content = read_file(os.path.join(server_dir, file))
                for match in re.finditer(r'function\s+(ig\.\w+\.\w+)\s*\(', content):
                    func_name = match.group(1)
                    if func_name not in scopes:
                        scopes[func_name] = set()
                    scopes[func_name].add('S')

    # Parse shared directory
    shared_dir = os.path.join(repo_root, 'shared')
    if os.path.exists(shared_dir):
        for file in os.listdir(shared_dir):
            if file.endswith('.lua'):
                content = read_file(os.path.join(shared_dir, file))
                for match in re.finditer(r'function\s+(ig\.\w+\.\w+)\s*\(', content):
                    func_name = match.group(1)
                    if func_name not in scopes:
                        scopes[func_name] = set()
                    scopes[func_name].add('S')
    
    # Convert sets to scope markers
    result = {}
    for func, locations in scopes.items():
        if locations == {'C', 'S'}:
            result[func] = '[S C]'
        elif locations == {'C'}:
            result[func] = '[C]'
        elif locations == {'S'}:
            result[func] = '[S]'
    
    return result

def fix_all_scopes():
    """Apply all scope fixes from the verification output"""
    
    # Determine README path relative to repo root
    env_repo = os.environ.get('GITHUB_WORKSPACE')
    if env_repo and os.path.exists(env_repo):
        repo_root = env_repo
    else:
        repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    readme_path = os.path.join(repo_root, 'Documentation', 'wiki', 'README.md')
    content = read_file(readme_path)
    
    # Extract lines and process them
    lines = content.split('\n')
    new_lines = []
    changes = 0
    
    # All fixes from the verification output
    fixes = {
        # Client-only (should be [C], not [S C])
        'callback.RegisterClient': '[C]',
        'callback.UnregisterClient': '[C]',
        'chat.AddSuggestions': '[C]',
        'chat.SetPermissions': '[C]',
        'data.GetEntityState': '[C]',
        'data.GetEntityStateCheck': '[C]',
        'data.GetLoadedStatus': '[C]',
        'data.GetLocalPlayer': '[C]',
        'data.GetLocalPlayerState': '[C]',
        'data.GetLocale': '[C]',
        'data.GetPlayerPedState': '[C]',
        'data.GetPlayerState': '[C]',
        'data.IsPlayerLoaded': '[C]',
        'data.Packet': '[C]',
        'data.SetEntityState': '[C]',
        'data.SetLoadedStatus': '[C]',
        'data.SetLocalPlayerState': '[C]',
        'data.SetLocale': '[C]',
        'door.AddDoorsToSystem': '[C]',
        'door.GenerateDoorsInRadius': '[C]',
        'door.GetModels': '[C]',
        'door.SetDoors': '[C]',
        'door.ToggleLock': '[C]',
        'func.GetClosestPosition': '[C]',
        'func.GetObjectsInArea': '[C]',
        'func.GetPedsInArea': '[C]',
        'func.GetPickupsInArea': '[C]',
        'func.GetPlayers': '[C]',
        'func.GetPlayersInArea': '[C]',
        'func.GetVehicleDoorStates': '[C]',
        'func.GetVehicleExtras': '[C]',
        'func.GetVehicleModifications': '[C]',
        'func.GetVehicleMods': '[C]',
        'func.GetVehicleSeatOfPed': '[C]',
        'func.GetVehicleStatebag': '[C]',
        'func.GetVehicleTireStates': '[C]',
        'func.GetVehicleWindowStates': '[C]',
        'func.GetVehiclesInArea': '[C]',
        'func.IsVehicleSpawnClear': '[C]',
        'func.SetVehicleCondition': '[C]',
        'func.SetVehicleDoorStates': '[C]',
        'func.SetVehicleExtras': '[C]',
        'func.SetVehicleExtrasFalse': '[C]',
        'func.SetVehicleModifications': '[C]',
        'func.SetVehicleMods': '[C]',
        'func.SetVehicleStatebag': '[C]',
        'func.SetVehicleTireStates': '[C]',
        'func.SetVehicleWindowStates': '[C]',
        'item.SetItems': '[C]',
        'modkit.ClearCache': '[C]',
        'persistance.UpdateVehicle': '[C]',
        'skill.CompareSkill': '[C]',
        'skill.GetSkill': '[C]',
        'skill.GetSkills': '[C]',
        'skill.SetSkills': '[C]',
        'state.AddState': '[C]',
        'state.ChangeAction': '[C]',
        'state.ChangeEffect': '[C]',
        'state.TriggerAction': '[C]',
        'state.TriggerEffect': '[C]',
        'state.TriggerState': '[C]',
        'tattoo.ClearCache': '[C]',
        'time.ClearOverride': '[C]',
        'time.GetTime': '[C]',
        'time.SetTimeOverride': '[C]',
        'time.UpdateTime': '[C]',
        'vehicle.ClearCache': '[C]',
        'vehicle.GetCurrentSeat': '[C]',
        'vehicle.GetCurrentVehicle': '[C]',
        'vehicle.IsInVehicle': '[C]',
        'weapon.ClearCache': '[C]',
        'weapon.Get': '[C]',
        'weapon.GetComponents': '[C]',
        'weapon.GetName': '[C]',
        
        # Server-only (should be [S], not [S C])
        'appearance.CalculateCost': '[S]',
        'appearance.GetDefaultAppearance': '[S]',
        'appearance.GetDefaultPricing': '[S]',
        'appearance.GetEyeColors': '[S]',
        'appearance.GetHairDecorations': '[S]',
        'appearance.GetHeadOverlays': '[S]',
        'appearance.GetPricing': '[S]',
        'appearance.LoadJobPricing': '[S]',
        'appearance.SaveAllDirtyPricing': '[S]',
        'appearance.SaveAllPricing': '[S]',
        'appearance.UpdatePrice': '[S]',
        'appearance.ValidateAppearance': '[S]',
        'class.BlankObject': '[S]',
        'class.ExistingObject': '[S]',
        'class.Job': '[S]',
        'class.Npc': '[S]',
        'class.OfflinePlayer': '[S]',
        'class.OwnedVehicle': '[S]',
        'class.Player': '[S]',
        'class.Vehicle': '[S]',
        'data.CharacterValues': '[S]',
        'data.CreateJobObjects': '[S]',
        'data.GetJob': '[S]',
        'data.GetJobs': '[S]',
        'data.LoadJSONData': '[S]',
        'data.LoadPlayer': '[S]',
        'data.RestoreDrops': '[S]',
        'data.RetrievePackets': '[S]',
        'data.ReviveSync': '[S]',
        'data.Save': '[S]',
        'data.ServerSync': '[S]',
        'door.ChangeState': '[S]',
        'door.GetDoors': '[S]',
        'drop.Activate': '[S]',
        'drop.CleanupOld': '[S]',
        'drop.Create': '[S]',
        'drop.Deactivate': '[S]',
        'drop.MergeDropsForSave': '[S]',
        'drop.Remove': '[S]',
        'func.GetClosestPlayerPed': '[S]',
        'func.IsAnyPlayerInsideVehicle': '[S]',
        'func.IsPedHuman': '[S]',
        'func.IsPedMale': '[S]',
        'func.Timestring': '[S]',
        'func.identifier': '[S]',
        'func.identifiers': '[S]',
        'inst.GetEntityInstance': '[S]',
        'inst.GetPlayerInstance': '[S]',
        'inst.SetEntity': '[S]',
        'inst.SetEntityDefault': '[S]',
        'inst.SetPlayer': '[S]',
        'inst.SetPlayerDefault': '[S]',
        'item.CanCraft': '[S]',
        'item.GenerateConsumptionEvents': '[S]',
        'item.GetAll': '[S]',
        'item.GetByCategory': '[S]',
        'item.GetByName': '[S]',
        'item.GetByValueRange': '[S]',
        'item.GetByWeightRange': '[S]',
        'item.GetConsumables': '[S]',
        'item.GetCraftable': '[S]',
        'item.GetDegradable': '[S]',
        'item.GetDescription': '[S]',
        'item.GetLabel': '[S]',
        'item.GetRecipe': '[S]',
        'item.GetStackSize': '[S]',
        'item.GetTotalInEconomy': '[S]',
        'item.GetWeapons': '[S]',
        'item.GetWeight': '[S]',
        'item.IsConsumeable': '[S]',
        'item.RequiresLicense': '[S]',
        'item.Search': '[S]',
        'item.ValidateItemData': '[S]',
        'job.CalculatePayroll': '[S]',
        'job.Exists': '[S]',
        'job.GetAll': '[S]',
        'job.GetAllStats': '[S]',
        'job.GetBosses': '[S]',
        'job.GetByBoss': '[S]',
        'job.GetByCategory': '[S]',
        'job.GetByName': '[S]',
        'job.GetCount': '[S]',
        'job.GetGradeInfo': '[S]',
        'job.GetGradeName': '[S]',
        'job.GetGradeSalary': '[S]',
        'job.GetHiring': '[S]',
        'job.GetMembers': '[S]',
        'job.GetOnDutyCount': '[S]',
        'job.GetOnlineMembers': '[S]',
        'job.GetOnlineMembersByGrade': '[S]',
        'job.GetPayrollEligible': '[S]',
        'job.GetRichest': '[S]',
        'job.GetStats': '[S]',
        'job.GetTotalMemberCount': '[S]',
        'job.IsBossGrade': '[S]',
        'job.IsBossOfAny': '[S]',
        'job.ProcessPayroll': '[S]',
        'job.Resync': '[S]',
        'job.Search': '[S]',
        'job.ValidateData': '[S]',
        'modkit.GetByID': '[S]',
        'modkit.HasModkit': '[S]',
        'modkit.Load': '[S]',
        'npc.AddNpc': '[S]',
        'npc.FindNpc': '[S]',
        'npc.GetNpc': '[S]',
        'npc.GetNpcs': '[S]',
        'npc.RemoveNpc': '[S]',
        'ped.GetAll': '[S]',
        'ped.GetByGender': '[S]',
        'ped.GetByHash': '[S]',
        'ped.GetByName': '[S]',
        'ped.GetByType': '[S]',
        'ped.GetDisplayName': '[S]',
        'ped.GetFemalePeds': '[S]',
        'ped.GetFreemodePeds': '[S]',
        'ped.GetMalePeds': '[S]',
        'ped.IsFemale': '[S]',
        'ped.IsFreemode': '[S]',
        'ped.IsMale': '[S]',
        'ped.IsValid': '[S]',
        'persistance.ObjectThread': '[S]',
        'persistance.VehicleThread': '[S]',
        'security.AddAllowedStateBagKey': '[S]',
        'security.AddBlockedStateBagKey': '[S]',
        'security.CheckRateLimit': '[S]',
        'security.CheckTransactionRateLimit': '[S]',
        'security.DetectSuspiciousActivity': '[S]',
        'tattoo.GetByCollection': '[S]',
        'tattoo.GetByHash': '[S]',
        'tattoo.IsFemale': '[S]',
        'tattoo.IsMale': '[S]',
        'time.ServerSync': '[S]',
        'time.Update': '[S]',
        'vehicle.AddVehicle': '[S]',
        'vehicle.FindVehicle': '[S]',
        'vehicle.FindVehicleFromPlate': '[S]',
        'vehicle.GetByClass': '[S]',
        'vehicle.GetByManufacturer': '[S]',
        'vehicle.GetByName': '[S]',
        'vehicle.GetVehicle': '[S]',
        'vehicle.GetVehicleByPlate': '[S]',
        'vehicle.GetVehicles': '[S]',
        'vehicle.IsAircraft': '[S]',
        'vehicle.IsBoa': '[S]',
        'vehicle.Load': '[S]',
        'vehicle.RemoveVehicle': '[S]',
        'vehicle.SetVehicle': '[S]',
        'weapon.Exist': '[S]',
        'weapon.GetByCategory': '[S]',
        'weapon.GetByName': '[S]',
        'weapon.IsMelee': '[S]',
        'weapon.Resync': '[S]',
        
        # Appearance dual-scope (both client and server)
        'appearance.GetComponents': '[S C]',
        'appearance.GetConstants': '[S C]',
        'appearance.GetFaceFeatures': '[S C]',
        'appearance.GetProps': '[S C]',
        
        # Callback functions that are dual-scope (uses IsDuplicityVersion)
        'callback.RegisterServer': '[S C]',
        'callback.UnregisterServer': '[S C]',
        'callback.RegisterClient': '[S C]',
        'callback.UnregisterClient': '[S C]',
    }
    
    for line in lines:
        new_line = line
        # Pattern: - [ig.namespace.FunctionName](link.md) [SCOPE]
        for func_name, correct_marker in fixes.items():
            # Look for function in line
            if f'ig.{func_name}' in line and '[' in line:
                # Replace the scope marker at the end of the line
                pattern = r'(\[ig\.' + re.escape(func_name) + r'\]\([^)]+\))\s*\[[S C]+\]'
                replacement = r'\1 ' + correct_marker
                new_line = re.sub(pattern, replacement, new_line)
                if new_line != line:
                    changes += 1
                    print(f"✅ Fixed {func_name}: {correct_marker}")
        new_lines.append(new_line)
    
    new_content = '\n'.join(new_lines)
    write_file(readme_path, new_content)
    return changes

if __name__ == '__main__':
    changes = fix_all_scopes()
    print(f"\n📝 Applied {changes} fixes to README.md")
    
    if changes > 0:
        exit(0)  # Signal that changes were made
    else:
        exit(1)  # Signal no changes
