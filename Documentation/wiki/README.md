# Ingenium Function Reference

Complete wiki-style reference documentation for all Ingenium framework functions.

## Overview

This wiki contains comprehensive documentation for **781 functions** across the Ingenium framework. Each function has its own dedicated markdown file with:

- ✅ Function signature and parameters
- ✅ Detailed description
- ✅ Usage examples and code snippets
- ✅ Security notes and warnings (where applicable)
- ✅ Related functions and alternatives
- ✅ Source file location

## How to Use This Documentation

1. **Browse by Namespace**: Find functions organized by their namespace (e.g., `ig.func`, `ig.callback`, `ig.appearance`)
2. **Click on a Function**: Each function name links to its dedicated documentation page
3. **Read Examples**: All functions include practical usage examples
4. **Check Security Notes**: Functions with security implications include clear warnings

## Quick Links

### Most Common Namespaces

- **[func](#func)** - Core utility functions (76 functions)
- **[sql](#sql)** - Database operations (92 functions)
- **[appearance](#appearance)** - Character customization (54 functions)
- **[voip](#voip)** - Voice communication (43 functions)
- **[callback](#callback)** - Async callback system (10 functions)
- **[target](#target)** - Targeting/interaction system (19 functions)
- **[vehicle](#vehicle)** - Vehicle management (24 functions)
- **[job](#job)** - Job/employment system (27 functions)
- **[item](#item)** - Item management (50 functions)
- **[status](#status)** - Player status effects (36 functions)

## Security Best Practices

⚠️ Functions with security implications include warnings about:
- SQL injection vulnerabilities
- Network request safety
- Player identifier handling
- Admin permission requirements
- Dynamic code execution risks

Always review security notes before using sensitive functions in production.

## Contributing

Found an issue or want to improve the documentation? 
- Check the source file location in each function's page
- Submit improvements via pull request
- Report issues on GitHub

---

Total Functions: **781**

## All Namespaces

- [GetEntityState](#GetEntityState) (1 functions)
- [GetJob](#GetJob) (1 functions)
- [GetLocalPlayer](#GetLocalPlayer) (1 functions)
- [GetLocalPlayerState](#GetLocalPlayerState) (1 functions)
- [GetNpc](#GetNpc) (1 functions)
- [GetNpcs](#GetNpcs) (1 functions)
- [GetObject](#GetObject) (1 functions)
- [GetObjects](#GetObjects) (1 functions)
- [GetPlayer](#GetPlayer) (1 functions)
- [GetPlayerByCharacterID](#GetPlayerByCharacterID) (1 functions)
- [GetPlayerFromId](#GetPlayerFromId) (1 functions)
- [GetPlayerPedState](#GetPlayerPedState) (1 functions)
- [GetPlayerState](#GetPlayerState) (1 functions)
- [GetPlayers](#GetPlayers) (1 functions)
- [GetVehicle](#GetVehicle) (1 functions)
- [GetVehicleByPlate](#GetVehicleByPlate) (1 functions)
- [GetVehicles](#GetVehicles) (1 functions)
- [SetEntityState](#SetEntityState) (1 functions)
- [SetLocalPlayerState](#SetLocalPlayerState) (1 functions)
- [affiliation](#affiliation) (3 functions)
- [ammo](#ammo) (2 functions)
- [appearance](#appearance) (54 functions)
- [bank](#bank) (3 functions)
- [blip](#blip) (9 functions)
- [callback](#callback) (10 functions)
- [camera](#camera) (4 functions)
- [chat](#chat) (2 functions)
- [check](#check) (4 functions)
- [class](#class) (8 functions)
- [cron](#cron) (2 functions)
- [data](#data) (28 functions)
- [door](#door) (15 functions)
- [drop](#drop) (7 functions)
- [event](#event) (1 functions)
- [file](#file) (4 functions)
- [func](#func) (76 functions)
- [fx](#fx) (2 functions)
- [game](#game) (3 functions)
- [gsr](#gsr) (19 functions)
- [inst](#inst) (6 functions)
- [inventory](#inventory) (8 functions)
- [ipl](#ipl) (12 functions)
- [item](#item) (50 functions)
- [job](#job) (27 functions)
- [json](#json) (2 functions)
- [marker](#marker) (1 functions)
- [math](#math) (4 functions)
- [modifier](#modifier) (14 functions)
- [modkit](#modkit) (8 functions)
- [name](#name) (4 functions)
- [note](#note) (27 functions)
- [npc](#npc) (5 functions)
- [objects](#objects) (7 functions)
- [ped](#ped) (13 functions)
- [persistance](#persistance) (3 functions)
- [pick](#pick) (18 functions)
- [player](#player) (8 functions)
- [queue](#queue) (1 functions)
- [rng](#rng) (8 functions)
- [security](#security) (5 functions)
- [skill](#skill) (4 functions)
- [sql](#sql) (92 functions)
- [state](#state) (6 functions)
- [status](#status) (36 functions)
- [table](#table) (9 functions)
- [target](#target) (19 functions)
- [tattoo](#tattoo) (9 functions)
- [text](#text) (2 functions)
- [time](#time) (6 functions)
- [validation](#validation) (7 functions)
- [vehicle](#vehicle) (24 functions)
- [version](#version) (3 functions)
- [voip](#voip) (43 functions)
- [weapon](#weapon) (15 functions)

## GetEntityState

- [ig.GetEntityState](ig_GetEntityState.md)

## GetJob

- [ig.GetJob](ig_GetJob.md)

## GetLocalPlayer

- [ig.GetLocalPlayer](ig_GetLocalPlayer.md)

## GetLocalPlayerState

- [ig.GetLocalPlayerState](ig_GetLocalPlayerState.md)

## GetNpc

- [ig.GetNpc](ig_GetNpc.md)

## GetNpcs

- [ig.GetNpcs](ig_GetNpcs.md)

## GetObject

- [ig.GetObject](ig_GetObject.md)

## GetObjects

- [ig.GetObjects](ig_GetObjects.md)

## GetPlayer

- [ig.GetPlayer](ig_GetPlayer.md)

## GetPlayerByCharacterID

- [ig.GetPlayerByCharacterID](ig_GetPlayerByCharacterID.md)

## GetPlayerFromId

- [ig.GetPlayerFromId](ig_GetPlayerFromId.md)

## GetPlayerPedState

- [ig.GetPlayerPedState](ig_GetPlayerPedState.md)

## GetPlayerState

- [ig.GetPlayerState](ig_GetPlayerState.md)

## GetPlayers

- [ig.GetPlayers](ig_GetPlayers.md)

## GetVehicle

- [ig.GetVehicle](ig_GetVehicle.md)

## GetVehicleByPlate

- [ig.GetVehicleByPlate](ig_GetVehicleByPlate.md)

## GetVehicles

- [ig.GetVehicles](ig_GetVehicles.md)

## SetEntityState

- [ig.SetEntityState](ig_SetEntityState.md)

## SetLocalPlayerState

- [ig.SetLocalPlayerState](ig_SetLocalPlayerState.md)

## affiliation

- [ig.affiliation.AddGroupToTable](ig_affiliation_AddGroupToTable.md)
- [ig.affiliation.CreateGroup](ig_affiliation_CreateGroup.md)
- [ig.affiliation.GetGroups](ig_affiliation_GetGroups.md)

## ammo

- [ig.ammo.Get](ig_ammo_Get.md)
- [ig.ammo.GetType](ig_ammo_GetType.md)

## appearance

- [ig.appearance.ApplyAppearanceData](ig_appearance_ApplyAppearanceData.md)
- [ig.appearance.ApplyTattoo](ig_appearance_ApplyTattoo.md)
- [ig.appearance.ApplyTattoos](ig_appearance_ApplyTattoos.md)
- [ig.appearance.CalculateCost](ig_appearance_CalculateCost.md)
- [ig.appearance.ClearTattoos](ig_appearance_ClearTattoos.md)
- [ig.appearance.CreateCamera](ig_appearance_CreateCamera.md)
- [ig.appearance.DestroyCamera](ig_appearance_DestroyCamera.md)
- [ig.appearance.GetAppearance](ig_appearance_GetAppearance.md)
- [ig.appearance.GetCameraMode](ig_appearance_GetCameraMode.md)
- [ig.appearance.GetComponent](ig_appearance_GetComponent.md)
- [ig.appearance.GetComponents](ig_appearance_GetComponents.md)
- [ig.appearance.GetComponents](ig_appearance_GetComponents.md)
- [ig.appearance.GetConstants](ig_appearance_GetConstants.md)
- [ig.appearance.GetConstants](ig_appearance_GetConstants.md)
- [ig.appearance.GetDefaultAppearance](ig_appearance_GetDefaultAppearance.md)
- [ig.appearance.GetDefaultPricing](ig_appearance_GetDefaultPricing.md)
- [ig.appearance.GetEyeColor](ig_appearance_GetEyeColor.md)
- [ig.appearance.GetEyeColors](ig_appearance_GetEyeColors.md)
- [ig.appearance.GetFaceFeatures](ig_appearance_GetFaceFeatures.md)
- [ig.appearance.GetFaceFeatures](ig_appearance_GetFaceFeatures.md)
- [ig.appearance.GetHair](ig_appearance_GetHair.md)
- [ig.appearance.GetHairDecorations](ig_appearance_GetHairDecorations.md)
- [ig.appearance.GetHeadBlend](ig_appearance_GetHeadBlend.md)
- [ig.appearance.GetHeadOverlays](ig_appearance_GetHeadOverlays.md)
- [ig.appearance.GetModel](ig_appearance_GetModel.md)
- [ig.appearance.GetPricing](ig_appearance_GetPricing.md)
- [ig.appearance.GetProp](ig_appearance_GetProp.md)
- [ig.appearance.GetProps](ig_appearance_GetProps.md)
- [ig.appearance.GetProps](ig_appearance_GetProps.md)
- [ig.appearance.Initialize](ig_appearance_Initialize.md)
- [ig.appearance.IsCustomizationActive](ig_appearance_IsCustomizationActive.md)
- [ig.appearance.IsFreemode](ig_appearance_IsFreemode.md)
- [ig.appearance.LoadJobPricing](ig_appearance_LoadJobPricing.md)
- [ig.appearance.RotateCamera](ig_appearance_RotateCamera.md)
- [ig.appearance.SaveAllDirtyPricing](ig_appearance_SaveAllDirtyPricing.md)
- [ig.appearance.SaveAllPricing](ig_appearance_SaveAllPricing.md)
- [ig.appearance.SetAppearance](ig_appearance_SetAppearance.md)
- [ig.appearance.SetCameraView](ig_appearance_SetCameraView.md)
- [ig.appearance.SetComponent](ig_appearance_SetComponent.md)
- [ig.appearance.SetComponents](ig_appearance_SetComponents.md)
- [ig.appearance.SetCustomizationActive](ig_appearance_SetCustomizationActive.md)
- [ig.appearance.SetEyeColor](ig_appearance_SetEyeColor.md)
- [ig.appearance.SetFaceFeature](ig_appearance_SetFaceFeature.md)
- [ig.appearance.SetFaceFeatures](ig_appearance_SetFaceFeatures.md)
- [ig.appearance.SetHair](ig_appearance_SetHair.md)
- [ig.appearance.SetHeadBlend](ig_appearance_SetHeadBlend.md)
- [ig.appearance.SetHeadOverlay](ig_appearance_SetHeadOverlay.md)
- [ig.appearance.SetHeadOverlays](ig_appearance_SetHeadOverlays.md)
- [ig.appearance.SetModel](ig_appearance_SetModel.md)
- [ig.appearance.SetProp](ig_appearance_SetProp.md)
- [ig.appearance.SetProps](ig_appearance_SetProps.md)
- [ig.appearance.TurnAround](ig_appearance_TurnAround.md)
- [ig.appearance.UpdatePrice](ig_appearance_UpdatePrice.md)
- [ig.appearance.ValidateAppearance](ig_appearance_ValidateAppearance.md)

## bank

- [ig.bank.CalculateInterest](ig_bank_CalculateInterest.md)
- [ig.bank.CalculatePayments](ig_bank_CalculatePayments.md)
- [ig.bank.CheckNegativeBalances](ig_bank_CheckNegativeBalances.md)

## blip

- [ig.blip.AreaBlip](ig_blip_AreaBlip.md)
- [ig.blip.Blip](ig_blip_Blip.md)
- [ig.blip.CreateArea](ig_blip_CreateArea.md)
- [ig.blip.CreateBlip](ig_blip_CreateBlip.md)
- [ig.blip.CreateRadius](ig_blip_CreateRadius.md)
- [ig.blip.EntityBlip](ig_blip_EntityBlip.md)
- [ig.blip.GetBlip](ig_blip_GetBlip.md)
- [ig.blip.RadiusBlip](ig_blip_RadiusBlip.md)
- [ig.blip.Remove](ig_blip_Remove.md)

## callback

- [ig.callback.Async](ig_callback_Async.md)
- [ig.callback.AsyncClient](ig_callback_AsyncClient.md)
- [ig.callback.AsyncWithTimeout](ig_callback_AsyncWithTimeout.md)
- [ig.callback.Await](ig_callback_Await.md)
- [ig.callback.AwaitClient](ig_callback_AwaitClient.md)
- [ig.callback.AwaitWithTimeout](ig_callback_AwaitWithTimeout.md)
- [ig.callback.RegisterClient](ig_callback_RegisterClient.md)
- [ig.callback.RegisterServer](ig_callback_RegisterServer.md)
- [ig.callback.UnregisterClient](ig_callback_UnregisterClient.md)
- [ig.callback.UnregisterServer](ig_callback_UnregisterServer.md)

## camera

- [ig.camera.Advanced](ig_camera_Advanced.md)
- [ig.camera.Basic](ig_camera_Basic.md)
- [ig.camera.CleanUp](ig_camera_CleanUp.md)
- [ig.camera.NewName](ig_camera_NewName.md)

## chat

- [ig.chat.AddSuggestions](ig_chat_AddSuggestions.md)
- [ig.chat.SetPermissions](ig_chat_SetPermissions.md)

## check

- [ig.check.Boolean](ig_check_Boolean.md)
- [ig.check.Number](ig_check_Number.md)
- [ig.check.String](ig_check_String.md)
- [ig.check.Table](ig_check_Table.md)

## class

- [ig.class.BlankObject](ig_class_BlankObject.md)
- [ig.class.ExistingObject](ig_class_ExistingObject.md)
- [ig.class.Job](ig_class_Job.md)
- [ig.class.Npc](ig_class_Npc.md)
- [ig.class.OfflinePlayer](ig_class_OfflinePlayer.md)
- [ig.class.OwnedVehicle](ig_class_OwnedVehicle.md)
- [ig.class.Player](ig_class_Player.md)
- [ig.class.Vehicle](ig_class_Vehicle.md)

## cron

- [ig.cron.OnTime](ig_cron_OnTime.md)
- [ig.cron.RunAt](ig_cron_RunAt.md)

## data

- [ig.data.CharacterValues](ig_data_CharacterValues.md)
- [ig.data.CreateJobObjects](ig_data_CreateJobObjects.md)
- [ig.data.GetEntityState](ig_data_GetEntityState.md)
- [ig.data.GetEntityStateCheck](ig_data_GetEntityStateCheck.md)
- [ig.data.GetJob](ig_data_GetJob.md)
- [ig.data.GetJobs](ig_data_GetJobs.md)
- [ig.data.GetLoadedStatus](ig_data_GetLoadedStatus.md)
- [ig.data.GetLocalPlayer](ig_data_GetLocalPlayer.md)
- [ig.data.GetLocalPlayerState](ig_data_GetLocalPlayerState.md)
- [ig.data.GetLocale](ig_data_GetLocale.md)
- [ig.data.GetPlayer](ig_data_GetPlayer.md)
- [ig.data.GetPlayerPedState](ig_data_GetPlayerPedState.md)
- [ig.data.GetPlayerState](ig_data_GetPlayerState.md)
- [ig.data.Initilize](ig_data_Initilize.md)
- [ig.data.Initilize](ig_data_Initilize.md)
- [ig.data.IsPlayerLoaded](ig_data_IsPlayerLoaded.md)
- [ig.data.LoadJSONData](ig_data_LoadJSONData.md)
- [ig.data.LoadPlayer](ig_data_LoadPlayer.md)
- [ig.data.Packet](ig_data_Packet.md)
- [ig.data.RestoreDrops](ig_data_RestoreDrops.md)
- [ig.data.RetrievePackets](ig_data_RetrievePackets.md)
- [ig.data.ReviveSync](ig_data_ReviveSync.md)
- [ig.data.Save](ig_data_Save.md)
- [ig.data.ServerSync](ig_data_ServerSync.md)
- [ig.data.SetEntityState](ig_data_SetEntityState.md)
- [ig.data.SetLoadedStatus](ig_data_SetLoadedStatus.md)
- [ig.data.SetLocalPlayerState](ig_data_SetLocalPlayerState.md)
- [ig.data.SetLocale](ig_data_SetLocale.md)

## door

- [ig.door.Add](ig_door_Add.md)
- [ig.door.Add](ig_door_Add.md)
- [ig.door.AddDoorsToSystem](ig_door_AddDoorsToSystem.md)
- [ig.door.ChangeState](ig_door_ChangeState.md)
- [ig.door.Find](ig_door_Find.md)
- [ig.door.Find](ig_door_Find.md)
- [ig.door.FindHash](ig_door_FindHash.md)
- [ig.door.FindHash](ig_door_FindHash.md)
- [ig.door.GenerateDoorsInRadius](ig_door_GenerateDoorsInRadius.md)
- [ig.door.GetDoors](ig_door_GetDoors.md)
- [ig.door.GetModels](ig_door_GetModels.md)
- [ig.door.SetDoors](ig_door_SetDoors.md)
- [ig.door.SetState](ig_door_SetState.md)
- [ig.door.SetState](ig_door_SetState.md)
- [ig.door.ToggleLock](ig_door_ToggleLock.md)

## drop

- [ig.drop.Activate](ig_drop_Activate.md)
- [ig.drop.CleanupOld](ig_drop_CleanupOld.md)
- [ig.drop.Create](ig_drop_Create.md)
- [ig.drop.Deactivate](ig_drop_Deactivate.md)
- [ig.drop.MergeDropsForSave](ig_drop_MergeDropsForSave.md)
- [ig.drop.Remove](ig_drop_Remove.md)
- [ig.drop.StartCleanupRoutine](ig_drop_StartCleanupRoutine.md)

## event

- [ig.event.AddInteractJobEvent](ig_event_AddInteractJobEvent.md)

## file

- [ig.file.Append](ig_file_Append.md)
- [ig.file.Exists](ig_file_Exists.md)
- [ig.file.Read](ig_file_Read.md)
- [ig.file.Write](ig_file_Write.md)

## func

- [ig.func.Alert](ig_func_Alert.md)
- [ig.func.Alert](ig_func_Alert.md)
- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.CompareCoords](ig_func_CompareCoords.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)
- [ig.func.CreateVehicle](ig_func_CreateVehicle.md)
- [ig.func.CreateVehicle](ig_func_CreateVehicle.md)
- [ig.func.Debug_1](ig_func_Debug_1.md)
- [ig.func.Debug_1](ig_func_Debug_1.md)
- [ig.func.Debug_2](ig_func_Debug_2.md)
- [ig.func.Debug_2](ig_func_Debug_2.md)
- [ig.func.Debug_3](ig_func_Debug_3.md)
- [ig.func.Debug_3](ig_func_Debug_3.md)
- [ig.func.DeleteVehicle](ig_func_DeleteVehicle.md)
- [ig.func.Discord](ig_func_Discord.md)
- [ig.func.Discorse](ig_func_Discorse.md)
- [ig.func.Err](ig_func_Err.md)
- [ig.func.Err](ig_func_Err.md)
- [ig.func.Error](ig_func_Error.md)
- [ig.func.Error](ig_func_Error.md)
- [ig.func.Eventban](ig_func_Eventban.md)
- [ig.func.FadeIn](ig_func_FadeIn.md)
- [ig.func.FadeOut](ig_func_FadeOut.md)
- [ig.func.Func](ig_func_Func.md)
- [ig.func.Func](ig_func_Func.md)
- [ig.func.GetAllPlayerPeds](ig_func_GetAllPlayerPeds.md)
- [ig.func.GetClosestPed](ig_func_GetClosestPed.md)
- [ig.func.GetClosestPlayer](ig_func_GetClosestPlayer.md)
- [ig.func.GetClosestPlayer](ig_func_GetClosestPlayer.md)
- [ig.func.GetClosestPlayerPed](ig_func_GetClosestPlayerPed.md)
- [ig.func.GetClosestPosition](ig_func_GetClosestPosition.md)
- [ig.func.GetClosestVehicle](ig_func_GetClosestVehicle.md)
- [ig.func.GetEntityFromRay](ig_func_GetEntityFromRay.md)
- [ig.func.GetObjectsInArea](ig_func_GetObjectsInArea.md)
- [ig.func.GetPedsInArea](ig_func_GetPedsInArea.md)
- [ig.func.GetPickupsInArea](ig_func_GetPickupsInArea.md)
- [ig.func.GetPlayers](ig_func_GetPlayers.md)
- [ig.func.GetPlayersInArea](ig_func_GetPlayersInArea.md)
- [ig.func.GetVehicleCondition](ig_func_GetVehicleCondition.md)
- [ig.func.GetVehicleDoorStates](ig_func_GetVehicleDoorStates.md)
- [ig.func.GetVehicleExtras](ig_func_GetVehicleExtras.md)
- [ig.func.GetVehicleModifications](ig_func_GetVehicleModifications.md)
- [ig.func.GetVehicleMods](ig_func_GetVehicleMods.md)
- [ig.func.GetVehicleSeatOfPed](ig_func_GetVehicleSeatOfPed.md)
- [ig.func.GetVehicleTireStates](ig_func_GetVehicleTireStates.md)
- [ig.func.GetVehicleWindowStates](ig_func_GetVehicleWindowStates.md)
- [ig.func.GetVehiclesInArea](ig_func_GetVehiclesInArea.md)
- [ig.func.HasPlayers](ig_func_HasPlayers.md)
- [ig.func.IsAnyPlayerInsideVehicle](ig_func_IsAnyPlayerInsideVehicle.md)
- [ig.func.IsBusy](ig_func_IsBusy.md)
- [ig.func.IsBusyPleaseWait](ig_func_IsBusyPleaseWait.md)
- [ig.func.IsPedHuman](ig_func_IsPedHuman.md)
- [ig.func.IsPedMale](ig_func_IsPedMale.md)
- [ig.func.IsVehicleSpawnClear](ig_func_IsVehicleSpawnClear.md)
- [ig.func.NotBusy](ig_func_NotBusy.md)
- [ig.func.PleaseWait](ig_func_PleaseWait.md)
- [ig.func.SetInterval](ig_func_SetInterval.md)
- [ig.func.SetInterval](ig_func_SetInterval.md)
- [ig.func.SetVehicleCondition](ig_func_SetVehicleCondition.md)
- [ig.func.SetVehicleDoorStates](ig_func_SetVehicleDoorStates.md)
- [ig.func.SetVehicleExtras](ig_func_SetVehicleExtras.md)
- [ig.func.SetVehicleExtrasFalse](ig_func_SetVehicleExtrasFalse.md)
- [ig.func.SetVehicleModifications](ig_func_SetVehicleModifications.md)
- [ig.func.SetVehicleMods](ig_func_SetVehicleMods.md)
- [ig.func.SetVehicleTireStates](ig_func_SetVehicleTireStates.md)
- [ig.func.SetVehicleWindowStates](ig_func_SetVehicleWindowStates.md)
- [ig.func.Timestamp](ig_func_Timestamp.md)
- [ig.func.Timestring](ig_func_Timestring.md)
- [ig.func.WaitUntilNetIdExists](ig_func_WaitUntilNetIdExists.md)
- [ig.func.WaitUntilPlayerIsOwner](ig_func_WaitUntilPlayerIsOwner.md)
- [ig.func.identifier](ig_func_identifier.md)
- [ig.func.identifiers](ig_func_identifiers.md)

## fx

- [ig.fx.StartDeath](ig_fx_StartDeath.md)
- [ig.fx.StopDeath](ig_fx_StopDeath.md)

## game

- [ig.game.GetGameMode](ig_game_GetGameMode.md)
- [ig.game.GetGameModeSettings](ig_game_GetGameModeSettings.md)
- [ig.game.IsGameModeFeatureEnabled](ig_game_IsGameModeFeatureEnabled.md)

## gsr

- [ig.gsr.Add](ig_gsr_Add.md)
- [ig.gsr.Clean](ig_gsr_Clean.md)
- [ig.gsr.CleanOld](ig_gsr_CleanOld.md)
- [ig.gsr.Clear](ig_gsr_Clear.md)
- [ig.gsr.Create](ig_gsr_Create.md)
- [ig.gsr.Exist](ig_gsr_Exist.md)
- [ig.gsr.GetAll](ig_gsr_GetAll.md)
- [ig.gsr.GetByCharacter](ig_gsr_GetByCharacter.md)
- [ig.gsr.GetByID](ig_gsr_GetByID.md)
- [ig.gsr.GetByWeapon](ig_gsr_GetByWeapon.md)
- [ig.gsr.GetCount](ig_gsr_GetCount.md)
- [ig.gsr.GetNearby](ig_gsr_GetNearby.md)
- [ig.gsr.GetRecent](ig_gsr_GetRecent.md)
- [ig.gsr.GetStats](ig_gsr_GetStats.md)
- [ig.gsr.HasRecent](ig_gsr_HasRecent.md)
- [ig.gsr.IncrementShots](ig_gsr_IncrementShots.md)
- [ig.gsr.Load](ig_gsr_Load.md)
- [ig.gsr.Remove](ig_gsr_Remove.md)
- [ig.gsr.Test](ig_gsr_Test.md)

## inst

- [ig.inst.GetEntityInstance](ig_inst_GetEntityInstance.md)
- [ig.inst.GetPlayerInstance](ig_inst_GetPlayerInstance.md)
- [ig.inst.SetEntity](ig_inst_SetEntity.md)
- [ig.inst.SetEntityDefault](ig_inst_SetEntityDefault.md)
- [ig.inst.SetPlayer](ig_inst_SetPlayer.md)
- [ig.inst.SetPlayerDefault](ig_inst_SetPlayerDefault.md)

## inventory

- [ig.inventory.GetInventory](ig_inventory_GetInventory.md)
- [ig.inventory.GetItemData](ig_inventory_GetItemData.md)
- [ig.inventory.GetItemFromPosition](ig_inventory_GetItemFromPosition.md)
- [ig.inventory.GetItemMeta](ig_inventory_GetItemMeta.md)
- [ig.inventory.GetItemQuality](ig_inventory_GetItemQuality.md)
- [ig.inventory.GetItemQuantity](ig_inventory_GetItemQuantity.md)
- [ig.inventory.GetWeight](ig_inventory_GetWeight.md)
- [ig.inventory.HasItem](ig_inventory_HasItem.md)

## ipl

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)
- [ig.ipl.LoadConfigurations](ig_ipl_LoadConfigurations.md)
- [ig.ipl.LoadMultiple](ig_ipl_LoadMultiple.md)
- [ig.ipl.Register](ig_ipl_Register.md)
- [ig.ipl.SetupZoneHandler](ig_ipl_SetupZoneHandler.md)
- [ig.ipl.Unload](ig_ipl_Unload.md)
- [ig.ipl.UnloadByName](ig_ipl_UnloadByName.md)
- [ig.ipl.UnloadMultiple](ig_ipl_UnloadMultiple.md)

## item

- [ig.item.CanCraft](ig_item_CanCraft.md)
- [ig.item.CanDegrade](ig_item_CanDegrade.md)
- [ig.item.CanDegrade](ig_item_CanDegrade.md)
- [ig.item.CanHotkey](ig_item_CanHotkey.md)
- [ig.item.CanHotkey](ig_item_CanHotkey.md)
- [ig.item.CanStack](ig_item_CanStack.md)
- [ig.item.CanStack](ig_item_CanStack.md)
- [ig.item.Exists](ig_item_Exists.md)
- [ig.item.Exists](ig_item_Exists.md)
- [ig.item.GenerateConsumptionEvents](ig_item_GenerateConsumptionEvents.md)
- [ig.item.GetAbout](ig_item_GetAbout.md)
- [ig.item.GetAbout](ig_item_GetAbout.md)
- [ig.item.GetAll](ig_item_GetAll.md)
- [ig.item.GetByCategory](ig_item_GetByCategory.md)
- [ig.item.GetByName](ig_item_GetByName.md)
- [ig.item.GetByValueRange](ig_item_GetByValueRange.md)
- [ig.item.GetByWeightRange](ig_item_GetByWeightRange.md)
- [ig.item.GetConsumables](ig_item_GetConsumables.md)
- [ig.item.GetCraftable](ig_item_GetCraftable.md)
- [ig.item.GetData](ig_item_GetData.md)
- [ig.item.GetData](ig_item_GetData.md)
- [ig.item.GetDegradable](ig_item_GetDegradable.md)
- [ig.item.GetDescription](ig_item_GetDescription.md)
- [ig.item.GetItem](ig_item_GetItem.md)
- [ig.item.GetItem](ig_item_GetItem.md)
- [ig.item.GetItems](ig_item_GetItems.md)
- [ig.item.GetItems](ig_item_GetItems.md)
- [ig.item.GetLabel](ig_item_GetLabel.md)
- [ig.item.GetMeta](ig_item_GetMeta.md)
- [ig.item.GetMeta](ig_item_GetMeta.md)
- [ig.item.GetRecipe](ig_item_GetRecipe.md)
- [ig.item.GetStackSize](ig_item_GetStackSize.md)
- [ig.item.GetTotalInEconomy](ig_item_GetTotalInEconomy.md)
- [ig.item.GetValue](ig_item_GetValue.md)
- [ig.item.GetValue](ig_item_GetValue.md)
- [ig.item.GetWeaponAmmoType](ig_item_GetWeaponAmmoType.md)
- [ig.item.GetWeaponAmmoType](ig_item_GetWeaponAmmoType.md)
- [ig.item.GetWeapons](ig_item_GetWeapons.md)
- [ig.item.GetWeight](ig_item_GetWeight.md)
- [ig.item.IsConsumeable](ig_item_IsConsumeable.md)
- [ig.item.IsCraftable](ig_item_IsCraftable.md)
- [ig.item.IsCraftable](ig_item_IsCraftable.md)
- [ig.item.IsWeapon](ig_item_IsWeapon.md)
- [ig.item.IsWeapon](ig_item_IsWeapon.md)
- [ig.item.RequiresLicense](ig_item_RequiresLicense.md)
- [ig.item.ReturnPosition](ig_item_ReturnPosition.md)
- [ig.item.ReturnPosition](ig_item_ReturnPosition.md)
- [ig.item.Search](ig_item_Search.md)
- [ig.item.SetItems](ig_item_SetItems.md)
- [ig.item.ValidateItemData](ig_item_ValidateItemData.md)

## job

- [ig.job.CalculatePayroll](ig_job_CalculatePayroll.md)
- [ig.job.Exists](ig_job_Exists.md)
- [ig.job.GetAll](ig_job_GetAll.md)
- [ig.job.GetAllStats](ig_job_GetAllStats.md)
- [ig.job.GetBosses](ig_job_GetBosses.md)
- [ig.job.GetByBoss](ig_job_GetByBoss.md)
- [ig.job.GetByCategory](ig_job_GetByCategory.md)
- [ig.job.GetByName](ig_job_GetByName.md)
- [ig.job.GetCount](ig_job_GetCount.md)
- [ig.job.GetGradeInfo](ig_job_GetGradeInfo.md)
- [ig.job.GetGradeName](ig_job_GetGradeName.md)
- [ig.job.GetGradeSalary](ig_job_GetGradeSalary.md)
- [ig.job.GetHiring](ig_job_GetHiring.md)
- [ig.job.GetMembers](ig_job_GetMembers.md)
- [ig.job.GetOnDutyCount](ig_job_GetOnDutyCount.md)
- [ig.job.GetOnlineMembers](ig_job_GetOnlineMembers.md)
- [ig.job.GetOnlineMembersByGrade](ig_job_GetOnlineMembersByGrade.md)
- [ig.job.GetPayrollEligible](ig_job_GetPayrollEligible.md)
- [ig.job.GetRichest](ig_job_GetRichest.md)
- [ig.job.GetStats](ig_job_GetStats.md)
- [ig.job.GetTotalMemberCount](ig_job_GetTotalMemberCount.md)
- [ig.job.IsBossGrade](ig_job_IsBossGrade.md)
- [ig.job.IsBossOfAny](ig_job_IsBossOfAny.md)
- [ig.job.ProcessPayroll](ig_job_ProcessPayroll.md)
- [ig.job.Resync](ig_job_Resync.md)
- [ig.job.Search](ig_job_Search.md)
- [ig.job.ValidateData](ig_job_ValidateData.md)

## json

- [ig.json.Load](ig_json_Load.md)
- [ig.json.Write](ig_json_Write.md)

## marker

- [ig.marker.Place](ig_marker_Place.md)

## math

- [ig.math.Decimals](ig_math_Decimals.md)
- [ig.math.GroupDigits](ig_math_GroupDigits.md)
- [ig.math.Round](ig_math_Round.md)
- [ig.math.Trim](ig_math_Trim.md)

## modifier

- [ig.modifier.AddHungerModifier](ig_modifier_AddHungerModifier.md)
- [ig.modifier.AddStressModifier](ig_modifier_AddStressModifier.md)
- [ig.modifier.AddThirstModifier](ig_modifier_AddThirstModifier.md)
- [ig.modifier.DegradeModifiers](ig_modifier_DegradeModifiers.md)
- [ig.modifier.GetDegradeBoost](ig_modifier_GetDegradeBoost.md)
- [ig.modifier.GetHungerModifier](ig_modifier_GetHungerModifier.md)
- [ig.modifier.GetModifiers](ig_modifier_GetModifiers.md)
- [ig.modifier.GetStressModifier](ig_modifier_GetStressModifier.md)
- [ig.modifier.GetThirstModifier](ig_modifier_GetThirstModifier.md)
- [ig.modifier.SetDegradeBoost](ig_modifier_SetDegradeBoost.md)
- [ig.modifier.SetHungerModifier](ig_modifier_SetHungerModifier.md)
- [ig.modifier.SetModifiers](ig_modifier_SetModifiers.md)
- [ig.modifier.SetStressModifier](ig_modifier_SetStressModifier.md)
- [ig.modifier.SetThirstModifier](ig_modifier_SetThirstModifier.md)

## modkit

- [ig.modkit.ClearCache](ig_modkit_ClearCache.md)
- [ig.modkit.GetAll](ig_modkit_GetAll.md)
- [ig.modkit.GetAll](ig_modkit_GetAll.md)
- [ig.modkit.GetByID](ig_modkit_GetByID.md)
- [ig.modkit.GetForVehicle](ig_modkit_GetForVehicle.md)
- [ig.modkit.GetForVehicle](ig_modkit_GetForVehicle.md)
- [ig.modkit.HasModkit](ig_modkit_HasModkit.md)
- [ig.modkit.Load](ig_modkit_Load.md)

## name

- [ig.name.Load](ig_name_Load.md)
- [ig.name.RandomFemale](ig_name_RandomFemale.md)
- [ig.name.RandomMale](ig_name_RandomMale.md)
- [ig.name.RandomUnisex](ig_name_RandomUnisex.md)

## note

- [ig.note.Add](ig_note_Add.md)
- [ig.note.Clean](ig_note_Clean.md)
- [ig.note.CleanOld](ig_note_CleanOld.md)
- [ig.note.CleanUp](ig_note_CleanUp.md)
- [ig.note.Create](ig_note_Create.md)
- [ig.note.CreateBulletin](ig_note_CreateBulletin.md)
- [ig.note.CreateEvidence](ig_note_CreateEvidence.md)
- [ig.note.CreateGraffiti](ig_note_CreateGraffiti.md)
- [ig.note.Exist](ig_note_Exist.md)
- [ig.note.GetAll](ig_note_GetAll.md)
- [ig.note.GetByAuthor](ig_note_GetByAuthor.md)
- [ig.note.GetByID](ig_note_GetByID.md)
- [ig.note.GetByType](ig_note_GetByType.md)
- [ig.note.GetCount](ig_note_GetCount.md)
- [ig.note.GetMostRead](ig_note_GetMostRead.md)
- [ig.note.GetNearby](ig_note_GetNearby.md)
- [ig.note.GetRecent](ig_note_GetRecent.md)
- [ig.note.Hide](ig_note_Hide.md)
- [ig.note.Load](ig_note_Load.md)
- [ig.note.MarkRead](ig_note_MarkRead.md)
- [ig.note.Remove](ig_note_Remove.md)
- [ig.note.ResyncAll](ig_note_ResyncAll.md)
- [ig.note.Search](ig_note_Search.md)
- [ig.note.Show](ig_note_Show.md)
- [ig.note.Update](ig_note_Update.md)
- [ig.note.Update](ig_note_Update.md)
- [ig.note.ValidateData](ig_note_ValidateData.md)

## npc

- [ig.npc.AddNpc](ig_npc_AddNpc.md)
- [ig.npc.FindNpc](ig_npc_FindNpc.md)
- [ig.npc.GetNpc](ig_npc_GetNpc.md)
- [ig.npc.GetNpcs](ig_npc_GetNpcs.md)
- [ig.npc.RemoveNpc](ig_npc_RemoveNpc.md)

## objects

- [ig.objects.AddObject](ig_objects_AddObject.md)
- [ig.objects.FindObject](ig_objects_FindObject.md)
- [ig.objects.FindObjectFromUUID](ig_objects_FindObjectFromUUID.md)
- [ig.objects.GetObject](ig_objects_GetObject.md)
- [ig.objects.GetObjectFromUUID](ig_objects_GetObjectFromUUID.md)
- [ig.objects.GetObjects](ig_objects_GetObjects.md)
- [ig.objects.RemoveObject](ig_objects_RemoveObject.md)

## ped

- [ig.ped.GetAll](ig_ped_GetAll.md)
- [ig.ped.GetByGender](ig_ped_GetByGender.md)
- [ig.ped.GetByHash](ig_ped_GetByHash.md)
- [ig.ped.GetByName](ig_ped_GetByName.md)
- [ig.ped.GetByType](ig_ped_GetByType.md)
- [ig.ped.GetDisplayName](ig_ped_GetDisplayName.md)
- [ig.ped.GetFemalePeds](ig_ped_GetFemalePeds.md)
- [ig.ped.GetFreemodePeds](ig_ped_GetFreemodePeds.md)
- [ig.ped.GetMalePeds](ig_ped_GetMalePeds.md)
- [ig.ped.IsFemale](ig_ped_IsFemale.md)
- [ig.ped.IsFreemode](ig_ped_IsFreemode.md)
- [ig.ped.IsMale](ig_ped_IsMale.md)
- [ig.ped.IsValid](ig_ped_IsValid.md)

## persistance

- [ig.persistance.ObjectThread](ig_persistance_ObjectThread.md)
- [ig.persistance.UpdateVehicle](ig_persistance_UpdateVehicle.md)
- [ig.persistance.VehicleThread](ig_persistance_VehicleThread.md)

## pick

- [ig.pick.Activate](ig_pick_Activate.md)
- [ig.pick.CleanupOld](ig_pick_CleanupOld.md)
- [ig.pick.Collect](ig_pick_Collect.md)
- [ig.pick.Create](ig_pick_Create.md)
- [ig.pick.CreateLoot](ig_pick_CreateLoot.md)
- [ig.pick.CreateZone](ig_pick_CreateZone.md)
- [ig.pick.Deactivate](ig_pick_Deactivate.md)
- [ig.pick.GetAll](ig_pick_GetAll.md)
- [ig.pick.GetByEvent](ig_pick_GetByEvent.md)
- [ig.pick.GetByModel](ig_pick_GetByModel.md)
- [ig.pick.GetByUUID](ig_pick_GetByUUID.md)
- [ig.pick.GetCount](ig_pick_GetCount.md)
- [ig.pick.GetNearby](ig_pick_GetNearby.md)
- [ig.pick.IsActive](ig_pick_IsActive.md)
- [ig.pick.Remove](ig_pick_Remove.md)
- [ig.pick.ResyncAll](ig_pick_ResyncAll.md)
- [ig.pick.UpdateData](ig_pick_UpdateData.md)
- [ig.pick.ValidateData](ig_pick_ValidateData.md)

## player

- [ig.player.AddPlayer](ig_player_AddPlayer.md)
- [ig.player.ArePlayersActive](ig_player_ArePlayersActive.md)
- [ig.player.GetOfflinePlayer](ig_player_GetOfflinePlayer.md)
- [ig.player.GetPlayer](ig_player_GetPlayer.md)
- [ig.player.GetPlayerByCharacterID](ig_player_GetPlayerByCharacterID.md)
- [ig.player.GetPlayers](ig_player_GetPlayers.md)
- [ig.player.RemovePlayer](ig_player_RemovePlayer.md)
- [ig.player.SetPlayer](ig_player_SetPlayer.md)

## queue

- [ig.queue.Join](ig_queue_Join.md)

## rng

- [ig.rng.RandomValuesNoRepeats](ig_rng_RandomValuesNoRepeats.md)
- [ig.rng.UUID](ig_rng_UUID.md)
- [ig.rng.char](ig_rng_char.md)
- [ig.rng.chars](ig_rng_chars.md)
- [ig.rng.let](ig_rng_let.md)
- [ig.rng.lets](ig_rng_lets.md)
- [ig.rng.num](ig_rng_num.md)
- [ig.rng.nums](ig_rng_nums.md)

## security

- [ig.security.CheckRateLimit](ig_security_CheckRateLimit.md)
- [ig.security.CheckTransactionRateLimit](ig_security_CheckTransactionRateLimit.md)
- [ig.security.DetectSuspiciousActivity](ig_security_DetectSuspiciousActivity.md)
- [ig.security.LogPlayerTransaction](ig_security_LogPlayerTransaction.md)
- [ig.security.LogTransaction](ig_security_LogTransaction.md)

## skill

- [ig.skill.CompareSkill](ig_skill_CompareSkill.md)
- [ig.skill.GetSkill](ig_skill_GetSkill.md)
- [ig.skill.GetSkills](ig_skill_GetSkills.md)
- [ig.skill.SetSkills](ig_skill_SetSkills.md)

## sql

- [ig.sql.AwaitReady](ig_sql_AwaitReady.md)
- [ig.sql.Batch](ig_sql_Batch.md)
- [ig.sql.ExecutePrepared](ig_sql_ExecutePrepared.md)
- [ig.sql.FetchScalar](ig_sql_FetchScalar.md)
- [ig.sql.FetchSingle](ig_sql_FetchSingle.md)
- [ig.sql.GetStats](ig_sql_GetStats.md)
- [ig.sql.Insert](ig_sql_Insert.md)
- [ig.sql.IsReady](ig_sql_IsReady.md)
- [ig.sql.PrepareQuery](ig_sql_PrepareQuery.md)
- [ig.sql.Query](ig_sql_Query.md)
- [ig.sql.ResetActiveCharacters](ig_sql_ResetActiveCharacters.md)
- [ig.sql.Transaction](ig_sql_Transaction.md)
- [ig.sql.Update](ig_sql_Update.md)
- [ig.sql.bank.AddAccount](ig_sql_bank_AddAccount.md)
- [ig.sql.bank.GetBank](ig_sql_bank_GetBank.md)
- [ig.sql.bank.GetLoan](ig_sql_bank_GetLoan.md)
- [ig.sql.bank.SetBank](ig_sql_bank_SetBank.md)
- [ig.sql.bank.SetLoan](ig_sql_bank_SetLoan.md)
- [ig.sql.bank.TakeOutLoan](ig_sql_bank_TakeOutLoan.md)
- [ig.sql.bank.TickOverLoanDuration](ig_sql_bank_TickOverLoanDuration.md)
- [ig.sql.bank.TickOverLoanInterest](ig_sql_bank_TickOverLoanInterest.md)
- [ig.sql.bank.TickOverLoansInactive](ig_sql_bank_TickOverLoansInactive.md)
- [ig.sql.char.Add](ig_sql_char_Add.md)
- [ig.sql.char.AddOutfit](ig_sql_char_AddOutfit.md)
- [ig.sql.char.Current](ig_sql_char_Current.md)
- [ig.sql.char.Delete](ig_sql_char_Delete.md)
- [ig.sql.char.Get](ig_sql_char_Get.md)
- [ig.sql.char.GetAll](ig_sql_char_GetAll.md)
- [ig.sql.char.GetAllNotDead](ig_sql_char_GetAllNotDead.md)
- [ig.sql.char.GetAllPermited](ig_sql_char_GetAllPermited.md)
- [ig.sql.char.GetAllWanted](ig_sql_char_GetAllWanted.md)
- [ig.sql.char.GetAppearance](ig_sql_char_GetAppearance.md)
- [ig.sql.char.GetArmour](ig_sql_char_GetArmour.md)
- [ig.sql.char.GetCityId](ig_sql_char_GetCityId.md)
- [ig.sql.char.GetCoords](ig_sql_char_GetCoords.md)
- [ig.sql.char.GetCount](ig_sql_char_GetCount.md)
- [ig.sql.char.GetFromCityId](ig_sql_char_GetFromCityId.md)
- [ig.sql.char.GetFromPhone](ig_sql_char_GetFromPhone.md)
- [ig.sql.char.GetHealth](ig_sql_char_GetHealth.md)
- [ig.sql.char.GetHunger](ig_sql_char_GetHunger.md)
- [ig.sql.char.GetOutfitByNumber](ig_sql_char_GetOutfitByNumber.md)
- [ig.sql.char.GetOutfitsAsCount](ig_sql_char_GetOutfitsAsCount.md)
- [ig.sql.char.GetPhone](ig_sql_char_GetPhone.md)
- [ig.sql.char.GetStress](ig_sql_char_GetStress.md)
- [ig.sql.char.GetThirst](ig_sql_char_GetThirst.md)
- [ig.sql.char.ReviveDeadCharacters](ig_sql_char_ReviveDeadCharacters.md)
- [ig.sql.char.SetActive](ig_sql_char_SetActive.md)
- [ig.sql.char.SetAppearance](ig_sql_char_SetAppearance.md)
- [ig.sql.char.SetArmour](ig_sql_char_SetArmour.md)
- [ig.sql.char.SetCoords](ig_sql_char_SetCoords.md)
- [ig.sql.char.SetDead](ig_sql_char_SetDead.md)
- [ig.sql.char.SetHealth](ig_sql_char_SetHealth.md)
- [ig.sql.char.SetHunger](ig_sql_char_SetHunger.md)
- [ig.sql.char.SetInstance](ig_sql_char_SetInstance.md)
- [ig.sql.char.SetStress](ig_sql_char_SetStress.md)
- [ig.sql.char.SetThirst](ig_sql_char_SetThirst.md)
- [ig.sql.char.SetWanted](ig_sql_char_SetWanted.md)
- [ig.sql.gen.AccountNumber](ig_sql_gen_AccountNumber.md)
- [ig.sql.gen.CarPlate](ig_sql_gen_CarPlate.md)
- [ig.sql.gen.CharacterID](ig_sql_gen_CharacterID.md)
- [ig.sql.gen.CityID](ig_sql_gen_CityID.md)
- [ig.sql.gen.Iban](ig_sql_gen_Iban.md)
- [ig.sql.gen.PhoneNumber](ig_sql_gen_PhoneNumber.md)
- [ig.sql.save.Jobs](ig_sql_save_Jobs.md)
- [ig.sql.save.Objects](ig_sql_save_Objects.md)
- [ig.sql.save.User](ig_sql_save_User.md)
- [ig.sql.save.Users](ig_sql_save_Users.md)
- [ig.sql.save.Vehicle](ig_sql_save_Vehicle.md)
- [ig.sql.save.Vehicles](ig_sql_save_Vehicles.md)
- [ig.sql.user.Add](ig_sql_user_Add.md)
- [ig.sql.user.AddCharacterSlot](ig_sql_user_AddCharacterSlot.md)
- [ig.sql.user.Find](ig_sql_user_Find.md)
- [ig.sql.user.Get](ig_sql_user_Get.md)
- [ig.sql.user.GetAce](ig_sql_user_GetAce.md)
- [ig.sql.user.GetBan](ig_sql_user_GetBan.md)
- [ig.sql.user.GetBanReason](ig_sql_user_GetBanReason.md)
- [ig.sql.user.GetLastLogin](ig_sql_user_GetLastLogin.md)
- [ig.sql.user.GetLocale](ig_sql_user_GetLocale.md)
- [ig.sql.user.GetPriority](ig_sql_user_GetPriority.md)
- [ig.sql.user.GetSlots](ig_sql_user_GetSlots.md)
- [ig.sql.user.SetAce](ig_sql_user_SetAce.md)
- [ig.sql.user.SetBan](ig_sql_user_SetBan.md)
- [ig.sql.user.SetLocale](ig_sql_user_SetLocale.md)
- [ig.sql.user.SetPriority](ig_sql_user_SetPriority.md)
- [ig.sql.user.Update](ig_sql_user_Update.md)
- [ig.sql.veh.Add](ig_sql_veh_Add.md)
- [ig.sql.veh.ChangeOwner](ig_sql_veh_ChangeOwner.md)
- [ig.sql.veh.GetAll](ig_sql_veh_GetAll.md)
- [ig.sql.veh.GetByPlate](ig_sql_veh_GetByPlate.md)
- [ig.sql.veh.GetID](ig_sql_veh_GetID.md)
- [ig.sql.veh.GetVehicles](ig_sql_veh_GetVehicles.md)
- [ig.sql.veh.Reset](ig_sql_veh_Reset.md)

## state

- [ig.state.AddState](ig_state_AddState.md)
- [ig.state.ChangeAction](ig_state_ChangeAction.md)
- [ig.state.ChangeEffect](ig_state_ChangeEffect.md)
- [ig.state.TriggerAction](ig_state_TriggerAction.md)
- [ig.state.TriggerEffect](ig_state_TriggerEffect.md)
- [ig.state.TriggerState](ig_state_TriggerState.md)

## status

- [ig.status.AddArmour](ig_status_AddArmour.md)
- [ig.status.AddArmourToAmount](ig_status_AddArmourToAmount.md)
- [ig.status.AddHunger](ig_status_AddHunger.md)
- [ig.status.AddStress](ig_status_AddStress.md)
- [ig.status.AddThirst](ig_status_AddThirst.md)
- [ig.status.Bobble](ig_status_Bobble.md)
- [ig.status.Camera](ig_status_Camera.md)
- [ig.status.GetArmour](ig_status_GetArmour.md)
- [ig.status.GetHealth](ig_status_GetHealth.md)
- [ig.status.GetHunger](ig_status_GetHunger.md)
- [ig.status.GetMaxHealth](ig_status_GetMaxHealth.md)
- [ig.status.GetStress](ig_status_GetStress.md)
- [ig.status.GetThirst](ig_status_GetThirst.md)
- [ig.status.RemoveHunger](ig_status_RemoveHunger.md)
- [ig.status.RemoveStress](ig_status_RemoveStress.md)
- [ig.status.RemoveThirst](ig_status_RemoveThirst.md)
- [ig.status.SelfDamageHealth](ig_status_SelfDamageHealth.md)
- [ig.status.SetArmour](ig_status_SetArmour.md)
- [ig.status.SetBleed](ig_status_SetBleed.md)
- [ig.status.SetBurn](ig_status_SetBurn.md)
- [ig.status.SetHaste](ig_status_SetHaste.md)
- [ig.status.SetHealth](ig_status_SetHealth.md)
- [ig.status.SetHunger](ig_status_SetHunger.md)
- [ig.status.SetInjury](ig_status_SetInjury.md)
- [ig.status.SetPlayer](ig_status_SetPlayer.md)
- [ig.status.SetPoison](ig_status_SetPoison.md)
- [ig.status.SetSlow](ig_status_SetSlow.md)
- [ig.status.SetStress](ig_status_SetStress.md)
- [ig.status.SetThirst](ig_status_SetThirst.md)
- [ig.status.SetVision](ig_status_SetVision.md)
- [ig.status.SetWithdrawls](ig_status_SetWithdrawls.md)
- [ig.status.Sound](ig_status_Sound.md)
- [ig.status.StartHungerDecrease](ig_status_StartHungerDecrease.md)
- [ig.status.StartStressIncrease](ig_status_StartStressIncrease.md)
- [ig.status.StartThirstDecrease](ig_status_StartThirstDecrease.md)
- [ig.status.WalkType](ig_status_WalkType.md)

## table

- [ig.table.Clone](ig_table_Clone.md)
- [ig.table.Dump](ig_table_Dump.md)
- [ig.table.MakeReadOnly](ig_table_MakeReadOnly.md)
- [ig.table.MatchKey](ig_table_MatchKey.md)
- [ig.table.MatchValue](ig_table_MatchValue.md)
- [ig.table.Merge](ig_table_Merge.md)
- [ig.table.ReArrange](ig_table_ReArrange.md)
- [ig.table.Size](ig_table_Size.md)
- [ig.table.SizeOf](ig_table_SizeOf.md)

## target

- [ig.target.AddBoxZone](ig_target_AddBoxZone.md)
- [ig.target.AddEntity](ig_target_AddEntity.md)
- [ig.target.AddEntityZone](ig_target_AddEntityZone.md)
- [ig.target.AddGlobalObject](ig_target_AddGlobalObject.md)
- [ig.target.AddGlobalPed](ig_target_AddGlobalPed.md)
- [ig.target.AddGlobalPlayer](ig_target_AddGlobalPlayer.md)
- [ig.target.AddGlobalVehicle](ig_target_AddGlobalVehicle.md)
- [ig.target.AddLocalEntity](ig_target_AddLocalEntity.md)
- [ig.target.AddModel](ig_target_AddModel.md)
- [ig.target.AddPolyZone](ig_target_AddPolyZone.md)
- [ig.target.AddSphereZone](ig_target_AddSphereZone.md)
- [ig.target.removeEntity](ig_target_removeEntity.md)
- [ig.target.removeGlobalObject](ig_target_removeGlobalObject.md)
- [ig.target.removeGlobalPed](ig_target_removeGlobalPed.md)
- [ig.target.removeGlobalPlayer](ig_target_removeGlobalPlayer.md)
- [ig.target.removeGlobalVehicle](ig_target_removeGlobalVehicle.md)
- [ig.target.removeLocalEntity](ig_target_removeLocalEntity.md)
- [ig.target.removeModel](ig_target_removeModel.md)
- [ig.target.removeZone](ig_target_removeZone.md)

## tattoo

- [ig.tattoo.ClearCache](ig_tattoo_ClearCache.md)
- [ig.tattoo.GetAll](ig_tattoo_GetAll.md)
- [ig.tattoo.GetAll](ig_tattoo_GetAll.md)
- [ig.tattoo.GetByCollection](ig_tattoo_GetByCollection.md)
- [ig.tattoo.GetByHash](ig_tattoo_GetByHash.md)
- [ig.tattoo.GetByZone](ig_tattoo_GetByZone.md)
- [ig.tattoo.GetByZone](ig_tattoo_GetByZone.md)
- [ig.tattoo.IsFemale](ig_tattoo_IsFemale.md)
- [ig.tattoo.IsMale](ig_tattoo_IsMale.md)

## text

- [ig.text.AddEntry](ig_text_AddEntry.md)
- [ig.text.DisplayHelp](ig_text_DisplayHelp.md)

## time

- [ig.time.ClearOverride](ig_time_ClearOverride.md)
- [ig.time.GetTime](ig_time_GetTime.md)
- [ig.time.ServerSync](ig_time_ServerSync.md)
- [ig.time.SetTimeOverride](ig_time_SetTimeOverride.md)
- [ig.time.Update](ig_time_Update.md)
- [ig.time.UpdateTime](ig_time_UpdateTime.md)

## validation

- [ig.validation.GetItemQuantities](ig_validation_GetItemQuantities.md)
- [ig.validation.IsValidItem](ig_validation_IsValidItem.md)
- [ig.validation.LogAndBanExploiter](ig_validation_LogAndBanExploiter.md)
- [ig.validation.ValidateAndUnpack](ig_validation_ValidateAndUnpack.md)
- [ig.validation.ValidateInventory](ig_validation_ValidateInventory.md)
- [ig.validation.ValidateInventoryIntegrity](ig_validation_ValidateInventoryIntegrity.md)
- [ig.validation.ValidateSlot](ig_validation_ValidateSlot.md)

## vehicle

- [ig.vehicle.AddVehicle](ig_vehicle_AddVehicle.md)
- [ig.vehicle.ClearCache](ig_vehicle_ClearCache.md)
- [ig.vehicle.FindVehicle](ig_vehicle_FindVehicle.md)
- [ig.vehicle.FindVehicleFromPlate](ig_vehicle_FindVehicleFromPlate.md)
- [ig.vehicle.GetAll](ig_vehicle_GetAll.md)
- [ig.vehicle.GetAll](ig_vehicle_GetAll.md)
- [ig.vehicle.GetByClass](ig_vehicle_GetByClass.md)
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md)
- [ig.vehicle.GetByHash](ig_vehicle_GetByHash.md)
- [ig.vehicle.GetByManufacturer](ig_vehicle_GetByManufacturer.md)
- [ig.vehicle.GetByName](ig_vehicle_GetByName.md)
- [ig.vehicle.GetCurrentSeat](ig_vehicle_GetCurrentSeat.md)
- [ig.vehicle.GetCurrentVehicle](ig_vehicle_GetCurrentVehicle.md)
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md)
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md)
- [ig.vehicle.GetVehicle](ig_vehicle_GetVehicle.md)
- [ig.vehicle.GetVehicleByPlate](ig_vehicle_GetVehicleByPlate.md)
- [ig.vehicle.GetVehicles](ig_vehicle_GetVehicles.md)
- [ig.vehicle.IsAircraft](ig_vehicle_IsAircraft.md)
- [ig.vehicle.IsBoa](ig_vehicle_IsBoa.md)
- [ig.vehicle.IsInVehicle](ig_vehicle_IsInVehicle.md)
- [ig.vehicle.Load](ig_vehicle_Load.md)
- [ig.vehicle.RemoveVehicle](ig_vehicle_RemoveVehicle.md)
- [ig.vehicle.SetVehicle](ig_vehicle_SetVehicle.md)

## version

- [ig.version.Check](ig_version_Check.md)
- [ig.version.CronCheck](ig_version_CronCheck.md)
- [ig.version.LoopCheck](ig_version_LoopCheck.md)

## voip

- [ig.voip.Debug](ig_voip_Debug.md)
- [ig.voip.GetDistance](ig_voip_GetDistance.md)
- [ig.voip.GetGridCell](ig_voip_GetGridCell.md)
- [ig.voip.GetNextVoiceMode](ig_voip_GetNextVoiceMode.md)
- [ig.voip.GetPreviousVoiceMode](ig_voip_GetPreviousVoiceMode.md)
- [ig.voip.GetSurroundingGridCells](ig_voip_GetSurroundingGridCells.md)
- [ig.voip.GetVoiceMode](ig_voip_GetVoiceMode.md)
- [ig.voip.GetVoiceModeCount](ig_voip_GetVoiceModeCount.md)
- [ig.voip.IsValidRadioChannel](ig_voip_IsValidRadioChannel.md)
- [ig.voip.client.GetVoiceMode](ig_voip_client_GetVoiceMode.md)
- [ig.voip.client.HandleAdminCallStateChange](ig_voip_client_HandleAdminCallStateChange.md)
- [ig.voip.client.HandleCallStateChange](ig_voip_client_HandleCallStateChange.md)
- [ig.voip.client.HandleConnectionStateChange](ig_voip_client_HandleConnectionStateChange.md)
- [ig.voip.client.InitializeMumble](ig_voip_client_InitializeMumble.md)
- [ig.voip.client.IsTalking](ig_voip_client_IsTalking.md)
- [ig.voip.client.JoinRadioChannel](ig_voip_client_JoinRadioChannel.md)
- [ig.voip.client.LeaveRadioChannel](ig_voip_client_LeaveRadioChannel.md)
- [ig.voip.client.NextVoiceMode](ig_voip_client_NextVoiceMode.md)
- [ig.voip.client.PreviousVoiceMode](ig_voip_client_PreviousVoiceMode.md)
- [ig.voip.client.SetRadioTransmitting](ig_voip_client_SetRadioTransmitting.md)
- [ig.voip.client.SetVoiceMode](ig_voip_client_SetVoiceMode.md)
- [ig.voip.client.UpdateAdminCallTargets](ig_voip_client_UpdateAdminCallTargets.md)
- [ig.voip.client.UpdateCallTargets](ig_voip_client_UpdateCallTargets.md)
- [ig.voip.client.UpdateConnectionTargets](ig_voip_client_UpdateConnectionTargets.md)
- [ig.voip.client.UpdateProximityTargets](ig_voip_client_UpdateProximityTargets.md)
- [ig.voip.client.UpdateRadioTargets](ig_voip_client_UpdateRadioTargets.md)
- [ig.voip.client.UpdateTalkingState](ig_voip_client_UpdateTalkingState.md)
- [ig.voip.server.CleanupPlayer](ig_voip_server_CleanupPlayer.md)
- [ig.voip.server.EndAdminCall](ig_voip_server_EndAdminCall.md)
- [ig.voip.server.EndCall](ig_voip_server_EndCall.md)
- [ig.voip.server.EndConnection](ig_voip_server_EndConnection.md)
- [ig.voip.server.GetPlayersInProximity](ig_voip_server_GetPlayersInProximity.md)
- [ig.voip.server.GetVoiceMode](ig_voip_server_GetVoiceMode.md)
- [ig.voip.server.InitializePlayer](ig_voip_server_InitializePlayer.md)
- [ig.voip.server.JoinRadioChannel](ig_voip_server_JoinRadioChannel.md)
- [ig.voip.server.LeaveRadioChannel](ig_voip_server_LeaveRadioChannel.md)
- [ig.voip.server.RemoveFromGrid](ig_voip_server_RemoveFromGrid.md)
- [ig.voip.server.SetRadioTransmitting](ig_voip_server_SetRadioTransmitting.md)
- [ig.voip.server.SetVoiceMode](ig_voip_server_SetVoiceMode.md)
- [ig.voip.server.StartAdminCall](ig_voip_server_StartAdminCall.md)
- [ig.voip.server.StartCall](ig_voip_server_StartCall.md)
- [ig.voip.server.StartConnection](ig_voip_server_StartConnection.md)
- [ig.voip.server.UpdateGrid](ig_voip_server_UpdateGrid.md)

## weapon

- [ig.weapon.ClearCache](ig_weapon_ClearCache.md)
- [ig.weapon.Exist](ig_weapon_Exist.md)
- [ig.weapon.Get](ig_weapon_Get.md)
- [ig.weapon.GetAll](ig_weapon_GetAll.md)
- [ig.weapon.GetAll](ig_weapon_GetAll.md)
- [ig.weapon.GetByCategory](ig_weapon_GetByCategory.md)
- [ig.weapon.GetByHash](ig_weapon_GetByHash.md)
- [ig.weapon.GetByHash](ig_weapon_GetByHash.md)
- [ig.weapon.GetByName](ig_weapon_GetByName.md)
- [ig.weapon.GetComponents](ig_weapon_GetComponents.md)
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md)
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md)
- [ig.weapon.GetName](ig_weapon_GetName.md)
- [ig.weapon.IsMelee](ig_weapon_IsMelee.md)
- [ig.weapon.Resync](ig_weapon_Resync.md)
