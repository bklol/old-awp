#pragma semicolon 1 
#include <PTaH> 
#include <sdktools> 

#define range_modifier 272 //0x010C + 4 now....
#define primary_clip_size 20

Handle hGetCCSWeaponData;
char sig[] = "\x55\x31\xC0\x89\xE5\x53\x83\xEC\x14\x8B\x55\x08\x85\xD2";

public void OnPluginStart()  
{
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetSignature(SDKLibrary_Server, sig, sizeof(sig) - 1);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetCCSWeaponData = EndPrepSDKCall();
	if(!hGetCCSWeaponData) SetFailState("Could not initialize call to GetCCSWeaponDataFromDef");
}

public void OnMapStart()  
{
	CEconItemDefinition ItemDef;
	Address CCSWeaponData;
	ItemDef = PTaH_GetItemDefinitionByName("weapon_awp");
	if(ItemDef && (CCSWeaponData = SDKCall(hGetCCSWeaponData, ItemDef)))
	{
		StoreToAddress(CCSWeaponData + view_as<Address>(primary_clip_size), 10, NumberType_Int32);
	}
	ItemDef = PTaH_GetItemDefinitionByName("weapon_m4a1_silencer");
	if(ItemDef && (CCSWeaponData = SDKCall(hGetCCSWeaponData, ItemDef)))
	{
		StoreToAddress(CCSWeaponData + view_as<Address>(range_modifier), view_as<int>(0.990000), NumberType_Int32); //Damage Given to "电脑玩家施德尔" - 110 in 4 hits
	}
}