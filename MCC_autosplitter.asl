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
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x038DC480, 0x28, 0x13FB373), 3))
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
			
		}
	} else if (modules.First().ToString() == "MCC-Win64-Shipping-WinStore.exe")
	{
		if (version == "1.1570.0.0")
		{
			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x36A1258))),
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x37CE0A9)))
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.H1_gameindicator = new StringWatcher(new DeepPointer(0x037B1420, 0x8, 0x115C6F1), 6)),
				(vars.H1_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0x8, 0x115C6F8), 3)),
				(vars.H2_gameindicator = new StringWatcher(new DeepPointer(0x037B1420, 0x28, 0x13FB364), 8)),
				(vars.H2_levelname = new StringWatcher(new DeepPointer(0x037B1420, 0x28, 0x13FB373), 3))
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x8, 0x1FA8B94))),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x8, 0x10CF324))),
				(vars.H1_playerfrozen = new MemoryWatcher<bool>(new DeepPointer(0x037B1420, 0x8, 0x224B0C0)))
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(0x037B1420, 0x28, 0xEADAD74))),
				(vars.H2_cutsceneflag = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x19A2AC8))),
				(vars.H2_CSind = new MemoryWatcher<byte>(new DeepPointer(0x037B1420, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C)))
			};
		}
	}
	
	//VARIABLE inits
	vars.loopcount = 0;
	//HALO 2
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
	
	settings.Add("ILmode", false, "Halo 1: IL mode");
	settings.Add("noarmory", false, "Halo 2: noarmory%");
	settings.Add("multigame", false, "Multi-game run (eg trilogy run)");
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
	}
	//print("h1_levelname" + vars.H1_level//name.Current);
	//print("h1_tickcounter" + vars.H1_tick//counter.Current);
	//print ("h2cs current" + vars.H2_CSind.Current);
}





start 	//starts timer
{	
	if (vars.H1_gameindicator.Current == "levels") //AKA if Halo 1 is loaded
	{
		if (settings["ILmode"])
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
	} else if (vars.H2_gameindicator.Current == "scenario") //AKA if Halo 2 is loaded
	{
		if (settings["noarmory"])
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
				{return true;
				}
			}
			
			if (settings["ILmode"])
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
					return(vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44); //split on loading screen
				} else
				{
					return (vars.H1_bspstate.Current == 7 && vars.H1_playerfrozen.Current == true); //maw ending
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
		
		return ((vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44 && vars.menuindicator.Current == 7) || (vars.H2_levelname.Current == "08b" && vars.H2_CSind.Current == 0x19 && vars.H2_CSind.Old != 0x19));
	}
	
}


reset
{ 
	if (!(settings["multigame"]))
	{
		if (vars.H1_gameindicator.Current == "levels") //AKA if Halo 1 is loaded
		{
			if (vars.menuindicator.Current == 7)
			{
				if (settings["ILmode"])
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
			}
		} else if (vars.H2_gameindicator.Current == "scenario") //AKA if Halo 2 is loaded
		{
			if (settings["noarmory"]) 
			{
				return (vars.H2_levelname.Current == "01b" && vars.H2_cutsceneflag.Current == 48 && vars.H2_tickcounter.Current <30); //reset on Cairo
			} else
			{
				return (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current <20); //reset on Armory 
			}
			
		}
	}
}


isLoading
{
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
				print("we paused for 01a");
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










