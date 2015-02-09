Scriptname vMYC_AlcoveController extends ObjectReference
{Handle alcove data and appearance.}

;=== Imports ===--

Import Utility
Import Game
Import vMYC_Registry

;=== Constants ===--  

;=== Properties ===--

Activator						Property	vMYC_AlcoveLightingControllerActivator	Auto
vMYC_AlcoveLightingController	Property	LightingController						Auto Hidden
vMYC_ShrineManager				Property	ShrineManager							Auto Hidden

Actor							Property	PlayerREF								Auto

Int								Property 	AlcoveIndex 							Auto

Actor							Property	AlcoveActor								Auto Hidden
;=== Variables ===--

String _sFormID

;=== Events and Functions ===--

Function CheckVars()
	If !_sFormID
		_sFormID = GetFormIDString(Self)
	EndIf
	CheckObjects()
EndFunction

Event OnInit()
	DebugTrace("OnInit!")
	CheckVars()
	RegisterForModEvents()
EndEvent

Event OnLoad()
	DebugTrace("OnLoad!")
	CheckVars()
EndEvent

Event OnCellAttach()
	DebugTrace("OnCellAttach!")
EndEvent

Event OnShrineManagerReady(Form akSender)
	If !ShrineManager && akSender as vMYC_ShrineManager
		ShrineManager = akSender as vMYC_ShrineManager
		;DebugTrace("I am " + Self + ", registry reports Shrine.Alcove" + AlcoveIndex + ".UUID is " + GetRegStr("Shrine.Alcove" + AlcoveIndex + ".UUID") + "!")
		If GetRegForm("Shrine.Alcove" + AlcoveIndex + ".Form") != Self
			DebugTrace("Not present in the registry, registering for the first time...")
			SendRegisterEvent()
		Else
			DebugTrace("Already registered at index " + GetRegInt("Shrine.Alcove" + AlcoveIndex + ".Index") + "!")
			SendSyncEvent()
		EndIf
	EndIf
EndEvent

Function SendRegisterEvent()
	Int iHandle = ModEvent.Create("vMYC_AlcoveRegister")
	If iHandle
		ModEvent.PushInt(iHandle,AlcoveIndex)
		ModEvent.PushForm(iHandle,Self)
		ModEvent.Send(iHandle)
	Else
		DebugTrace("WARNING: Couldn't send vMYC_AlcoveRegister!",1)
	EndIf
EndFunction

Function SendSyncEvent()
	Int iHandle = ModEvent.Create("vMYC_AlcoveSync")
	If iHandle
		ModEvent.PushInt(iHandle,AlcoveIndex)
		ModEvent.PushForm(iHandle,Self)
		ModEvent.Send(iHandle)
	Else
		DebugTrace("WARNING: Couldn't send vMYC_AlcoveSync!",1)
	EndIf
EndFunction

Function RegisterForModEvents()
	RegisterForModEvent("vMYC_ShrineManagerReady","OnShrineManagerReady")
EndFunction

Function CheckObjects()
	If !LightingController
		FindObjects()
	EndIf
EndFunction

Function FindObjects()
	LightingController = FindClosestReferenceOfTypeFromRef(vMYC_AlcoveLightingControllerActivator,Self,1500) as vMYC_AlcoveLightingController
	
	DebugTrace("LightingController is " + LightingController + "!")
EndFunction



	
;=== Utility functions ===--

Function DebugTrace(String sDebugString, Int iSeverity = 0)
	Debug.Trace("MYC/AlcoveController/" + _sFormID + ": " + sDebugString,iSeverity)
	;FFUtils.TraceConsole(sDebugString)
EndFunction

String Function GetFormIDString(Form kForm)
	String sResult
	sResult = kForm as String ; [FormName < (FF000000)>]
	sResult = StringUtil.SubString(sResult,StringUtil.Find(sResult,"(") + 1,8)
	Return sResult
EndFunction

Bool Function WaitFor3DLoad(ObjectReference kObjectRef, Int iSafety = 20)
	While !kObjectRef.Is3DLoaded() && iSafety > 0
		iSafety -= 1
		Wait(0.1)
	EndWhile
	Return iSafety as Bool
EndFunction
