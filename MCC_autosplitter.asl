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
		case "1.1619.0.0": 
		version = "1.1619.0.0";
		break;
		
		case "1.1658.0.0": 
		version = "1.1658.0.0";
		break;
		
		default: 
		version = "1.1619.0.0";
		if (vars.brokenupdateshowed == false)
		{
			vars.brokenupdateshowed = true;
			var brokenupdateMessage = MessageBox.Show(
				"It looks like MCC has recieved a new patch that will "+
				"probably break me (the autosplitter). \n"+
				"Autosplitter was made for version: "+ "1.1619.0.0" + "\n" + 
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
	if (modules.First().ToString() == "MCC-Win64-Shipping.exe")
	{
		if (version == "1.1619.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x37CC2D8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x38F92D9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x038F2268, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x038DC480, 0x8, 0x115C6F8), 3)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x038DC480, 0x28, 0x13FB373), 3)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x0), 3)), //invalid but need blank
				(vars.HR_levelname = new StringWatcher(new DeepPointer(0x038DC480, 0xC8, 0x2AAB267), 3))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0x8, 0x1FA8B94)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x8, 0x10CF324)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x038DC480, 0x8, 0x224B0C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x038DC480, 0x8, 0x2199338)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x038DC480, 0x8, 0x219933C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0x28, 0xEADAD74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x28, 0x19A2AC8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x28, 0x1294D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(0x038DC480, 0x28, 0x133E0E8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(0x038DC480, 0x28, 0x133E0EC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0x28, 0x13BA300)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //invalid but need blank
				(vars.H3_validtimeflag = new MemoryWatcher<byte>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_IGT = new MemoryWatcher<uint> (new DeepPointer(0x038DC480, 0xC8, 0x025041E8, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_validtimeflag = new MemoryWatcher<byte> (new DeepPointer(0x038DC480, 0xC8, 0x010CD868, 0x12E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0xC8, 0x38C48F0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
		} 
	} else if (modules.First().ToString() == "MCC-Win64-Shipping-WinStore.exe")
	{
		if (version == "1.1619.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x36A1258)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x37CE0A9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x037C7288, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0x8, 0x115C6F8), 3)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0x28, 0x13FB373), 3)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x0), 3)), //invalid but need blank
				(vars.HR_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0xC8, 0x2AAB267), 3))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x8, 0x1FA8B94)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x8, 0x10CF324)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x037B1420, 0x8, 0x224B0C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(0x037B1420, 0x8, 0x2199338)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(0x037B1420, 0x8, 0x219933C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x28, 0xEADAD74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x19A2AC8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x1294D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(0x037B1420, 0x28, 0x133E0E8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(0x037B1420, 0x28, 0x133E0EC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x28, 0x13BA300)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //invalid but need blank
				(vars.H3_validtimeflag = new MemoryWatcher<byte>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_IGT = new MemoryWatcher<uint> (new DeepPointer(0x037B1420, 0xC8, 0x025041E8, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.HR_validtimeflag = new MemoryWatcher<byte> (new DeepPointer(0x037B1420, 0xC8, 0x010CD868, 0x12E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0xC8, 0x38C48F0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
		} 
	}
	
	
	
}


startup //variable init and settings
{
	
	
	//MOVED VARIABLE INIT TO STARTUP TO PREVENT BUGS WHEN RESTARTING (/CRASHING) MCC MID RUN
	
	//GENERAL inits
	vars.loopcount = 0;
	vars.dirtybsps_byte = new List<byte>();
	vars.dirtybsps_int = new List<uint>();
	vars.dirtybsps_long = new List<ulong>();
	vars.h3times = 0;
	vars.startedlevel = "000";
	vars.varsreset = false;
	vars.loopsplit = true;
	vars.h2times = 0;
	vars.brokenupdateshowed = false;
	vars.reachwarningshowed = false;
	
	
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
	vars.sierrasplit = false;
	
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
			break;
			
			case 1:
			vars.watchers_h2.UpdateAll(game);
			if (settings["bspmode"])
			{ vars.watchers_h2bsp.UpdateAll(game); }
			if (settings["ILmode"])
			{ vars.watchers_h2IL.UpdateAll(game); }
			break;
			
			case 2:
			if (settings["bspmode"])
			{ vars.watchers_h3bsp.UpdateAll(game); }
			if (settings["ILmode"])
			{ vars.watchers_h3IL.UpdateAll(game); }
			else 
			{ vars.watchers_h3.UpdateAll(game); }
			break;
			
			case 6: 
			vars.watchers_hr.UpdateAll(game);	
			if (settings["bspmode"])
			{ vars.watchers_hrbsp.UpdateAll(game); }
			break;
			
		}
	}
}





start 	//starts timer
{	
	string checklevel; 
	
	if (vars.varsreset == false)
	{
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
		vars.startedlevel = "000";
		
		vars.h3times = 0;
		vars.hrtimes = 0;
		vars.h2times = 0;
		
		vars.varsreset = true;
	}
	
	
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
		
		case 6:
		if (vars.reachwarningshowed == false)
		{
			vars.reachwarningshowed = true;
			
			var reachwarningmessage = MessageBox.Show(
				"Heya, looks like you're running Reach with EAC disabled. \n"+
				"Obviously EAC disabled is necessary for this autosplitter to work, \n"+
				"but it's worth being aware that the Reach speedrun community \n" + 
				"has not yet come to a decision on whether EAC disabled runs \n" +
				"are valid to submit. Run at your own risk.",
				vars.aslName+" | LiveSplit",
				MessageBoxButtons.OK 
			);
		}
		
		if ((settings["ILmode"] || vars.HR_levelname.Current == "m10")  && vars.HR_IGT.Current > 10 && vars.HR_IGT.Current < 30)
		{
			vars.startedlevel = vars.HR_levelname.Current;
			vars.varsreset = false;
			return true;
		}
		break;
	}
}



split
{ 
	
	
	
	if (vars.menuindicator.Current == 7)
	{
		
		string checklevel;
		byte test = vars.gameindicator.Current;
		switch (test)
		{
			
			case 0:
			checklevel = vars.H1_levelname.Current;
			if (settings["multigamesplit"])
			{
				if (vars.poasplit == false && vars.H1_levelname.Current == "a10" &&  timer.CurrentPhase == TimerPhase.Running && vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true && vars.H1_bspstate.Current == 0)
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
			
			
			if (settings["ILmode"])
			{
				if (
					((vars.stateindicator.Current == 57 || vars.stateindicator.Current == 44) && (vars.stateindicator.Old != 57 && vars.stateindicator.Old != 44) && !(vars.H1_levelname.Current == "d20" && vars.H1_bspstate.Current == 3)) //split on PGCR or Loading screen
					|| (vars.H1_levelname.Current == "d20" && vars.H1_bspstate.Current == 3 && vars.H1_playerfrozen.Current == true && vars.H1_playerfrozen.Old == false) //Keyes ending to end time at start of cutscene instead of end of it
					|| (vars.H1_levelname.Current == "d40" && vars.H1_bspstate.Current == 7 && vars.H1_playerfrozen.Current == true && vars.H1_playerfrozen.Old == false) //Maw ending
				)
				{
					vars.dirtybsps_byte.Clear();
					vars.loopsplit = false;
					return true;
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
						return true;
					}
				}
			}
			break;
			
			
			case 1:
			checklevel = vars.H2_levelname.Current;
			if (settings["multigamesplit"])
			{
				if (vars.armorysplit == false && timer.CurrentPhase == TimerPhase.Running && vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current > 26 &&  vars.H2_tickcounter.Current < 30)
				{
					vars.dirtybsps_byte.clear();
					vars.armorysplit = true;
					return true;
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
				return true;
			}
			
			break;
			
			case 2:
			checklevel = vars.H3_levelname.Current;
			if (settings["multigamesplit"])
			{
				if (vars.sierrasplit == false && timer.CurrentPhase == TimerPhase.Running && vars.H3_levelname.Current == "010" && vars.H3_theatertime.Current > 15 && vars.H3_theatertime.Current < 30)
				{
					vars.sierrasplit = true;
					return true;
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
			
			
			
			if (settings["bspmode"])
			{
				
				
				
				if (settings["bsp_cache"])
				{
					switch (checklevel)
					{
						case "010":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_010, x => x == vars.H3_bspstate.Current));
						break;
						
						case "040":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_040, x => x == vars.H3_bspstate.Current));
						break;
						
						case "070":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_070, x => x == vars.H3_bspstate.Current));
						break;
						
						case "100":
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_100, x => x == vars.H3_bspstate.Current));
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
					
					case "040":
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_040, x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
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
			} else //not on IL mode, and not on last level
			{
				if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
				{
					vars.dirtybsps_long.Clear();
					return true;
				} 
			} 
			break;
			
			case 6:
			checklevel = vars.HR_levelname.Current;
			if (settings["multigamesplit"])
			{
				if (vars.wcsplit == false && timer.CurrentPhase == TimerPhase.Running && vars.HR_levelname.Current == "010" && vars.HR_IGT.Current > 15 && vars.HR_IGT.Current < 30)
				{
					vars.wcsplit = true;
					return true;
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
		return (vars.stateindicator.Current == 44);
	} 
	
	//also should prolly code load removal to work in loading screens when menuindicator isn't == 7 in case of restart/crash
	byte test = vars.gameindicator.Current;
	switch (test)
	{
		
		case 0:
		return (vars.stateindicator.Current == 44);
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
				if (vars.H3_validtimeflag.Current == 0 && vars.H3_validtimeflag.Old == 1)
				{
					vars.h3times = vars.h3times + (vars.H3_theatertime.Old - (vars.H3_theatertime.Old % 60));
				}
				
				return (TimeSpan.FromMilliseconds(((1000.0 / 60.0) * (vars.h3times + vars.H3_theatertime.Current)) ));
				
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








