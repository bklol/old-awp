#pragma semicolon 1 
#include <PTaH> 
#include <sdktools> 

#define range_modifier 272 //0x010C + 4 now....
#define primary_clip_size 20

Handle hGetCCSWeaponData;
/*
//basic look like this
undefined4 GetCCSWeaponData(undefined4 *param_1)

{
  code *pcVar1;
  undefined2 uVar2;
  undefined4 uVar3;
  
  if (param_1 == (undefined4 *)0x0) {
    uVar3 = 0;
  }
  else {
    pcVar1 = *(code **)(DAT_0186d4ac + 8);
    if (*(code **)*param_1 == FUN_005db3e0) {
      uVar2 = *(undefined2 *)(param_1 + 2);
    }
    else {
      uVar2 = (**(code **)*param_1)(param_1);
    }
    uVar3 = (*pcVar1)(&DAT_0186d4ac,uVar2);
  }
  return uVar3;
}

*/
char sig[] = "\x85\xC9\x75\x2A\x33\xC0\xC3\x8B\x01"; //win
//char sig[] = "\x55\x89\xE5\x53\x83\xEC\x04\x8B\x45\x08\x85\xC0\x74\x4A\x8B\x15"; //linux

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