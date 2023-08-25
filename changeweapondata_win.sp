#include <sourcemod>
#include <sdktools>

#define primary_clip_size 20
#define range_modifier 272

char sGetItemSchema_win[] = "\xA1\x2A\x2A\x2A\x2A\x85\xC0\x75\x2A\xA1\x2A\x2A\x2A\x2A\x56";
char sGetCCSWeaponData[] = "\x85\xC9\x75\x2A\x33\xC0\xC3\x8B\x01";

Handle hGetItemSchema;
Handle hGetItemDefinitionByName;
Handle hGetCCSWeaponData;

public Plugin myinfo =
{
	name = "change weapon data(windows)",
	author = "neko AKA bklol"
}

public void OnPluginStart()  
{

	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetSignature(SDKLibrary_Server, sGetItemSchema_win, sizeof(sGetItemSchema_win) - 1);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetItemSchema = EndPrepSDKCall();
	if(!hGetItemSchema) SetFailState("Could not initialize call to GetItemSchema");
	
	Address GetItemDefinitionByName = Dereference(Dereference(SDKCall(hGetItemSchema), 0x4) , 0xa8);
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetAddress(GetItemDefinitionByName);
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);	
	hGetItemDefinitionByName = EndPrepSDKCall();
	if(!hGetItemDefinitionByName) 
		SetFailState("Could not initialize call to hGetItemDefinitionByName");
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetSignature(SDKLibrary_Server, sGetCCSWeaponData, sizeof(sGetCCSWeaponData) - 1);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	hGetCCSWeaponData = EndPrepSDKCall();
	if(!hGetCCSWeaponData) SetFailState("Could not initialize call to GetCCSWeaponDataFromDef");
	
}

public void OnMapStart()  
{
	Address CCSWeaponData = SDKCall(hGetCCSWeaponData, SDKCall(hGetItemDefinitionByName, SDKCall(hGetItemSchema) + view_as<Address>(0x4), "weapon_awp"));
	StoreToAddress(CCSWeaponData + view_as<Address>(primary_clip_size), 10, NumberType_Int32);
}

stock any Dereference( Address ptr, int offset = 0, NumberType type = NumberType_Int32 )
{
    #if defined _DEBUG
    if ( ptr == Address_Null )
    {
        ThrowError("ptr == Address_Null");
    }
    #endif
 
    return view_as<Address>(LoadFromAddress(ptr + view_as<Address>(offset), type));
} 