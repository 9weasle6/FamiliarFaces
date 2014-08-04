Scriptname vMYC_Config Hidden

Function SetConfigDefaults() Global
	Debug.Trace("MYC/Config: Setting defaults!")
	SetConfigInt("MagicAllowHealing",True as Int)
	SetConfigInt("MagicAllowDefensive",True as Int)
EndFunction

Function SendConfigEvent(String asPath) Global
	Int iHandle = ModEvent.Create("vMYC_ConfigUpdate")
	If iHandle
		ModEvent.PushString(iHandle,asPath)
		ModEvent.Send(iHandle)
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
	Int jConfigFileData = JValue.ReadFromFile("Data/vMYC/vMYC_config.json")
	Int DataSerial = JMap.getInt(jConfigData,"DataSerial")
	Int DataFileSerial = JMap.getInt(jConfigFileData,"DataSerial")
	If DataSerial > DataFileSerial
		Debug.Trace("MYC/Config: Our data is newer than the saved file, overwriting it!")
		JValue.WriteToFile(jConfigData,"Data/vMYC/vMYC_config.json")
	ElseIf DataSerial < DataFileSerial
		Debug.Trace("MYC/Config: Our data is older than the saved file, loading it!")
		JConfigData = JValue.ReadFromFile("Data/vMYC/vMYC_config.json")
	Else
		;Already synced. Sunc?
	EndIf
EndFunction

Function LoadConfig() Global
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	jConfigData = JValue.ReadFromFile("Data/vMYC/vMYC_config.json")
EndFunction

Function SaveConfig() Global
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	JMap.setInt(jConfigData,"DataSerial",JMap.getInt(jConfigData,"DataSerial") + 1)
	JValue.WriteToFile(jConfigData,"Data/vMYC/vMYC_config.json")
EndFunction

Int Function CreateConfigDataIfMissing() Global
	Int jConfigData = JDB.solveObj(".vMYC._ConfigData")
	If jConfigData
		Return jConfigData
	EndIf
	Debug.Trace("MYC/Config: First ConfigData access, creating JDB key!")
	Int _jMYC = JDB.solveObj(".vMYC")
	jConfigData = JValue.ReadFromFile("Data/vMYC/vMYC_config.json")	
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

Function SetConfigStr(String asPath, String asString, Bool abDeferSave = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setStr(jConfig,asPath,asString)
	If !abDeferSave
		SaveConfig()
	EndIf
EndFunction

String Function GetConfigStr(String asPath) Global
	Return JDB.solveStr(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigInt(String asPath, Int aiInt, Bool abDeferSave = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setInt(jConfig,asPath,aiInt)
	SendConfigEvent(asPath)
	If !abDeferSave
		SaveConfig()
	EndIf
EndFunction

Int Function GetConfigInt(String asPath) Global
	Return JDB.solveInt(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigFlt(String asPath, Float afFloat, Bool abDeferSave = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setFlt(jConfig,asPath,afFloat)
	SendConfigEvent(asPath)
	If !abDeferSave
		SaveConfig()
	EndIf
EndFunction

Float Function GetConfigFlt(String asPath) Global
	Return JDB.solveFlt(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigForm(String asPath, Form akForm, Bool abDeferSave = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setForm(jConfig,asPath,akForm)
	SendConfigEvent(asPath)
	If !abDeferSave
		SaveConfig()
	EndIf
EndFunction

Form Function GetConfigForm(String asPath) Global
	Return JDB.solveForm(".vMYC._ConfigData." + asPath)
EndFunction

Function SetConfigObj(String asPath, Int ajObj, Bool abDeferSave = False) Global
	Int jConfig = CreateConfigDataIfMissing()
	JMap.setObj(jConfig,asPath,ajObj)
	SendConfigEvent(asPath)
	If !abDeferSave
		SaveConfig()
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
