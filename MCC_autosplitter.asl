//Halo: The Master Chief Collection Autosplitter
//by Burnt


//TODO;
//add poscheck for backtrack levels (just do tgj for now) DONE
//check loop mode works on reach
//fix h2 dying in cutscenes


state("MCC-Win64-Shipping") {}
state("MCC-Win64-Shipping-WinStore") {} 

init //hooking to game to make memorywatchers
{ 
	
	//need to clear h2 pause flags incase of restart/crash
	vars.ending01a = false;
	vars.ending01b = false;
	vars.ending03a = false;
	vars.ending03b = false;
	vars.ending04a = false;
	vars.ending04b = false; 
	vars.ending05a = false;
	vars.ending05b = false;
	vars.ending06a = false;
	vars.ending06b = false;
	vars.ending07a = false;
	vars.ending08a = false;
	vars.ending07b = false;
	
	
	
	//version check and warning message for invalid version  
	switch(modules.First().FileVersionInfo.FileVersion)
	{
		
		case "1.1716.0.0": 
		version = "1.1716.0.0";
		break;
		
		case "1.1829.0.0": 
		version = "1.1829.0.0";
		break;
		
		case "1.1864.0.0":
		version = "1.1864.0.0";
		break;
		
		default: 
		version = "1.1864.0.0";
		if (vars.brokenupdateshowed == false)
		{
			vars.brokenupdateshowed = true;
			var brokenupdateMessage = MessageBox.Show(
				"It looks like MCC has recieved a new patch that will "+
				"probably break me (the autosplitter). \n"+
				"Autosplitter was made for version: "+ "1.1864.0.0" + "\n" + 
				"Current detected version: "+ modules.First().FileVersionInfo.FileVersion + "\n" +
				"If I'm broken, you'll just have to wait for Burnt to update me. "+
				"You won't need to do anything except restart Livesplit once I'm updated.",
				vars.aslName+" | LiveSplit",
				MessageBoxButtons.OK 
			);
			
		}
		break;
	}
	
	//STATE init
	// STEAM !!!!!!!!!!!!!!!!!!!! 
	if (modules.First().ToString() == "MCC-Win64-Shipping.exe")
	{
		
		if (version == "1.1829.0.0" || version == "1.1864.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x37CFCD8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //behaviour changed to 07 and 0B, instead of 07 and 0C
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x38FCAF9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x038F5A00, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x038DFE90, 0x8, 0x2A6B00C), 3)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x038DFE90, 0x28, 0xE342C3), 3)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x038DFE90, 0x48, 0xB94513B), 3)), 
				(vars.HR_levelname = new StringWatcher(new DeepPointer(0x038DFE90, 0xC8, 0x28478D7), 3)),
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(0x038DFE90, 0xA8, 0xA942E25), 4))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0x8, 0x2b21e24)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x8, 0x19edc1c)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x038DFE90, 0x8, 0x2bb98c0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x038DFE90, 0x8, 0x2A76848)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x038DFE90, 0x8, 0x2A7684C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038DFE90, 0x8, 0x2a6afd7)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x8, 0x02BB9D70, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0x28, 0x64FCC14)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x28, 0x13b8e80)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x28, 0x06B9B5F0, 0x38, 0x78, 0x1E8, 0xE8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x28, 0xcd5d74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(0x038DFE90, 0x28, 0xD77278)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(0x038DFE90, 0x28, 0xD7727C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0x28, 0xdf3250)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038DFE90, 0x28, 0x00D776E0, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x28, 0x67AFCA2)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0x48, 0xBA7AE40)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
				//(vars.H3_validtimeflag = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x48, 0xD64296)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //not using anymore
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x038DFE90, 0x48, 0x00B884E0, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0x48, 0xB95D60)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038DFE90, 0x48, 0x00939028, 0xFC0D)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H3_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0x48, 0xB95D70)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_IGT = new MemoryWatcher<uint> (new DeepPointer(0x038DFE90, 0xC8, 0x00C57168, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_validtimeflag = new MemoryWatcher<byte> (new DeepPointer(0x038DFE90, 0xC8, 0x01163A88, 0x12E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0xC8, 0x3721CF0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038DFE90, 0xC8, 0x01163A88, 0x543A39)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0xC8, 0x00DA1C20, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.odst_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0xA8, 0xC8E00A8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.odst_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x038DFE90, 0xA8, 0xCCD73A0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstIL = new MemoryWatcherList() {
				(vars.odst_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038DFE90, 0xA8, 0xA876FF0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.odst_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038DFE90, 0xA8, 0x0AD4339C, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.odst_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038DFE90, 0xA8, 0x00B85020, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
		}else if (version == "1.1716.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x37BF358)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //behaviour changed to 07 and 0B, instead of 07 and 0C
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x38EBCC9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x038E4BD0, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x038CF520, 0x8, 0x115C90C), 3)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x038CF520, 0x28, 0xE33303), 3)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x038CF520, 0x48, 0xA90A4B), 3)), 
				(vars.HR_levelname = new StringWatcher(new DeepPointer(0x038CF520, 0xC8, 0x2AA3277), 3)),
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(0x0), 4))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038CF520, 0x8, 0x1FA9094)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x8, 0x10CF45C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x038CF520, 0x8, 0x224BCA0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x038CF520, 0x8, 0x2199F08)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x038CF520, 0x8, 0x2199F0C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038CF520, 0x8, 0x115C8D7)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x8, 0x0224C130, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038CF520, 0x28, 0x64FBC54)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x28, 0x13B7EC0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x28, 0x06B9A3F0, 0x38, 0x78, 0x1F0, 0x74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x28, 0xCD4D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(0x038CF520, 0x28, 0xD762B8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(0x038CF520, 0x28, 0xD762BC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038CF520, 0x28, 0xDF2290)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038CF520, 0x28, 0x00D766F0, -0x23A3)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x28, 0x67AEAC2)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x038CF520, 0x48, 0xBC56D0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
				//(vars.H3_validtimeflag = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x48, 0xD64296)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //not using anymore
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x038CF520, 0x48, 0xC37094)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038CF520, 0x48, 0xE62410)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038CF520, 0x48, 0x0BE6CB1C, -0x29D3EF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H3_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x48, 0x00E33BC0, 0x24)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_IGT = new MemoryWatcher<uint> (new DeepPointer(0x038CF520, 0xC8, 0x02506158, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_validtimeflag = new MemoryWatcher<byte> (new DeepPointer(0x038CF520, 0xC8, 0x010CC008, 0x12E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(0x038CF520, 0xC8, 0x38C87F0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x038CF520, 0xC8, 0x010CC008, 0x543A39)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0xC8, 0x00D0A1A0, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.odst_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.odst_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstIL = new MemoryWatcherList() {
				(vars.odst_IGT = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.odst_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.odst_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			
		} 
		
		
		
		
		// WINSTORE !!!!!!!!!!!!!!!!!!!!
	} else if (modules.First().ToString() == "MCC-Win64-Shipping-WinStore.exe")
	{
		
		if (version == "1.1829.0.0" || version == "1.1864.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3681BD8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //behaviour changed to 07 and 0B, instead of 07 and 0C
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x37AE859)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x037A7988, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x03791DA0, 0x8, 0x2A6B00C), 3)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x03791DA0, 0x28, 0xE342C3), 3)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x03791DA0, 0x48, 0xB94513B), 3)), 
				(vars.HR_levelname = new StringWatcher(new DeepPointer(0x03791DA0, 0xC8, 0x28478D7), 3)),
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(0x03791DA0, 0xA8, 0xA942E25), 4))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0x8, 0x2b21e24)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x8, 0x19edc1c)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x03791DA0, 0x8, 0x2bb98c0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x03791DA0, 0x8, 0x2A76848)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x03791DA0, 0x8, 0x2A7684C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03791DA0, 0x8, 0x2a6afd7)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x8, 0x02BB9D70, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0x28, 0x64FCC14)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x28, 0x13b8e80)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x28, 0x06B9B5F0, 0x38, 0x78, 0x1E8, 0xE8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x28, 0xcd5d74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(0x03791DA0, 0x28, 0xD77278)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(0x03791DA0, 0x28, 0xD7727C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0x28, 0xdf3250)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03791DA0, 0x28, 0x00D776E0, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x28, 0x67AFCA2)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0x48, 0xBA7AE40)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
				//(vars.H3_validtimeflag = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0x48, 0xD64296)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //not using anymore
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x03791DA0, 0x48, 0x00B884E0, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0x48, 0xB95D60)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03791DA0, 0x48, 0x00939028, 0xFC0D)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H3_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0x48, 0xB95D70)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_IGT = new MemoryWatcher<uint> (new DeepPointer(0x03791DA0, 0xC8, 0x00C57168, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_validtimeflag = new MemoryWatcher<byte> (new DeepPointer(0x03791DA0, 0xC8, 0x01163A88, 0x12E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0xC8, 0x3721CF0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03791DA0, 0xC8, 0x01163A88, 0x543A39)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0xC8, 0x00DA1C20, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.odst_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0xA8, 0xC8E00A8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.odst_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x03791DA0, 0xA8, 0xCCD73A0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstIL = new MemoryWatcherList() {
				(vars.odst_IGT = new MemoryWatcher<uint>(new DeepPointer(0x03791DA0, 0xA8, 0xA876FF0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.odst_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03791DA0, 0xA8, 0x0AD4339C, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.odst_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03791DA0, 0xA8, 0x00B85020, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
		}else if (version == "1.1716.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3670258)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //behaviour changed to 07 and 0B, instead of 07 and 0C
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x379CA19)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x03795B48, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x03780430, 0x8, 0x115C90C), 3)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x03780430, 0x28, 0xE33303), 3)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x03780430, 0x48, 0xA90A4B), 3)), 
				(vars.HR_levelname = new StringWatcher(new DeepPointer(0x03780430, 0xC8, 0x2AA3277), 3)),
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(0x0), 4))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x03780430, 0x8, 0x1FA9094)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x8, 0x10CF45C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x03780430, 0x8, 0x224BCA0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x03780430, 0x8, 0x2199F08)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x03780430, 0x8, 0x2199F0C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03780430, 0x8, 0x115C8D7)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x8, 0x0224C130, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x03780430, 0x28, 0x64FBC54)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x28, 0x13B7EC0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x28, 0x06B9A3F0, 0x38, 0x78, 0x1F0, 0x74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x28, 0xCD4D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(0x03780430, 0x28, 0xD762B8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(0x03780430, 0x28, 0xD762BC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x03780430, 0x28, 0xDF2290)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03780430, 0x28, 0x00D766F0, -0x23A3)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x28, 0x67AEAC2)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x03780430, 0x48, 0xBC56D0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
				//(vars.H3_validtimeflag = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x48, 0xD64296)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //not using anymore
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x03780430, 0x48, 0xC37094)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x03780430, 0x48, 0xE62410)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03780430, 0x48, 0x0BE6CB1C, -0x29D3EF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H3_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x03780430, 0x48, 0x00E33BC0, 0x24)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_IGT = new MemoryWatcher<uint> (new DeepPointer(0x03780430, 0xC8, 0x02506158, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_validtimeflag = new MemoryWatcher<byte> (new DeepPointer(0x03780430, 0xC8, 0x010CC008, 0x12E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(0x03780430, 0xC8, 0x38C87F0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x03780430, 0xC8, 0x010CC008, 0x543A39)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x038CF520, 0xC8, 0x00D0A1A0, 0x422)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.odst_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.odst_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstIL = new MemoryWatcherList() {
				(vars.odst_IGT = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.odst_deathflag = new MemoryWatcher<bool>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.odst_revertcount = new MemoryWatcher<byte>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			
		} 
	}
	
	
	
}


startup //variable init and settings
{ 
	
	
	
	//MOVED VARIABLE INIT TO STARTUP TO PREVENT BUGS WHEN RESTARTING (/CRASHING) MCC MID RUN
	
	//GENERAL inits
	vars.secondreset = true;
	vars.loopcount = 0;
	vars.dirtybsps_byte = new List<byte>();
	vars.dirtybsps_int = new List<uint>();
	vars.dirtybsps_long = new List<ulong>();
	vars.h3times = 0;
	vars.odsttimes = 0;
	vars.startedlevel = "000";
	vars.varsreset = false;
	vars.loopsplit = true;
	vars.h2times = 0;
	vars.brokenupdateshowed = false;
	vars.multigamepauseflag = false;
	
	
	//HALO 1
	vars.splitbsp_a10 = new byte[6] { 1, 2, 3, 4, 5, 6 };
	vars.splitbsp_a30 = new byte[1] { 1 };
	vars.splitbsp_a50 = new byte[3] { 1, 2, 3 };
	vars.splitbsp_b30 = new byte[1] { 1 };
	vars.splitbsp_b40 = new byte[4] { 0, 1, 10, 2};
	vars.splitbsp_c10 = new byte[4] { 1, 3, 4, 5};
	vars.splitbsp_c20 = new byte[3] { 1, 2, 3};
	vars.splitbsp_c40 = new byte[8] { 12, 10, 1, 9, 8, 6, 0, 5 };
	vars.splitbsp_d20 = new byte[2] { 4, 3 };
	vars.splitbsp_d40 = new byte[7] { 1, 2, 3, 4, 5, 6, 7 };
	vars.poasplit = false;
	vars.mawsplit = false;
	
	//HALO 2
	vars.splitbsp_01b = new byte[3] { 2, 0, 3 }; //cairo
	vars.splitbsp_03a = new byte[2] { 1, 2 }; //os
	vars.splitbsp_03b = new byte[1] { 1 }; //metro
	vars.splitbsp_04a = new byte[2] { 3, 0 }; //arby - 2, 0, 4, and 1 are using in cs 
	vars.splitbsp_04b = new byte[4] { 0, 2, 1, 5 }; //here - 0 in cs, 3 at start, returns to 0 later gah - maybe skip the 4 split cos it's just for like 10s when cables cut
	vars.splitbsp_05a = new byte[1] { 1 }; //dh - flahses between 2 and 0 in cs
	vars.splitbsp_05b = new byte[2] { 1, 2 }; //reg - 0 in cs. skipping 3 & 4 since it's autoscroller
	vars.splitbsp_06a = new byte[2] { 1, 2 }; //si - 0 then 3 in cs, starts on 0
	vars.splitbsp_06b = new byte[3] { 1, 2, 3 }; //qz- there are more besides this but all during autoscroller
	vars.splitbsp_07a = new byte[5] { 1, 2, 3, 4, 5 }; //gm - 7 & 0 in cs
	vars.splitbsp_08a = new byte[2] { 1, 0 }; //up -- hits 0 again after 1. ignoring skipable
	vars.splitbsp_07b = new byte[3] { 1, 2, 4 }; //HC -- none if doing HC skip
	vars.splitbsp_08b = new byte[3] { 0, 1, 3 }; //TGJ -- starts 0 and in cs, then goes to 1, then 0, then 1, then 0, then 3 (skipping 2 cos it's skippable)
	//so tgjs actual count is 5
	
	
	
	vars.ending01a = false;
	vars.ending01b = false;
	vars.ending03a = false;
	vars.ending03b = false;
	vars.ending04a = false;
	vars.ending04b = false;
	vars.ending05a = false;
	vars.ending05b = false;
	vars.ending06a = false;
	vars.ending06b = false;
	vars.ending07a = false;
	vars.ending08a = false;
	vars.ending07b = false;
	vars.armorysplit = false;
	
	//delays unpausing at start of levels to match the late pausing at the end of levels
	//10 ticks for the initial check, then adjustment factor per level (from measurements)
	vars.adjust01b = 10 + 113;
	vars.adjust03a = 10 + 46;
	vars.adjust03b = 10 + 22;
	vars.adjust04a = 10 + 85;
	vars.adjust04b = 10 + 48;
	vars.adjust05a = 10 + 85;
	vars.adjust05b = 10 + 32;
	vars.adjust06a = 10 + 23;
	vars.adjust06b = 10 + 29;
	vars.adjust07a = 10 + 29;
	vars.adjust08a = 10 + 32;
	vars.adjust07b = 10 + 67;
	vars.adjust08b = 10 + 109;
	
	//HALO 3
	vars.splitbsp_010 = new ulong[8] { 7, 4111, 4127, 8589938751, 12884907135, 4294972543, 4294972927, 6143}; //sierra
	vars.splitbsp_040 = new ulong[8] { 70746701299715, 76347338653703, 5987184410895, 43920335569183, 52712133624127, 4449586119039, 110002702385663, 127560528691711 }; //storm 
	vars.splitbsp_070 = new ulong[9] { 319187993615142919, 497073530286903311, 5109160733019475999, 7059113264503853119, 7058267740062093439, 5296235395170702591, 6467180094380056063, 6471685893030682623, 6453663797939806207 }; //ark
	vars.splitbsp_100 = new ulong[11] { 4508347378708774919, 2060429875000377375, 4384271889560765215, 2060429875000378143, 4508347378708775711, 4229124150272197439, 4105313024951190527, 4159567262287660031, 4153434048988972031, 4099400491367139327, 21673629041340192 }; //cov
	vars.splitbsp_120 = new ulong[6] { 1030792151055, 691489734703, 1924145349759, 1133871367679, 1202590844927, 1219770714111 }; //halo
	
	//new levels
	vars.splitbsp_020 = new ulong[10] { 2753726871765283, 351925325267239, 527984624664871, 527980329698111, 355107896034111, 495845384389503, 1058778157941759, 2081384101315583, 2076028277097471, 2043042928264191}; //crows nest
	vars.splitbsp_030 = new ulong[5] { 708669603847, 1812476198927, 1709396983839, 128849018943, 2327872274495}; //tsavo
	vars.splitbsp_050 = new ulong[7] { 137438953607, 154618822791, 167503724703, 98784247967, 98784247999, 133143986431, 111669150207}; //floodgate
	vars.splitbsp_110 = new ulong[4] { 4294967459, 4294967527, 4294967535, 4294967551}; //cortana
	
	vars.sierrasplit = false;
	vars.addtimes = false;
	vars.splith3 = false;
	
	//HALO REACH
	vars.hrtimes = 0;
	vars.wcsplit = false;
	
	vars.splitbsp_m10 = new uint[4] { 143, 175, 239, 495 }; // WC
	vars.splitbsp_m20 = new uint[4] { 249, 505, 509, 511 }; // oni
	vars.splitbsp_m30 = new uint[6] { 269, 781, 797, 1821, 1853, 1917 }; // nightfall
	vars.splitbsp_m35 = new uint[5] { 4111, 4127, 4223, 4607, 5119 }; //tots
	vars.splitbsp_m45 = new uint[6] { 31, 383, 10111, 12159, 16255, 32639 }; //lnos, might have to swap 895 for 10111 since former is cs only. 127 is cs only too, swap for 383?
	vars.splitbsp_m50 = new uint[5] { 5135, 5151, 5247, 5631, 8191 }; //exo
	//skipping NA
	vars.splitbsp_m60 = new uint[5] { 113, 125, 4221, 4223, 5119 }; //package
	vars.splitbsp_m70 = new uint[7] { 31, 63, 127, 255, 511, 1023, 2047 }; //poa
	
	
	//HALO ODST
	vars.ptdsplit = false;
	vars.splitodst = false;
	vars.ptdremoval = 0;
	
	//streets
	vars.splitbsp_h100 = new ulong[9] { 1271310319912, 1511828488552, //drone optic
		1511828488544, 1305670058352, 1717986918896, 3848290698224, //guass turret
		1125281431814, //remote det (actually goes to sniper)
		1666447311756, //sniper rifle (actually goes to guass turret)
		1112396529931
		//no loads on pre data hive
	};//end streets
	//hopefully no 1236950581544, it shows up on drone optic without actual bsp load
	//1374389535040, 1168231104880 shows up on guass turret
	//1116691497220 shows up on remote det
	//3848290698120 shows up on .. first bsp load doesn't show up on my bytes, so gonna have to skip that one
	//1108101562634 more bad vals
	//1103806595337 more
	//no bsp loads on ptd
	
	vars.splitbsp_sc10 = new ulong[3] { 60129542158, 55834574863, 38654705679 }; //tayari
	
	
	vars.splitbsp_sc11 = new ulong[3] { 339302416463, 395136991327, 412316860543 }; //uplift reserve
	//first load has issue of being used in cutscene - add check for pgcr time being > 30 or something
	
	vars.splitbsp_sc13 = new ulong[2] { 47244640267,  30064771087}; //oni
	//bad vals 38654705673
	//12884901899 is a a valid bsp bsp load but i've removed it since it doesn't save time to compare to
	
	vars.splitbsp_sc12 = new ulong[3] { 47244640267, 60129542159, 51539607567 }; //kizingo
	//bad vals 38654705673, 42949672971
	
	vars.splitbsp_sc14 = new ulong[3] { 47244640267, 60129542159, 51539607567}; //NMPD
	//bad vals 38654705673
	//yes the vals are the same as kizongo
	
	vars.splitbsp_sc15 = new ulong[3] { 60129542159, 120259084319, 103079215135 }; //kikowani
	//bad vals 4294967297, 25769803783
	
	vars.splitbsp_l200 = new ulong[7] { 60129542159, 120259084319, 103079215135, 206158430271, 893353197823, 962072674559, 1786706395647}; //data hive
	//30064771079, 30064771072, 824633721087
	
	vars.splitbsp_l300  = new ulong[1] { 141733920935 }; //coastal
	//575525617798, 176093659311 (valid bsp but no timesave), 171798692015, 240518168767(valid but no timesave), 206158430399, 481036337407
	
	
	vars.aslName = "MCCsplitter";
	if(timer.CurrentTimingMethod == TimingMethod.RealTime){
		
		var timingMessage = MessageBox.Show(
			"This game uses Game Time (time without loads) as the main timing method. "+
			"LiveSplit is currently set to show Real Time (time INCLUDING loads). "+
			"Would you like the timing method to be set to Game Time for you?",
			vars.aslName+" | LiveSplit",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		if (timingMessage == DialogResult.Yes)
		timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
	
	
	settings.Add("ILmode", false, "Individual Level mode");
	settings.SetToolTip("ILmode", "Makes the timer start, reset and ending split at the correct IL time for each level. For H2/H3, switches timing to PGCR timer.");
	
	settings.Add("Loopmode", false, "Level Loop mode", "ILmode");
	settings.SetToolTip("Loopmode", "For TBx10 (or similiar memes). Disables resets, and adds a split each time you get to the start of the level the run started on. \n" +
		"So for TBx10, you would want 19 splits (10 level ends and 9 level starts in between them)."
		
	);
	
	settings.Add("bspmode", false, "Split on unique \"Loading... Done\"'s ");
	settings.SetToolTip("bspmode", "Split on unique bsp loads (\"Loading... Done\") within levels. \n" +
		"You'll need to add a lot of extra splits for this option, see this spreadsheet for a count of how many per level of each game: \n" +
		"tinyurl.com/bspsplit"
	);
	
	settings.Add("bsp_cache", false, "Split on non-unique loads too", "bspmode");
	settings.SetToolTip("bsp_cache", "With this disabled, only the first time you enter a specific bsp will cause a split. \n" +
		"This is so that if you hit a load, then die and revert to before the load, and hit again, you won't get duplicate splits. \n" +
		"You probably shouldn't turn this on, unless you're say, practicing a specific segment of a level (from one load to another)."
	);
	
	
	settings.Add("multigame", false, "Multi-game run (eg trilogy run)");
	settings.SetToolTip("multigame", "Changes all timing to use RTA minus loads");
	settings.Add("multigamesplit", true, "Add split at start of first level of each game", "multigame");
	settings.Add("multigamepause", false, "Pause time inbetween game end -> game start", "multigame");
	
	
	settings.Add("counters", false, "Counters and fun stuff");
	
	settings.Add("deathcounter", false, "Enable Death Counter", "counters");
	settings.SetToolTip("deathcounter", "Will automatically create a layout component for you. Feel free \n" +
		"to move it around, but you won't be able to rename it"
	);
	settings.Add("revertcounter", false, "Enable Revert Counter", "counters");
	settings.SetToolTip("revertcounter", "Will automatically create a layout component for you. Feel free \n" +
		"to move it around, but you won't be able to rename it \n" +
		"N.B. In some games, restarting level counts as a revert."
	);
	settings.Add("revertcounterdeaths", false, "Include deaths", "revertcounter");
	settings.SetToolTip("revertcounterdeaths", "Makes dying also count as a revert"
	);
	

	
	
	//DEATH COUNTERS AND FUN
	
	//DEATHS
	vars.TextDeathCounter     = null;
	vars.DeathCounter         = 0;
	vars.UpdateDeathCounter = (Action)(() => {
		if(vars.TextDeathCounter == null) {
			foreach (dynamic component in timer.Layout.Components) {
				if (component.GetType().Name != "TextComponent") continue;
				
				if (component.Settings.Text1 == "Deaths:"){
					vars.TextDeathCounter = component.Settings;
					break;
				}
			}
			if(vars.TextDeathCounter == null) {
                vars.TextDeathCounter = vars.CreateTextComponent("Deaths:");
			}
		}
		
        vars.TextDeathCounter.Text2 = vars.DeathCounter.ToString();
	});
	
	//REVERTS
	vars.TextRevertCounter     = null;
	vars.RevertCounter         = 0;
	vars.UpdateRevertCounter = (Action)(() => {
		if(vars.TextRevertCounter == null) {
			foreach (dynamic component in timer.Layout.Components) {
				if (component.GetType().Name != "TextComponent") continue;
				
				if (component.Settings.Text1 == "Reverts:"){
					vars.TextRevertCounter = component.Settings;
					break;
				}
			}
			if(vars.TextRevertCounter == null) {
				vars.TextRevertCounter = vars.CreateTextComponent("Reverts:");
			}
		}
		
        vars.TextRevertCounter.Text2 = vars.RevertCounter.ToString();
	}); 
	
	
	
	
	vars.CreateTextComponent = (Func<string, dynamic>)((name) => {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        dynamic textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
        textComponent.Settings.Text1 = name;
        return textComponent.Settings;
	}); 
	
	
	
	
} 


update {
	vars.watchers_fast.UpdateAll(game);
	if (vars.loopcount == 60)
	{
		vars.watchers_slow.UpdateAll(game);
		vars.loopcount = 0;
	} else
	{
		++vars.loopcount;
	}
	
	
	if (vars.menuindicator.Current == 7)
	{
		byte test = vars.gameindicator.Current;
		switch (test)
		{
			
			case 0:
			vars.watchers_h1.UpdateAll(game);
			
			if (settings["deathcounter"] || settings["revertcounter"])
			{vars.watchers_h1death.UpdateAll(game); }
			break;
			
			case 1:
			vars.watchers_h2.UpdateAll(game);
			if (settings["deathcounter"] || settings["revertcounter"])
			{vars.watchers_h2death.UpdateAll(game); }
			if (settings["bspmode"])
			{ vars.watchers_h2bsp.UpdateAll(game); }
			if (settings["ILmode"])
			{ vars.watchers_h2IL.UpdateAll(game); }
			break;
			
			case 2:
			if (settings["deathcounter"] || settings["revertcounter"])
			{vars.watchers_h3death.UpdateAll(game); }
			if (settings["bspmode"])
			{ vars.watchers_h3bsp.UpdateAll(game); }
			if (settings["ILmode"])
			{ vars.watchers_h3IL.UpdateAll(game); }
			else 
			{ vars.watchers_h3.UpdateAll(game); }
			break;
			
			case 5:
			vars.watchers_odstbsp.UpdateAll(game); 
			if (settings["deathcounter"] || settings["revertcounter"])
			{vars.watchers_odstdeath.UpdateAll(game); }
			if (settings["ILmode"])
			{ vars.watchers_odstIL.UpdateAll(game); }
			else 
			{ vars.watchers_odst.UpdateAll(game); }
			break;
			
			case 6: 
			vars.watchers_hr.UpdateAll(game);	
			if (settings["deathcounter"] || settings["revertcounter"])
			{vars.watchers_hrdeath.UpdateAll(game); }
			if (settings["bspmode"])
			{ vars.watchers_hrbsp.UpdateAll(game); }
			break;
			
			
			
		}
	}
}





start 	//starts timer
{	
	
	
	vars.varsreset = false;
	string checklevel; 
	
	if (vars.secondreset == true) 
	{
		vars.ptdremoval = 0;
		vars.lasth3mgsplit = 0;
		vars.lastodstmgsplit = 0;
		vars.startedlevel = "000";
		vars.DeathCounter = 0;
		vars.RevertCounter = 0;
		if (settings["deathcounter"])
		vars.UpdateDeathCounter();
		
		if (settings["revertcounter"])
		vars.UpdateRevertCounter();
		
		
		vars.secondreset = false;
		
		print("What about second varsreset? Elevensies? Luncheon? Afternoon tea?");
	}
	
	
	if (vars.menuindicator.Current == 7) 
	{
		byte test = vars.gameindicator.Current;
		switch (test)
		{
			
			case 0:
			if (settings["ILmode"])
			{
				checklevel = vars.H1_levelname.Current;
				
				switch (checklevel)
				{
					case "a10":
					if (vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "a30":
					if (vars.H1_tickcounter.Current == 183)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "a50":
					if (vars.H1_tickcounter.Current == 850)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "b30":
					if (vars.H1_tickcounter.Current == 1093)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "b40":
					if (vars.H1_tickcounter.Current == 966)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "c10":
					if (vars.H1_tickcounter.Current == 717)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "c20":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "c40":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "d20":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
					case "d40":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.startedlevel = checklevel;
						vars.varsreset = false;
						return true;
					}
					break;
					
				}
				
			} else if (vars.H1_levelname.Current == "a10" && vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
			{
				vars.startedlevel = "a10";
				vars.varsreset = false;
				return true;
			}
			break;
			
			case 1:
			if (settings["ILmode"] && vars.H2_IGT.Current > 10 && vars.H2_IGT.Current < 30)
			{
				vars.startedlevel = vars.H2_levelname.Current;
				vars.varsreset = false;
				return true;
			} else if (vars.H2_levelname.Current == "01b" && vars.H2_CSind.Current != 0xD9 && vars.H2_tickcounter.Current > vars.adjust01b && vars.stateindicator.Current != 44 && vars.H2_tickcounter.Current < (vars.adjust01b + 30)) //start on cairo
			{
				vars.startedlevel = "01b";
				vars.varsreset = false;
				return true;
			} else if (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current > 26 &&  vars.H2_tickcounter.Current < 30) //start on armory
			{
				vars.startedlevel = "01a";
				vars.varsreset = false;
				return true;
			}
			break;
			
			case 2:
			if (settings["ILmode"] && vars.H3_IGT.Current > 10 && vars.H3_IGT.Current < 30)
			{
				vars.startedlevel = vars.H3_levelname.Current;
				vars.varsreset = false;
				return true;
			} else if (vars.H3_levelname.Current == "010" && vars.H3_theatertime.Current > 15 && vars.H3_theatertime.Current < 30)
			{
				vars.startedlevel = "010";
				vars.varsreset = false;
				return true;
			}
			break;
			
			case 5: //ODST
			if (settings["ILmode"] && vars.odst_IGT.Current > 10 && vars.odst_IGT.Current < 30)
			{
				vars.startedlevel = vars.ODST_levelname.Current;
				vars.varsreset = false;
				return true;
			} else if (vars.ODST_levelname.Current == "c100" && vars.odst_theatertime.Current > 15 && vars.odst_theatertime.Current < 30 && vars.odst_bspstate.Current != 12884901891)
			{
				vars.startedlevel = "c100";
				vars.varsreset = false;
				return true;
			}
			break;
			
			case 6:
			if ((settings["ILmode"] || vars.HR_levelname.Current == "m10")  && vars.HR_IGT.Current > 10 && vars.HR_IGT.Current < 30)
			{
				print ("what");
				print ("eee: " + vars.HR_IGT.Current);
				print ("aaa: " + vars.HR_levelname.Current);
				vars.startedlevel = vars.HR_levelname.Current;
				vars.varsreset = false;
				return true;
			}
			break;
		}
	}
	
	
}



split
{ 
	byte test = vars.gameindicator.Current;
	if (vars.varsreset == false)
	{
	vars.lasth3mgsplit = 0;
	vars.lastodstmgsplit = 0;
		vars.ending01a = false; //reset h2 variables
		vars.ending01b = false;
		vars.ending03a = false;
		vars.ending03b = false;
		vars.ending04a = false;
		vars.ending04b = false;
		vars.ending05a = false;
		vars.ending05b = false;
		vars.ending06a = false;
		vars.ending06b = false;
		vars.ending07a = false;
		vars.ending08a = false; 
		vars.ending07b = false;
		vars.ptdremoval = 0;
		vars.ending01a = false; 
		
		vars.loopsplit = true;
		
		vars.armorysplit = false;
		vars.cairosplit = false;
		vars.poasplit = false;
		vars.mawsplit = false;
		vars.sierrasplit = false;
		vars.wcsplit = false;
		
		vars.dirtybsps_byte.Clear();
		vars.dirtybsps_int.Clear();
		vars.dirtybsps_long.Clear();
		//vars.startedlevel = "000";
		switch (test)
		{
			case 0: //halo 1
			vars.startedlevel = vars.H1_levelname.Current;
			break;
			
			case 1:
			vars.startedlevel = vars.H2_levelname.Current;
			break;
			
			case 2:
			vars.startedlevel = vars.H3_levelname.Current;
			break;
			
			case 5:
			vars.startedlevel = vars.ODST_levelname.Current;
			break;
			
			case 6:
			vars.startedlevel = vars.HR_levelname.Current;
			break;
		}
		vars.odsttimes = 0;
		vars.h3times = 0;
		vars.hrtimes = 0;
		vars.h2times = 0;
		vars.addtimes = false;
		
		vars.multigamepauseflag = false;
		
		vars.varsreset = true;
		
		vars.DeathCounter = 0;
		if (settings["deathcounter"])
		vars.UpdateDeathCounter();
		
		vars.RevertCounter = 0;
		if (settings["revertcounter"])
		vars.UpdateRevertCounter();
		
		vars.secondreset = true;
		
		print ("autosplitter vars reinit!");
	}
	
	
	
	
	
	
	
	if (vars.menuindicator.Current == 7)
	{
		
		string checklevel;
		switch (test)
		{
			
			case 0:
			//Death counter check
			if (settings["counters"])
			{
				if (settings["deathcounter"])
				{
					if (vars.H1_deathflag.Current && !vars.H1_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
					
				}
				//Revert counter check
				if (settings["revertcounter"])
				{
					if (vars.H1_revertcount.Current > vars.H1_revertcount.Old && !(vars.H1_deathflag.Old)) //don't count it if you're dead
					{
						print ("adding revert");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				} 
				//Revert counter death check
				if (settings["revertcounterdeaths"])
				{
					if (vars.H1_deathflag.Current && !vars.H1_deathflag.Old)
					{
						print ("adding revert-death");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				}
			}
			
			checklevel = vars.H1_levelname.Current;
			if (settings["multigamesplit"])
			{
				if (vars.poasplit == false && vars.H1_levelname.Current == "a10" && vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true && vars.H1_bspstate.Current == 0 && timer.CurrentTime.RealTime.Value.TotalSeconds > 30)
				{
					vars.dirtybsps_byte.Clear();
					vars.poasplit = true;
					return true;
				}
			}
			
			if (settings["Loopmode"] && vars.H1_levelname.Current == vars.startedlevel && vars.loopsplit == false)
			{
				switch (checklevel)
				{
					case "a10":
					if (vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "a30":
					if (vars.H1_tickcounter.Current == 183)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "a50":
					if (vars.H1_tickcounter.Current == 850)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "b30":
					if (vars.H1_tickcounter.Current == 1093)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "b40":
					if (vars.H1_tickcounter.Current == 966)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "c10":
					if (vars.H1_tickcounter.Current == 717)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "c20":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "c40":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "d20":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
					case "d40":
					if (vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = true;
						return true;
					}
					break;
					
				}
				
				
			}
			
			if (settings["bspmode"])
			{
				
				if (settings["bsp_cache"])
				{
					switch (checklevel)
					{
						case "a10":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a10, x => x == vars.H1_bspstate.Current));
						break;
						
						case "a30":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a30, x => x == vars.H1_bspstate.Current));
						break;
						
						case "a50":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a50, x => x == vars.H1_bspstate.Current));
						break;
						
						case "b30":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_b30, x => x == vars.H1_bspstate.Current));
						break;
						
						case "b40":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_b40, x => x == vars.H1_bspstate.Current));
						break;
						
						case "c10":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c10, x => x == vars.H1_bspstate.Current));
						break;
						
						case "c20":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c20, x => x == vars.H1_bspstate.Current));
						break;
						
						case "c40":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c40, x => x == vars.H1_bspstate.Current));
						break;
						
						case "d20":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_d20, x => x == vars.H1_bspstate.Current));
						break;
						
						case "d40":
						return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_d40, x => x == vars.H1_bspstate.Current));
						break;
						
						default:
						return false;
						break;
					}
				}
				
				
				switch (checklevel)
				{
					case "a10":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a10, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "a30":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a30, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "a50":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a50, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "b30":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_b30, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "b40":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_b40, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						if (vars.H1_bspstate.Current == 0)
						{
							print ("hi");
							//update xy, check for match
							vars.watchers_h1xy.UpdateAll(game);
							print ("x: " + vars.H1_xpos.Current);
							print ("y: " + vars.H1_ypos.Current);
							
							if (vars.H1_xpos.Current > 39.23589 && vars.H1_xpos.Current < 47.319897 && vars.H1_ypos.Current > -24.960575 && vars.H1_ypos.Current < -18.383484)
							{
								vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
								return true;
							} else
							{
								return false;
							}
						} 
						else
						{
							vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
							return true;
						}
					}
					break;
					
					case "c10":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c10, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "c20":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c20, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "c40":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c40, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)) && vars.H1_tickcounter.Current > 30)
					{
						if (vars.H1_bspstate.Current == 0)
						{
							//update xy, check for match
							vars.watchers_h1xy.UpdateAll(game);
							if (vars.H1_xpos.Current > 171.87326 && vars.H1_xpos.Current < 185.818526 && vars.H1_ypos.Current > -295.3629 && vars.H1_ypos.Current < -284.356986)
							{
								vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
								return true;
							} else
							{
								return false;
							}
						} 
						else
						{
							vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
							return true;
						}
					}
					break;
					
					
					case "d20":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_d20, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "d40":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_d40, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					default:
					break;
				}
				
			}
			
			
			if (settings["ILmode"] && vars.H1_playerfrozen.Current == true && vars.H1_playerfrozen.Old == false)
			{
				switch (checklevel)
				{
					
					case "a10":
					if (vars.H1_bspstate.Current == 6)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					case "a30": //so we don't false split on lightbridge cs
					if (vars.H1_bspstate.Current == 1)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					case "a50": 
					if (vars.H1_bspstate.Current == 2)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					case "b30": //will false split if you go to security button
					if (vars.H1_bspstate.Current == 0)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					
					
					case "c10": //so we don't split on reveal cs
					if (vars.H1_bspstate.Current != 2)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					
					case "d20": //keyes -- won't false split on fullpath
					if (vars.H1_bspstate.Current != 0 && vars.H1_bspstate.Current != 1)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					case "d40": //maw - will false split on bad ending but not bridge cs
					if (vars.H1_bspstate.Current != 1)
					{
						vars.dirtybsps_byte.Clear();
						vars.loopsplit = false;
						return true;
					}
					break;
					
					default: //don't need bsp check for levels without multiple cutscenes
					vars.dirtybsps_byte.Clear();
					vars.loopsplit = false;
					return true;
					break;
					
				}
				
				
				
			} else
			{
				if (!(vars.H1_levelname.Current == "d40" && vars.H1_bspstate.Current == 7)) //!= maw last bsp
				{
					if(vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44) //split on loading screen
					{
						vars.dirtybsps_byte.Clear();
						return true;
					}
				} else
				{
					if (vars.H1_bspstate.Current == 7 && vars.H1_playerfrozen.Current == true && vars.mawsplit == false)//maw ending
					{
						vars.mawsplit = true;
						vars.dirtybsps_byte.Clear();
						vars.multigamepauseflag = true;
						return true;
					}
				}
			}
			break;
			
			
			case 1:
			if (settings["counters"])
			{
				if (settings["deathcounter"])
				{
					if (vars.H2_deathflag.Current && !vars.H2_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
					
				}
				//Revert counter check
				if (settings["revertcounter"])
				{
					if (vars.H2_revertcount.Current > vars.H2_revertcount.Old && !(vars.H2_deathflag.Old)) //don't count it if you're dead
					{
						print ("adding revert");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				} 
				//Revert counter death check
				if (settings["revertcounterdeaths"])
				{
					if (vars.H2_deathflag.Current && !vars.H2_deathflag.Old)
					{
						print ("adding revert-death");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				}
			}
			
			
			
			checklevel = vars.H2_levelname.Current;
			
			
			
			if (settings["multigamesplit"] || settings["multigamepause"])
			{
				if (vars.armorysplit == false && vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current > 26 && vars.H2_tickcounter.Current < 30 && timer.CurrentTime.RealTime.Value.TotalSeconds > 30)
				{																		
					vars.dirtybsps_byte.Clear();
					vars.armorysplit = true;
					vars.multigamepauseflag = false;
					return (settings["multigamesplit"]);
				}
			}
			
			
			
			if (settings["Loopmode"] && vars.H2_levelname.Current == vars.startedlevel)
			{
				
				if (vars.H2_IGT.Current > 10 && vars.H2_IGT.Current < 30 && vars.loopsplit == false)
				{
					vars.dirtybsps_byte.Clear();
					vars.loopsplit = true;
				}
				
				
			}
			
			
			if (settings["bspmode"])
			{
				if (settings["bsp_cache"])
				{
					switch (checklevel)
					{
						case "01b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_01b, x => x == vars.H2_bspstate.Current));
						break;
						
						case "03a":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_03a, x => x == vars.H2_bspstate.Current));
						break;
						
						case "03b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_03b, x => x == vars.H2_bspstate.Current));
						break;
						
						case "04a":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_04a, x => x == vars.H2_bspstate.Current));
						break;
						
						case "04b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_04b, x => x == vars.H2_bspstate.Current));
						break;
						
						case "05a":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_05a, x => x == vars.H2_bspstate.Current));
						break;
						
						case "05b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_05b, x => x == vars.H2_bspstate.Current));
						break;
						
						case "06a":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_06a, x => x == vars.H2_bspstate.Current));
						break;
						
						case "06b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_06b, x => x == vars.H2_bspstate.Current));
						break;
						
						case "07a":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_07a, x => x == vars.H2_bspstate.Current));
						break;
						
						case "08a":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_08a, x => x == vars.H2_bspstate.Current));
						break;
						
						case "07b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_07b, x => x == vars.H2_bspstate.Current));
						break;
						
						case "08b":
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_08b, x => x == vars.H2_bspstate.Current));
						break;
						
						
						default:
						return false;
						break;
						
					}
				}
				
				switch (checklevel)
				{
					case "01b":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_01b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps_byte.Contains(2)))
						{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "03a":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_03a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "03b":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_03b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "04a":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_04a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps_byte.Contains(3)))
						{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "04b":
					if (vars.H2_bspstate.Current == 3 && !(vars.dirtybsps_byte.Contains(3)))
					{
						print ("e");
						vars.dirtybsps_byte.Add(3);	//prevent splitting on starting bsp
					}
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_04b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						print ("a");
						if (vars.H2_bspstate.Current == 0 && (vars.dirtybsps_byte.Contains(3)))
						{
							print ("b");
						return true;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
						
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "05a":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_05a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "05b":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_05b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "06a":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_06a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "06b":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_06b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "07a":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_07a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "08a":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_08a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps_byte.Contains(1)))
						{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "07b":
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_07b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
					{
						vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
						return true;
					}
					break;
					
					case "08b":
					//TGJ -- starts 0 and in cs, then goes to 1, then 0, then 1, then 0, then 3 (skipping 2 cos it's skippable)
					//so I have jank logic cos it does so much backtracking and backbacktracking
					if (vars.H2_bspstate.Current != vars.H2_bspstate.Old)
					{
						vars.watchers_h2xy.UpdateAll(game);
						//print ("x: " + vars.H2_xpos.Current);
						//print ("y: " + vars.H2_ypos.Current);
						
						byte checkbspstate = vars.H2_bspstate.Current;
						switch (checkbspstate)
						{
							case 1:
							if (!(vars.dirtybsps_byte.Contains(1)) && vars.H2_xpos.Current > -2 && vars.H2_xpos.Current < 5 && vars.H2_ypos.Current > -35 && vars.H2_ypos.Current < -15)
							{
								vars.dirtybsps_byte.Add(1);
								//print ("first");
								return true;
							} else if (!(vars.dirtybsps_byte.Contains(21)) && (vars.dirtybsps_byte.Contains(10))  && vars.H2_xpos.Current > 15 && vars.H2_xpos.Current < 25 && vars.H2_ypos.Current > 15 && vars.H2_ypos.Current < 30)
							{
								vars.dirtybsps_byte.Add(21);
								//print ("third");
								return true;
							}
							
							break;
							
							case 0:
							if (!(vars.dirtybsps_byte.Contains(10)) && vars.H2_xpos.Current > -20 && vars.H2_xpos.Current < -10 && vars.H2_ypos.Current > 20 && vars.H2_ypos.Current < 30)
							{
								vars.dirtybsps_byte.Add(10);
								//print ("second");
								return true;
							} else if (!(vars.dirtybsps_byte.Contains(20)) && (vars.dirtybsps_byte.Contains(21))  && vars.H2_xpos.Current > 45 && vars.H2_xpos.Current < 55 && vars.H2_ypos.Current > -5 && vars.H2_ypos.Current < 10)
							{
								//print ("fourth");
								vars.dirtybsps_byte.Add(20);
								return true;
							}
							break;
							
							case 3:
							if (!(vars.dirtybsps_byte.Contains(3)))
							{
								vars.dirtybsps_byte.Add(3);
								return true;
							}
							break;
							
							default:
							break;
							
						}
						
						
						
					} 
					break;
					
					default:
					break;
				}
				
			}
			
			
			if ((vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44 && vars.menuindicator.Current == 7) || (vars.H2_levelname.Current == "08b" && vars.H2_CSind.Current == 0x19 && vars.H2_CSind.Old != 0x19))
			{
				vars.dirtybsps_byte.Clear();
				vars.loopsplit = false;
				vars.multigamepauseflag = true;
				return true;
			}
			
			break;
			
			case 2:
			if (settings["counters"])
			{
				if (settings["deathcounter"])
				{
					if (vars.H3_deathflag.Current && !vars.H3_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
					
				}
				//Revert counter check
				if (settings["revertcounter"])
				{
					if (vars.H3_revertcount.Current > vars.H3_revertcount.Old && !(vars.H3_deathflag.Old)) //don't count it if you're dead
					{
						print ("adding revert");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				} 
				//Revert counter death check
				if (settings["revertcounterdeaths"])
				{
					if (vars.H3_deathflag.Current && !vars.H3_deathflag.Old)
					{
						print ("adding revert-death");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				}
			}
			
			
			
			
			checklevel = vars.H3_levelname.Current;
			if (settings["multigamesplit"] || settings["multigamepause"])
			{
				if (vars.sierrasplit == false && vars.H3_levelname.Current == "010" && vars.H3_theatertime.Current > 15 && vars.H3_theatertime.Current < 30 && timer.CurrentTime.RealTime.Value.TotalSeconds > 30)
				{
					vars.sierrasplit = true;
					vars.multigamepauseflag = false;
					return (settings["multigamesplit"]);
				}
			}
			
			if (settings["Loopmode"] && vars.H3_levelname.Current == vars.startedlevel && vars.loopsplit == false)
			{
				if (vars.H3_IGT.Current > 10 && vars.H3_IGT.Current < 30)
				{
					vars.loopsplit = true;
					vars.dirtybsps_byte.Clear();
					return true;
				}
				
			}
			
			if (settings["multigame"])
			{
				if (vars.H3_levelname.Current != vars.H3_levelname.Old && timer.CurrentTime.RealTime.Value.TotalSeconds > vars.lasth3mgsplit + 30 && vars.H3_levelname != null)
				{
					vars.splith3 = false;
					vars.lasth3mgsplit = timer.CurrentTime.RealTime.Value.TotalSeconds;
					vars.dirtybsps_long.Clear();
					return true;
				}
			}
			
			
			if (settings["bspmode"])
			{
				
				if (settings["bsp_cache"])
				{
					switch (checklevel)
					{
						case "010":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_010, x => x == vars.H3_bspstate.Current));
						break;
						
						case "020":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_020, x => x == vars.H3_bspstate.Current));
						break;
						
						case "030":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_030, x => x == vars.H3_bspstate.Current));
						break;
						
						case "040":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_040, x => x == vars.H3_bspstate.Current));
						break;
						
						case "050":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_050, x => x == vars.H3_bspstate.Current));
						break;
						
						case "070":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_070, x => x == vars.H3_bspstate.Current));
						break;
						
						case "100":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_100, x => x == vars.H3_bspstate.Current));
						break;
						
						case "110":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_110, x => x == vars.H3_bspstate.Current));
						break;
						
						case "120":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_120, x => x == vars.H3_bspstate.Current));
						break;
						
						
						default:
						return false;
						break;
						
					}
					
				}
				
				switch (checklevel)
				{
					case "010":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_010, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "020":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_020, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "030":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_030, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "040":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_040, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "050":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_050, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "070":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_070, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					
					case "100":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_100, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "110":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_110, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					case "120":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_120, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
					break;
					
					default:
					break;
				} 
			} 
			
			if (settings["ILmode"])
			{
				if ((vars.stateindicator.Old != 44 && vars.stateindicator.Old != 57) && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57))
				{
					vars.dirtybsps_long.Clear();
					vars.loopsplit = false;
					return true;
				}
			} else if (!(settings["multigame"])) //not on IL mode, and not on last level
			{
				if (vars.splith3 == true)
				{
					vars.splith3 = false;
					vars.dirtybsps_long.Clear();
					return true;
				} 
			} 
			break;
			
			
			case 5: //ODST
			if (settings["counters"])
			{
				if (settings["deathcounter"])
				{
					if (vars.odst_deathflag.Current && !vars.odst_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
					
				}
				//Revert counter check
				if (settings["revertcounter"])
				{
					if (vars.odst_revertcount.Current > vars.odst_revertcount.Old && !(vars.odst_deathflag.Old)) //don't count it if you're dead
					{
						print ("adding revert");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				} 
				//Revert counter death check
				if (settings["revertcounterdeaths"])
				{
					if (vars.odst_deathflag.Current && !vars.odst_deathflag.Old)
					{
						print ("adding revert-death");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				}
			}
			
			
			
			
			checklevel = vars.ODST_levelname.Current;
			if (settings["multigamesplit"] || settings["multigamepause"])
			{
				if (vars.ptdsplit == false && vars.ODST_levelname.Current == "c100" && vars.odst_theatertime.Current > 15 && vars.odst_theatertime.Current < 30 && timer.CurrentTime.RealTime.Value.TotalSeconds > 30)
				{
					vars.ptdsplit = true;
					vars.multigamepauseflag = false;
					print ("eeeeee");
					return (settings["multigamesplit"]);
					
				}
			}
			
			if (settings["Loopmode"] && vars.ODST_levelname.Current == vars.startedlevel && vars.loopsplit == false)
			{
				if (vars.odst_IGT.Current > 10 && vars.odst_IGT.Current < 30)
				{
					vars.loopsplit = true;
					vars.dirtybsps_byte.Clear();
					return true; 
				}
				
			}
			
			if (settings["multigame"])
			{
				if (vars.ODST_levelname.Current != vars.ODST_levelname.Old && vars.ODST_levelname.Old != null && timer.CurrentTime.RealTime.Value.TotalSeconds > vars.lastodstmgsplit + 30)
				{
					vars.splitodst = false;
					vars.lastodstmgsplit = timer.CurrentTime.RealTime.Value.TotalSeconds;
					vars.dirtybsps_long.Clear();
					//print ("a:" + vars.ODST_levelname.Current);
					//print ("b:" + vars.ODST_levelname.Old);
					return true;
					
				}
			}
			
			
			if (settings["bspmode"])
			{
				
				if (settings["bsp_cache"])
				{
					switch (checklevel)
					{
						case "h100":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_h100, x => x == vars.odst_bspstate.Current));
						break;
						
						case "sc10":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc10, x => x == vars.odst_bspstate.Current));
						break;
						
						case "sc11":
						if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc11, x => x == vars.odst_bspstate.Current))
						{
							vars.watchers_odstIL.UpdateAll(game); 
							if (vars.odst_IGT.Current > 30)
							{
								return true;
							}
						}
						break;
						
						case "sc13":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc13, x => x == vars.odst_bspstate.Current));
						break;
						
						case "sc12":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc12, x => x == vars.odst_bspstate.Current));
						break;
						
						case "sc14":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc14, x => x == vars.odst_bspstate.Current));
						break;
						
						case "sc15":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc15, x => x == vars.odst_bspstate.Current));
						break;
						
						case "l200":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_l200, x => x == vars.odst_bspstate.Current));
						break;
						
						case "l300":
						return (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_l300, x => x == vars.odst_bspstate.Current));
						break;
						
						default:
						return false;
						break;
						
					}
					
				}
				
				switch (checklevel)
				{
					case "h100":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_h100, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "sc10":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc10, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "sc11":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc11, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.watchers_odstIL.UpdateAll(game); 
						if (vars.odst_IGT.Current > 30)
						{
							vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
							return true;
						}
						
						
						
					}
					break;
					
					case "sc13":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc13, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "sc12":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc12, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "sc14":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc14, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "sc15":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_sc15, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "l200":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_l200, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					case "l300":
					if (vars.odst_bspstate.Current != vars.odst_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_l300, x => x == vars.odst_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.odst_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.odst_bspstate.Current);
						return true;
					}
					break;
					
					
					
					default:
					break;
				} 
			} 
			
			if (settings["ILmode"])
			{
				if ((vars.stateindicator.Old != 44 && vars.stateindicator.Old != 57) && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57))
				{
					vars.dirtybsps_long.Clear();
					vars.loopsplit = false;
					return true;
				}
			} else if (!(settings["multigame"])) //not on IL mode, and not on last level
			{
				if (vars.splitodst == true)
				{
					vars.splitodst = false;
					if (checklevel != "h100") //don't clear dirty bsps of streets in fg.. tho will break in multigame. meh who uses bsp splits in multigame lmao
					{
						vars.dirtybsps_long.Clear();
					}
					return true;
				} 
			} 
			break;
			
			
			
			
			
			
			case 6:
			//Death counter check
			if (settings["counters"]) 
			{
				if (settings["deathcounter"])
				{
					if (vars.HR_deathflag.Current && !vars.HR_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
					
				}
				//Revert counter check
				if (settings["revertcounter"]  && vars.stateindicator.Current != 44) //have to add an extra check here cos reach revert counter is a lil buggy
				{
					if (vars.HR_revertcount.Current > vars.HR_revertcount.Old && !(vars.HR_deathflag.Old)) //don't count it if you're dead
					{
						print ("adding revert");
						vars.RevertCounter += 1;
						vars.UpdateRevertCounter();
					}
					
				} 
				//Revert counter death check
				if (settings["revertcounterdeaths"])
				{
				if (vars.HR_deathflag.Current && !vars.HR_deathflag.Old)
				{
					print ("adding revert-death");
					vars.RevertCounter += 1;
					vars.UpdateRevertCounter();
				}
				
				}
				}
				
			
			
			checklevel = vars.HR_levelname.Current;
			if (settings["multigamesplit"] || settings["multigamepause"])
			{
				if (vars.wcsplit == false && vars.HR_levelname.Current == "010" && vars.HR_IGT.Current > 15 && vars.HR_IGT.Current < 30 && timer.CurrentTime.RealTime.Value.TotalSeconds > 30)
				{
					vars.wcsplit = true;
					vars.multigamepauseflag = false;
					return (settings["multigamesplit"]);
				}
			}
			
			if (settings["Loopmode"] && vars.HR_levelname == vars.startedlevel)
			{
				if (vars.HR_IGT.Current > 10 && vars.HR_IGT.Current < 30 && vars.loopsplit == false)
				{
					vars.loopsplit = true;
					vars.dirtybsps_int.Clear();
					return true;
				}
			}
			
			if (settings["bspmode"])
			{
				
				if (settings["bsp_cache"])
				{
					switch (checklevel)
					{
						case "m10":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m10, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m20":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m20, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m30":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m30, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m35":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m35, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m45":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m45, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m50":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m50, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m60":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m60, x => x == vars.HR_bspstate.Current));
						break;
						
						case "m70":
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m70, x => x == vars.HR_bspstate.Current));
						break;
						
						
						default:
						break;
					}
				}
				
				
				switch (checklevel)
				{
					case "m10":
					/* 					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old)
						{
						print ("new: " + vars.HR_bspstate.Current);
						print ("old: " + vars.HR_bspstate.Old);
						
						foreach (uint item in vars.dirtybsps_int) // Loop through List with foreach
						{
						print ("dirty: " + item);
						}
					} */
					
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m10, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m20":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m20, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m30":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m30, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m35":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m35, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m45":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m45, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m50":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m50, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m60":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m60, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					case "m70":
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.splitbsp_m70, x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
					break;
					
					
					default:
					break;
				}
				
			}
			
			if (settings["ILmode"])
			{
				if ((vars.stateindicator.Old != 44 && vars.stateindicator.Old != 57) && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57))
				{
					vars.dirtybsps_int.Clear();
					vars.loopsplit = false;
					return true;
				}
			} else
			{
				if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
				{
					vars.dirtybsps_int.Clear();
					return true;
				} 
			} 
			
			
			break;
			
		}
	}
}

reset
{ 
	if ((settings["ILmode"]) && vars.menuindicator.Current != 7 && timer.CurrentPhase != TimerPhase.Ended)
	{
		return true;
	}
	
	if (!( (settings["multigame"]) || (settings["Loopmode"]) ) && vars.menuindicator.Current == 7)
	{
		
		byte test = vars.gameindicator.Current;
		switch (test)
		{
			
			case 0:
			if (vars.H1_levelname.Current == vars.startedlevel) //h1
			{
				if (settings["ILmode"])
				{
					return (timer.CurrentPhase != TimerPhase.Ended &&( (
						(vars.H1_levelname.Current == "a10" && vars.H1_bspstate.Current == 0 && vars.H1_playerfrozen.Current == true) 
						|| (vars.H1_levelname.Current == "a30" && vars.H1_tickcounter.Current < 50) 
						|| (vars.H1_levelname.Current == "a50" && vars.H1_tickcounter.Current < 500) 
						|| (vars.H1_levelname.Current == "b30" && vars.H1_tickcounter.Current < 500) 
						|| (vars.H1_levelname.Current == "b40" && vars.H1_tickcounter.Current < 500) 
						|| (vars.H1_levelname.Current == "c10" && vars.H1_tickcounter.Current < 500) 
						|| (vars.H1_levelname.Current == "c20" && vars.H1_playerfrozen.Current == true && vars.H1_tickcounter.Current < 50)
						|| (vars.H1_levelname.Current == "c40" && vars.H1_playerfrozen.Current == true && vars.H1_tickcounter.Current < 50)
						|| (vars.H1_levelname.Current == "d20" && vars.H1_playerfrozen.Current == true && vars.H1_tickcounter.Current < 50)
						|| (vars.H1_levelname.Current == "d40" && vars.H1_playerfrozen.Current == true && vars.H1_tickcounter.Current < 50)
					))); 
				} else
				{
					return (vars.H1_levelname.Current == "a10" && vars.H1_bspstate.Current == 0 && vars.H1_playerfrozen.Current == true); //reset on PoA
				}
				
				
				
			} 
			break;
			
			case 1:
			if (vars.H2_levelname.Current == vars.startedlevel) //AKA if Halo 2 is loaded
			{
				if (settings["ILmode"])
				{
					return (timer.CurrentPhase != TimerPhase.Ended && (vars.H2_IGT.Current < 10));
				}
				else
				{
					return (vars.H2_CSind.Current == 0xD9 || (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current <20)); //reset on Cairo & armory
				} 
				
			} 
			break;
			
			case 2:
			if (vars.H3_levelname.Current == vars.startedlevel) //h3 (guessed val)
			{
				if (settings["ILmode"])
				{
					return ( timer.CurrentPhase != TimerPhase.Ended && ( vars.H3_IGT.Current < 10));
				} else
				{
					return (vars.H3_levelname.Current == "010" && vars.H3_theatertime.Current > 0 && vars.H3_theatertime.Current < 15);	
				}
			} 
			break;
			
			case 5:
			if (vars.ODST_levelname.Current == vars.startedlevel) //odst
			{
				if (settings["ILmode"])
				{
					return ( timer.CurrentPhase != TimerPhase.Ended && ( vars.odst_IGT.Current < 10));
				} else
				{
				return ((vars.odst_bspstate.Current == 12884901891) || (vars.ODST_levelname.Current == "c100" && vars.odst_theatertime.Current > 0 && vars.odst_theatertime.Current < 15) );	
				}
			} 
			break;
			
			case 6:
			if (vars.HR_levelname.Current == vars.startedlevel) //hr
			{
				if (settings["ILmode"])
				{
					return ( timer.CurrentPhase != TimerPhase.Ended && ( vars.HR_IGT.Current < 10));
				} else
				{
					return ( vars.HR_levelname.Current == "m10" && timer.CurrentPhase != TimerPhase.Ended && vars.HR_IGT.Current < 10);
				}
			}
			break;
			
			
			
			
		}
	}
}

isLoading
{
	if (settings["multigame"]) //timing for multigame and halo 1 is identical
	{
		
		if (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)
		return true;
		
		if (settings["multigamepause"])
		{
			return (vars.multigamepauseflag);	
			
		}
		return false;
	} 
	
	//also should prolly code load removal to work in loading screens when menuindicator isn't == 7 in case of restart/crash
	byte test = vars.gameindicator.Current;
	switch (test)
	{
		
		case 0:
		return (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57);
		break;
		
		case 1:
		if (settings["ILmode"])
		{
			return true;
		}
		
		if (vars.menuindicator.Current == 7)
		{
			string H2_checklevel = vars.H2_levelname.Current;
			switch (H2_checklevel)
			{
				case "01a": //The Armory
				if (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)    
				{
					vars.ending01a = true;
					//print("we paused for 01a");
				}
				return (vars.ending01a);
				break;
				
				case "01b": //Cairo Station
				if (vars.ending01a == true && vars.H2_CSind.Current != 0xD9 && vars.H2_tickcounter.Current > vars.adjust01b && vars.stateindicator.Current != 44)   //intro cutscene over check 
				vars.ending01a = false; 
				if (vars.ending01a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0xE5))    //outro cutscene started check
				vars.ending01b = true;
				return (vars.ending01a || vars.ending01b);
				break;
				
				case "03a": //Outskirts
				if (vars.ending01b == true && vars.H2_CSind.Current != 0xB1 && vars.H2_tickcounter.Current > vars.adjust03a && vars.stateindicator.Current != 44) 
				vars.ending01b = false;
				if (vars.ending01b == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)) //outskirts has no outro cs
				vars.ending03a = true;
				return (vars.ending01b || vars.ending03a);
				break;
				
				case "03b": //Metropolis
				if (vars.ending03a == true && (vars.H2_CSind.Current != 0xF1 && vars.H2_CSind.Current != 0xB5 && vars.H2_CSind.Current != 0x8D && vars.H2_CSind.Current != 0xD5) && vars.H2_tickcounter.Current > vars.adjust03b && vars.stateindicator.Current != 44) //4 variations of intro cs for difficulties
				vars.ending03a = false;
				if (vars.ending03a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0xDD))
				vars.ending03b = true;	
				return (vars.ending03a || vars.ending03b);
				break;
				
				case "04a": //The Arbiter
				if (vars.ending03b == true && vars.H2_CSind.Current != 0x9D && vars.H2_tickcounter.Current > vars.adjust04a && vars.stateindicator.Current != 44) 
				vars.ending03b = false;
				if (vars.ending03b == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)) //the arbiter has no outro cs
				vars.ending04a = true;	
				return (vars.ending03b || vars.ending04a);
				break;
				
				case "04b": //Oracle
				if (vars.ending04a == true && vars.H2_CSind.Current != 0x61 && vars.H2_tickcounter.Current > vars.adjust04b && vars.stateindicator.Current != 44) 
				vars.ending04a = false;
				if (vars.ending04a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0x31)) 
				vars.ending04b = true;	
				return (vars.ending04a || vars.ending04b);
				break;
				
				case "05a": //Delta Halo
				if (vars.ending04b == true && vars.H2_CSind.Current != 0x69 && vars.H2_tickcounter.Current > vars.adjust05a && vars.stateindicator.Current != 44) 
				vars.ending04b = false;
				if (vars.ending04b == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)) //delta halo has no outro cs
				vars.ending05a = true;	
				return (vars.ending04b || vars.ending05a);
				break;
				
				case "05b": //Regret
				if (vars.ending05a == true && vars.H2_CSind.Current != 0x6D && vars.H2_tickcounter.Current > vars.adjust05b && vars.stateindicator.Current != 44) 
				vars.ending05a = false;
				if (vars.ending05a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0x45)) 
				vars.ending05b = true;	
				return (vars.ending05a || vars.ending05b);
				break;
				
				case "06a": //Sacred Icon
				if (vars.ending05b == true && vars.H2_CSind.Current != 0xA1 && vars.H2_tickcounter.Current > vars.adjust06a && vars.stateindicator.Current != 44) 
				vars.ending05b = false;
				if (vars.ending05b == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)) //sacred icon has no outro cs
				vars.ending06a = true;	
				return (vars.ending05b || vars.ending06a);
				break;
				
				case "06b": //Quarantine Zone
				if (vars.ending06a == true && vars.H2_CSind.Current != 0x85 && vars.H2_tickcounter.Current > vars.adjust06b && vars.stateindicator.Current != 44) 
				vars.ending06a = false;
				if (vars.ending06a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0x75)) 
				vars.ending06b = true;	
				return (vars.ending06a || vars.ending06b);
				break;
				
				case "07a": //Gravemind
				if (vars.ending06b == true && vars.H2_CSind.Current != 0x15 && vars.H2_tickcounter.Current > vars.adjust07a && vars.stateindicator.Current != 44) 
				vars.ending06b = false;
				if (vars.ending06b == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0xF9)) 
				vars.ending07a = true;	
				return (vars.ending06b || vars.ending07a);
				break;
				
				case "08a": //Uprising
				if (vars.ending07a == true && vars.H2_CSind.Current != 0xB9 && vars.H2_tickcounter.Current > vars.adjust08a && vars.stateindicator.Current != 44) 
				vars.ending07a = false;
				if (vars.ending07a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0x21)) 
				vars.ending08a = true;	
				return (vars.ending07a || vars.ending08a);
				break;
				
				case "07b": //High Charity
				if (vars.ending08a == true && vars.H2_CSind.Current != 0x4D && vars.H2_tickcounter.Current > vars.adjust07b && vars.stateindicator.Current != 44) 
				vars.ending08a = false;
				if (vars.ending08a == false && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57 || vars.H2_CSind.Current == 0x79)) 
				vars.ending07b = true;	
				return (vars.ending08a || vars.ending07b);
				break;
				
				case "08b": //The Great Journey
				if (vars.ending07b == true && vars.H2_CSind.Current != 0xF5 && vars.H2_tickcounter.Current > vars.adjust08b && vars.stateindicator.Current != 44) 
				vars.ending07b = false;	
				return (vars.ending07b);
				break; //no outro cs check cos that's game end, no need to pause
				
				default: 	//eg return true if any of the following are true
				return ( 
					vars.ending01a ||
					vars.ending01b ||
					vars.ending03a ||
					vars.ending03b ||
					vars.ending04a ||
					vars.ending04b ||
					vars.ending05a ||
					vars.ending05b ||
					vars.ending06a ||
					vars.ending06b ||
					vars.ending07a ||
					vars.ending08a ||
					vars.ending07b 
				);
				break;
			}
			
		} else //menuindicator != 7
		{
			return (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57);
		}
		break;
		
		case 2:
		case 5:
		case 6:
		return true;
		break;
	}
}


gameTime
{
	
	if (!(settings["multigame"]) && vars.menuindicator.Current == 7)
	{
		if (vars.gameindicator.Current == 6) //reach
		{
			if (settings["ILmode"])
			{return TimeSpan.FromMilliseconds(((1000.0 / 60.0) * vars.HR_IGT.Current));}
			else
			{
				if (vars.HR_validtimeflag.Current == 19)
				{
					if (vars.HR_validtimeflag.Old != 19)
					{
						vars.hrtimes = vars.hrtimes + (vars.HR_IGT.Old - (vars.HR_IGT.Old % 60));
						
					}
					
					return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.hrtimes)) ));	
				}
				
				return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.hrtimes + vars.HR_IGT.Current)) ));
			}
		}  else if (vars.gameindicator.Current == 2) //h3
		{
			if (settings["ILmode"])
			{return TimeSpan.FromMilliseconds(((1000.0 / 60.0) * vars.H3_IGT.Current));}
			else
			{
				if (vars.H3_theatertime.Old > vars.H3_theatertime.Current && vars.H3_levelname.Current != "")
				{
					vars.splith3 = true;
					print ("Adding times");
					print ("time added: " + vars.H3_theatertime.Old);
					vars.h3times = vars.h3times + (vars.H3_theatertime.Old - (vars.H3_theatertime.Old % 60));
				}
				
				return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.h3times + vars.H3_theatertime.Current)) ));
				
			}
		} else if (vars.gameindicator.Current == 5) //ODST
		{
		
			// bsp value to remove ptd times on 1133871366144
		
			if (settings["ILmode"])
			{return TimeSpan.FromMilliseconds(((1000.0 / 60.0) * vars.odst_IGT.Current));}
			else
			{
				if (vars.odst_theatertime.Old > vars.odst_theatertime.Current && vars.ODST_levelname.Current != "")
				{
					vars.splitodst = true;
					print ("Adding times");
					print ("time added: " + vars.odst_theatertime.Old);
					vars.odsttimes = vars.odsttimes + (vars.odst_theatertime.Old - (vars.odst_theatertime.Old % 60));
				}
				if (vars.odst_bspstate.Current == 1133871366144 && vars.odst_bspstate.Old != 1133871366144 && vars.ODST_levelname.Current == "c100")
				{
					vars.ptdremoval = (vars.odst_theatertime.Old - (vars.odst_theatertime.Old % 60));
					print ("removing ptd time");
				print ("time removed: " + ((vars.odst_theatertime.Old - (vars.odst_theatertime.Old % 60)) / 60));
				}
				
				return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.odsttimes + vars.odst_theatertime.Current - vars.ptdremoval)) ));
				
			}
		} else if (settings["ILmode"] && vars.gameindicator.Current == 1) //h2
		{
			if (settings["Loopmode"])
			{
				if (vars.stateindicator.Current == 57)
				{
					if (vars.stateindicator.Old != 57)
					{
						vars.h2times = vars.h2times + (vars.H2_IGT.Current - (vars.H2_IGT.Current % 60));
					}
					
					return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.h2times)) )); 
				}
				
				if (vars.stateindicator.Current == 44)
				{
					return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.h2times)) )); 	
				}
				return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.h2times + vars.H2_IGT.Current)) ));
			}
			
			return TimeSpan.FromMilliseconds(((1000.0 / 60.0) * vars.H2_IGT.Current));
		}
	}
}




exit
{
	if (vars.multigamepauseflag == false)
	timer.IsGameTimePaused = false; //unpause the timer on gamecrash UNLESS it was paused for multi-game-pause option.
}



