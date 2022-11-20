#pragma semicolon 1 
#include <PTaH> 
#include <sdktools> 

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
	Address CCSWeaponData, aBuf;	
	ItemDef = PTaH_GetItemDefinitionByName("weapon_awp");
	if(ItemDef && (CCSWeaponData = SDKCall(hGetCCSWeaponData, ItemDef)))
	{
		aBuf = view_as<Address>(20);
		StoreToAddress(CCSWeaponData + aBuf, 10, NumberType_Int32);
	}
}