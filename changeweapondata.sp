#include <sourcemod>
#include <sdktools>

#define primary_clip_size 20
#define range_modifier 272

char sGetItemSchema[] = "\x55\x89\xE5\x83\xEC\x08\xE8\x2A\x2A\x2A\x2A\xC9\x83\xC0\x04\xC3";
char sGetItemDefinitionByName[] = "\x55\x89\xE5\x57\x56\x53\x83\xEC\x0C\x8B\x45\x2A\x80\xB8\x2A\x2A\x2A\x2A\x00\x75\x2A\x8B\x55";
char sGetCCSWeaponData[] = "\x55\x89\xE5\x53\x83\xEC\x04\x8B\x45\x08\x85\xC0\x74\x4A\x8B\x15"; 

Handle hGetItemSchema;
Handle hGetItemDefinitionByName;
Handle hGetCCSWeaponData;

public Plugin myinfo =
{
	name = "change weapon data",
	author = "neko AKA bklol"
}

public void OnPluginStart()  
{
	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetSignature(SDKLibrary_Server, sGetItemSchema, sizeof(sGetItemSchema) - 1);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetItemSchema = EndPrepSDKCall();
	if(!hGetItemSchema) SetFailState("Could not initialize call to GetItemSchema");

	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetSignature(SDKLibrary_Server, sGetItemDefinitionByName, sizeof(sGetItemDefinitionByName) - 1);
	PrepSDKCall_AddParameter(SDKType_PlainOldData,  SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_String,  SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetItemDefinitionByName = EndPrepSDKCall();
	if(!hGetItemDefinitionByName) SetFailState("Could not initialize call to GetItemDefinitionByName");
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetSignature(SDKLibrary_Server, sGetCCSWeaponData, sizeof(sGetCCSWeaponData) - 1);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetCCSWeaponData = EndPrepSDKCall();
	if(!hGetCCSWeaponData) SetFailState("Could not initialize call to GetCCSWeaponDataFromDef");
	
	

}

public void OnMapStart()  
{
	Address CCSWeaponData = SDKCall(hGetCCSWeaponData, SDKCall(hGetItemDefinitionByName, SDKCall(hGetItemSchema), "weapon_awp"));
	StoreToAddress(CCSWeaponData + view_as<Address>(primary_clip_size), 5, NumberType_Int32);
	
	/*
	CCSWeaponData = SDKCall(hGetCCSWeaponData, SDKCall(GetItemDefinitionByName, SDKCall(GetItemSchema), "weapon_m4a1_silencer")); // range_modifier back to 0.99
	StoreToAddress(CCSWeaponData + view_as<Address>(range_modifier), view_as<int>(0.990000), NumberType_Int32);
	*/ 
}