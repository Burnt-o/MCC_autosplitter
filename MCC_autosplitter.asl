//Halo: The Master Chief Collection Autosplitter
//Supports H1A and H2A
//Updated 2020/06/07
//by Burnt


state("MCC-Win64-Shipping") {}
state("MCC-Win64-Shipping-WinStore") {}

init //variable initialization
{ 
	
	//version check and warning message for invalid version 
	switch(modules.First().FileVersionInfo.FileVersion)
	{
		case "1.1570.0.0": 
		version = "1.1570.0.0";
		break;
		
		case "1.1629.0.0": 
		version = "1.1629.0.0";
		break;
		
		default: 
		version = "1.1570.0.0";
		var brokenupdateMessage = MessageBox.Show(
			"It looks like MCC has recieved a new patch that will "+
			"probably break me (the autosplitter). \n"+
			"Autosplitter was made for version: "+ "1.1570.0.0" + "\n" + 
			"Current detected version: "+ modules.First().FileVersionInfo.FileVersion + "\n" +
			"If I'm broken, you'll just have to wait for Burnt to update me. "+
			"You won't need to do anything except restart Livesplit once I'm updated.",
			vars.aslName+" | LiveSplit",
			MessageBoxButtons.OK 
		);
		break;
	}
	
	//STATE init
	if (modules.First().ToString() == "MCC-Win64-Shipping.exe")
	{
		if (version == "1.1570.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x37CC2D8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x38F92D9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.H1_gameindicator = new StringWatcher(new DeepPointer(0x038DC480, 0x8, 0x115C6F1), 6)),
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x038DC480, 0x8, 0x115C6F8), 3)),
				(vars.H2_gameindicator = new StringWatcher(new DeepPointer(0x038DC480, 0x28, 0x13FB364), 8)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x038DC480, 0x28, 0x13FB373), 3)),
				(vars.H3_gameindicator = new StringWatcher(new DeepPointer(0x0), 4)), //invalid but need blank
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x0), 3)) //invalid but need blank
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0x8, 0x1FA8B94)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x8, 0x10CF324)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x038DC480, 0x8, 0x224B0C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0x28, 0xEADAD74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x28, 0x19A2AC8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x038DC480, 0x28, 0x1294D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038DC480, 0x28, 0x13BA300)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
		} else if (version == "1.1629.0.0") //h3 flight
		{
			
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x37B4F58)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x38E17A9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.H1_gameindicator = new StringWatcher(new DeepPointer(0x0), 6)), //invalid but need blank
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x0), 3)), //invalid but need blank
				(vars.H2_gameindicator = new StringWatcher(new DeepPointer(0x0), 8)), //invalid but need blank
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x0), 3)), //invalid but need blank
				(vars.H3_gameindicator = new StringWatcher(new DeepPointer(0x038C5120, 0x48, 0x4E), 4)),
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x038C5120, 0x48, 0xAA6CCB), 3))
				
			};
			
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x038C5120, 0x48, 0xC4D314)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x038C5120, 0x48, 0xE78690)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
		}
	} else if (modules.First().ToString() == "MCC-Win64-Shipping-WinStore.exe")
	{
		if (version == "1.1570.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x36A1258)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x37CE0A9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.H1_gameindicator = new StringWatcher(new DeepPointer(0x037B1420, 0x8, 0x115C6F1), 6) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0x8, 0x115C6F8), 3) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_gameindicator = new StringWatcher(new DeepPointer(0x037B1420, 0x28, 0x13FB364), 8) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0x28, 0x13FB373), 3) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H3_gameindicator = new StringWatcher(new DeepPointer(0x0), 4)), //invalid but need blank
				(vars.H3_levelname = new StringWatcher(new DeepPointer(0x0), 3)) //invalid but need blank
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x8, 0x1FA8B94)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x8, 0x10CF324)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x037B1420, 0x8, 0x224B0C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x28, 0xEADAD74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x19A2AC8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x1294D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2IL = new MemoryWatcherList() {
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x28, 0x13BA300)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
			vars.watchers_h3IL = new MemoryWatcherList() {
				(vars.H3_IGT = new MemoryWatcher<uint>(new DeepPointer(0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //invalid but need blank
			};
			
		} else if (version == "1.1629.0.0")
		{
			//h3 flight stuff - but not actually going to do winstore ver
		}
	}
	
	//VARIABLE inits
	vars.loopcount = 0;
	vars.dirtybsps = new List<byte>();
	vars.h3dirtybsps = new List<ulong>();
	
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
	
}


startup //settings
{
	
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
	
	settings.Add("H1ILmode", false, "Halo 1: IL mode");
	settings.SetToolTip("H1ILmode", "Makes the timer start, reset and ending split at the correct IL time for each H1 level");
	
	settings.Add("H1bsp", false, "Halo 1: split on bsp loads (WIP)");
	settings.SetToolTip("H1bsp", "Split on fresh bsp loads (\"Loading... Done\") within levels. \n" +
		"You'll need to add the following amount of extra splits for each level: \n Poa: 6 \n Halo: 1 \n TnR: 3 \n SC: 1 \n AotCR: 4 \n GS: 4 \n Lib: 3 \n TB: 5 if full BOOL, 6 if inbounds 2nd gen, 8 if no BOOL \n Keyes: 2 \n Maw: 7 \n" +
		"BTW you may want to make these splits into subsplits, see here: redd.it/84661r"
	);
	
	settings.Add("H1bsp_cache", false, "split on unfresh bsp loads", "H1bsp");
	settings.SetToolTip("H1bsp_cache", "With this disabled, only the first time you enter a specific bsp will cause a split. \n" +
		"This is so that if you hit a load, then die and revert to before the load, and hit again, you won't get duplicate splits. \n" +
		"You probably shouldn't turn this on, unless you're say, practicing a specific segment of a level (from one load to another)."
	);
	
		settings.Add("noarmory", false, "Halo 2: noarmory%");
	settings.SetToolTip("noarmory", "Let's the timer auto-start/reset on Cairo Station, instead of Armory");
	
	settings.Add("H2ILmode", false, "Halo 2: IL mode");
	settings.SetToolTip("H2ILmode", "Makes the timer correspond to the PGCR time. ");
	
	settings.Add("H2bsp", false, "Halo 2: split on bsp loads (WIP)");
	settings.SetToolTip("H2bsp", "Split on fresh bsp loads (\"Loading... Done\") within levels. \n" +
		"You'll need to add the following amount of extra splits for each level: \n Arm: 0 \n CS: 3 \n OS: 2 \n Met: 1 \n Arb: 2 \n Ora: 4 \n DH: 1 \n Reg: 2 \n SI: 2 \n QZ: 3 \n GM: 5 \n Up: 2 \n HC: 0 if HC skip, 3 otherwise \n TGJ: 5 \n" +
		"BTW you may want to make these splits into subsplits, see here: redd.it/84661r"
	);
	
	settings.Add("H2bsp_cache", false, "split on unfresh bsp loads", "H2bsp");
	settings.SetToolTip("H2bsp_cache", "With this disabled, only the first time you enter a specific bsp will cause a split. \n" +
		"This is so that if you hit a load, then die and revert to before the load, and hit again, you won't get duplicate splits. \n" +
		"You probably shouldn't turn this on, unless you're say, practicing a specific segment of a level (from one load to another)."
	);
	
	settings.Add("H3ILmode", false, "Halo 3: IL mode");
	settings.SetToolTip("H3ILmode", "Makes the timer correspond to the PGCR time. ");	
	
	
	settings.Add("H3bsp", false, "Halo 3: split on bsp loads (WIP)");
	settings.SetToolTip("H3bsp", "Split on fresh bsp loads (\"Loading... Done\") within levels. (well, most of them) \n" +
		"You'll need to add the following amount of extra splits for each level: \n 117: 8 \n Storm: 8 \n Ark: 9 \n Cov: 11 \n Halo: 6 \n" +
		"BTW you may want to make these splits into subsplits, see here: redd.it/84661r"
	);
	
	settings.Add("H3bsp_cache", false, "split on unfresh bsp loads", "H3bsp");
	settings.SetToolTip("H3bsp_cache", "With this disabled, only the first time you enter a specific bsp will cause a split. \n" +
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
	
	if (vars.H1_gameindicator.Current == "levels")
	{ 
		vars.watchers_h1.UpdateAll(game);
	} else if (vars.H2_gameindicator.Current == "scenario")  
	{
		vars.watchers_h2.UpdateAll(game);
		if (settings["H2bsp"])
		{ vars.watchers_h2bsp.UpdateAll(game); }
		if (settings["H2ILmode"])
		{ vars.watchers_h2IL.UpdateAll(game); }
	} else if (vars.H3_gameindicator.Current == "This")
	{
		if (settings["H3bsp"])
		{ vars.watchers_h3bsp.UpdateAll(game); }
		if (settings["H3ILmode"])
		{ vars.watchers_h3IL.UpdateAll(game); }
		
	}
	//print("h1_levelname" + vars.H1_level//name.Current);
	//print("h1_tickcounter" + vars.H1_tick//counter.Current);
	//print ("h2cs current" + vars.H2_CSind.Current);
}





start 	//starts timer
{	
	vars.dirtybsps.Clear();
	vars.h3dirtybsps.Clear();
	if (vars.H1_gameindicator.Current == "levels" && vars.menuindicator.Current == 7) //AKA if Halo 1 is loaded
	{
		if (settings["H1ILmode"])
		{
			return (
				(vars.H1_levelname.Current == "a10" && vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true) 
				|| (vars.H1_levelname.Current == "a30" && vars.H1_tickcounter.Current == 183) 
				|| (vars.H1_levelname.Current == "a50" && vars.H1_tickcounter.Current == 850) 
				|| (vars.H1_levelname.Current == "b30" && vars.H1_tickcounter.Current == 1093) 
				|| (vars.H1_levelname.Current == "b40" && vars.H1_tickcounter.Current == 966) 
				|| (vars.H1_levelname.Current == "c10" && vars.H1_tickcounter.Current == 717) 
				|| (vars.H1_levelname.Current == "c20" && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
				|| (vars.H1_levelname.Current == "c40" && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
				|| (vars.H1_levelname.Current == "d20" && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
				|| (vars.H1_levelname.Current == "d40" && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true)
			); 
		} else
		{
			return (vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true); //poa start code
		}
	} else if (vars.H2_gameindicator.Current == "scenario"  && vars.menuindicator.Current == 7) //AKA if Halo 2 is loaded
	{
		if (settings["H2ILmode"])
		{
			return (vars.H2_IGT.Current > 10 && vars.H2_IGT.Current < 30);
		}
		
		
		else if (settings["noarmory"])
		{
			
			if (vars.H2_levelname.Current == "01b" && vars.H2_cutsceneflag.Current == 128 &&  vars.H2_cutsceneflag.Old == 48 && vars.H2_tickcounter.Current <30) //start on cairo
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
				vars.armorysplit = false;
				return true;
			}; 
		} else
		{
			if (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current > 26 &&  vars.H2_tickcounter.Current < 30) //start on armory
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
				vars.armorysplit = false;
				return true;
				
			}
		}
	} else if (vars.H3_gameindicator.Current == "This"  && vars.menuindicator.Current == 7)
	{
		if (settings["H3ILmode"])
		{
			return (vars.H3_IGT.Current > 10 && vars.H2_IGT.Current < 30);
			
			
		}
		
	}
}



split
{ 
	if (vars.H1_gameindicator.Current == "levels") //AKA if Halo 1 is loaded
	{
		if (vars.menuindicator.Current == 7)
		{
			if (settings["multigamesplit"])
			{
				if (vars.H1_levelname.Current == "a10" &&  timer.CurrentPhase == TimerPhase.Running && vars.H1_tickcounter.Current > 280 && vars.H1_playerfrozen.Current == false && vars.H1_playerfrozen.Old == true && vars.H1_bspstate.Current == 0)
				{
					vars.dirtybsps.Clear();
					return true;
				}
			}
			
			
			
			if (settings["H1bsp"])
			{
				string checklevel = vars.H1_levelname.Current;
			if (settings["H1bsp_cache"])
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
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a10, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "a30":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a30, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "a50":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_a50, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "b30":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_b30, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "b40":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_b40, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "c10":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c10, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "c20":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c20, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "c40":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_c40, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "d20":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_d20, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					case "d40":
					if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_d40, x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H1_bspstate.Current)))
					{
						vars.dirtybsps.Add(vars.H1_bspstate.Current);
						return true;
					}
					break;
					
					default:
					break;
				}
				
			}
			
			
			if (settings["H1ILmode"])
			{
				return (
					((vars.stateindicator.Current == 57 || vars.stateindicator.Current == 44) && (vars.stateindicator.Old != 57 && vars.stateindicator.Old != 44) && vars.H1_levelname.Current != "d20") //split on PGCR or Loading screen
					|| (vars.H1_levelname.Current == "d20" && vars.H1_bspstate.Current == 3 && vars.H1_playerfrozen.Current == true && vars.H1_playerfrozen.Old == false) //Keyes ending to end time at start of cutscene instead of end of it
					|| (vars.H1_levelname.Current == "d40" && vars.H1_bspstate.Current == 7 && vars.H1_playerfrozen.Current == true && vars.H1_playerfrozen.Old == false) //Maw ending
				);
			} else
			{
				if (!(vars.H1_levelname.Current == "d40" && vars.H1_bspstate.Current == 7)) //!= maw last bsp
				{
					if(vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44) //split on loading screen
					{
						vars.dirtybsps.Clear();
						return true;
					}
				} else
				{
					if (vars.H1_bspstate.Current == 7 && vars.H1_playerfrozen.Current == true)//maw ending
					{
						vars.dirtybsps.Clear();
						return true;
					}
				}
			}
		}
	} else if (vars.H2_gameindicator.Current == "scenario") //AKA if Halo 2 is loaded
	{
		if (settings["multigamesplit"])
		{
			if (vars.armorysplit == false && timer.CurrentPhase == TimerPhase.Running && vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current > 26 &&  vars.H2_tickcounter.Current < 30)
			{
				vars.armorysplit = true;
				return true;
			}
		}
		
		if (settings["H2bsp"])
		{
			string checklevel = vars.H2_levelname.Current;
			
			if (settings["H2bsp_cache"])
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
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_01b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)) )
				{
					if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps.Contains(2)))
					{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
					
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "03a":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_03a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "03b":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_03b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "04a":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_04a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps.Contains(3)))
					{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "04b":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_04b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps.Contains(3)))
					{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "05a":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_05a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "05b":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_05b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "06a":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_06a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "06b":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_06b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "07a":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_07a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "08a":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_08a, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps.Contains(1)))
					{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "07b":
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.splitbsp_07b, x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps.Contains(vars.H2_bspstate.Current)))
				{
					vars.dirtybsps.Add(vars.H2_bspstate.Current);
					return true;
				}
				break;
				
				case "08b":
				//TGJ -- starts 0 and in cs, then goes to 1, then 0, then 1, then 0, then 3 (skipping 2 cos it's skippable)
				//so I have jank logic cos it does so much backtracking and backbacktracking
				if (vars.H2_bspstate.Current != vars.H2_bspstate.Old)
				{
					byte checkbspstate = vars.H2_bspstate.Current;
					switch (checkbspstate)
					{
						case 1:
						if (!(vars.dirtybsps.Contains(1)))
						{
							vars.dirtybsps.Add(1);
							return true;
						} else if (!(vars.dirtybsps.Contains(21)))
						{
							vars.dirtybsps.Add(21);
							return true;
						}
						
						break;
						
						case 0:
						if (!(vars.dirtybsps.Contains(10)))
						{
							vars.dirtybsps.Add(10);
							return true;
						} else if (!(vars.dirtybsps.Contains(20)))
						{
							vars.dirtybsps.Add(20);
							return true;
						}
						break;
						
						case 3:
						if (!(vars.dirtybsps.Contains(3)))
						{
							vars.dirtybsps.Add(3);
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
			vars.dirtybsps.Clear();
			return true;
		}
	} else if (vars.H3_gameindicator.Current == "This")
	{
	if ((vars.stateindicator.Old != 44 && vars.stateindicator.Old != 57) && (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57))
		{vars.h3dirtybsps.Clear();
		return true;	//hopefully doesn't split too early
		}
	
		string checklevel = vars.H3_levelname.Current;
		
	if (settings["H3bsp_cache"])
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
			if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_010, x => x == vars.H3_bspstate.Current) && !(vars.h3dirtybsps.Contains(vars.H3_bspstate.Current)))
			{
				vars.h3dirtybsps.Add(vars.H3_bspstate.Current);
				return true;
			}
			break;
			
			case "040":
			if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_040, x => x == vars.H3_bspstate.Current) && !(vars.h3dirtybsps.Contains(vars.H3_bspstate.Current)))
			{
				vars.h3dirtybsps.Add(vars.H3_bspstate.Current);
				return true;
			}
			break;
			
			case "070":
			if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_070, x => x == vars.H3_bspstate.Current) && !(vars.h3dirtybsps.Contains(vars.H3_bspstate.Current)))
			{
				vars.h3dirtybsps.Add(vars.H3_bspstate.Current);
				return true;
			}
			break;
			
			
			case "100":
			if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_100, x => x == vars.H3_bspstate.Current) && !(vars.h3dirtybsps.Contains(vars.H3_bspstate.Current)))
			{
				vars.h3dirtybsps.Add(vars.H3_bspstate.Current);
				return true;
			}
			break;
			
			case "120":
			if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.splitbsp_120, x => x == vars.H3_bspstate.Current) && !(vars.h3dirtybsps.Contains(vars.H3_bspstate.Current)))
			{
				vars.h3dirtybsps.Add(vars.H3_bspstate.Current);
				return true;
			}
			break;
			
			default:
			break;
		}
		
	}
	
}


reset
{ 
	if (!(settings["multigame"]))
	{
		if (vars.H1_gameindicator.Current == "levels" && vars.menuindicator.Current == 7) //AKA if Halo 1 is loaded
		{
			if (settings["H1ILmode"])
			{
				return (timer.CurrentPhase != TimerPhase.Ended &&(
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
				)); 
			} else
			{
				return (vars.H1_levelname.Current == "a10" && vars.H1_bspstate.Current == 0 && vars.H1_playerfrozen.Current == true); //reset on PoA
			}
		} else if (vars.H2_gameindicator.Current == "scenario" && vars.menuindicator.Current == 7) //AKA if Halo 2 is loaded
		{
			if (settings["H2ILmode"])
			{
				return (timer.CurrentPhase != TimerPhase.Ended && vars.H2_IGT.Current < 10);
			}
			else if (settings["noarmory"]) 
			{
				return (vars.H2_levelname.Current == "01b" && vars.H2_cutsceneflag.Current == 48 && vars.H2_tickcounter.Current <30); //reset on Cairo
			} else
			{
				return (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current <20); //reset on Armory 
			}
			
		} else if (vars.H3_gameindicator.Current == "This" && vars.menuindicator.Current == 7)
		{
			if (settings["H3ILmode"])
			{
				return ( timer.CurrentPhase != TimerPhase.Ended && vars.H3_IGT.Current < 10);
			}
		}
		
		
		
		
		
	}
}


isLoading
{
	if ((settings["H2ILmode"]) || (settings["H3ILmode"])) 
	{return true;}
	
	
	if (settings["multigame"] || vars.H1_gameindicator.Current == "levels") //timing for multigame and halo 1 is identical
	{
		return (vars.menuindicator.Current == 7 && vars.stateindicator.Current == 44);
	} else if (vars.H2_gameindicator.Current == "scenario") //if halo 2
	{
		if (vars.menuindicator.Current != 7)
		return false;
		
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
	}
}


gameTime
{
	if (settings["H2ILmode"] && vars.H2_gameindicator.Current == "scenario") 
	{return TimeSpan.FromMilliseconds(((1000.0 / 60.0) * vars.H2_IGT.Current) + 500);}
	
	if (settings["H3ILmode"] && vars.H3_gameindicator.Current == "This") 
	{return TimeSpan.FromMilliseconds(((1000.0 / 60.0) * vars.H3_IGT.Current) + 500);}
}









