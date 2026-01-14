# Ingenium Framework - Complete Function & Event Reference

**745+ functions** | **100+ events** | **62+ public exports** | **11+ public events**

---

## ✅ Best Practice: Declaring the Framework Object

When using Ingenium from an external resource, declare the framework as a global variable at the start of your script:

```lua
-- Declare at the top of your resource.
ig = exports["ingenium"]:GetIngenium()

-- Then use it throughout your resource:
ig.func.Notify("Hello!", "green", 3000)
ig.inventory.GetInventory()
ig.appearance.SetAppearance(appearanceData)
```

---

## Complete Namespace Reference

### affiliation

affiliation namespace functions.

- [ig.affiliation.AddGroupToTable](ig_affiliation_AddGroupToTable.md) [C]
- [ig.affiliation.ClearGroupRelationship](ig_affiliation_ClearGroupRelationship.md) [C]
- [ig.affiliation.ConfigureGroupRelationships](ig_affiliation_ConfigureGroupRelationships.md) [C]
- [ig.affiliation.CreateGroup](ig_affiliation_CreateGroup.md) [C]
- [ig.affiliation.GetGroupHash](ig_affiliation_GetGroupHash.md) [C]
- [ig.affiliation.GetGroupRelationship](ig_affiliation_GetGroupRelationship.md) [C]
- [ig.affiliation.GetGroups](ig_affiliation_GetGroups.md) [C]
- [ig.affiliation.GetPedRelationship](ig_affiliation_GetPedRelationship.md) [C]
- [ig.affiliation.GroupExists](ig_affiliation_GroupExists.md) [C]
- [ig.affiliation.SetGroupRelationship](ig_affiliation_SetGroupRelationship.md) [C]
- [ig.affiliation.SetGroupRelationshipDirectional](ig_affiliation_SetGroupRelationshipDirectional.md) [C]
- [ig.affiliation.SetPedDefaultGroup](ig_affiliation_SetPedDefaultGroup.md) [C]
- [ig.affiliation.SetPedGroup](ig_affiliation_SetPedGroup.md) [C]

### ammo

ammo namespace functions.

- [ig.ammo.Get](ig_ammo_Get.md) [C]
- [ig.ammo.GetType](ig_ammo_GetType.md) [C]

### appearance

appearance namespace functions.

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md) [C]
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md) [C]
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md) [C]
- [ig.appearance.CalculateCost](ig_appearance_CalculateCost.md) [S]
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md) [C]
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md) [C]
- [ig.appearance.DestroyCamera](ig_appearance_DestroyCamera.md) [C]
- [ig.appearance.GetAppearance](ig_appearance_GetAppearance.md) [C]
- [ig.appearance.GetCameraMode](ig_appearance_GetCameraMode.md) [C]
- [ig.appearance.GetComponent](ig_appearance_GetComponent.md) [C]
- [ig.appearance.GetComponents](ig_appearance_GetComponents.md) [S C]
- [ig.appearance.GetConstants](ig_appearance_GetConstants.md) [S C]
- [ig.appearance.GetDefaultAppearance](ig_appearance_GetDefaultAppearance.md) [S]
- [ig.appearance.GetDefaultPricing](ig_appearance_GetDefaultPricing.md) [S]
- [ig.appearance.GetEyeColor](ig_appearance_GetEyeColor.md) [C]
- [ig.appearance.GetEyeColors](ig_appearance_GetEyeColors.md) [S]
- [ig.appearance.GetFaceFeatures](ig_appearance_GetFaceFeatures.md) [S C]
- [ig.appearance.GetHair](ig_appearance_GetHair.md) [C]
- [ig.appearance.GetHairDecorations](ig_appearance_GetHairDecorations.md) [S]
- [ig.appearance.GetHeadBlend](ig_appearance_GetHeadBlend.md) [C]
- [ig.appearance.GetHeadOverlays](ig_appearance_GetHeadOverlays.md) [S]
- [ig.appearance.GetModel](ig_appearance_GetModel.md) [C]
- [ig.appearance.GetPricing](ig_appearance_GetPricing.md) [S]
- [ig.appearance.GetProp](ig_appearance_GetProp.md) [C]
- [ig.appearance.GetProps](ig_appearance_GetProps.md) [S C]
- [ig.appearance.Initialize](ig_appearance_Initialize.md) [C]
- [ig.appearance.IsCustomizationActive](ig_appearance_IsCustomizationActive.md) [C]
- [ig.appearance.IsFreemode](ig_appearance_IsFreemode.md) [C]
- [ig.appearance.LoadJobPricing](ig_appearance_LoadJobPricing.md) [S]
- [ig.appearance.RotateCamera](ig_appearance_RotateCamera.md) [C]
- [ig.appearance.SaveAllDirtyPricing](ig_appearance_SaveAllDirtyPricing.md) [S]
- [ig.appearance.SaveAllPricing](ig_appearance_SaveAllPricing.md) [S]
- [ig.appearance.SetAppearance](ig_appearance_SetAppearance.md) [C]
- [ig.appearance.SetCameraView](ig_appearance_SetCameraView.md) [C]
- [ig.appearance.SetComponent](ig_appearance_SetComponent.md) [C]
- [ig.appearance.SetComponents](ig_appearance_SetComponents.md) [C]
- [ig.appearance.SetCustomizationActive](ig_appearance_SetCustomizationActive.md) [C]
- [ig.appearance.SetEyeColor](ig_appearance_SetEyeColor.md) [C]
- [ig.appearance.SetFaceFeature](ig_appearance_SetFaceFeature.md) [C]
- [ig.appearance.SetFaceFeatures](ig_appearance_SetFaceFeatures.md) [C]
- [ig.appearance.SetHair](ig_appearance_SetHair.md) [C]
- [ig.appearance.SetHeadBlend](ig_appearance_SetHeadBlend.md) [C]
- [ig.appearance.SetHeadOverlay](ig_appearance_SetHeadOverlay.md) [C]
- [ig.appearance.SetHeadOverlays](ig_appearance_SetHeadOverlays.md) [C]
- [ig.appearance.SetModel](ig_appearance_SetModel.md) [C]
- [ig.appearance.SetProp](ig_appearance_SetProp.md) [C]
- [ig.appearance.SetProps](ig_appearance_SetProps.md) [C]
- [ig.appearance.TurnAround](ig_appearance_TurnAround.md) [C]
- [ig.appearance.UpdatePrice](ig_appearance_UpdatePrice.md) [S]
- [ig.appearance.ValidateAppearance](ig_appearance_ValidateAppearance.md) [S]

### bank

bank namespace functions.

- [ig.bank.CalculateInterest](ig_bank_CalculateInterest.md) [S]
- [ig.bank.CalculatePayments](ig_bank_CalculatePayments.md) [S]
- [ig.bank.CheckNegativeBalances](ig_bank_CheckNegativeBalances.md) [S]

### blip

blip namespace functions.

- [ig.blip.AreaBlip](ig_blip_AreaBlip.md) [C]
- [ig.blip.Blip](ig_blip_Blip.md) [C]
- [ig.blip.CreateArea](ig_blip_CreateArea.md) [C]
- [ig.blip.CreateBlip](ig_blip_CreateBlip.md) [C]
- [ig.blip.CreateRadius](ig_blip_CreateRadius.md) [C]
- [ig.blip.EntityBlip](ig_blip_EntityBlip.md) [C]
- [ig.blip.GetBlip](ig_blip_GetBlip.md) [C]
- [ig.blip.RadiusBlip](ig_blip_RadiusBlip.md) [C]
- [ig.blip.Remove](ig_blip_Remove.md) [C]

### callback

callback namespace functions.

- [ig.callback.Async](ig_callback_Async.md) [C]
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md) [C]
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md) [C]
- [ig.callback.Await](ig_callback_Await.md) [C]
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md) [C]
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md) [C]
- [ig.callback.RegisterClient](ig_callback_RegisterClient.md) [C]
- [ig.callback.RegisterServer](ig_callback_RegisterServer.md) [S C]
- [ig.callback.UnregisterClient](ig_callback_UnregisterClient.md) [C]
- [ig.callback.UnregisterServer](ig_callback_UnregisterServer.md) [S C]

### camera

camera namespace functions.

- [ig.camera.Advanced](ig_camera_Advanced.md) [C]
- [ig.camera.Basic](ig_camera_Basic.md) [C]
- [ig.camera.CleanUp](ig_camera_CleanUp.md) [C]
- [ig.camera.NewName](ig_camera_NewName.md) [C]

### chat

chat namespace functions.

- [ig.chat.AddSuggestions](ig_chat_AddSuggestions.md) [C]
- [ig.chat.FormatLogEntry](ig_chat_FormatLogEntry.md) [S]
- [ig.chat.LogMessage](ig_chat_LogMessage.md) [S]
- [ig.chat.SetPermissions](ig_chat_SetPermissions.md) [C]

### check

check namespace functions.

- [ig.check.Boolean](ig_check_Boolean.md) [S C]
- [ig.check.Number](ig_check_Number.md) [S C]
- [ig.check.String](ig_check_String.md) [S C]
- [ig.check.Table](ig_check_Table.md) [S C]

### class

class namespace functions.

- [ig.class.BlankObject](ig_class_BlankObject.md) [S]
- [ig.class.ExistingObject](ig_class_ExistingObject.md) [S]
- [ig.class.Job](ig_class_Job.md) [S]
- [ig.class.Npc](ig_class_Npc.md) [S]
- [ig.class.OfflinePlayer](ig_class_OfflinePlayer.md) [S]
- [ig.class.OwnedVehicle](ig_class_OwnedVehicle.md) [S]
- [ig.class.Player](ig_class_Player.md) [S]
- [ig.class.Vehicle](ig_class_Vehicle.md) [S]

### cron

cron namespace functions.

- [ig.cron.OnTime](ig_cron_OnTime.md) [S]
- [ig.cron.RunAt](ig_cron_RunAt.md) [S]

### data

data namespace functions.

- [ig.data.AddPlayer](ig_data_AddPlayer.md) [S] ⚠️ Missing Documentation
- [ig.data.CharacterValues](ig_data_CharacterValues.md) [S]
- [ig.data.CreateJobObjects](ig_data_CreateJobObjects.md) [S]
- [ig.data.GetEntityState](ig_data_GetEntityState.md) [C]
- [ig.data.GetEntityStateCheck](ig_data_GetEntityStateCheck.md) [C]
- [ig.data.GetJob](ig_data_GetJob.md) [S]
- [ig.data.GetJobs](ig_data_GetJobs.md) [S]
- [ig.data.GetLoadedStatus](ig_data_GetLoadedStatus.md) [C]
- [ig.data.GetLocalPlayer](ig_data_GetLocalPlayer.md) [C]
- [ig.data.GetLocalPlayerState](ig_data_GetLocalPlayerState.md) [C]
- [ig.data.GetLocale](ig_data_GetLocale.md) [C]
- [ig.data.GetPlayer](ig_data_GetPlayer.md) [S C]
- [ig.data.GetPlayerByCharacterId](ig_data_GetPlayerByCharacterId.md) [S]
- [ig.data.GetPlayerPedState](ig_data_GetPlayerPedState.md) [C]
- [ig.data.GetPlayerState](ig_data_GetPlayerState.md) [C]
- [ig.data.GetPlayers](ig_data_GetPlayers.md) [S] ⚠️ Missing Documentation
- [ig.data.Initilize](ig_data_Initilize.md) [S C]
- [ig.data.IsPlayerLoaded](ig_data_IsPlayerLoaded.md) [C]
- [ig.data.LoadJSONData](ig_data_LoadJSONData.md) [S]
- [ig.data.LoadPlayer](ig_data_LoadPlayer.md) [S]
- [ig.data.Packet](ig_data_Packet.md) [C]
- [ig.data.RemovePlayer](ig_data_RemovePlayer.md) [S] ⚠️ Missing Documentation
- [ig.data.RestoreDrops](ig_data_RestoreDrops.md) [S]
- [ig.data.RetrievePackets](ig_data_RetrievePackets.md) [S]
- [ig.data.ReviveSync](ig_data_ReviveSync.md) [S]
- [ig.data.Save](ig_data_Save.md) [S]
- [ig.data.ServerSync](ig_data_ServerSync.md) [S]
- [ig.data.SetEntityState](ig_data_SetEntityState.md) [C]
- [ig.data.SetLoadedStatus](ig_data_SetLoadedStatus.md) [C]
- [ig.data.SetLocalPlayerState](ig_data_SetLocalPlayerState.md) [C]
- [ig.data.SetLocale](ig_data_SetLocale.md) [C]
- [ig.data.SetPlayer](ig_data_SetPlayer.md) [S] ⚠️ Missing Documentation

### death

death namespace functions.

- [ig.death.PlayerKilled](ig_death_PlayerKilled.md) [C] ⚠️ Missing Documentation

### debug

debug namespace functions.

- [ig.debug.Debug](ig_debug_Debug.md) [S C] ⚠️ Missing Documentation
- [ig.debug.Error](ig_debug_Error.md) [S C] ⚠️ Missing Documentation
- [ig.debug.ErrorHandler](ig_debug_ErrorHandler.md) [S C] ⚠️ Missing Documentation
- [ig.debug.FormatMessage](ig_debug_FormatMessage.md) [S C] ⚠️ Missing Documentation
- [ig.debug.GetContext](ig_debug_GetContext.md) [S C] ⚠️ Missing Documentation
- [ig.debug.GetLevel](ig_debug_GetLevel.md) [S C] ⚠️ Missing Documentation
- [ig.debug.Info](ig_debug_Info.md) [S C] ⚠️ Missing Documentation
- [ig.debug.Log](ig_debug_Log.md) [S C] ⚠️ Missing Documentation
- [ig.debug.Trace](ig_debug_Trace.md) [S C] ⚠️ Missing Documentation
- [ig.debug.Warn](ig_debug_Warn.md) [S C] ⚠️ Missing Documentation
- [ig.debug.Wrap](ig_debug_Wrap.md) [S C] ⚠️ Missing Documentation

### discord

discord namespace functions.

- [ig.discord.GetDiscordId](ig_discord_GetDiscordId.md) [S] ⚠️ Missing Documentation
- [ig.discord.GetPriority](ig_discord_GetPriority.md) [S] ⚠️ Missing Documentation
- [ig.discord.HasAnyRole](ig_discord_HasAnyRole.md) [S] ⚠️ Missing Documentation
- [ig.discord.HasMemberRole](ig_discord_HasMemberRole.md) [S] ⚠️ Missing Documentation
- [ig.discord.HasRole](ig_discord_HasRole.md) [S] ⚠️ Missing Documentation

### door

door namespace functions.

- [ig.door.Add](ig_door_Add.md) [S C]
- [ig.door.AddDoorsToSystem](ig_door_AddDoorsToSystem.md) [C]
- [ig.door.ChangeState](ig_door_ChangeState.md) [S]
- [ig.door.Find](ig_door_Find.md) [S C]
- [ig.door.FindHash](ig_door_FindHash.md) [S C]
- [ig.door.GenerateDoorsInRadius](ig_door_GenerateDoorsInRadius.md) [C]
- [ig.door.GetDoors](ig_door_GetDoors.md) [S]
- [ig.door.GetModels](ig_door_GetModels.md) [C]
- [ig.door.SetDoors](ig_door_SetDoors.md) [C]
- [ig.door.SetState](ig_door_SetState.md) [S C]
- [ig.door.ToggleLock](ig_door_ToggleLock.md) [C]

### drop

drop namespace functions.

- [ig.drop.Activate](ig_drop_Activate.md) [S]
- [ig.drop.CleanupOld](ig_drop_CleanupOld.md) [S]
- [ig.drop.Create](ig_drop_Create.md) [S]
- [ig.drop.Deactivate](ig_drop_Deactivate.md) [S]
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md) [S]
- [ig.drop.Remove](ig_drop_Remove.md) [S]

### event

event namespace functions.

- [ig.event.AddInteractJobEvent](ig_event_AddInteractJobEvent.md) [S]

### file

file namespace functions.

- [ig.file.Append](ig_file_Append.md) [S C]
- [ig.file.Exists](ig_file_Exists.md) [S C]
- [ig.file.Read](ig_file_Read.md) [S C]
- [ig.file.Write](ig_file_Write.md) [S C]

### func

func namespace functions.

- [ig.func.Alert](ig_func_Alert.md) [S C]
- [ig.func.ClearInterval](ig_func_ClearInterval.md) [S C]
- [ig.func.CompareCoords](ig_func_CompareCoords.md) [C]
- [ig.func.CreateObject](ig_func_CreateObject.md) [S C]
- [ig.func.CreatePed](ig_func_CreatePed.md) [S C]
- [ig.func.CreateVehicle](ig_func_CreateVehicle.md) [S C]
- [ig.func.Debug_1](ig_func_Debug_1.md) [S C]
- [ig.func.Debug_2](ig_func_Debug_2.md) [S C]
- [ig.func.Debug_3](ig_func_Debug_3.md) [S C]
- [ig.func.DeleteVehicle](ig_func_DeleteVehicle.md) [C]
- [ig.func.Discord](ig_func_Discord.md) [S]
- [ig.func.Discorse](ig_func_Discorse.md) [S]
- [ig.func.Err](ig_func_Err.md) [S C]
- [ig.func.Error](ig_func_Error.md) [S C]
- [ig.func.Eventban](ig_func_Eventban.md) [S]
- [ig.func.FadeIn](ig_func_FadeIn.md) [C]
- [ig.func.FadeOut](ig_func_FadeOut.md) [C]
- [ig.func.Func](ig_func_Func.md) [S C]
- [ig.func.GetAllPlayerPeds](ig_func_GetAllPlayerPeds.md) [S]
- [ig.func.GetClosestPed](ig_func_GetClosestPed.md) [C]
- [ig.func.GetClosestPlayer](ig_func_GetClosestPlayer.md) [S C]
- [ig.func.GetClosestPlayerPed](ig_func_GetClosestPlayerPed.md) [S]
- [ig.func.GetClosestPosition](ig_func_GetClosestPosition.md) [C]
- [ig.func.GetClosestVehicle](ig_func_GetClosestVehicle.md) [C]
- [ig.func.GetEntityFromRay](ig_func_GetEntityFromRay.md) [C]
- [ig.func.GetObjectsInArea](ig_func_GetObjectsInArea.md) [C]
- [ig.func.GetPedsInArea](ig_func_GetPedsInArea.md) [C]
- [ig.func.GetPickupsInArea](ig_func_GetPickupsInArea.md) [C]
- [ig.func.GetPlayers](ig_func_GetPlayers.md) [C]
- [ig.func.GetPlayersInArea](ig_func_GetPlayersInArea.md) [C]
- [ig.func.GetVehicleCondition](ig_func_GetVehicleCondition.md) [C]
- [ig.func.GetVehicleDoorStates](ig_func_GetVehicleDoorStates.md) [C]
- [ig.func.GetVehicleExtras](ig_func_GetVehicleExtras.md) [C]
- [ig.func.GetVehicleModifications](ig_func_GetVehicleModifications.md) [C]
- [ig.func.GetVehicleMods](ig_func_GetVehicleMods.md) [C]
- [ig.func.GetVehicleSeatOfPed](ig_func_GetVehicleSeatOfPed.md) [C]
- [ig.func.GetVehicleStatebag](ig_func_GetVehicleStatebag.md) [C]
- [ig.func.GetVehicleTireStates](ig_func_GetVehicleTireStates.md) [C]
- [ig.func.GetVehicleWindowStates](ig_func_GetVehicleWindowStates.md) [C]
- [ig.func.GetVehiclesInArea](ig_func_GetVehiclesInArea.md) [C]
- [ig.func.HasPlayers](ig_func_HasPlayers.md) [S]
- [ig.func.IsAnyPlayerInsideVehicle](ig_func_IsAnyPlayerInsideVehicle.md) [S]
- [ig.func.IsBusy](ig_func_IsBusy.md) [C]
- [ig.func.IsBusyPleaseWait](ig_func_IsBusyPleaseWait.md) [C]
- [ig.func.IsPedHuman](ig_func_IsPedHuman.md) [S]
- [ig.func.IsPedMale](ig_func_IsPedMale.md) [S]
- [ig.func.IsVehicleSpawnClear](ig_func_IsVehicleSpawnClear.md) [C]
- [ig.func.NotBusy](ig_func_NotBusy.md) [C]
- [ig.func.PleaseWait](ig_func_PleaseWait.md) [C]
- [ig.func.SetInterval](ig_func_SetInterval.md) [S C]
- [ig.func.SetVehicleCondition](ig_func_SetVehicleCondition.md) [C]
- [ig.func.SetVehicleDoorStates](ig_func_SetVehicleDoorStates.md) [C]
- [ig.func.SetVehicleExtras](ig_func_SetVehicleExtras.md) [C]
- [ig.func.SetVehicleExtrasFalse](ig_func_SetVehicleExtrasFalse.md) [C]
- [ig.func.SetVehicleModifications](ig_func_SetVehicleModifications.md) [C]
- [ig.func.SetVehicleMods](ig_func_SetVehicleMods.md) [C]
- [ig.func.SetVehicleStatebag](ig_func_SetVehicleStatebag.md) [C]
- [ig.func.SetVehicleTireStates](ig_func_SetVehicleTireStates.md) [C]
- [ig.func.SetVehicleWindowStates](ig_func_SetVehicleWindowStates.md) [C]
- [ig.func.Timestamp](ig_func_Timestamp.md) [S]
- [ig.func.Timestring](ig_func_Timestring.md) [S]
- [ig.func.WaitUntilNetIdExists](ig_func_WaitUntilNetIdExists.md) [C]
- [ig.func.WaitUntilPlayerIsOwner](ig_func_WaitUntilPlayerIsOwner.md) [C]
- [ig.func.identifier](ig_func_identifier.md) [S]
- [ig.func.identifiers](ig_func_identifiers.md) [S]

### fx

fx namespace functions.

- [ig.fx.StartDeath](ig_fx_StartDeath.md) [C]
- [ig.fx.StopDeath](ig_fx_StopDeath.md) [C]

### game

game namespace functions.

- [ig.game.GetGameMode](ig_game_GetGameMode.md) [S C]
- [ig.game.GetGameModeSettings](ig_game_GetGameModeSettings.md) [S C]
- [ig.game.IsGameModeFeatureEnabled](ig_game_IsGameModeFeatureEnabled.md) [S C]

### gsr

gsr namespace functions.

- [ig.gsr.Add](ig_gsr_Add.md) [S]
- [ig.gsr.Clean](ig_gsr_Clean.md) [S]
- [ig.gsr.CleanOld](ig_gsr_CleanOld.md) [S]
- [ig.gsr.Clear](ig_gsr_Clear.md) [S]
- [ig.gsr.Create](ig_gsr_Create.md) [S]
- [ig.gsr.Exist](ig_gsr_Exist.md) [S]
- [ig.gsr.GetAll](ig_gsr_GetAll.md) [S]
- [ig.gsr.GetByCharacter](ig_gsr_GetByCharacter.md) [S]
- [ig.gsr.GetByID](ig_gsr_GetByID.md) [S]
- [ig.gsr.GetByWeapon](ig_gsr_GetByWeapon.md) [S]
- [ig.gsr.GetCount](ig_gsr_GetCount.md) [S]
- [ig.gsr.GetNearby](ig_gsr_GetNearby.md) [S]
- [ig.gsr.GetRecent](ig_gsr_GetRecent.md) [S]
- [ig.gsr.GetStats](ig_gsr_GetStats.md) [S]
- [ig.gsr.HasRecent](ig_gsr_HasRecent.md) [S]
- [ig.gsr.IncrementShots](ig_gsr_IncrementShots.md) [S]
- [ig.gsr.Load](ig_gsr_Load.md) [S]
- [ig.gsr.Remove](ig_gsr_Remove.md) [S]
- [ig.gsr.Test](ig_gsr_Test.md) [S]

### inst

inst namespace functions.

- [ig.inst.GetEntityInstance](ig_inst_GetEntityInstance.md) [S]
- [ig.inst.GetPlayerInstance](ig_inst_GetPlayerInstance.md) [S]
- [ig.inst.SetEntity](ig_inst_SetEntity.md) [S]
- [ig.inst.SetEntityDefault](ig_inst_SetEntityDefault.md) [S]
- [ig.inst.SetPlayer](ig_inst_SetPlayer.md) [S]
- [ig.inst.SetPlayerDefault](ig_inst_SetPlayerDefault.md) [S]

### inventory

inventory namespace functions.

- [ig.inventory.GetInventory](ig_inventory_GetInventory.md) [C]
- [ig.inventory.GetItemData](ig_inventory_GetItemData.md) [C]
- [ig.inventory.GetItemFromPosition](ig_inventory_GetItemFromPosition.md) [C]
- [ig.inventory.GetItemMeta](ig_inventory_GetItemMeta.md) [C]
- [ig.inventory.GetItemQuality](ig_inventory_GetItemQuality.md) [C]
- [ig.inventory.GetItemQuantity](ig_inventory_GetItemQuantity.md) [C]
- [ig.inventory.GetWeight](ig_inventory_GetWeight.md) [C]
- [ig.inventory.HasItem](ig_inventory_HasItem.md) [C]

### ipl

ipl namespace functions.

- [ig.ipl.Get](ig_ipl_Get.md) [C]
- [ig.ipl.GetAll](ig_ipl_GetAll.md) [C]
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md) [C]
- [ig.ipl.Load](ig_ipl_Load.md) [C]
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md) [C]
- [ig.ipl.LoadConfigurations](ig_ipl_LoadConfigurations.md) [C]
- [ig.ipl.LoadMultiple](ig_ipl_LoadMultiple.md) [C]
- [ig.ipl.Register](ig_ipl_Register.md) [C]
- [ig.ipl.SetupZoneHandler](ig_ipl_SetupZoneHandler.md) [C]
- [ig.ipl.Unload](ig_ipl_Unload.md) [C]
- [ig.ipl.UnloadByName](ig_ipl_UnloadByName.md) [C]
- [ig.ipl.UnloadMultiple](ig_ipl_UnloadMultiple.md) [C]

### item

item namespace functions.

- [ig.item.CanCraft](ig_item_CanCraft.md) [S]
- [ig.item.CanDegrade](ig_item_CanDegrade.md) [S C]
- [ig.item.CanHotkey](ig_item_CanHotkey.md) [S C]
- [ig.item.CanStack](ig_item_CanStack.md) [S C]
- [ig.item.Exists](ig_item_Exists.md) [S C]
- [ig.item.GenerateConsumptionEvents](ig_item_GenerateConsumptionEvents.md) [S]
- [ig.item.GetAbout](ig_item_GetAbout.md) [S C]
- [ig.item.GetAll](ig_item_GetAll.md) [S]
- [ig.item.GetByCategory](ig_item_GetByCategory.md) [S]
- [ig.item.GetByName](ig_item_GetByName.md) [S]
- [ig.item.GetByValueRange](ig_item_GetByValueRange.md) [S]
- [ig.item.GetByWeightRange](ig_item_GetByWeightRange.md) [S]
- [ig.item.GetConsumables](ig_item_GetConsumables.md) [S]
- [ig.item.GetCraftable](ig_item_GetCraftable.md) [S]
- [ig.item.GetData](ig_item_GetData.md) [S C]
- [ig.item.GetDegradable](ig_item_GetDegradable.md) [S]
- [ig.item.GetDescription](ig_item_GetDescription.md) [S]
- [ig.item.GetItem](ig_item_GetItem.md) [S C]
- [ig.item.GetItems](ig_item_GetItems.md) [S C]
- [ig.item.GetLabel](ig_item_GetLabel.md) [S]
- [ig.item.GetMeta](ig_item_GetMeta.md) [S C]
- [ig.item.GetRecipe](ig_item_GetRecipe.md) [S]
- [ig.item.GetStackSize](ig_item_GetStackSize.md) [S]
- [ig.item.GetTotalInEconomy](ig_item_GetTotalInEconomy.md) [S]
- [ig.item.GetValue](ig_item_GetValue.md) [S C]
- [ig.item.GetWeaponAmmoType](ig_item_GetWeaponAmmoType.md) [S C]
- [ig.item.GetWeapons](ig_item_GetWeapons.md) [S]
- [ig.item.GetWeight](ig_item_GetWeight.md) [S]
- [ig.item.IsConsumeable](ig_item_IsConsumeable.md) [S]
- [ig.item.IsCraftable](ig_item_IsCraftable.md) [S C]
- [ig.item.IsWeapon](ig_item_IsWeapon.md) [S C]
- [ig.item.RequiresLicense](ig_item_RequiresLicense.md) [S]
- [ig.item.ReturnPosition](ig_item_ReturnPosition.md) [S C]
- [ig.item.Search](ig_item_Search.md) [S]
- [ig.item.SetItems](ig_item_SetItems.md) [C]
- [ig.item.ValidateItemData](ig_item_ValidateItemData.md) [S]

### job

job namespace functions.

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md) [S]
- [ig.job.Exists](ig_job_Exists.md) [S]
- [ig.job.GetAll](ig_job_GetAll.md) [S]
- [ig.job.GetAllStats](ig_job_GetAllStats.md) [S]
- [ig.job.GetBosses](ig_job_GetBosses.md) [S]
- [ig.job.GetByBoss](ig_job_GetByBoss.md) [S]
- [ig.job.GetByCategory](ig_job_GetByCategory.md) [S]
- [ig.job.GetByName](ig_job_GetByName.md) [S]
- [ig.job.GetCount](ig_job_GetCount.md) [S]
- [ig.job.GetGradeInfo](ig_job_GetGradeInfo.md) [S]
- [ig.job.GetGradeName](ig_job_GetGradeName.md) [S]
- [ig.job.GetGradeSalary](ig_job_GetGradeSalary.md) [S]
- [ig.job.GetHiring](ig_job_GetHiring.md) [S]
- [ig.job.GetMembers](ig_job_GetMembers.md) [S]
- [ig.job.GetOnDutyCount](ig_job_GetOnDutyCount.md) [S]
- [ig.job.GetOnlineMembers](ig_job_GetOnlineMembers.md) [S]
- [ig.job.GetOnlineMembersByGrade](ig_job_GetOnlineMembersByGrade.md) [S]
- [ig.job.GetPayrollEligible](ig_job_GetPayrollEligible.md) [S]
- [ig.job.GetRichest](ig_job_GetRichest.md) [S]
- [ig.job.GetStats](ig_job_GetStats.md) [S]
- [ig.job.GetTotalMemberCount](ig_job_GetTotalMemberCount.md) [S]
- [ig.job.IsBossGrade](ig_job_IsBossGrade.md) [S]
- [ig.job.IsBossOfAny](ig_job_IsBossOfAny.md) [S]
- [ig.job.ProcessPayroll](ig_job_ProcessPayroll.md) [S]
- [ig.job.Resync](ig_job_Resync.md) [S]
- [ig.job.Search](ig_job_Search.md) [S]
- [ig.job.ValidateData](ig_job_ValidateData.md) [S]

### json

json namespace functions.

- [ig.json.Load](ig_json_Load.md) [S C]
- [ig.json.Write](ig_json_Write.md) [S C]

### log

log namespace functions.

- [ig.log.Debug](ig_log_Debug.md) [S C]
- [ig.log.Error](ig_log_Error.md) [S C]
- [ig.log.Info](ig_log_Info.md) [S C]
- [ig.log.Log](ig_log_Log.md) [S C]
- [ig.log.Trace](ig_log_Trace.md) [S C]
- [ig.log.Warn](ig_log_Warn.md) [S C]

### marker

marker namespace functions.

- [ig.marker.Place](ig_marker_Place.md) [C]

### math

math namespace functions.

- [ig.math.Decimals](ig_math_Decimals.md) [S C]
- [ig.math.GroupDigits](ig_math_GroupDigits.md) [S C]
- [ig.math.Round](ig_math_Round.md) [S C]
- [ig.math.Trim](ig_math_Trim.md) [S C]

### modifier

modifier namespace functions.

- [ig.modifier.AddHungerModifier](ig_modifier_AddHungerModifier.md) [C]
- [ig.modifier.AddStressModifier](ig_modifier_AddStressModifier.md) [C]
- [ig.modifier.AddThirstModifier](ig_modifier_AddThirstModifier.md) [C]
- [ig.modifier.DegradeModifiers](ig_modifier_DegradeModifiers.md) [C]
- [ig.modifier.GetDegradeBoost](ig_modifier_GetDegradeBoost.md) [C]
- [ig.modifier.GetHungerModifier](ig_modifier_GetHungerModifier.md) [C]
- [ig.modifier.GetModifiers](ig_modifier_GetModifiers.md) [C]
- [ig.modifier.GetStressModifier](ig_modifier_GetStressModifier.md) [C]
- [ig.modifier.GetThirstModifier](ig_modifier_GetThirstModifier.md) [C]
- [ig.modifier.SetDegradeBoost](ig_modifier_SetDegradeBoost.md) [C]
- [ig.modifier.SetHungerModifier](ig_modifier_SetHungerModifier.md) [C]
- [ig.modifier.SetModifiers](ig_modifier_SetModifiers.md) [C]
- [ig.modifier.SetStressModifier](ig_modifier_SetStressModifier.md) [C]
- [ig.modifier.SetThirstModifier](ig_modifier_SetThirstModifier.md) [C]

### modkit

modkit namespace functions.

- [ig.modkit.ClearCache](ig_modkit_ClearCache.md) [C]
- [ig.modkit.GetAll](ig_modkit_GetAll.md) [S C]
- [ig.modkit.GetByID](ig_modkit_GetByID.md) [S]
- [ig.modkit.GetForVehicle](ig_modkit_GetForVehicle.md) [S C]
- [ig.modkit.HasModkit](ig_modkit_HasModkit.md) [S]
- [ig.modkit.Load](ig_modkit_Load.md) [S]

### name

name namespace functions.

- [ig.name.Load](ig_name_Load.md) [S]
- [ig.name.RandomFemale](ig_name_RandomFemale.md) [S]
- [ig.name.RandomMale](ig_name_RandomMale.md) [S]
- [ig.name.RandomUnisex](ig_name_RandomUnisex.md) [S]

### note

note namespace functions.

- [ig.note.Add](ig_note_Add.md) [S]
- [ig.note.CleanOld](ig_note_CleanOld.md) [S]
- [ig.note.Create](ig_note_Create.md) [S]
- [ig.note.CreateBulletin](ig_note_CreateBulletin.md) [S]
- [ig.note.CreateEvidence](ig_note_CreateEvidence.md) [S]
- [ig.note.CreateGraffiti](ig_note_CreateGraffiti.md) [S]
- [ig.note.Exist](ig_note_Exist.md) [S]
- [ig.note.GetAll](ig_note_GetAll.md) [S]
- [ig.note.GetByAuthor](ig_note_GetByAuthor.md) [S]
- [ig.note.GetByID](ig_note_GetByID.md) [S]
- [ig.note.GetByType](ig_note_GetByType.md) [S]
- [ig.note.GetCount](ig_note_GetCount.md) [S]
- [ig.note.GetMostRead](ig_note_GetMostRead.md) [S]
- [ig.note.GetNearby](ig_note_GetNearby.md) [S]
- [ig.note.GetRecent](ig_note_GetRecent.md) [S]
- [ig.note.Hide](ig_note_Hide.md) [S]
- [ig.note.Load](ig_note_Load.md) [S]
- [ig.note.MarkRead](ig_note_MarkRead.md) [S]
- [ig.note.Remove](ig_note_Remove.md) [S]
- [ig.note.ResyncAll](ig_note_ResyncAll.md) [S]
- [ig.note.Search](ig_note_Search.md) [S]
- [ig.note.Show](ig_note_Show.md) [S]
- [ig.note.Update](ig_note_Update.md) [S]
- [ig.note.ValidateData](ig_note_ValidateData.md) [S]

### npc

npc namespace functions.

- [ig.npc.AddNpc](ig_npc_AddNpc.md) [S]
- [ig.npc.FindNpc](ig_npc_FindNpc.md) [S]
- [ig.npc.GetNpc](ig_npc_GetNpc.md) [S]
- [ig.npc.GetNpcs](ig_npc_GetNpcs.md) [S]
- [ig.npc.RemoveNpc](ig_npc_RemoveNpc.md) [S]

### object

object namespace functions.

- [ig.object.AddObject](ig_object_AddObject.md) [S] ⚠️ Missing Documentation
- [ig.object.FindObject](ig_object_FindObject.md) [S] ⚠️ Missing Documentation
- [ig.object.FindObjectFromUUID](ig_object_FindObjectFromUUID.md) [S] ⚠️ Missing Documentation
- [ig.object.GetObject](ig_object_GetObject.md) [S] ⚠️ Missing Documentation
- [ig.object.GetObjectFromUUID](ig_object_GetObjectFromUUID.md) [S] ⚠️ Missing Documentation
- [ig.object.GetObjects](ig_object_GetObjects.md) [S] ⚠️ Missing Documentation
- [ig.object.RemoveObject](ig_object_RemoveObject.md) [S] ⚠️ Missing Documentation

### payroll

payroll namespace functions.

- [ig.payroll.ProcessPayroll](ig_payroll_ProcessPayroll.md) [S] ⚠️ Missing Documentation

### ped

ped namespace functions.

- [ig.ped.GetAll](ig_ped_GetAll.md) [S]
- [ig.ped.GetByGender](ig_ped_GetByGender.md) [S]
- [ig.ped.GetByHash](ig_ped_GetByHash.md) [S]
- [ig.ped.GetByName](ig_ped_GetByName.md) [S]
- [ig.ped.GetByType](ig_ped_GetByType.md) [S]
- [ig.ped.GetDisplayName](ig_ped_GetDisplayName.md) [S]
- [ig.ped.GetFemalePeds](ig_ped_GetFemalePeds.md) [S]
- [ig.ped.GetFreemodePeds](ig_ped_GetFreemodePeds.md) [S]
- [ig.ped.GetMalePeds](ig_ped_GetMalePeds.md) [S]
- [ig.ped.IsFemale](ig_ped_IsFemale.md) [S]
- [ig.ped.IsFreemode](ig_ped_IsFreemode.md) [S]
- [ig.ped.IsMale](ig_ped_IsMale.md) [S]
- [ig.ped.IsValid](ig_ped_IsValid.md) [S]

### persistance

persistance namespace functions.

- [ig.persistance.ObjectThread](ig_persistance_ObjectThread.md) [S]
- [ig.persistance.UpdateVehicle](ig_persistance_UpdateVehicle.md) [C]
- [ig.persistance.VehicleThread](ig_persistance_VehicleThread.md) [S]

### pick

pick namespace functions.

- [ig.pick.Activate](ig_pick_Activate.md) [S]
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md) [S]
- [ig.pick.Collect](ig_pick_Collect.md) [S]
- [ig.pick.Create](ig_pick_Create.md) [S]
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md) [S]
- [ig.pick.CreateZone](ig_pick_CreateZone.md) [S]
- [ig.pick.Deactivate](ig_pick_Deactivate.md) [S]
- [ig.pick.GetAll](ig_pick_GetAll.md) [S]
- [ig.pick.GetByEvent](ig_pick_GetByEvent.md) [S]
- [ig.pick.GetByModel](ig_pick_GetByModel.md) [S]
- [ig.pick.GetByUUID](ig_pick_GetByUUID.md) [S]
- [ig.pick.GetCount](ig_pick_GetCount.md) [S]
- [ig.pick.GetNearby](ig_pick_GetNearby.md) [S]
- [ig.pick.IsActive](ig_pick_IsActive.md) [S]
- [ig.pick.Remove](ig_pick_Remove.md) [S]
- [ig.pick.ResyncAll](ig_pick_ResyncAll.md) [S]
- [ig.pick.UpdateData](ig_pick_UpdateData.md) [S]
- [ig.pick.ValidateData](ig_pick_ValidateData.md) [S]

### player

player namespace functions.

- [ig.player.AddPlayer](ig_player_AddPlayer.md) [S]
- [ig.player.ArePlayersActive](ig_player_ArePlayersActive.md) [S]
- [ig.player.GetOfflinePlayer](ig_player_GetOfflinePlayer.md) [S]
- [ig.player.GetPlayer](ig_player_GetPlayer.md) [S]
- [ig.player.GetPlayerByCharacterID](ig_player_GetPlayerByCharacterID.md) [S] ⚠️ Missing Documentation
- [ig.player.GetPlayerByCharacterId](ig_player_GetPlayerByCharacterId.md) [S] ⚠️ Missing Documentation
- [ig.player.GetPlayers](ig_player_GetPlayers.md) [S]
- [ig.player.RemovePlayer](ig_player_RemovePlayer.md) [S]
- [ig.player.SetPlayer](ig_player_SetPlayer.md) [S]

### queue

queue namespace functions.

- [ig.queue.GetQueueList](ig_queue_GetQueueList.md) [S] ⚠️ Missing Documentation
- [ig.queue.GetQueueSize](ig_queue_GetQueueSize.md) [S] ⚠️ Missing Documentation
- [ig.queue.HandleConnection](ig_queue_HandleConnection.md) [S] ⚠️ Missing Documentation
- [ig.queue.InitiateShutdown](ig_queue_InitiateShutdown.md) [S] ⚠️ Missing Documentation
- [ig.queue.RegisterConnectionStep](ig_queue_RegisterConnectionStep.md) [S] ⚠️ Missing Documentation
- [ig.queue.RemovePlayer](ig_queue_RemovePlayer.md) [S] ⚠️ Missing Documentation
- [ig.queue.SendAlert](ig_queue_SendAlert.md) [S] ⚠️ Missing Documentation

### rng

rng namespace functions.

- [ig.rng.RandomValuesNoRepeats](ig_rng_RandomValuesNoRepeats.md) [S C]
- [ig.rng.UUID](ig_rng_UUID.md) [S C]
- [ig.rng.char](ig_rng_char.md) [S C]
- [ig.rng.chars](ig_rng_chars.md) [S C]
- [ig.rng.let](ig_rng_let.md) [S C]
- [ig.rng.lets](ig_rng_lets.md) [S C]
- [ig.rng.num](ig_rng_num.md) [S C]
- [ig.rng.nums](ig_rng_nums.md) [S C]

### screenshot

screenshot namespace functions.

- [ig.screenshot.LogToDatabase](ig_screenshot_LogToDatabase.md) [S]
- [ig.screenshot.SendToDiscord](ig_screenshot_SendToDiscord.md) [S]
- [ig.screenshot.SendToDiscourse](ig_screenshot_SendToDiscourse.md) [S]
- [ig.screenshot.SendToImageHost](ig_screenshot_SendToImageHost.md) [S]
- [ig.screenshot.Take](ig_screenshot_Take.md) [C]
- [ig.screenshot.ValidateWebhook](ig_screenshot_ValidateWebhook.md) [S]

### security

security namespace functions.

- [ig.security.AddAllowedStateBagKey](ig_security_AddAllowedStateBagKey.md) [S]
- [ig.security.AddBlockedStateBagKey](ig_security_AddBlockedStateBagKey.md) [S]
- [ig.security.CheckRateLimit](ig_security_CheckRateLimit.md) [S]
- [ig.security.CheckTransactionRateLimit](ig_security_CheckTransactionRateLimit.md) [S]
- [ig.security.DetectSuspiciousActivity](ig_security_DetectSuspiciousActivity.md) [S]
- [ig.security.GetAllowedStateBagKeys](ig_security_GetAllowedStateBagKeys.md) [S]
- [ig.security.GetBlockedStateBagKeys](ig_security_GetBlockedStateBagKeys.md) [S]
- [ig.security.LogPlayerTransaction](ig_security_LogPlayerTransaction.md) [S]
- [ig.security.LogTransaction](ig_security_LogTransaction.md) [S]
- [ig.security.RemoveAllowedStateBagKey](ig_security_RemoveAllowedStateBagKey.md) [S]
- [ig.security.RemoveBlockedStateBagKey](ig_security_RemoveBlockedStateBagKey.md) [S]

### skill

skill namespace functions.

- [ig.skill.CompareSkill](ig_skill_CompareSkill.md) [C]
- [ig.skill.GetSkill](ig_skill_GetSkill.md) [C]
- [ig.skill.GetSkills](ig_skill_GetSkills.md) [C]
- [ig.skill.SetSkills](ig_skill_SetSkills.md) [C]

### sql

sql namespace functions.

- [ig.sql.AwaitReady](ig_sql_AwaitReady.md) [S]
- [ig.sql.Batch](ig_sql_Batch.md) [S]
- [ig.sql.ExecutePrepared](ig_sql_ExecutePrepared.md) [S]
- [ig.sql.FetchScalar](ig_sql_FetchScalar.md) [S]
- [ig.sql.FetchSingle](ig_sql_FetchSingle.md) [S]
- [ig.sql.GetStats](ig_sql_GetStats.md) [S]
- [ig.sql.Insert](ig_sql_Insert.md) [S]
- [ig.sql.IsReady](ig_sql_IsReady.md) [S]
- [ig.sql.PrepareQuery](ig_sql_PrepareQuery.md) [S]
- [ig.sql.Query](ig_sql_Query.md) [S]
- [ig.sql.Transaction](ig_sql_Transaction.md) [S]
- [ig.sql.Update](ig_sql_Update.md) [S]

### state

state namespace functions.

- [ig.state.AddState](ig_state_AddState.md) [C]
- [ig.state.ChangeAction](ig_state_ChangeAction.md) [C]
- [ig.state.ChangeEffect](ig_state_ChangeEffect.md) [C]
- [ig.state.TriggerAction](ig_state_TriggerAction.md) [C]
- [ig.state.TriggerEffect](ig_state_TriggerEffect.md) [C]
- [ig.state.TriggerState](ig_state_TriggerState.md) [C]

### status

status namespace functions.

- [ig.status.AddArmour](ig_status_AddArmour.md) [C]
- [ig.status.AddArmourToAmount](ig_status_AddArmourToAmount.md) [C]
- [ig.status.AddHunger](ig_status_AddHunger.md) [C]
- [ig.status.AddStress](ig_status_AddStress.md) [C]
- [ig.status.AddThirst](ig_status_AddThirst.md) [C]
- [ig.status.Bobble](ig_status_Bobble.md) [C]
- [ig.status.Camera](ig_status_Camera.md) [C]
- [ig.status.GetArmour](ig_status_GetArmour.md) [C]
- [ig.status.GetHealth](ig_status_GetHealth.md) [C]
- [ig.status.GetHunger](ig_status_GetHunger.md) [C]
- [ig.status.GetMaxHealth](ig_status_GetMaxHealth.md) [C]
- [ig.status.GetStress](ig_status_GetStress.md) [C]
- [ig.status.GetThirst](ig_status_GetThirst.md) [C]
- [ig.status.RemoveHunger](ig_status_RemoveHunger.md) [C]
- [ig.status.RemoveStress](ig_status_RemoveStress.md) [C]
- [ig.status.RemoveThirst](ig_status_RemoveThirst.md) [C]
- [ig.status.SelfDamageHealth](ig_status_SelfDamageHealth.md) [C]
- [ig.status.SetArmour](ig_status_SetArmour.md) [C]
- [ig.status.SetBleed](ig_status_SetBleed.md) [C]
- [ig.status.SetBurn](ig_status_SetBurn.md) [C]
- [ig.status.SetHaste](ig_status_SetHaste.md) [C]
- [ig.status.SetHealth](ig_status_SetHealth.md) [C]
- [ig.status.SetHunger](ig_status_SetHunger.md) [C]
- [ig.status.SetInjury](ig_status_SetInjury.md) [C]
- [ig.status.SetPlayer](ig_status_SetPlayer.md) [C]
- [ig.status.SetPoison](ig_status_SetPoison.md) [C]
- [ig.status.SetSlow](ig_status_SetSlow.md) [C]
- [ig.status.SetStress](ig_status_SetStress.md) [C]
- [ig.status.SetThirst](ig_status_SetThirst.md) [C]
- [ig.status.SetVision](ig_status_SetVision.md) [C]
- [ig.status.SetWithdrawls](ig_status_SetWithdrawls.md) [C]
- [ig.status.Sound](ig_status_Sound.md) [C]
- [ig.status.StartHungerDecrease](ig_status_StartHungerDecrease.md) [C]
- [ig.status.StartStressIncrease](ig_status_StartStressIncrease.md) [C]
- [ig.status.StartThirstDecrease](ig_status_StartThirstDecrease.md) [C]
- [ig.status.WalkType](ig_status_WalkType.md) [C]

### table

table namespace functions.

- [ig.table.Clone](ig_table_Clone.md) [S C]
- [ig.table.Dump](ig_table_Dump.md) [S C]
- [ig.table.MakeReadOnly](ig_table_MakeReadOnly.md) [S C]
- [ig.table.MatchKey](ig_table_MatchKey.md) [S C]
- [ig.table.MatchValue](ig_table_MatchValue.md) [S C]
- [ig.table.Merge](ig_table_Merge.md) [S C]
- [ig.table.ReArrange](ig_table_ReArrange.md) [S C]
- [ig.table.Size](ig_table_Size.md) [S C]
- [ig.table.SizeOf](ig_table_SizeOf.md) [S C]

### target

target namespace functions.

- [ig.target.AddBoxZone](ig_target_AddBoxZone.md) [C]
- [ig.target.AddEntity](ig_target_AddEntity.md) [C]
- [ig.target.AddEntityZone](ig_target_AddEntityZone.md) [C]
- [ig.target.AddGlobalObject](ig_target_AddGlobalObject.md) [C]
- [ig.target.AddGlobalPed](ig_target_AddGlobalPed.md) [C]
- [ig.target.AddGlobalPlayer](ig_target_AddGlobalPlayer.md) [C]
- [ig.target.AddGlobalVehicle](ig_target_AddGlobalVehicle.md) [C]
- [ig.target.AddLocalEntity](ig_target_AddLocalEntity.md) [C]
- [ig.target.AddModel](ig_target_AddModel.md) [C]
- [ig.target.AddPolyZone](ig_target_AddPolyZone.md) [C]
- [ig.target.AddSphereZone](ig_target_AddSphereZone.md) [C]
- [ig.target.removeEntity](ig_target_removeEntity.md) [C]
- [ig.target.removeGlobalObject](ig_target_removeGlobalObject.md) [C]
- [ig.target.removeGlobalPed](ig_target_removeGlobalPed.md) [C]
- [ig.target.removeGlobalPlayer](ig_target_removeGlobalPlayer.md) [C]
- [ig.target.removeGlobalVehicle](ig_target_removeGlobalVehicle.md) [C]
- [ig.target.removeLocalEntity](ig_target_removeLocalEntity.md) [C]
- [ig.target.removeModel](ig_target_removeModel.md) [C]
- [ig.target.removeZone](ig_target_removeZone.md) [C]

### tattoo

tattoo namespace functions.

- [ig.tattoo.ClearCache](ig_tattoo_ClearCache.md) [C]
- [ig.tattoo.GetAll](ig_tattoo_GetAll.md) [S C]
- [ig.tattoo.GetByCollection](ig_tattoo_GetByCollection.md) [S]
- [ig.tattoo.GetByHash](ig_tattoo_GetByHash.md) [S]
- [ig.tattoo.GetByZone](ig_tattoo_GetByZone.md) [S C]
- [ig.tattoo.IsFemale](ig_tattoo_IsFemale.md) [S]
- [ig.tattoo.IsMale](ig_tattoo_IsMale.md) [S]

### text

text namespace functions.

- [ig.text.AddEntry](ig_text_AddEntry.md) [C]
- [ig.text.DisplayHelp](ig_text_DisplayHelp.md) [C]

### time

time namespace functions.

- [ig.time.ClearOverride](ig_time_ClearOverride.md) [C]
- [ig.time.GetTime](ig_time_GetTime.md) [C]
- [ig.time.ServerSync](ig_time_ServerSync.md) [S]
- [ig.time.SetTimeOverride](ig_time_SetTimeOverride.md) [C]
- [ig.time.Update](ig_time_Update.md) [S]
- [ig.time.UpdateTime](ig_time_UpdateTime.md) [C]

### ui

ui namespace functions.

- [ig.ui.HideContext](ig_ui_HideContext.md) [C] ⚠️ Missing Documentation
- [ig.ui.HideHUD](ig_ui_HideHUD.md) [C] ⚠️ Missing Documentation
- [ig.ui.HideInput](ig_ui_HideInput.md) [C] ⚠️ Missing Documentation
- [ig.ui.HideMenu](ig_ui_HideMenu.md) [C] ⚠️ Missing Documentation
- [ig.ui.Notify](ig_ui_Notify.md) [C] ⚠️ Missing Documentation
- [ig.ui.Send](ig_ui_Send.md) [C] ⚠️ Missing Documentation
- [ig.ui.ShowContext](ig_ui_ShowContext.md) [C] ⚠️ Missing Documentation
- [ig.ui.ShowHUD](ig_ui_ShowHUD.md) [C] ⚠️ Missing Documentation
- [ig.ui.ShowInput](ig_ui_ShowInput.md) [C] ⚠️ Missing Documentation
- [ig.ui.ShowMenu](ig_ui_ShowMenu.md) [C] ⚠️ Missing Documentation
- [ig.ui.UpdateHUD](ig_ui_UpdateHUD.md) [C] ⚠️ Missing Documentation

### util

util namespace functions.

- [ig.util.CheckBoneDistance](ig_util_CheckBoneDistance.md) [S C] ⚠️ Missing Documentation
- [ig.util.EnsureTable](ig_util_EnsureTable.md) [S C] ⚠️ Missing Documentation
- [ig.util.IsVehicleLocked](ig_util_IsVehicleLocked.md) [S C] ⚠️ Missing Documentation

### validation

validation namespace functions.

- [ig.validation.GetItemQuantities](ig_validation_GetItemQuantities.md) [S]
- [ig.validation.IsValidItem](ig_validation_IsValidItem.md) [S]
- [ig.validation.LogAndBanExploiter](ig_validation_LogAndBanExploiter.md) [S]
- [ig.validation.ValidateAndUnpack](ig_validation_ValidateAndUnpack.md) [S]
- [ig.validation.ValidateInventory](ig_validation_ValidateInventory.md) [S]
- [ig.validation.ValidateInventoryIntegrity](ig_validation_ValidateInventoryIntegrity.md) [S]
- [ig.validation.ValidateSlot](ig_validation_ValidateSlot.md) [S]

### vehicle

vehicle namespace functions.

- [ig.vehicle.AddVehicle](ig_vehicle_AddVehicle.md) [S]
- [ig.vehicle.ClearCache](ig_vehicle_ClearCache.md) [C]
- [ig.vehicle.ClearLocateBlips](ig_vehicle_ClearLocateBlips.md) [C] ⚠️ Missing Documentation
- [ig.vehicle.FindVehicle](ig_vehicle_FindVehicle.md) [S]
- [ig.vehicle.FindVehicleFromPlate](ig_vehicle_FindVehicleFromPlate.md) [S]
- [ig.vehicle.GetAll](ig_vehicle_GetAll.md) [S C]
- [ig.vehicle.GetAllPersistentVehicles](ig_vehicle_GetAllPersistentVehicles.md) [S]
- [ig.vehicle.GetByClass](ig_vehicle_GetByClass.md) [S]
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md) [S C]
- [ig.vehicle.GetByManufacturer](ig_vehicle_GetByManufacturer.md) [S]
- [ig.vehicle.GetByName](ig_vehicle_GetByName.md) [S]
- [ig.vehicle.GetCurrentSeat](ig_vehicle_GetCurrentSeat.md) [C]
- [ig.vehicle.GetCurrentVehicle](ig_vehicle_GetCurrentVehicle.md) [C]
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md) [S C]
- [ig.vehicle.GetPersistentVehicle](ig_vehicle_GetPersistentVehicle.md) [S]
- [ig.vehicle.GetVehicle](ig_vehicle_GetVehicle.md) [S]
- [ig.vehicle.GetVehicleByPlate](ig_vehicle_GetVehicleByPlate.md) [S]
- [ig.vehicle.GetVehicles](ig_vehicle_GetVehicles.md) [S]
- [ig.vehicle.HookVehicleEvents](ig_vehicle_HookVehicleEvents.md) [S]
- [ig.vehicle.InitializeClient](ig_vehicle_InitializeClient.md) [C] ⚠️ Missing Documentation
- [ig.vehicle.InitializePersistence](ig_vehicle_InitializePersistence.md) [S]
- [ig.vehicle.IsAircraft](ig_vehicle_IsAircraft.md) [S]
- [ig.vehicle.IsBoa](ig_vehicle_IsBoa.md) [S]
- [ig.vehicle.IsInVehicle](ig_vehicle_IsInVehicle.md) [C]
- [ig.vehicle.Load](ig_vehicle_Load.md) [S]
- [ig.vehicle.LoadPersistentVehicles](ig_vehicle_LoadPersistentVehicles.md) [S]
- [ig.vehicle.LocatePlayerVehicles](ig_vehicle_LocatePlayerVehicles.md) [S] ⚠️ Missing Documentation
- [ig.vehicle.RegisterPersistent](ig_vehicle_RegisterPersistent.md) [S]
- [ig.vehicle.RemoveVehicle](ig_vehicle_RemoveVehicle.md) [S]
- [ig.vehicle.RestoreParkedVehicles](ig_vehicle_RestoreParkedVehicles.md) [S] ⚠️ Missing Documentation
- [ig.vehicle.RestorePersistentVehicle](ig_vehicle_RestorePersistentVehicle.md) [S]
- [ig.vehicle.SavePersistentVehicles](ig_vehicle_SavePersistentVehicles.md) [S]
- [ig.vehicle.SetVehicle](ig_vehicle_SetVehicle.md) [S]
- [ig.vehicle.StartPeriodicSave](ig_vehicle_StartPeriodicSave.md) [S]
- [ig.vehicle.UpdateVehicleLocation](ig_vehicle_UpdateVehicleLocation.md) [S]
- [ig.vehicle.UpdateVehicleState](ig_vehicle_UpdateVehicleState.md) [S]

### voip

voip namespace functions.

- [ig.voip.Debug](ig_voip_Debug.md) [S C]
- [ig.voip.GetDistance](ig_voip_GetDistance.md) [S C]
- [ig.voip.GetGridCell](ig_voip_GetGridCell.md) [S C]
- [ig.voip.GetNextVoiceMode](ig_voip_GetNextVoiceMode.md) [S C]
- [ig.voip.GetPreviousVoiceMode](ig_voip_GetPreviousVoiceMode.md) [S C]
- [ig.voip.GetSurroundingGridCells](ig_voip_GetSurroundingGridCells.md) [S C]
- [ig.voip.GetVoiceMode](ig_voip_GetVoiceMode.md) [S C]
- [ig.voip.GetVoiceModeCount](ig_voip_GetVoiceModeCount.md) [S C]
- [ig.voip.IsValidRadioChannel](ig_voip_IsValidRadioChannel.md) [S C]

### weapon

weapon namespace functions.

- [ig.weapon.ClearCache](ig_weapon_ClearCache.md) [C]
- [ig.weapon.Exist](ig_weapon_Exist.md) [S]
- [ig.weapon.Get](ig_weapon_Get.md) [C]
- [ig.weapon.GetAll](ig_weapon_GetAll.md) [S C]
- [ig.weapon.GetAllWeaponComponents](ig_weapon_GetAllWeaponComponents.md) [C] ⚠️ Missing Documentation
- [ig.weapon.GetByCategory](ig_weapon_GetByCategory.md) [S]
- [ig.weapon.GetByHash](ig_weapon_GetByHash.md) [S C]
- [ig.weapon.GetByName](ig_weapon_GetByName.md) [S]
- [ig.weapon.GetComponents](ig_weapon_GetComponents.md) [C]
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md) [S C]
- [ig.weapon.GetInitializedCategories](ig_weapon_GetInitializedCategories.md) [C] ⚠️ Missing Documentation
- [ig.weapon.GetName](ig_weapon_GetName.md) [C]
- [ig.weapon.GetWeaponComponents](ig_weapon_GetWeaponComponents.md) [C] ⚠️ Missing Documentation
- [ig.weapon.HasWeaponComponents](ig_weapon_HasWeaponComponents.md) [C] ⚠️ Missing Documentation
- [ig.weapon.InitializeWeaponData](ig_weapon_InitializeWeaponData.md) [C] ⚠️ Missing Documentation
- [ig.weapon.IsAllowedCategory](ig_weapon_IsAllowedCategory.md) [C] ⚠️ Missing Documentation
- [ig.weapon.IsMelee](ig_weapon_IsMelee.md) [S]
- [ig.weapon.Resync](ig_weapon_Resync.md) [S]

---

## Documentation Status

**Total Functions:** 692
**Documented:** 630 (91%)
**Missing Documentation:** 62 ⚠️
