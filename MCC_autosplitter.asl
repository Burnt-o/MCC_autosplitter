//Halo: The Master Chief Collection Autosplitter
//Supports H1A and H2A
//Updated 2020/06/07
//by Burnt



state("MCC-Win64-Shipping", "1.1570.0.0") //AKA the Steam version of the game.
{	
	//GENERAL
	byte menuindicator: 0x37CC2D8; //07 in game (any game), some random junk when in main menu. used in combo with below and for sanity checking.
	byte stateindicator: 0x38F92D9; //pgcr = 57, load = 44, ig = 255, pause = 129, menu = 255
	
	//HALO 1
	//pointer for anything in halo1.dll is: 0x038DC480, 0x8, OFFSET
	string6 H1_gameindicator: 0x038DC480, 0x8, 0x115C6F1; //UPDATE THIS - - reads "levels" if halo1.dll loaded and offsets haven't been broken by a patch
	string3 H1_levelname: 0x038DC480, 0x8, 0x115C6F8; //indicates which level is loaded
	uint H1_tickcounter: 0x038DC480, 0x8, 0x1FA8B94; //counts game ticks since level start
	byte H1_bspstate: 0x038DC480, 0x8, 0x10CF324; //tracks which part of level is loaded
	bool H1_playerfrozen: 0x038DC480, 0x8, 0x224B0C0; //only true in cutscenes
	
	//HALO 2
	//pointer for anything in halo2.dll is: 0x038DC480, 0x28, OFFSET
	string8 H2_gameindicator: 0x038DC480, 0x28, 0x13FB364; //reads "scenario" if halo2.dll loaded and offsets haven't been broken by a patch
	string3 H2_levelname: 0x038DC480, 0x28, 0x13FB373; //indicates which level is loaded
	uint H2_tickcounter: 0x038DC480, 0x28, 0xEADAD74; //counts game ticks since level start
	byte H2_cutsceneflag: 0x038DC480, 0x28, 0x19A2AC8; //dec48 when in cutscene, dec128  when not, dec0 when out of level ALSO THIS FLAG LIESSSS
	byte H2_CSind: 0x038DC480, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C; //check .bk2 movie files at offset 18C for vals
	
}

state("MCC-Win64-Shipping-WinStore", "1.1570.0.0") //AKA the Microsoft Store version of the game.
{
	//GENERAL
	byte menuindicator: 0x36A1258; //07 in game (any game), 12 otherwise. used in combo with below and for sanity checking
	byte stateindicator: 0x37CE0A9; //pgcr = 57, load = 44, ig = 255, pause = 129, menu = 255 
	
	//HALO 1
	//pointer for anything in halo1.dll is: 0x037B1420, 0x8, OFFSET
	string6 H1_gameindicator: 0x037B1420, 0x8, 0x115C6F1; //UPDATE THIS - - reads "levels" if halo1.dll loaded and offsets haven't been broken by a patch
	string3 H1_levelname: 0x037B1420, 0x8, 0x115C6F8; //indicates which level is loaded
	uint H1_tickcounter: 0x037B1420, 0x8, 0x1FA8B94; //counts game ticks since level start
	byte H1_bspstate: 0x037B1420, 0x8, 0x10CF324; //tracks which part of level is loaded
	bool H1_playerfrozen: 0x037B1420, 0x8, 0x224B0C0; //only true in cutscenes
	
	//HALO 2
	//pointer for anything in halo2.dll is: 0x037B1420, 0x28, OFFSET
	string8 H2_gameindicator: 0x037B1420, 0x28, 0x13FB364; //reads "scenario" if halo2.dll loaded and offsets haven't been broken by a patch
	string3 H2_levelname: 0x037B1420, 0x28, 0x13FB373; //indicates which level is loaded
	uint H2_tickcounter: 0x037B1420, 0x28, 0xEADAD74; // counts game ticks since level start
	byte H2_cutsceneflag: 0x037B1420, 0x28, 0x19A2AC8; //dec48 when in cutscene, dec128  when not, dec0 when out of level ALSO THIS FLAG LIESSSS
	byte H2_CSind: 0x037B1420, 0x28, 0x0F1D9D70, 0x38, 0x78, 0x220, 0x15C; //check .bk2 movie files at offset 18C for vals
	
	
	
	
} 

init //variable initialization
{
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
	vars.adjust03b = 10 + 18;
	vars.adjust04a = 10 + 79;
	vars.adjust04b = 10 + 30;
	vars.adjust05a = 10 + 79;
	vars.adjust05b = 10 + 20;
	vars.adjust06a = 10 + 19;
	vars.adjust06b = 10 + 23;
	vars.adjust07a = 10 + 22;
	vars.adjust08a = 10 + 17;
	vars.adjust07b = 10 + 52;
	vars.adjust08b = 10 + 96;
	
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








start 	//starts timer
{	
	if (current.H1_gameindicator == "levels") //AKA if Halo 1 is loaded
	{
		if (settings["ILmode"])
		{
			return (
				(current.H1_levelname == "a10" && current.H1_tickcounter > 280 && current.H1_playerfrozen == false && old.H1_playerfrozen == true) 
				|| (current.H1_levelname == "a30" && current.H1_tickcounter == 183) 
				|| (current.H1_levelname == "a50" && current.H1_tickcounter == 850) 
				|| (current.H1_levelname == "b30" && current.H1_tickcounter == 1093) 
				|| (current.H1_levelname == "b40" && current.H1_tickcounter == 966) 
				|| (current.H1_levelname == "c10" && current.H1_tickcounter == 717) 
				|| (current.H1_levelname == "c20" && current.H1_playerfrozen == false && old.H1_playerfrozen == true)
				|| (current.H1_levelname == "c40" && current.H1_playerfrozen == false && old.H1_playerfrozen == true)
				|| (current.H1_levelname == "d20" && current.H1_playerfrozen == false && old.H1_playerfrozen == true)
				|| (current.H1_levelname == "d40" && current.H1_playerfrozen == false && old.H1_playerfrozen == true)
			); 
		} else
		{
			return (current.H1_tickcounter > 280 && current.H1_playerfrozen == false && old.H1_playerfrozen == true); //poa start code
		}
	} else if (current.H2_gameindicator == "scenario") //AKA if Halo 2 is loaded
	{
		if (settings["noarmory"])
		{
	
			if (current.H2_levelname == "01b" && current.H2_cutsceneflag == 128 && old.H2_cutsceneflag == 48 && current.H2_tickcounter <30) //start on cairo
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
			if (current.H2_levelname == "01a" && current.H2_tickcounter > 26 &&  current.H2_tickcounter < 30) //start on armory
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
	if (current.H1_gameindicator == "levels") //AKA if Halo 1 is loaded
	{
		if (current.menuindicator == 7)
		{
			if (settings["multigamesplit"])
			{
				if (current.H1_levelname == "a10" &&  timer.CurrentPhase == TimerPhase.Running && current.H1_tickcounter > 280 && current.H1_playerfrozen == false && old.H1_playerfrozen == true && current.H1_bspstate == 0)
				{return true;
				}
			}
			
			if (settings["ILmode"])
			{
				return (
					((current.stateindicator == 57 || current.stateindicator == 44) && (old.stateindicator != 57 && old.stateindicator != 44) && current.H1_levelname != "d20") //split on PGCR or Loading screen
					|| (current.H1_levelname == "d20" && current.H1_bspstate == 3 && current.H1_playerfrozen == true && old.H1_playerfrozen == false) //Keyes ending to end time at start of cutscene instead of end of it
					|| (current.H1_levelname == "d40" && current.H1_bspstate == 7 && current.H1_playerfrozen == true && old.H1_playerfrozen == false) //Maw ending
				);
			} else
			{
				if (!(current.H1_levelname == "d40" && current.H1_bspstate == 7)) //!= maw last bsp
				{
					return(current.stateindicator == 44 && old.stateindicator != 44); //split on loading screen
				} else
				{
					return (current.H1_bspstate == 7 && current.H1_playerfrozen == true); //maw ending
				}
			}
		}
	} else if (current.H2_gameindicator == "scenario") //AKA if Halo 2 is loaded
	{
		if (settings["multigamesplit"])
		{
			if (vars.armorysplit == false && timer.CurrentPhase == TimerPhase.Running && current.H2_levelname == "01a" && current.H2_tickcounter > 26 &&  current.H2_tickcounter < 30)
			{
				vars.armorysplit = true;
				return true;
			}
		}
		
		return ((current.stateindicator == 44 && old.stateindicator != 44 && current.menuindicator == 7) || (current.H2_levelname == "08b" && current.H2_CSind == 0x19 && old.H2_CSind != 0x19));
	}
	
}


reset
{ 
	if (current.H1_gameindicator == "levels") //AKA if Halo 1 is loaded
	{
		if (current.menuindicator == 7)
		{
			if (settings["ILmode"])
			{
				return (timer.CurrentPhase != TimerPhase.Ended &&(
					(current.H1_levelname == "a10" && current.H1_bspstate == 0 && current.H1_playerfrozen == true) 
					|| (current.H1_levelname == "a30" && current.H1_tickcounter < 50) 
					|| (current.H1_levelname == "a50" && current.H1_tickcounter < 500) 
					|| (current.H1_levelname == "b30" && current.H1_tickcounter < 500) 
					|| (current.H1_levelname == "b40" && current.H1_tickcounter < 500) 
					|| (current.H1_levelname == "c10" && current.H1_tickcounter < 500) 
					|| (current.H1_levelname == "c20" && current.H1_playerfrozen == true && current.H1_tickcounter < 50)
					|| (current.H1_levelname == "c40" && current.H1_playerfrozen == true && current.H1_tickcounter < 50)
					|| (current.H1_levelname == "d20" && current.H1_playerfrozen == true && current.H1_tickcounter < 50)
					|| (current.H1_levelname == "d40" && current.H1_playerfrozen == true && current.H1_tickcounter < 50)
				)); 
			} else
			{
				return (current.H1_levelname == "a10" && current.H1_bspstate == 0 && current.H1_playerfrozen == true); //reset on PoA
			}
		}
	} else if (current.H2_gameindicator == "scenario") //AKA if Halo 2 is loaded
	{
		if (settings["noarmory"]) 
		{
			return (current.H2_levelname == "01b" && current.H2_cutsceneflag == 48 && current.H2_tickcounter <30); //reset on Cairo
		} else
		{
			return (current.H2_levelname == "01a" && current.H2_tickcounter <20); //reset on Armory 
		}
		
	}
}


isLoading
{
	if (settings["multigame"] || current.H1_gameindicator == "levels") //timing for multigame and halo 1 is identical
	{
		return (current.menuindicator == 7 && current.stateindicator == 44);
	} else if (current.H2_gameindicator == "scenario") //if halo 2
	{
		if (current.menuindicator != 7)
		return false;
		
		string H2_checklevel = current.H2_levelname;
		switch (H2_checklevel)
		{
			case "01a": //The Armory
			if (current.stateindicator == 44 || current.stateindicator == 57)    
			{
				vars.ending01a = true;
			}
			return (vars.ending01a);
			break;
			
			case "01b": //Cairo Station
			if (vars.ending01a == true && current.H2_CSind != 0xD9 && current.H2_tickcounter > vars.adjust01b && current.stateindicator != 44)   //intro cutscene over check 
			vars.ending01a = false; 
			if (vars.ending01a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0xE5))    //outro cutscene started check
			vars.ending01b = true;
			return (vars.ending01a || vars.ending01b);
			break;
			
			case "03a": //Outskirts
			if (vars.ending01b == true && current.H2_CSind != 0xB1 && current.H2_tickcounter > vars.adjust03a && current.stateindicator != 44) 
			vars.ending01b = false;
			if (vars.ending01b == false && (current.stateindicator == 44 || current.stateindicator == 57)) //outskirts has no outro cs
			vars.ending03a = true;
			return (vars.ending01b || vars.ending03a);
			break;
			
			case "03b": //Metropolis
			if (vars.ending03a == true && (current.H2_CSind != 0xF1 && current.H2_CSind != 0xB5 && current.H2_CSind != 0x8D && current.H2_CSind != 0xD5) && current.H2_tickcounter > vars.adjust03b && current.stateindicator != 44) //4 variations of intro cs for difficulties
			vars.ending03a = false;
			if (vars.ending03a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0xDD))
			vars.ending03b = true;	
			return (vars.ending03a || vars.ending03b);
			break;
			
			case "04a": //The Arbiter
			if (vars.ending03b == true && current.H2_CSind != 0x9D && current.H2_tickcounter > vars.adjust04a && current.stateindicator != 44) 
			vars.ending03b = false;
			if (vars.ending03b == false && (current.stateindicator == 44 || current.stateindicator == 57)) //the arbiter has no outro cs
			vars.ending04a = true;	
			return (vars.ending03b || vars.ending04a);
			break;
			
			case "04b": //Oracle
			if (vars.ending04a == true && current.H2_CSind != 0x61 && current.H2_tickcounter > vars.adjust04b && current.stateindicator != 44) 
			vars.ending04a = false;
			if (vars.ending04a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0x31)) 
			vars.ending04b = true;	
			return (vars.ending04a || vars.ending04b);
			break;
			
			case "05a": //Delta Halo
			if (vars.ending04b == true && current.H2_CSind != 0x69 && current.H2_tickcounter > vars.adjust05a && current.stateindicator != 44) 
			vars.ending04b = false;
			if (vars.ending04b == false && (current.stateindicator == 44 || current.stateindicator == 57)) //delta halo has no outro cs
			vars.ending05a = true;	
			return (vars.ending04b || vars.ending05a);
			break;
			
			case "05b": //Regret
			if (vars.ending05a == true && current.H2_CSind != 0x6D && current.H2_tickcounter > vars.adjust05b && current.stateindicator != 44) 
			vars.ending05a = false;
			if (vars.ending05a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0x45)) 
			vars.ending05b = true;	
			return (vars.ending05a || vars.ending05b);
			break;
			
			case "06a": //Sacred Icon
			if (vars.ending05b == true && current.H2_CSind != 0xA1 && current.H2_tickcounter > vars.adjust06a && current.stateindicator != 44) 
			vars.ending05b = false;
			if (vars.ending05b == false && (current.stateindicator == 44 || current.stateindicator == 57)) //sacred icon has no outro cs
			vars.ending06a = true;	
			return (vars.ending05b || vars.ending06a);
			break;
			
			case "06b": //Quarantine Zone
			if (vars.ending06a == true && current.H2_CSind != 0x85 && current.H2_tickcounter > vars.adjust06b && current.stateindicator != 44) 
			vars.ending06a = false;
			if (vars.ending06a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0x75)) 
			vars.ending06b = true;	
			return (vars.ending06a || vars.ending06b);
			break;
			
			case "07a": //Gravemind
			if (vars.ending06b == true && current.H2_CSind != 0x15 && current.H2_tickcounter > vars.adjust07a && current.stateindicator != 44) 
			vars.ending06b = false;
			if (vars.ending06b == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0xF9)) 
			vars.ending07a = true;	
			return (vars.ending06b || vars.ending07a);
			break;
			
			case "08a": //Uprising
			if (vars.ending07a == true && current.H2_CSind != 0xB9 && current.H2_tickcounter > vars.adjust08a && current.stateindicator != 44) 
			vars.ending07a = false;
			if (vars.ending07a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0x21)) 
			vars.ending08a = true;	
			return (vars.ending07a || vars.ending08a);
			break;
			
			case "07b": //High Charity
			if (vars.ending08a == true && current.H2_CSind != 0x4D && current.H2_tickcounter > vars.adjust07b && current.stateindicator != 44) 
			vars.ending08a = false;
			if (vars.ending08a == false && (current.stateindicator == 44 || current.stateindicator == 57 || current.H2_CSind == 0x79)) 
			vars.ending07b = true;	
			return (vars.ending08a || vars.ending07b);
			break;
			
			case "08b": //The Great Journey
			if (vars.ending07b == true && current.H2_CSind != 0xF5 && current.H2_tickcounter > vars.adjust08b && current.stateindicator != 44) 
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










