Scriptname vMYC_Config Hidden

Function SendConfigEvent(String asPath) Global
	Int iHandle = ModEvent.Create("vMYC_ConfigUpdate")
	If iHandle
		ModEvent.PushString(iHandle,asPath)
		ModEvent.Send(iHandle)
	Else
		Debug.Trace("MYC/Config: Error sending ConfigUpdate event!",1)
	EndIf
EndFunction

Function SendLocalConfigEvent(String asPath) Global
	Int iHandle = ModEvent.Create("vMYC_LocalConfigUpdate")
	If iHandle
		ModEvent.PushString(iHandle,asPath)
		ModEvent.Send(iHandle)
	EndIf
EndFunction

Function InitConfig() Global
	Int jConfigData = CreateConfigDataIfMissing()
	SyncConfig()
EndFunction

Function SyncConfig() Global
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	Int jConfigFileData = JValue.ReadFromFile(JContainers.userDirectory() + "vMYC/vMYC_config.json")
	Int DataSerial = JMap.getInt(jConfigData,"DataSerial")
	Int DataFileSerial = JMap.getInt(jConfigFileData,"DataSerial")
	;Debug.Trace("MYC/Config: SyncConfig called! Our DataSerial is " + DataSerial + ", file DataSerial is " + DataFileSerial)
	If DataSerial > DataFileSerial
		;Debug.Trace("MYC/Config: Our data is newer than the saved file, overwriting it!")
		JValue.WriteToFile(jConfigData,JContainers.userDirectory() + "vMYC/vMYC_config.json")
	ElseIf DataSerial < DataFileSerial
		;Debug.Trace("MYC/Config: Our data is older than the saved file, loading it!")
		JValue.Clear(jConfigData)
		jConfigData = JValue.ReadFromFile(JContainers.userDirectory() + "vMYC/vMYC_config.json")
		JDB.solveObjSetter(".vMYC._ConfigData",jConfigData)
	Else
		;Already synced. Sunc?
	EndIf
EndFunction

Function LoadConfig() Global
	;Debug.Trace("MYC/Config: LoadConfig called!")
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	jConfigData = JValue.ReadFromFile(JContainers.userDirectory() + "vMYC/vMYC_config.json")
EndFunction

Function SaveConfig() Global
	;Debug.Trace("MYC/Config: SaveConfig called!")
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	JMap.setInt(jConfigData,"DataSerial",JMap.getInt(jConfigData,"DataSerial") + 1)
	JValue.WriteToFile(jConfigData,JContainers.userDirectory() + "vMYC/vMYC_config.json")
EndFunction

Int Function CreateConfigDataIfMissing() Global
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	If jConfigData
		JMap.setInt(jConfigData,"DataSerial",JMap.getInt(jConfigData,"DataSerial") + 1)
		Return jConfigData
	EndIf
	Debug.Trace("MYC/Config: First ConfigData access, creating JDB key!")
	Int _jMYC = JDB.solveObj(".vMYC")
	jConfigData = JValue.ReadFromFile(JContainers.userDirectory() + "vMYC/vMYC_config.json")	
	If jConfigData
		Debug.Trace("MYC/Config: Loaded config file!")
	Else
		Debug.Trace("MYC/Config: No config file found, creating new ConfigData data!")
		jConfigData = JMap.Object()
		JMap.setInt(jConfigData,"DataSerial",0)
	EndIf
	JMap.setObj(_jMYC,"_ConfigData",jConfigData)
	Return jConfigData
EndFunction

Bool Function HasConfigKey(String asPath) Global
	Int jConfig = CreateConfigDataIfMissing()
	Return JMap.hasKey(jConfig,asPath)
EndFunction

Function SetConfigStr(String asPath, String asString, Bool abDeferSave = False, Bool abNoEvent = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setStr(jConfig,asPath,asString)
	If !abDeferSave
		SyncConfig()
	EndIf
EndFunction

String Function GetConfigStr(String asPath) Global
	Return JDB.solveStr(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigBool(String asPath, Bool abBool, Bool abDeferSave = False, Bool abNoEvent = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setInt(jConfig,asPath,abBool as Int)
	If !abNoEvent
		SendConfigEvent(asPath)
	EndIf
	If !abDeferSave
		SyncConfig()
	EndIf
EndFunction

Bool Function GetConfigBool(String asPath) Global
	Return JDB.solveInt(".vMYC._ConfigData." + asPath) as Bool
EndFunction

Function SetConfigInt(String asPath, Int aiInt, Bool abDeferSave = False, Bool abNoEvent = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setInt(jConfig,asPath,aiInt)
	If !abNoEvent
		SendConfigEvent(asPath)
	EndIf
	If !abDeferSave
		SyncConfig()
	EndIf
EndFunction

Int Function GetConfigInt(String asPath) Global
	Return JDB.solveInt(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigFlt(String asPath, Float afFloat, Bool abDeferSave = False, Bool abNoEvent = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setFlt(jConfig,asPath,afFloat)
	If !abNoEvent
		SendConfigEvent(asPath)
	EndIf
	If !abDeferSave
		SyncConfig()
	EndIf
EndFunction

Float Function GetConfigFlt(String asPath) Global
	Return JDB.solveFlt(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigForm(String asPath, Form akForm, Bool abDeferSave = False, Bool abNoEvent = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setForm(jConfig,asPath,akForm)
	If !abNoEvent
		SendConfigEvent(asPath)
	EndIf
	If !abDeferSave
		SyncConfig()
	EndIf
EndFunction

Form Function GetConfigForm(String asPath) Global
	Return JDB.solveForm(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigObj(String asPath, Int ajObj, Bool abDeferSave = False, Bool abNoEvent = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setObj(jConfig,asPath,ajObj)
	If !abNoEvent
		SendConfigEvent(asPath)
	EndIf
	If !abDeferSave
		SyncConfig()
	EndIf
EndFunction

Int Function GetConfigObj(String asPath) Global
	Return JDB.solveObj(".vMYC._ConfigData." + asPath)
EndFunction

Int Function CreateLocalConfigDataIfMissing() Global
	Int jLocalConfigData = JDB.solveObj(".vMYC._LocalConfigData")
	If jLocalConfigData
		Return jLocalConfigData
	EndIf
	Debug.Trace("MYC/LocalConfig: First LocalConfigData access, creating JDB key!")
	Int _jMYC = JDB.solveObj(".vMYC")
	jLocalConfigData = JMap.Object()
	JMap.setObj(_jMYC,"_LocalConfigData",jLocalConfigData)
	Return jLocalConfigData
EndFunction

Bool Function HasLocalConfigKey(String asPath) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	Return JMap.hasKey(jLocalConfig,asPath)
EndFunction

Function SetLocalConfigStr(String asPath, String asString) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	JMap.setStr(jLocalConfig,asPath,asString)
EndFunction

String Function GetLocalConfigStr(String asPath) Global
	Return JDB.solveStr(".vMYC._LocalConfigData." + asPath)
EndFunction

Function SetLocalConfigBool(String asPath, Bool abBool) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	JMap.setInt(jLocalConfig,asPath,abBool as Int)
	SendLocalConfigEvent(asPath)
EndFunction

Bool Function GetLocalConfigBool(String asPath) Global
	Return JDB.solveInt(".vMYC._LocalConfigData." + asPath) as Bool
EndFunction

Function SetLocalConfigInt(String asPath, Int aiInt) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	JMap.setInt(jLocalConfig,asPath,aiInt)
	SendLocalConfigEvent(asPath)
EndFunction

Int Function GetLocalConfigInt(String asPath) Global
	Return JDB.solveInt(".vMYC._LocalConfigData." + asPath)
EndFunction

Function SetLocalConfigFlt(String asPath, Float afFloat) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	JMap.setFlt(jLocalConfig,asPath,afFloat)
	SendLocalConfigEvent(asPath)
EndFunction

Float Function GetLocalConfigFlt(String asPath) Global
	Return JDB.solveFlt(".vMYC._LocalConfigData." + asPath)
EndFunction

Function SetLocalConfigForm(String asPath, Form akForm) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	JMap.setForm(jLocalConfig,asPath,akForm)
	SendLocalConfigEvent(asPath)
EndFunction

Form Function GetLocalConfigForm(String asPath) Global
	Return JDB.solveForm(".vMYC._LocalConfigData." + asPath)
EndFunction

Function SetLocalConfigObj(String asPath, Int ajObj) Global
	Int jLocalConfig = CreateLocalConfigDataIfMissing()
	JMap.setObj(jLocalConfig,asPath,ajObj)
	SendLocalConfigEvent(asPath)
EndFunction

Int Function GetLocalConfigObj(String asPath) Global
	Return JDB.solveObj(".vMYC._LocalConfigData." + asPath)
EndFunction

String Function GetUUIDTrue() Global
	Int[] iBytes = New Int[16]
	Int i = 0
	While i < 16
		iBytes[i] = Utility.RandomInt(0,255)
		i += 1
	EndWhile
	Int iVersion = iBytes[6]
	iVersion = Math.LogicalOr(Math.LogicalAnd(iVersion,0x0f),0x40)
	iBytes[6] = iVersion
	Int iVariant = iBytes[8]
	iVariant = Math.LogicalOr(Math.LogicalAnd(iVariant,0x3f),0x80)
	iBytes[8] = iVariant
	String sUUID = ""
	i = 0
	While i < 16
		If iBytes[i] < 16
			sUUID += "0"
		EndIf
		sUUID += GetHexString(iBytes[i])
		If i == 3 || i == 5 || i == 7 || i == 9
			sUUID += "-"
		EndIf
		i += 1
	EndWhile
	Return sUUID
EndFunction

String Function GetUUIDFast() Global
	String sUUID = ""
	sUUID += GetHexString(Utility.RandomInt(0,0xffff),4) + GetHexString(Utility.RandomInt(0,0xffff),4)
	sUUID += "-"
	sUUID += GetHexString(Utility.RandomInt(0,0xffff),4)
	sUUID += "-"
	sUUID += GetHexString(Math.LogicalOr(Math.LogicalAnd(Utility.RandomInt(0,0xffff),0x0fff),0x4000)) ; version
	sUUID += "-"
	sUUID += GetHexString(Math.LogicalOr(Math.LogicalAnd(Utility.RandomInt(0,0xffff),0x3fff),0x8000)) ; variant
	sUUID += "-"
	sUUID += GetHexString(Utility.RandomInt(0,0xffffff),6) + GetHexString(Utility.RandomInt(0,0xffffff),6)
	Return sUUID
EndFunction

String Function GetHexString(Int iDec, Int iPadLength = 0) Global
	If iDec < 0
		Return ""
	ElseIf iDec == 0
		Return "0"
	EndIf
	String[] sHexT = New String[6]
	sHexT[0] = "a"
	sHexT[1] = "b"
	sHexT[2] = "c"
	sHexT[3] = "d"
	sHexT[4] = "e"
	sHexT[5] = "f"
	String sHex = ""
	If iDec > 15
		sHex += GetHexString(iDec / 16)
		sHex += GetHexString(iDec % 16)
	ElseIf iDec > 9
		sHex = sHexT[iDec - 10]
	ElseIf iDec 
		sHex = iDec
	Else
		sHex = "0"
	EndIf
	If iPadLength
		Int iHexLen = StringUtil.GetLength(sHex)
		If iHexLen < iPadLength
			sHex = StringUtil.Substring("0000000000000000",0,iPadLength - iHexLen) + sHex
		EndIf
	EndIf
	Return sHex
EndFunction
