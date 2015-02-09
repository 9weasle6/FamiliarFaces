Scriptname vMYC_TrophyManager extends vMYC_ManagerBase
{Handle registration and tracking of trophies.}

;=== Imports ===--

Import Utility
Import Game
Import vMYC_Registry

;=== Constants ===--


;=== Properties ===--

Actor 				Property PlayerRef 								Auto
{The Player, duh}

Static				Property vMYC_AlcoveTrophyPlacementMarker		Auto

Form				Property vMYC_TrophyBannerHangingMarker			Auto
Form				Property vMYC_TrophyBannerStandingMarker		Auto

FormList			Property vMYC_BannerAnchors						Auto

;=== Achievement test Properties ===--

;=== Variables ===--

ObjectReference	TrophyPlacementMarker

;=== Events ===--

Event OnInit()
	If IsRunning()
		SetRegObj("Trophies",0)
		RegisterForSingleUpdate(5)
	EndIf
EndEvent

Event OnGameReload()
	RegisterForSingleUpdate(5)
EndEvent

Event OnUpdate()
	SendTrophyManagerReady()
EndEvent

Event OnTrophyRegister(String asTrophyName, Form akTrophyForm)
	DebugTrace("Registering " + akTrophyform + " (" + asTrophyName + ")...")
	vMYC_TrophyBase kTrophy = akTrophyForm as vMYC_TrophyBase
	Int jTrophy = JMap.Object()
	JMap.SetStr(jTrophy,"Name",asTrophyName)
	JMap.SetForm(jTrophy,"Form",kTrophy)
	JMap.SetInt(jTrophy,"Version",kTrophy.TrophyVersion)
	JMap.SetInt(jTrophy,"Priority",kTrophy.TrophyPriority)
	JMap.SetStr(jTrophy,"Source",FFUtils.GetSourceMod(kTrophy))
	JMap.SetInt(jTrophy,"Loc",kTrophy.TrophyLoc)
	JMap.SetInt(jTrophy,"Size",kTrophy.TrophySize)
	JMap.SetInt(jTrophy,"Type",kTrophy.TrophyType)
	JMap.SetInt(jTrophy,"Extras",kTrophy.TrophyExtras)
	JMap.SetInt(jTrophy,"Flags",kTrophy.TrophyFlags)
	JMap.SetInt(jTrophy,"Enabled",kTrophy.Enabled as Int)
	SetRegObj("Trophies." + asTrophyName,jTrophy)
EndEvent

Function SendTrophyManagerReady()
	DebugTrace("Checking trophies!")
	RegisterForModEvent("vMYC_TrophyRegister","OnTrophyRegister")
	Int iHandle = ModEvent.Create("vMYC_TrophyManagerReady")
	If iHandle
		ModEvent.PushForm(iHandle,Self)
		ModEvent.Send(iHandle)
	Else
		DebugTrace("WARNING! Could not send vMYC_TrophyRegister event!",1)
	EndIf
EndFunction

Function UpdateAvailabilityList()
	DebugTrace("Updating trophy availability...")
	Int jTrophies = GetRegObj("Trophies")
	If !jTrophies
		DebugTrace("WARNING! No trophies found!",1)
	EndIf
	Int jTrophyNames = JMap.AllKeys(jTrophies)
	Int i = JArray.Count(jTrophyNames)
	While i > 0
		i -= 1
		String sTrophyName = JArray.GetStr(jTrophyNames,i)
		If sTrophyName
			vMYC_TrophyBase kTrophy = GetRegForm("Trophies." + sTrophyName + ".Form") as vMYC_TrophyBase
			If kTrophy
				Int iAvailable = kTrophy._IsAvailable()
				DebugTrace("Trophy " + sTrophyName + " reports availability of " + iAvailable)
				SetSessionInt("Trophies." + sTrophyName,iAvailable)
			Else
				DebugTrace("WARNING! Couldn't find form for " + sTrophyName + "!",1)
			EndIf
		EndIf
	EndWhile
EndFunction

ObjectReference Function GetTrophyOrigin()
;FIXME - For now always returns statue marker in vMYC_AlcoveLayout
	Return GetFormFromFile(0x0203051d,"vMYC_MeetYourCharacters.esp") as ObjectReference
EndFunction

ObjectReference Function GetTrophyOffsetOrigin()
;FIXME - For now always returns statue marker in vMYC_AlcoveLayout
	Return GetFormFromFile(0x02031C1E,"vMYC_MeetYourCharacters.esp") as ObjectReference
EndFunction

Function DebugTrace(String sDebugString, Int iSeverity = 0)
	Debug.Trace("MYC/TrophyManager: " + sDebugString,iSeverity)
EndFunction

Form Function GetHangingBannerMarker()
	Return vMYC_TrophyBannerHangingMarker
EndFunction

Form Function GetStandingBannerMarker()
	Return vMYC_TrophyBannerStandingMarker
EndFunction
