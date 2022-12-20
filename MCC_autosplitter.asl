//Halo: The Master Chief Collection Autosplitter
//by Burnt and Cambid

//NOTES
/*
	Nothing to see here currently
*/

state("MCC-Win64-Shipping") {}
state("MCC-Win64-Shipping-WinStore") {} 
state("MCCWinStore-Win64-Shipping") {} //what the fuck 343?!


init //hooking to game to make memorywatchers
{
	
	//need to clear pause flags incase of restart/crash
	vars.loading = false;

	if (settings["perfmode"]) {refreshRate = 30;} else {refreshRate = 60;}	//Set autosplitter refresh rate. Probably doesn't help much. Whatever


	var message = "It looks like MCC has received a new patch that will "+
	"probably break me (the autosplitter). \n"+
	"Autosplitter was made for version: "+ "1.3073.0.0" + "\n" + 
	"Current detected version: "+ modules.First().FileVersionInfo.FileVersion + "\n" +
	"If I'm broken, you'll just have to wait for Burnt or Cambid to update me. "+
	"You won't need to do anything except restart Livesplit once I'm updated.";
	
	//so the latest version of winstore (as of v2904), has a fun issue where you can't get the FileVersion from the module like you normally can
	//so this backup code will check for that failure and attempt to get it from the filepath
	
	//first check for the failure
	string testversion = modules.First().FileVersionInfo.FileVersion; 
	var winstorefileversioncheck = (testversion == null && (modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase)));
	if (winstorefileversioncheck) 
	{
		print ("dear god why");
		print (modules.First().FileName.ToString());
		var test = modules.First().FileName.ToString(); //get the filepath of the winstore exe
		var test2 = test.IndexOf("Chelan"); //check where the index of the word "Chelan" is in the filepath 
		if (test2 != -1) //-1 if it didn't find "Chelan"
		{
			var test3 = test.Substring(test2 + 7, 10); //move to the right of the filepath to get the version number
			print (test3);
			
			if (test3.Substring(1, 1) == ".") //sanity check
			testversion = test3;
		}
		
		if (testversion == null) //if our code didn't find the version, modify the error message to display below
		{
			message = "An issue with newer releases of WinStore MCC " + "\n" +
			"has broken some of my version checking code." + "\n" +
			"For now I'll assume you're on the latest patch and try to work anyway.";
		}
	}
	
	
	//version check and warning message for invalid version  
	switch (testversion)
	{
		case "1.2448.0.0":
			version = "1.2448.0.0";
		break;
		
		case "1.2645.0.0":
			version = "1.2645.0.0";
		break;
		
		case "1.2904.0.0":
			version = "1.2904.0.0";
		break;

		case "1.2969.0.0":
			version = "1.2969.0.0";
		break;

		case "1.3065.0.0":
			version = "1.3065.0.0";
		break;

		case "1.3073.0.0":
			version = "1.3073.0.0";
		break;
		
		default: 
			version = "1.3073.0.0";
			if (vars.brokenupdateshowed == false)
			{
				vars.brokenupdateshowed = true;
				var brokenupdateMessage = MessageBox.Show(message,
					vars.aslName+" | LiveSplit",
					MessageBoxButtons.OK 
				);
			}
		break;
	}
	
	//STATE init
	Int32 dllPointer = 0; //Game dll base address pointer. Define here to avoid mass copypasta
	switch (version)
	{
		case "1.3073.0.0":
			if (modules.First().ToString().Equals("MCC-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Steam
			{
				dllPointer = (0x401C208);
			
				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3EE3FA9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3FD8E99)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x401C1C0, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x401C204)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			else if (modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Winstore
			{
				dllPointer = (0x3E6B858); 

				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3D33AA9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3E28465)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x3E6B810, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3E6B854)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x8, 0x2CA07CC), 3)),
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2CEBD34)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x3008134)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x1CECDFC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x3005198, 0x0A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x3005198, 0x0B)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_check = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2C9F828)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2F00954)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2F00958)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2CA0797)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1fade = new MemoryWatcherList(){
				(vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x300D678, 0x3C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x8, 0x300D678, 0x3C4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x300D678, 0x3C6)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x28, 0xE6ED78), 3)),
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x15E1D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x15A1BA0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0x15F42B8, -0x92E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_letterbox = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0x15F42B8, -0x938)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_graphics = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xE1F178)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xDF7D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xE7E308)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xE7E30C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2fade = new MemoryWatcherList(){
				(vars.H2_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x15E9458, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H2_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x28, 0x15E9458, 0x4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x28, 0xE7E760, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x48, 0x1E92AB8), 3)), 
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x48, 0x1F2084C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x48, 0xA39220, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x48, 0x1E19C98, 0xFDCD)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xC8, 0x2A2F6D7), 3)),
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xC8, 0x3B9C020)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xC8, 0x250B808, 0x1ED09)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xA8, 0x20C0DA8), 4)),
				(vars.ODST_streets = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0xA8, 0x21463B4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.ODST_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xA8, 0x33FD0DC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.ODST_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xA8, 0xFDEAFC, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h4 = new MemoryWatcherList() {
				(vars.H4_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x68, 0x2AE485F), 3))
			};
			
			vars.watchers_h4bsp = new MemoryWatcherList() {
				(vars.H4_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x68, 0x2746930)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};

		break;



		case "1.3065.0.0":
			if (modules.First().ToString().Equals("MCC-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Steam
			{
				dllPointer = (0x401C208);
			
				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3EE3FA9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3FD8E99)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x401C1C0, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x401C204)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			else if (modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Winstore
			{
				dllPointer = (0x03E6B870); 

				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3D33AA9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3E28465)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x3E6B828, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3E6B86C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x8, 0x2CA07BC), 3)),
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2CEBCF4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x3008134)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x1CECE14)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x3005190, 0x0A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x3005190, 0x0B)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_check = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2C9F818)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2F00944)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2F00948)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2CA0787)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1fade = new MemoryWatcherList(){
				(vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x300D678, 0x3C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x8, 0x300D678, 0x3C4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x300D678, 0x3C6)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x28, 0xE6ED78), 3)),
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x15E1D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x15A1BA0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0x15F42B8, -0x92E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_letterbox = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0x15F42B8, -0x938)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_graphics = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xE1F178)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xDF7D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xE7E308)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xE7E30C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2fade = new MemoryWatcherList(){
				(vars.H2_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x15E9458, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H2_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x28, 0x15E9458, 0x4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x28, 0xE7E760, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x48, 0x1E92AB8), 3)), 
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x48, 0x1F2084C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x48, 0xA39220, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x48, 0x1E19C98, 0xFDCD)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xC8, 0x2A2F6D7), 3)),
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xC8, 0x3B9C020)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xC8, 0x250B808, 0x1ED09)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xA8, 0x20C0DA8), 4)),
				(vars.ODST_streets = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0xA8, 0x21463B4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.ODST_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xA8, 0x33FD0DC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.ODST_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xA8, 0xFDEAFC, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h4 = new MemoryWatcherList() {
				(vars.H4_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x68, 0x2AE47DF), 3))
			};
			
			vars.watchers_h4bsp = new MemoryWatcherList() {
				(vars.H4_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x68, 0x27468B0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};

		break;



		case "1.2969.0.0":
			if (modules.First().ToString().Equals("MCC-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Steam
			{
				dllPointer = (0x3F94F90);
			
				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3E5DF29)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3F519E9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x3F94E90, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3F94F88)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			else if (modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Winstore
			{
				dllPointer = (0x3DE6578); 

				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3CAFAA9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3DA30E5)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x3DE6468, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3DE6570)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x8, 0x2CC58AC), 3)),
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2CECFD4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2FFEC94)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x1CE4920)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2FFBD28, 0x0A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2FFBD28, 0x0B)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_check = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2EEB088)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x1DF5FF8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x1DF5FFC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2CC5877)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1fade = new MemoryWatcherList(){
				(vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x030041A8, 0x3C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x8, 0x030041A8, 0x3C4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x030041A8, 0x3C6)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x28, 0xD54498), 3)),
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14C7494)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14872C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0x14D9448, -0x92E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_letterbox = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0x14D9448, -0x938)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_graphics = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCD8998)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCB2D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xD63A28)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xD63A2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2fade = new MemoryWatcherList(){
				(vars.H2_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14CEB68, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H2_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x28, 0x14CEB68, 0x4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x28, 0xD63E80, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x48, 0x1EABB78), 3)), 
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x48, 0x1DC6200)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x48, 0xA41D20, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x48, 0x01E30758, 0x1074D)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xC8, 0x2A39A8F), 3)),
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xC8, 0x3BB32A0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xC8, 0x02514A88, 0x1F419)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xA8, 0x20D68F8), 4)),
				(vars.ODST_streets = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0xA8, 0x21DD308)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.ODST_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xA8, 0x3417D4C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.ODST_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xA8, 0xFB940C, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h4 = new MemoryWatcherList() {
				(vars.H4_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x68, 0x2B03887), 3))
			};
			
			vars.watchers_h4bsp = new MemoryWatcherList() {
				(vars.H4_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x68, 0x27564B0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};

		break;



		case "1.2904.0.0":
			if (modules.First().ToString().Equals("MCC-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Steam
			{
				dllPointer = (0x3F7BA50);

				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3E45529)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), 
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3F2FBC9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
				
				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x03F7C380, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3F7C33C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}
			else if (modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Winstore
			{
				dllPointer = (0x3E1F540);

				vars.watchers_fast = new MemoryWatcherList() {
					(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3CE9329)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
					(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3DD36E9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_slow = new MemoryWatcherList() {
					(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x03E1FE60, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};

				vars.watchers_igt = new MemoryWatcherList() {
					(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3E1FE1C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
				};
			}

			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x8, 0x2B611EC), 3)),
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2B88764)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2E7A354)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x1B661CC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x02E773D8, 0x0A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x02E773D8, 0x0B)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_check = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2D66A88)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2D7313C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2D73140)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2B611B7)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1fade = new MemoryWatcherList(){
				(vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2E7F868, 0x3C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x8, 0x2E7F868, 0x3C4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x2E7F868, 0x3C6)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x28, 0xD4ABF8), 3)),
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14BDBC4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x147D9F0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0x01520498, -0x92E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_letterbox = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0x01520498, -0x938)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_graphics = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCCF280)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //scan for FF FF FF FF 2A 0A 00 0D on outskirts. Should be around here somewhere
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCACD74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xD5A148)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xD5A14C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2fade = new MemoryWatcherList(){
				(vars.H2_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14C5228, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H2_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x28, 0x14C5228, 0x4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x28, 0x00D5A5A0, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x48, 0x1E092E8), 3)), 
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x48, 0x1EF61E8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x48, 0x99FCA0, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x48, 0x1D8DF48, 0x1073D)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xC8, 0x28A4C3F), 3)),
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xC8, 0x3719E24)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xC8, 0x23CC7D8, 0x1F419)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xA8, 0x202EA58), 4)),
				(vars.ODST_streets = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0xA8, 0x21353D8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.ODST_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xA8, 0x2F9FD4C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.ODST_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xA8, 0x00F3EB8C, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h4 = new MemoryWatcherList() {
				(vars.H4_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x68, 0x29A3743), 3))
			};
			
			vars.watchers_h4bsp = new MemoryWatcherList() {
				(vars.H4_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x68, 0x25DC188)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};

		break;



		//Legacy Steam Support - No Winstore
		case "1.2645.0.0":
			dllPointer = (0x3B80E98);

			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x3A4A7C9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //behaviour changed to 07 and 0B, instead of 07 and 0C
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x3b40d69)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x03B81270, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
			};

			vars.watchers_igt = new MemoryWatcherList() {
				(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3B80FF8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x8, 0x2AF8288), 3)),
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2B5FC04)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2AFB954)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x19F748C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2af89b8, 0x0A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2af89b8, 0x0B)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_check = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2A52DE8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2A5EFF4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2A5EFF8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2AF8257)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};

			vars.watchers_h1fade = new MemoryWatcherList(){
				(vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2B88E58, 0x3C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x8, 0x2B88E58, 0x3C4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x2B88E58, 0x3C6)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x28, 0xD42E68), 3)),
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14B5DE4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x1475C10)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0x015186A0, -0x92E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_letterbox = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0x015186A0, -0x938)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_graphics = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCC74A8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //scan for FF FF FF FF 2A 0A 00 0D on outskirts. Should be around here somewhere
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCA4D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xD523A8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xD523AC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2fade = new MemoryWatcherList(){
				(vars.H2_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x14BD450, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H2_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x28, 0x14BD450, 0x4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x28, 0x00D52800, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x48, 0x1e0d358), 3)), 
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x48, 0x1F34A68)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x48, 0x009A4Ba0, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x48, 0x1D91E68, 0x1077D)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xC8, 0x2907107), 3))
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xC8, 0x3716270)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xC8, 0x00EEF330, 0x594249)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xA8, 0x2020CA8), 4)),
				(vars.ODST_streets = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0xA8, 0x2116FD8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.ODST_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xA8, 0x2F91A9C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.ODST_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xA8, 0x00F3020c, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h4 = new MemoryWatcherList() {
				(vars.H4_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x68, 0x2836433), 3))
			};
			
			vars.watchers_h4bsp = new MemoryWatcherList() {
				(vars.H4_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x68, 0x2472A88)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};

		break;



		case "1.2448.0.0":
			dllPointer = (0x3A24FF8);

			vars.watchers_fast = new MemoryWatcherList() {
				(vars.menuindicator = new MemoryWatcher<byte>(new DeepPointer(0x38EF0A9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}), //behaviour changed to 07 and 0B, instead of 07 and 0C
				(vars.stateindicator = new MemoryWatcher<byte>(new DeepPointer(0x39E4DE9)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_slow = new MemoryWatcherList() {
				(vars.gameindicator = new MemoryWatcher<byte>(new DeepPointer(0x3A253A0, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //scan for 8B 4B 18 ** ** ** ** **    48 8B 5C 24 30  89 07 nonwriteable, check what 89 07 writes to
			};

			vars.watchers_igt = new MemoryWatcherList() {
				(vars.IGT_float = new MemoryWatcher<float>(new DeepPointer(0x3A25188)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1 = new MemoryWatcherList() {
				(vars.H1_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x8, 0x2AF111C), 3)),
				(vars.H1_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2B58A24)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2AF477C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x19F0400)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cinematic = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2AF1868, 0x0A)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_cutsceneskip = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2AF1868, 0x0B)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_check = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2A4BC68)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1xy = new MemoryWatcherList() {
				(vars.H1_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2A57E74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x8, 0x2A57E78)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h1death = new MemoryWatcherList(){
				(vars.H1_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x8, 0x2AF10E7)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};

			vars.watchers_h1fade = new MemoryWatcherList(){
				(vars.H1_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x8, 0x2B81CE8, 0x3C0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H1_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x8, 0x2B81CE8, 0x3C4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H1_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x8, 0x2B81CE8, 0x3C6)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2 = new MemoryWatcherList() {
				(vars.H2_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x28, 0xE63FB3), 3)),
				(vars.H2_tickcounter = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0xE63144)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_IGT = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0xE22F40)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_fadebyte = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0x0143ACA0, -0x92E)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_letterbox = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0x0143ACA0, -0x938)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_graphics = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCFB918)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) //scan for FF FF FF FF 2A 0A 00 0D on outskirts. Should be around here somewhere
			};
			
			vars.watchers_h2bsp = new MemoryWatcherList() {
				(vars.H2_bspstate = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0x28, 0xCD7D74)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h2xy = new MemoryWatcherList() {
				(vars.H2_xpos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xDA5CD8)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
				(vars.H2_ypos = new MemoryWatcher<float>(new DeepPointer(dllPointer, 0x28, 0xDA5CDC)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};

			vars.watchers_h2fade = new MemoryWatcherList(){
				(vars.H2_fadetick = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x28, 0x13DFC58, 0x0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),	
				(vars.H2_fadelength = new MemoryWatcher<ushort>(new DeepPointer(dllPointer, 0x28, 0x13DFC58, 0x4)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}),
			};
			
			vars.watchers_h2death = new MemoryWatcherList(){
				(vars.H2_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x28, 0x00DA6140, -0xEF)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h3 = new MemoryWatcherList() {
				(vars.H3_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x48, 0x1D2C460), 3)), 
				(vars.H3_theatertime = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0x48, 0x1E36118)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3bsp = new MemoryWatcherList() {
				(vars.H3_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x48, 0x009F3EF0, 0x2C)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_h3death = new MemoryWatcherList(){
				(vars.H3_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0x48, 0x1CB15C8, 0x1051D)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hr = new MemoryWatcherList() {
				(vars.HR_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xC8, 0x2868777), 3))
			};
			
			vars.watchers_hrbsp = new MemoryWatcherList() {
				(vars.HR_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xC8, 0x36778E0)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_hrdeath = new MemoryWatcherList(){
				(vars.HR_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xC8, 0x00EEFEB0, 0x544249)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odst = new MemoryWatcherList() {
				(vars.ODST_levelname = new StringWatcher(new DeepPointer(dllPointer, 0xA8, 0x1CDF200), 4)),
				(vars.ODST_streets = new MemoryWatcher<byte>(new DeepPointer(dllPointer, 0xA8, 0x1DB2568)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_odstbsp = new MemoryWatcherList() {
				(vars.ODST_bspstate = new MemoryWatcher<uint>(new DeepPointer(dllPointer, 0xA8, 0x2E46964)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};
			
			vars.watchers_odstdeath = new MemoryWatcherList(){
				(vars.ODST_deathflag = new MemoryWatcher<bool>(new DeepPointer(dllPointer, 0xA8, 0x00E8520C, -0x913)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull})
			};
			
			vars.watchers_h4 = new MemoryWatcherList() {
				(vars.H4_levelname = new StringWatcher(new DeepPointer(dllPointer, 0x68, 0x276ACA3), 3))
			};
			
			vars.watchers_h4bsp = new MemoryWatcherList() {
				(vars.H4_bspstate = new MemoryWatcher<ulong>(new DeepPointer(dllPointer, 0x68, 0x2441AB8, -0x560)) { FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull}) 
			};

		break;
	}
		

	//version dependant consts
	switch (version)
	{
		case "1.3073.0.0":
		case "1.3065.0.0":
			vars.H1_checklist = new Dictionary<string, uint>{{"a10", 3589325267},{"a30", 3649693672},{"a50", 1186687708},{"b30", 1551598635},{"b40", 1100623455},{"c10", 3494823778},{"c20", 2445460720},{"c40", 3759075146},{"d20", 3442848200},{"d40", 1751474532},};
		break;

		case "1.2969.0.0":
			vars.H1_checklist = new Dictionary<string, uint>{{"a10", 2023477633},{"a30", 1197744442},{"a50", 522123179},{"b30", 2022995318},{"b40", 4112928798},{"c10", 4250424451},{"c20", 1165450382},{"c40", 2733116763},{"d20", 1722772470},{"d40", 3775314541},};
		break;

		case "1.2904.0.0":
			vars.H1_checklist = new Dictionary<string, uint>{{"a10", 89028072},{"a30", 1083179843},{"a50", 2623582826},{"b30", 1895318681},{"b40", 1935970024},{"c10", 974037405},{"c20", 714510620},{"c40", 2859044941},{"d20", 1178559651},{"d40", 3253884125},};
		break;

		case "1.2645.0.0":
			vars.H1_checklist = new Dictionary<string, uint>{{"a10", 4031641132},{"a30", 1497905037},{"a50", 2613596386},{"b30", 4057206713},{"b40", 2439716616},{"c10", 2597150717},{"c20", 1656675814},{"c40", 1573304389},{"d20", 1507739304},{"d40", 2038583061},};
		break;

		case "1.2448.0.0":
			vars.H1_checklist = new Dictionary<string, uint>{{"a10", 2495112808},{"a30", 1196246201},{"a50", 3037603536},{"b30", 682311759},{"b40", 326064131},{"c10", 645721511},{"c20", 540616268},{"c40", 1500399674},{"d20", 2770760039},{"d40", 1695151528},};
			vars.fadescale = 0.183;
		break;
	}
}


startup //variable init and settings
{ 	
	//MOVED VARIABLE INIT TO STARTUP TO PREVENT BUGS WHEN RESTARTING (OR CRASHING) MCC MID RUN
	vars.brokenupdateshowed = false;
	vars.loopcount = 0;

	//GENERAL VARS INIT - most of these need to be reinit on timer reset
	vars.varsreset = false;
	vars.partialreset = false;

	vars.dirtybsps_byte = new List<byte>();
	vars.dirtybsps_int = new List<uint>();
	vars.dirtybsps_long = new List<ulong>();

	vars.startedlevel = "000";
	vars.levelloaded = "000";
	vars.startedgame = 10;
	vars.startedscene = 0; //default to recon helmet, 0 on recon helmet/ptd, 100 on drone optic, 110 on guass turret etc etc

	vars.loopsplit = true;
	vars.forcesplit = false;
	vars.forcesplit2 = false;

	vars.H2_tgjreadyflag = false;
	vars.H2_tgjreadytime = 0;
	vars.lastinternal = false;
	vars.oldtick = -2;
	vars.loading = false;
	vars.multigamepause = false;
	vars.multigametime = TimeSpan.Zero;

	vars.gametime = TimeSpan.Zero;
	vars.ingametime = 0;
	vars.leveltime = 0;
	vars.pgcrexists = false;

	vars.isvalid = false;
	vars.ctime = TimeSpan.Zero;
	vars.diff = TimeSpan.Zero;


	//GENERAL CONSTANTS INIT
	vars.fadescale = 0.067;
	vars.H1_checklist = new Dictionary<string, uint>{};

	//LEVEL LIST
	//HALO 1
	vars.H1_levellist = new Dictionary<string, byte[]>{
		{"a10", new byte[] { 1, 2, 3, 4, 5, 6 }}, //poa
		{"a30", new byte[] { 1 }}, //halo
		{"a50", new byte[] { 1, 2, 3 }}, //tnr
		{"b30", new byte[] { 1 }}, //sc
		{"b40", new byte[] { 0, 1, 2, 4, 8, 9, 10, 11 }}, //aotcr - could put the others in for fullpath andys?
		{"c10", new byte[] { 1, 3, 4, 5 }}, //343
		{"c20", new byte[] { 1, 2, 3 }}, //library
		{"c40", new byte[] { 12, 10, 1, 9, 8, 6, 0, 5 }}, //tb
		{"d20", new byte[] { 4, 3, 2 }}, //keyes
		{"d40", new byte[] { 1, 2, 3, 4, 5, 6, 7 }}, //maw
	};
	

	//HALO 2
	vars.H2_levellist = new Dictionary<string, byte[]>{
		{"01b", new byte[] { 2, 0, 3 }}, //cairo
		{"03a", new byte[] { 1, 2 }}, //os
		{"03b", new byte[] { 1 }}, //metro
		{"04a", new byte[] { 3, 0 }}, //arby - 2, 0, 4, and 1 are using in cs 
		{"04b", new byte[] { 0, 2, 1, 5 }}, //here - 0 in cs, 3 at start, returns to 0 later gah - maybe skip the 4 split cos it's just for like 10s when cables cut
		{"05a", new byte[] { 1 }}, //dh - flahses between 2 and 0 in cs
		{"05b", new byte[] { 1, 2 }}, //reg - 0 in cs. skipping 3 & 4 since it's autoscroller
		{"06a", new byte[] { 1, 2 }}, //si - 0 then 3 in cs, starts on 0
		{"06b", new byte[] { 1, 2, 3 }}, //qz- there are more besides this but all during autoscroller
		{"07a", new byte[] { 1, 2, 3, 4, 5 }}, //gm - 7 & 0 in cs
		{"08a", new byte[] { 1, 0 }}, //up -- hits 0 again after 1. ignoring skipable
		{"07b", new byte[] { 1, 2, 4 }}, //HC -- none if doing HC skip
		{"08b", new byte[] { 0, 1, 3 }}, //TGJ -- starts 0 and in cs, then goes to 1, then 0, then 1, then 0, then 3 (skipping 2 cos it's skippable)
	};
	
	
	//HALO 3
	vars.H3_levellist = new Dictionary<string, ulong[]>{
		{"010", new ulong[] { 7, 4111, 4127, 8589938751, 12884907135, 4294972543, 4294972927, 6143 }}, //sierra
		{"020", new ulong[] { 2753726871765283, 351925325267239, 527984624664871, 527980329698111, 355107896034111, 495845384389503, 1058778157941759, 2081384101315583, 2076028277097471, 2043042928264191 }}, //crows
		{"030", new ulong[] { 708669603847, 1812476198927, 1709396983839, 128849018943, 2327872274495 }}, //tsavo
		{"040", new ulong[] { 70746701299715, 76347338653703, 5987184410895, 43920335569183, 52712133624127, 4449586119039, 110002702385663, 127560528691711 }}, //storm
		{"050", new ulong[] { 137438953607, 154618822791, 167503724703, 98784247967, 98784247999, 133143986431, 111669150207 }}, //floodgate
		{"070", new ulong[] { 319187993615142919, 497073530286903311, 5109160733019475999, 7059113264503853119, 7058267740062093439, 5296235395170702591, 6467180094380056063, 6471685893030682623, 6453663797939806207 }}, //ark
		{"100", new ulong[] { 4508347378708774919, 2060429875000377375, 4384271889560765215, 2060429875000378143, 4508347378708775711, 4229124150272197439, 4105313024951190527, 4159567262287660031, 4153434048988972031, 4099400491367139327, 21673629041340192 }}, //covie
		{"110", new ulong[] { 4294967459, 4294967527, 4294967535, 4294967551 }}, //cortana
		{"120", new ulong[] { 1030792151055, 691489734703, 1924145349759, 1133871367679, 1202590844927, 1219770714111 }}, //halo
	};


	//HALO REACH
	vars.HR_levellist = new Dictionary<string, uint[]>{
		{"m10", new uint[] { 143, 175, 239, 495 }}, //wc
		{"m20", new uint[] { 249, 505, 509, 511 }}, //oni
		{"m30", new uint[] { 269, 781, 797, 1821, 1853, 1917 }}, //nf
		{"m35", new uint[] { 4111, 4127, 4223, 4607, 5119 }}, //tots
		{"m45", new uint[] { 31, 383, 10111, 12159, 16255, 32639 }}, //lnos, might have to swap 895 for 10111 since former is cs only. 127 is cs only too, swap for 383?
		{"m50", new uint[] { 5135, 5151, 5247, 5631, 8191 }}, //exo
		{"m52", new uint[] {  }}, //fuck na
		{"m60", new uint[] { 113, 125, 4221, 4223, 5119 }}, //package
		{"m70", new uint[] { 31, 63, 127, 255, 511, 1023, 2047 }}, //poa
	};

	
	//HALO 4
	vars.H4_levellist = new Dictionary<string, ulong[]>{
		{"m10", new ulong[] { 0, 0x0000000001800000, 0x000000000700000F }},
		{"m02", new ulong[] { 0, 0x0000000080000C02 }},
		{"m30", new ulong[] { 0, 0x0000000072001902 }},
		{"m40", new ulong[] { 0, 0x00000040000C0001, 0x00000000013C0001 }},
		{"m60", new ulong[] { 0, 0x0000C00002100001, 0x0000400006000001 }},
		{"m70", new ulong[] { 0, 0x0000000100100004 }},
		{"m80", new ulong[] { 0, 0x0020000080000006, 0x0000000080400006, 0x0000000180C0000E }},
		{"m90", new ulong[] { 0, 0x0000010000000006, 0x0000000000A00006 }},
	};

	
	//HALO ODST	
	/*	h100 streets value breakdown:
		296, 352, //drone optic
		352, 304, 400, 896, //guass turret
		262, //remote det (actually goes to sniper)
		388, 262, //sniper rifle
		259 //biofoam
	*/
	vars.ODST_levellist = new Dictionary<string, uint[]>{
		{"h100", new uint[] { 296, 352, 304, 400, 896, 262, 388, 259 }},
		{"sc10", new uint[] { 14, 13, 9 }},	//tayari, bad vals: 12
		{"sc11", new uint[] { 79, 92, 96 }}, //uplift reserve first load used in cutscene - add check for pgcr time being > 30 or something
		{"sc13", new uint[] { 11, 3, 7 }}, //oni
		{"sc12", new uint[] { 11, 14, 12  }}, //kizingo bad vals 9, 10
		{"sc14", new uint[] { 11, 14, 12  }}, //NMPD, bad vals: 9
		{"sc15", new uint[] { 14, 28, 24 }}, //kikowani
		{"l200", new uint[] { 14, 28, 24, 48, 208, 224, 416 }}, //data hive, bad: 6, 12, 16, 192, 160
		{"l300", new uint[] { 33, 41, 56, 112 }}, //coastal
	};
	
	
	//SETTINGS + UI
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
	settings.SetToolTip("Loopmode", "For TBx10 (or similiar memes)");
	
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
	
	settings.Add("anylevel", false, "Start full-game runs on any level (breaks multi-game runs)");
	settings.Add("menupause", true, "Pause when in Main Menu", "anylevel");
	settings.Add("sqsplit", false, "Split when loading a new level", "anylevel");
	settings.SetToolTip("sqsplit", "Useful for categories like Hunter%. Only works for Halo CE currently");

	settings.Add("deathcounter", false, "Enable Death Counter");
	settings.SetToolTip("deathcounter", "Will automatically create a layout component for you. Feel free \n" +
		"to move it around, but you won't be able to rename it"
	);

	settings.Add("debugmode", false, "Debug Mode");
	settings.SetToolTip("debugmode", "Probably shouldn't tick this");

	settings.Add("perfmode", false, "Performance Mode", "debugmode");
	settings.SetToolTip("perfmode", "Reduces the autosplitter refresh rate to 30Hz. Requires restart. No idea if this even works");

	settings.Add("IGTadd", false, "Add exact IGT on mission restart", "debugmode");
	settings.SetToolTip("IGTadd", "Add exact IGT value on mission restart instead of rounding to the value seen on-screen");

	settings.Add("IGTmode", false, "IGT Debug", "debugmode");
	settings.SetToolTip("IGTmode", "Forces IGT sync regardless of game. Probably shouldn't use this");
	
	


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
	
	
	vars.CreateTextComponent = (Func<string, dynamic>)((name) => {
		var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
		dynamic textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
		timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
		textComponent.Settings.Text1 = name;
		return textComponent.Settings;
	}); 

} 


update 
{
	//Update state vars
	vars.watchers_fast.UpdateAll(game);
	if (vars.menuindicator.Current == 5) {vars.menuindicator.Current = 7;} //Dodgy workaround for 2969

	if (!(vars.menuindicator.Current == 7))
	{
		vars.watchers_slow.UpdateAll(game);
		if (vars.pgcrexists == true) {vars.pgcrexists = false;} //sanity check. Should never come up normally
	}
	else if (vars.menuindicator.Current == 7)
	{
		if (vars.loopcount == 60) //update slow when actually in game and fast when on menu. Fixes some false resetting
		{
			vars.watchers_slow.UpdateAll(game);
			vars.loopcount = 0;
		}
		else {++vars.loopcount;}

		byte test = vars.gameindicator.Current;
		switch (test)
		{
			//H1
			case 0:
				vars.watchers_h1.UpdateAll(game);
				if (settings["deathcounter"]) {vars.watchers_h1death.UpdateAll(game);}
			break;
			
			//H2
			case 1:
				vars.watchers_h2.UpdateAll(game);
				if (settings["deathcounter"]) {vars.watchers_h2death.UpdateAll(game);}
				if (settings["bspmode"]) {vars.watchers_h2bsp.UpdateAll(game);}
			break;
			
			//H3
			case 2:
				vars.watchers_h3.UpdateAll(game);
				if (settings["deathcounter"]) {vars.watchers_h3death.UpdateAll(game);}
				if (settings["bspmode"]) {vars.watchers_h3bsp.UpdateAll(game);}
				if (settings["ILmode"]) {vars.watchers_igt.UpdateAll(game);}
			break;
			
			//H4
			case 3:
				vars.watchers_h4.UpdateAll(game);
				vars.watchers_igt.UpdateAll(game);
				if (settings["bspmode"]) {vars.watchers_h4bsp.UpdateAll(game);}
			break;
			
			//ODST
			case 5:
				vars.watchers_odst.UpdateAll(game);
				vars.watchers_igt.UpdateAll(game);
				if (settings["bspmode"]) {vars.watchers_odstbsp.UpdateAll(game);}
				if (settings["deathcounter"]) {vars.watchers_odstdeath.UpdateAll(game);}	
			break;
			
			//HR
			case 6: 
				vars.watchers_hr.UpdateAll(game);
				vars.watchers_igt.UpdateAll(game);
				if (settings["deathcounter"]) {vars.watchers_hrdeath.UpdateAll(game);}
				if (settings["bspmode"]) {vars.watchers_hrbsp.UpdateAll(game);}
			break;
		}
	}


	//var reset
	if (timer.CurrentPhase == TimerPhase.Running && vars.varsreset == false)
	{
		vars.varsreset = true;
	}
	else if (timer.CurrentPhase == TimerPhase.NotRunning && vars.varsreset == true)
	{
		vars.varsreset = false;
		vars.partialreset = false;

		vars.dirtybsps_byte = new List<byte>();
		vars.dirtybsps_int = new List<uint>();
		vars.dirtybsps_long = new List<ulong>();

		vars.startedlevel = "000";
		vars.levelloaded = "000";
		vars.startedgame = 10;
		vars.startedscene = 0; //default to recon helmet, 0 on recon helmet/ptd, 100 on drone optic, 110 on guass turret etc etc

		vars.loopsplit = true;
		vars.forcesplit = false;
		vars.forcesplit2 = false;

		vars.H2_tgjreadyflag = false;
		vars.H2_tgjreadytime = 0;
		vars.lastinternal = false;
		vars.oldtick = -2;
		vars.loading = false;
		vars.multigamepause = false;
		vars.multigametime = TimeSpan.Zero;

		vars.gametime = TimeSpan.Zero;
		vars.ingametime = 0;
		vars.leveltime = 0;
		vars.pgcrexists = false;

		vars.isvalid = false;
		vars.ctime = TimeSpan.Zero;
		vars.diff = TimeSpan.Zero;

		vars.DeathCounter = 0;
		if (settings["deathcounter"]) {vars.UpdateDeathCounter();}

		print ("Autosplitter vars reinitalized!");
	}


	//Things that only need to happen after timer has started
	if (timer.CurrentPhase == TimerPhase.Running)
	{
		byte test = vars.gameindicator.Current;

		//Clear dirty bsps
		if (vars.partialreset)
		{
			switch (test)
			{
				case 0:
				case 1:
					vars.dirtybsps_byte.Clear();
				break;

				case 2:
				case 3:
					vars.dirtybsps_long.Clear();
				break;

				case 5:
				case 6:
					vars.dirtybsps_int.Clear();
				break;
			}

			if (settings["debugmode"]) {print("Dirty BSPs cleared");}
			vars.partialreset = false;
		}
		

		//If someone is manually starting the timer for some reason
		if (vars.menuindicator.Current == 7 && (vars.startedlevel == "000" || vars.startedlevel == null))
		{
			switch (test)
			{
				case 0:
					vars.startedlevel = vars.H1_levelname.Current;
					vars.startedgame = 0;
				break;

				case 1:
					vars.startedlevel = vars.H2_levelname.Current;
					vars.startedgame = 1;
				break;

				case 2:
					vars.startedlevel = vars.H3_levelname.Current;
					vars.startedgame = 2;
				break;

				case 3:
					vars.startedlevel = vars.H4_levelname.Current;
					vars.startedgame = 3;
				break;

				case 5:
					vars.startedlevel = vars.ODST_levelname.Current;
					vars.startedscene = vars.ODST_streets.Current;
					vars.startedgame = 5;
				break;

				case 6:
					vars.startedlevel = vars.HR_levelname.Current;
					vars.startedgame = 6;
				break;
			}
			print ("Manual timer start detected, updating startedlevel");
		}


		if (!vars.multigamepause)
		{
			//IGT function
			if (vars.menuindicator.Current == 7 && (settings["IGTmode"] || !(test == 0 || (test == 1 && (!settings["ILmode"] || vars.H2_levelname.Current == "01a")))))
			{
				//reset gametime return of current iteration
				vars.gametime = TimeSpan.Zero;

				uint IGT = 0;
				uint IGTold = 0;
				byte tickrate = 0;
				string level = "000";
				
				switch (test)
				{
					case 0:
						IGT = vars.H1_IGT.Current;
						IGTold = vars.H1_IGT.Old;
						tickrate = 30;
						level = vars.H1_levelname.Current;
					break;

					case 1:
						IGT = vars.H2_IGT.Current;
						IGTold = vars.H2_IGT.Old;
						tickrate = 60;
						level = vars.H2_levelname.Current;
					break;

					case 2:
						if (settings["ILmode"])
						{
							IGT = (uint)Math.Round(vars.IGT_float.Current * 60);
							IGTold = (uint)Math.Round(vars.IGT_float.Old * 60);
							tickrate = 60;
							level = vars.H3_levelname.Current;
						}
						else
						{
							IGT = vars.H3_theatertime.Current;
							IGTold = vars.H3_theatertime.Old;
							tickrate = 60;
							level = vars.H3_levelname.Current;
						}
					break;

					case 3:
						IGT = (uint)Math.Round(vars.IGT_float.Current * 60);
						IGTold = (uint)Math.Round(vars.IGT_float.Old * 60);
						tickrate = 60;
						level = vars.H4_levelname.Current;
						break;

					case 5:
						IGT = (uint)Math.Round(vars.IGT_float.Current * 60);
						IGTold = (uint)Math.Round(vars.IGT_float.Old * 60); 
						tickrate = 60;
						level = vars.ODST_levelname.Current; //Streets might cause problems in loopmode if someone does something weird
					break;

					case 6:
						IGT = (uint)Math.Round(vars.IGT_float.Current * 60);
						IGTold = (uint)Math.Round(vars.IGT_float.Old * 60);
						tickrate = 60;
						level = vars.HR_levelname.Current;
					break;

				}

				//Squiggily mess is squiggily. Don't touch unless really need to.
				if (settings["ILmode"]) //ILs
				{
					if (settings["Loopmode"])
					{
						if (vars.leveltime == 0)
						{
							if (vars.stateindicator.Current != 44 && !(vars.pgcrexists) && vars.startedlevel == level)  {vars.leveltime = IGT;}
						}
						else if ((IGT - IGTold) > 0 && (IGT - IGTold) < 300 && vars.startedlevel == level) {vars.leveltime = vars.leveltime + (IGT - IGTold);}
						
						if (vars.stateindicator.Current == 57 && vars.stateindicator.Old != 57 && vars.stateindicator.Old != 190) //add times
						{
							vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
							vars.leveltime = 0;
							vars.pgcrexists = true;
							vars.forcesplit = true;
						}
						else if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
						{
							if (!(vars.pgcrexists))
							{
								vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
								vars.leveltime = 0;
								vars.forcesplit = true;
							}
							vars.pgcrexists = false;
						}
						else if (IGT < IGTold && IGT < 10 && vars.stateindicator.Current != 44)
						{
							if (!settings["IGTadd"])
							{
								if ((vars.leveltime % tickrate) > (0.5 * tickrate)) {vars.ingametime = vars.ingametime + (vars.leveltime + (tickrate - (vars.leveltime % tickrate)));}
								else {vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));}
							}
							else {vars.ingametime = vars.ingametime + vars.leveltime;}
							vars.leveltime = 0;
						}
						
						if (level != vars.startedlevel || vars.stateindicator.Current == 44) {vars.gametime = TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime));}
						else {vars.gametime = TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime + vars.leveltime));}		
					}
					else
					{
						if (vars.stateindicator.Current == 57 && vars.stateindicator.Old != 57 && vars.stateindicator.Old != 190) //add times
						{
							vars.pgcrexists = true;
							vars.forcesplit = true;
						}
						else if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
						{
							if (!(vars.pgcrexists)) {vars.forcesplit = true;}
							vars.pgcrexists = false;
						}
						vars.gametime = TimeSpan.FromMilliseconds((1000.0 / tickrate) * (IGT));
					}
				}
				else //Fullgame or anylevel
				{
					if (vars.leveltime == 0)
					{
						if (vars.stateindicator.Current != 44 && !(vars.pgcrexists)) {vars.leveltime = IGT;}
					}
					else if ((IGT - IGTold) > 0 && (IGT - IGTold) < 300) {vars.leveltime = vars.leveltime + (IGT - IGTold);}

					if (test == 2) //Want to do the math on the loading screen for theatre timing
					{
						if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
						{
							vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
							vars.leveltime = 0;
						}
					}
					else
					{
						if (vars.stateindicator.Current == 57 && vars.stateindicator.Old != 57 && vars.stateindicator.Old != 190) //add times
						{
							vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
							vars.leveltime = 0;
							vars.pgcrexists = true;
							vars.forcesplit = true;
						}
						else if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
						{
							if (!(vars.pgcrexists))
							{
								vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
								vars.leveltime = 0;
								vars.forcesplit = true;
							}
							vars.pgcrexists = false;
						}
						else if (IGT < IGTold && IGT < 10 && vars.stateindicator.Current != 44)
						{
							if (!settings["IGTadd"])
							{
								if ((vars.leveltime % tickrate) > (0.5 * tickrate)) {vars.ingametime = vars.ingametime + (vars.leveltime + (tickrate - (vars.leveltime % tickrate)));}
								else {vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));}
							}
							else {vars.ingametime = vars.ingametime + vars.leveltime;}
							vars.leveltime = 0;
						}
					}

					if (vars.stateindicator.Current == 44) {vars.gametime = (TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime)) + vars.multigametime);}
					else {vars.gametime = (TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime + vars.leveltime)) + vars.multigametime);}
				}
			}

			//RTA load removal stuff. Moved here to prevent conflict with multigamepause and other types of timer pause logic

			//Halo 1
			else if (vars.gameindicator.Current == 0 && !((settings["IGTmode"]) || settings["ILmode"]))
			{
				if (vars.loading == false) //if not currently loading, determine whether we need to be.
				{
					if (vars.menuindicator.Current == 7) //between level loads.
					{
						if (vars.H1_levelname.Current != vars.H1_levelname.Old && vars.H1_levelname.Current != vars.startedlevel && vars.H1_levellist.ContainsKey(vars.H1_levelname.Current))
						{
							vars.loading = true;
						}
					}
					else if (vars.stateindicator.Current == 44) {vars.loading = true;}	//main menu to level loads.
				}
				else //if currently loading, determine whether we need to not be.
				{
					if (vars.H1_tickcounter.Current == (vars.H1_tickcounter.Old + 1)) {vars.loading = false;}//determine whether to unpause the timer, ie tick counter starts incrementing again.
				}
			}

			///Halo 2
			else if (vars.gameindicator.Current == 1 && !(settings["ILmode"] || settings["IGTmode"]))
			{
				if (vars.loading == false ) //if not currently loading, determine whether we need to be
				{
					if (vars.menuindicator.Current == 7) //between level loads.
					{
						string H2_checklevel = vars.H2_levelname.Current;
						switch (H2_checklevel)
						{
							case "01a": //Armory
								if (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57) {vars.loading = true;}
							break;

							case "01b": //Cairo
							case "03a": //Outskirts
							case "03b": //Metropolis
							case "04a": //Arbiter
							case "05a": //Delta Halo
							case "06a": //Sacred Icon
							case "07a": //Gravemind
							case "08a": //Uprising
							case "07b": //High Charity
								if ((vars.H2_tickcounter.Current > 60 && vars.H2_fadebyte.Current == 1 && vars.H2_fadebyte.Old == 1 && vars.H2_letterbox.Current > 0.96 && vars.H2_letterbox.Old <= 0.96 && vars.H2_letterbox.Old != 0) || vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)
								{
									vars.loading = true;
								}
							break;

							case "04b": //Oracle
							case "05b": //Regret
								if (vars.lastinternal == false && (vars.H2_fadebyte.Current == 1 && vars.H2_letterbox.Current > 0.96 && vars.H2_letterbox.Old <= 0.96 && vars.H2_letterbox.Old != 0))
								{
									vars.watchers_h2bsp.UpdateAll(game);
									if (vars.H2_levelname.Current == "04b" && vars.H2_bspstate.Current == 5) {vars.lastinternal = true;}
									else if (vars.H2_levelname.Current == "05b" && vars.H2_bspstate.Current == 2) {vars.lastinternal = true;}

								}
								else if ((vars.H2_tickcounter.Current > 60 && vars.lastinternal == true && vars.H2_fadebyte.Current == 1 && vars.H2_fadebyte.Old == 1 && vars.H2_letterbox.Current > 0.96 && vars.H2_letterbox.Old <= 0.96 && vars.H2_letterbox.Old != 0) || vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)
								{
									vars.loading = true;	
									vars.lastinternal = false;
								}
							break;

							case "06b":	//Quarantine Zone
								if ((vars.H2_tickcounter.Current > 60 && vars.H2_fadebyte.Current == 1 && vars.H2_fadebyte.Old == 1 && vars.H2_letterbox.Current > 0.96 && vars.H2_letterbox.Old <= 0.96 && vars.H2_letterbox.Old != 0) || vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57)
								{
									vars.watchers_h2bsp.UpdateAll(game);
									if (vars.H2_bspstate.Current == 4  || vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57) {vars.loading = true;}
								}
							break;
						}

					}
					else if (vars.stateindicator.Current == 44 || vars.stateindicator.Current == 57) {vars.loading = true;}	//main menu to level loads.
				}
				else	//if currently loading, determine whether we need not be
				{
					if (vars.menuindicator.Current == 7 && vars.stateindicator.Current != 44 && vars.H2_levellist.ContainsKey(vars.H2_levelname.Current)) //between level loads.
					{
						if (vars.H2_levelname.Current == "03a")
						{
							if (vars.stateindicator.Current != 44)
							{
								vars.watchers_h2bsp.UpdateAll(game);
								if (vars.H2_fadebyte.Current == 1 && vars.H2_bspstate.Current == 0 && vars.H2_tickcounter.Current > 10 && vars.H2_tickcounter.Current < 100)
								{
									vars.watchers_h2fade.UpdateAll(game);
									if (vars.H2_fadelength.Current > 15 && vars.H2_tickcounter.Current >= (vars.H2_fadetick.Current + (uint)Math.Round(vars.H2_fadelength.Current * vars.fadescale))) {vars.loading = false;}
								}
								else if (vars.H2_fadebyte.Current == 0 && vars.H2_tickcounter.Current > vars.H2_tickcounter.Old && vars.H2_tickcounter.Current > 10) {vars.loading = false;}
							}
						}
						else
						{
							if (vars.H2_fadebyte.Current == 0 && vars.H2_fadebyte.Old == 1 && vars.stateindicator.Current != 129)
							{
								vars.loading = false;
								vars.lastinternal = false;
							} else if (vars.H2_fadebyte.Current == 0 && vars.H2_tickcounter.Current > vars.H2_tickcounter.Old && vars.H2_tickcounter.Current > 10) {vars.loading = false;}
						}
					}
				}
				//TGJ cutscene rubbish
				if (vars.H2_levelname.Current == "08b" && vars.H2_tgjreadyflag == false) 
				{
					vars.watchers_h2bsp.UpdateAll(game);
					if (vars.H2_bspstate.Current == 3)
					{
						vars.H2_tgjreadyflag = true;
						vars.H2_tgjreadytime = vars.H2_tickcounter.Current;
						print ("H2 tgj ready flag set");
					} 
				}
			}

			if (!settings["ILmode"])
			{
				//Save and quit splitting level tracking. Should probably get it working in other games, but eh
				if (settings["sqsplit"] && vars.gameindicator.Current == 0)
				{
					if (vars.levelloaded == "000") {vars.levelloaded = vars.startedlevel;}
					else if (vars.forcesplit2 == false && vars.stateindicator.Current == 44 && vars.H1_levelname.Current != vars.levelloaded && vars.H1_levellist.ContainsKey(vars.H1_levelname.Current)) //determine if there is a level swap thus a split required
					{
						if (vars.H1_levelname.Current != vars.startedlevel) //dont split if loading the starting level, probably a reset/loopmode. Otherwise split.
						{
							vars.levelloaded = vars.H1_levelname.Current;
							vars.forcesplit2 = true;
						}
					}
				}


				//Moved multigamepuse logic here as was pausing 1 cycle late in RTA games previously. Also handles end game split for RTA and theatre games so not doing the same checks twice for no reason
				switch (test)
				{
					case 0:
						if (vars.H1_levelname.Current == "d40" && vars.H1_cinematic.Old == false && vars.H1_cinematic.Current == true && vars.H1_cutsceneskip.Current == false)
						{							
							vars.watchers_h1death.UpdateAll(game);
							if (vars.H1_deathflag.Current == false)
							{
								if (settings["anylevel"]) {vars.loading = true;} else {vars.multigamepause = true;}
								vars.forcesplit = true;
							}
						}
					break;

					case 1:
						if (vars.H2_levelname.Current == "08b" && (vars.H2_fadebyte.Current == 1 && vars.H2_letterbox.Current > 0.96 && vars.H2_letterbox.Old <= 0.96  && vars.H2_letterbox.Old != 0 && vars.H2_tgjreadyflag && ( vars.H2_tickcounter.Current > (vars.H2_tgjreadytime + 300))))
						{
							if (settings["anylevel"]) {vars.loading = true;} else {vars.multigamepause = true;}
							vars.H2_tgjreadyflag = false;
							vars.forcesplit = true;
						}
					break;

					case 2:
						if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44 && vars.H3_levelname.Current == "130" && !settings["anylevel"])
						{
							vars.multigamepause = true;
							vars.forcesplit = true;
						}
					break;

					case 3:
						if (vars.stateindicator.Current == 57 && vars.stateindicator.Old != 57 && vars.stateindicator.Old != 190 && vars.H4_levelname.Current == "m90")
						{
							if (!settings["anylevel"]) {vars.multigamepause = true;}
						}
					break;

					case 5:
						if (vars.stateindicator.Current == 57 && vars.stateindicator.Old != 57 && vars.stateindicator.Old != 190 && vars.ODST_levelname.Current == "l300")
						{
							if (!settings["anylevel"]) {vars.multigamepause = true;}
						}
					break;

					case 6:
						if (vars.stateindicator.Current == 57 && vars.stateindicator.Old != 57 && vars.stateindicator.Old != 190 && vars.HR_levelname.Current == "m70")
						{
							if (!settings["anylevel"]) {vars.multigamepause = true;}
						}
					break;
				}

				if (settings["debugmode"] && vars.multigamepause) {print ("multigamepause is true");}
			}
		}
		else if (vars.multigamepause)
		{
			if (vars.menuindicator.Current == 7) 
			{
				switch (test)
				{
					case 0:
						if (vars.H1_levelname.Current == "a10" && vars.H1_bspstate.Current == 0 && vars.H1_tickcounter.Current > 280 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //Start on PoA
						{
							vars.watchers_h1xy.UpdateAll(game);
							if (vars.H1_xpos.Current < -55)
							{
								vars.multigamepause = false;
							}
						}
					break;
					
					case 1:
						if (vars.H2_levelname.Current == "01b" && vars.stateindicator.Current != 44 && vars.H2_fadebyte.Current == 0 && vars.H2_fadebyte.Old == 1 && vars.H2_tickcounter.Current < 30) //start on cairo
						{
							vars.multigamepause = false;
						}
						else if (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current > 26 &&  vars.H2_tickcounter.Current < 30) //start on armory
						{
							vars.multigamepause = false;
						}
					break;
					
					case 2:
						if (vars.H3_levelname.Current == "010" && vars.H3_theatertime.Current > 15 && vars.H3_theatertime.Current < 30) //start on sierra
						{
							vars.multigamepause = false;
						}
					break;
					
					case 3:
						if 	(vars.H4_levelname.Current == "m10" && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5) //start on dawn
						{
							vars.multigamepause = false;
						}
					break;
					
					case 5:
						if (vars.ODST_levelname.Current == "h100" && vars.ODST_streets.Current == 0 && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5) //start on recon helmet
						{
							vars.multigamepause = false;
						}
					break;
					
					case 6:
						if 	(vars.HR_levelname.Current == "m10" && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5) //start on wc
						{
							vars.multigamepause = false;
						}
					break;
				}

				if (settings["debugmode"] && !vars.multigamepause) {print ("multigamepause is false");}
			}
		}
		
		if (vars.isvalid == false && test == 0)
		{
			if (vars.menuindicator.Current == 7 && vars.loopcount == 60 && vars.stateindicator.Current != 44)
			{
				if (vars.H1_tickcounter.Current < 1100 && vars.H1_checklist.Count > 0 && vars.H1_checklist[vars.H1_levelname.Current] != vars.H1_check.Current)
				{
					vars.isvalid = true;
					print("sus");
				}

			}
		}
	}
}





start 	//starts timer
{	
	string checklevel; 

	if (vars.menuindicator.Current == 7) 
	{
		byte test = vars.gameindicator.Current;
		vars.startedgame = test; //Why did 343 reuse reach level names in H4 smh my head!

		switch (test)
		{
			//Halo 1
			case 0:
				if (vars.H1_levelname.Current == "a10" && vars.H1_bspstate.Current == 0 && vars.H1_tickcounter.Current > 280 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //Start on PoA
				{
					vars.watchers_h1xy.UpdateAll(game);
					if (vars.H1_xpos.Current < -55)
					{
						vars.startedlevel = "a10";
						return true;
					}
				}
				else if ((settings["ILmode"] || settings["anylevel"]) && vars.H1_levelname.Current != "a10")	//Start on any level thats not PoA
				{
					checklevel = vars.H1_levelname.Current;
					switch (checklevel)
					{
						case "a30":
							if (((vars.H1_tickcounter.Current >= 182 && vars.H1_tickcounter.Current < 190) || (vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true && vars.H1_tickcounter.Current > 500 && vars.H1_tickcounter.Current < 900)) && vars.H1_cutsceneskip.Current == false) //2 cases, depending on whether cs is skipped
							{
								vars.startedlevel = checklevel;
								return true;
							}
						break;

						case "a50":
						case "b30":
						case "b40":
						case "c10":
							if (vars.H1_tickcounter.Current > 30 && vars.H1_tickcounter.Current < 1060 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //levels with unskippable intro cutscenes
							{
								vars.startedlevel = checklevel;
								return true;
							}
						break;
						
						case "c20":
						case "c40":
						case "d20":
						case "d40":
							if (vars.H1_cutsceneskip.Current == false && vars.H1_cutsceneskip.Old == true) //levels with skippable intro cutscenes
							{
								vars.startedlevel = checklevel;
								return true;
							}
						break;

						default:
							return false;
						break;			
					}
				} 
			break;
			

			//Halo 2
			case 1: 
				if (vars.H2_levelname.Current == "01a" && vars.H2_tickcounter.Current >= 26 &&  vars.H2_tickcounter.Current < 30) //start on armory
				{
					vars.startedlevel = "01a";
					return true;
				}
				else if (vars.H2_levelname.Current == "01b" && vars.stateindicator.Current != 44 && vars.H2_fadebyte.Current == 0 && vars.H2_fadebyte.Old == 1 && vars.H2_tickcounter.Current < 30) //start on cairo
				{
					vars.startedlevel = "01b";
					return true;
				}
				else if ((settings["anylevel"] || settings["ILmode"]) && vars.stateindicator.Current != 44) //start on any other level
				{	
					if (vars.H2_levelname.Current == "03a") //outskirts
					{
						vars.watchers_h2bsp.UpdateAll(game);
						if (vars.H2_fadebyte.Current == 1 && vars.H2_bspstate.Current == 0 && vars.H2_tickcounter.Current > 10 && vars.H2_tickcounter.Current < 100)
						{
							vars.watchers_h2fade.UpdateAll(game);
							if (vars.H2_fadelength.Current > 15 && vars.H2_tickcounter.Current >= (vars.H2_fadetick.Current + (uint)Math.Round(vars.H2_fadelength.Current * vars.fadescale)))
							{
								vars.startedlevel = "03a";
								return true;
							}
						}
					}
					else if (vars.H2_fadebyte.Current == 0 && vars.H2_fadebyte.Old == 1 && vars.H2_tickcounter.Current < 120) //everything else
					{
						vars.startedlevel = vars.H2_levelname.Current;
						return true;
					}
				} 
			break;
			

			//Halo 3
			case 2:
				if (settings["ILmode"] && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5)
				{
					vars.startedlevel = vars.H3_levelname.Current;
					return true;
				}
				else if (settings["anylevel"] || vars.H3_levelname.Current == "010")
				{
					
					if (vars.stateindicator.Current != 44 && vars.H3_theatertime.Current > 15 && vars.H3_theatertime.Current < 30)
					{
						vars.startedlevel = vars.H3_levelname.Current;
						return true;
					}
				}
			break;
			

			//Halo 4
			case 3:
				if ((settings["ILmode"] || settings["anylevel"] || vars.H4_levelname.Current == "m10") && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5)
				{
					vars.startedlevel = vars.H4_levelname.Current;
					return true;
				}
			break;
			

			//ODST
			case 5:
				if ((settings["ILmode"] || settings["anylevel"] || (vars.ODST_levelname.Current == "h100" && vars.ODST_streets.Current == 0)) && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5)
				{
					vars.startedlevel = vars.ODST_levelname.Current;
					vars.startedscene = vars.ODST_streets.Current;
					return true;
				}
			break;
			

			//Reach
			case 6:
				if ((settings["ILmode"] || settings["anylevel"] || vars.HR_levelname.Current == "m10") && vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5)
				{
					vars.startedlevel = vars.HR_levelname.Current;
					return true;
				}
			break;
		}
	}	
}



split
{ 
	if (vars.forcesplit2) //for sqsplit
	{
		vars.forcesplit2 = false;
		vars.partialreset = true;
		return true;
	}
	
	if (vars.menuindicator.Current == 7)
	{
		if (vars.forcesplit) //for IGT game splits and RTA end game splits
		{
			vars.forcesplit = false;
			vars.partialreset = true;
			if (settings["Loopmode"]) {vars.loopsplit = false;}
			return true;
		}

		if (!vars.multigamepause)
		{
			byte test = vars.gameindicator.Current;
			string checklevel;

			switch (test)
			{
				//Halo 1
				case 0:

					//Death counter check
					if (settings["deathcounter"])
					{
						if (vars.H1_deathflag.Current && !vars.H1_deathflag.Old)
						{
							print ("adding death");
							vars.DeathCounter += 1;
							vars.UpdateDeathCounter();
						}
					}

					
					checklevel = vars.H1_levelname.Current;
					
					//Unpause timer at IL start
					if (settings["Loopmode"] && vars.H1_levelname.Current == vars.startedlevel && vars.loading == true && vars.H1_tickcounter.Current < 1500)
					{
						switch (checklevel)
						{
							case "a10":
							if (vars.H1_bspstate.Current == 0 && vars.H1_tickcounter.Current > 280 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //PoA
							{
								vars.watchers_h1xy.UpdateAll(game);
								if (vars.H1_xpos.Current < -55)
								{
									vars.dirtybsps_byte.Clear();
									vars.loading = false;
								}
							}
							break;
							
							case "a30":
							case "a50":
							case "b30":
							case "b40":
							case "c10":
								if (vars.H1_tickcounter.Current > 30 && vars.H1_tickcounter.Current < 1060 && vars.H1_cinematic.Current == false && vars.H1_cinematic.Old == true) //levels with unskippable intro cutscenes
								{
									vars.dirtybsps_byte.Clear();
									vars.loading = false;
								}
							break;
							
							case "c20":
							case "c40":
							case "d20":
							case "d40":
								if (vars.H1_cutsceneskip.Current == false && vars.H1_cutsceneskip.Old == true) //levels with skippable intro cutscenes
								{
									vars.dirtybsps_byte.Clear();
									vars.loading = false;
								}
							break;				
						}
					}

					if (settings["bspmode"])
					{
						
						if (settings["bsp_cache"])
						{
							if (checklevel == "b40")
							{
								if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.H1_bspstate.Current) && vars.H1_tickcounter.Current > 30)
								{
									if (vars.H1_bspstate.Current == 0)
									{
										vars.watchers_h1xy.UpdateAll(game);
										if (vars.H1_ypos.Current > (-19.344 - 0.2) && vars.H1_ypos.Current < (-19.344 + 0.2)) {return true;}
										else {return false;}
									} 
									else {return true;}

								}
							}
							else if (checklevel == "c40")
							{
								if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.H1_bspstate.Current) && vars.H1_tickcounter.Current > 30)
								{
									if (vars.H1_bspstate.Current == 0)
									{
										//update xy, check for match
										vars.watchers_h1xy.UpdateAll(game);
										if (vars.H1_xpos.Current > 171.87326 && vars.H1_xpos.Current < 185.818526 && vars.H1_ypos.Current > -295.3629 && vars.H1_ypos.Current < -284.356986) {return true;}
										else {return false;}
									} 
									else {return true;}
								}
							}
							else {return (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.H1_bspstate.Current));}
						}
						
						if (checklevel == "b40")
						{
							if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
							{
								if (vars.H1_bspstate.Current == 0)
								{
									vars.watchers_h1xy.UpdateAll(game);
									if (vars.H1_ypos.Current > (-19.344 - 0.2) && vars.H1_ypos.Current < (-19.344 + 0.2))
									{
										vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
										return true;
									}
									else {return false;}
								} 
								else
								{
									vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
									return true;
								}
							}
						}
						else if (checklevel == "c40")
						{
							if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)) && vars.H1_tickcounter.Current > 30)
							{
								if (vars.H1_bspstate.Current == 0)
								{
									//update xy, check for match
									vars.watchers_h1xy.UpdateAll(game);
									if (vars.H1_xpos.Current > 171.87326 && vars.H1_xpos.Current < 185.818526 && vars.H1_ypos.Current > -295.3629 && vars.H1_ypos.Current < -284.356986)
									{
										vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
										return true;
									}
									else {return false;}
								} 
								else
								{
									vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
									return true;
								}
							}
						}
						else
						{
							if (vars.H1_bspstate.Current != vars.H1_bspstate.Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.H1_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H1_bspstate.Current)))
							{
								vars.dirtybsps_byte.Add(vars.H1_bspstate.Current);
								return true;
							}
						}
					}
					
					if (!settings["IGTmode"]) //Just leaving this here for debugging igt code. It's mostly all copypasta anyway
					{
						if (settings["ILmode"]) //IL End level splits
						{
							switch (checklevel)
							{
								case "a10":
									if (vars.H1_bspstate.Current == 6 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
									{
										vars.dirtybsps_byte.Clear();
										if (settings["Loopmode"]) {vars.loading = true;}
										return true;
									}
								break;
								
								case "a30": //so we don't false split on lightbridge cs
									if (vars.H1_bspstate.Current == 1 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
									{
										vars.dirtybsps_byte.Clear();
										if (settings["Loopmode"]) {vars.loading = true;}
										return true;
									}
								break;
								
								case "a50": //so we don't false split on prison or lift cs.
									if (vars.H1_bspstate.Current == 3 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
									{
										vars.watchers_h1fade.UpdateAll(game);
										if(vars.H1_fadelength.Current == 15)
										{
											vars.dirtybsps_byte.Clear();
											if (settings["Loopmode"]) {vars.loading = true;}
											return true;
										}
									}
								break;
								
								case "b30": //no longer false splits on the security button
									if (vars.H1_bspstate.Current == 0 && vars.H1_cinematic.Current == false && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
									{
										vars.dirtybsps_byte.Clear();
										if (settings["Loopmode"]) {vars.loading = true;}
										return true;
									}
								break;
								
								case "b40": 
									if (vars.H1_bspstate.Current == 2 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true) //mandatory bsp load for any category
									{
										vars.dirtybsps_byte.Clear();
										if (settings["Loopmode"]) {vars.loading = true;}
										return true;
									}
								break;
								
								case "c10": //so we don't split on reveal cs
									if (vars.H1_bspstate.Current != 2 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
									{
										vars.dirtybsps_byte.Clear();
										if (settings["Loopmode"]) {vars.loading = true;}
										return true;
									}
								break;

								case "c20":
									if (vars.H1_cinematic.Current == true && vars.H1_cinematic.Old == false && vars.H1_tickcounter.Current > 30)
									{
										vars.dirtybsps_byte.Clear();
										if (settings["Loopmode"]) {vars.loading = true;}
										return true;
									}
								break;
								
								case "c40": //so dont false split on intro cutscene.
									if (vars.H1_tickcounter.Current > 30 && vars.H1_cutsceneskip.Old == false && vars.H1_cutsceneskip.Current == true)
									{
										vars.watchers_h1fade.UpdateAll(game); 
										if (vars.H1_fadebyte.Current != 1)	//so we dont false split on reverting to intro cutscene
										{
											vars.dirtybsps_byte.Clear();
											if (settings["Loopmode"]) {vars.loading = true;}
											return true;
										}
									}
								break;

								case "d20": //keyes -- won't false split on fullpath
									vars.watchers_h1fade.UpdateAll(game);
									if (vars.H1_fadebyte.Current == 1)
									{
										if (vars.H1_fadelength.Current == 30 && vars.H1_cinematic.Old == false && vars.H1_cinematic.Current == true)
										{
											vars.dirtybsps_byte.Clear();
											if (settings["Loopmode"]) {vars.loading = true;}
											return true;
										} else if (vars.H1_fadelength.Current == 60 && vars.H1_tickcounter.Current >= (vars.H1_fadetick.Current + 56) && vars.H1_tickcounter.Old < (vars.H1_fadetick.Current + 56)) //for the dumbass who does cutscene overlap. Nice timeloss nerd :P
										{
											vars.dirtybsps_byte.Clear();
											if (settings["Loopmode"]) {vars.loading = true;}
											return true;
										}
									}
								break;
								
								case "d40": //maw - will false split on bad ending but not bridge cs or death in end fadeout
									if (vars.H1_cinematic.Old == false && vars.H1_cinematic.Current == true && vars.H1_cutsceneskip.Current == false)
									{
										vars.watchers_h1death.UpdateAll(game);
										if (!vars.H1_deathflag.Current)
										{
											vars.dirtybsps_byte.Clear();
											if (settings["Loopmode"]) {vars.loading = true;}
											return true;
										}
									}
								break;
								
								default: //don't need bsp check for levels without multiple cutscenes
									return false;
								break;
							}
						}
						else	//fullgame or anylevel
						{
							if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44) //split on loading screen
							{
								vars.dirtybsps_byte.Clear();
								return true;
							}
						}
					}
				break;



				//Halo 2
				case 1:

				if (settings["deathcounter"])
				{
					if (vars.H2_deathflag.Current && !vars.H2_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
					
				}

				checklevel = vars.H2_levelname.Current;
				
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
						return (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.H2_bspstate.Current));
					}
					
					switch (checklevel)
					{
						case "01b":
							if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
							{
								if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps_byte.Contains(2)))
								{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
								vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
								return true;
							}
						break;
						
						case "03a":
						case "03b":
						case "05a":
						case "05b":
						case "06a":
						case "06b":
						case "07a":
						case "07b":
							if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
							{
								vars.dirtybsps_byte.Add(vars.H2_bspstate.Current);
								return true;
							}
						break;
						
						case "04a":
							if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
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
							if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
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
						
						case "08a":
							if (vars.H2_bspstate.Current != vars.H2_bspstate.Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.H2_bspstate.Current) && !(vars.dirtybsps_byte.Contains(vars.H2_bspstate.Current)))
							{
								if (vars.H2_bspstate.Current == 0 && !(vars.dirtybsps_byte.Contains(1)))
								{return false;} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
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


				if (!(settings["ILmode"] || settings["IGTmode"])) //Split on loading screen
				{
					if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44 && checklevel != "00a") 
					{
						vars.dirtybsps_byte.Clear();
						return true;
					}
				}
				break;
				


				//Halo 3
				case 2:

				if (settings["deathcounter"])
				{
					if (vars.H3_deathflag.Current && !vars.H3_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
				}
				
				
				checklevel = vars.H3_levelname.Current;
				
				if (settings["Loopmode"] && vars.H3_levelname.Current == vars.startedlevel && vars.loopsplit == false)
				{
					if (vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5)
					{
						vars.loopsplit = true;
						vars.dirtybsps_long.Clear();
					}
				}
					
				
				if (settings["bspmode"])
				{
					if (settings["bsp_cache"])
					{
						return (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.H3_levellist[checklevel], x => x == vars.H3_bspstate.Current));		
					}
					
					if (vars.H3_bspstate.Current != vars.H3_bspstate.Old && Array.Exists((ulong[]) vars.H3_levellist[checklevel], x => x == vars.H3_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H3_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H3_bspstate.Current);
						return true;
					}
				} 
				
				if (!settings["ILmode"])	//Split on loading screen
				{
					if (vars.stateindicator.Current == 44 && vars.stateindicator.Old != 44)
					{
						vars.dirtybsps_long.Clear();
						return true;
					}
				} 
				break;



				//Halo 4
				case 3:

				//Death counter code goes here if we ever bother to add it

				checklevel = vars.H4_levelname.Current;
				
				if (settings["Loopmode"] && vars.H4_levelname.Current == vars.startedlevel)
				{
					if (vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5 && vars.loopsplit == false)
					{
						vars.loopsplit = true;
						vars.dirtybsps_long.Clear();
					}
				}
				
				
				if (settings["bspmode"])
				{
					if (settings["bsp_cache"])
					{
						return (vars.H4_bspstate.Current != vars.H4_bspstate.Old && !Array.Exists((ulong[]) vars.H4_levellist[checklevel], x => x == vars.H4_bspstate.Current));
					}
					
					if (vars.H4_bspstate.Current != vars.H4_bspstate.Old && !Array.Exists((ulong[]) vars.H4_levellist[checklevel], x => x == vars.H4_bspstate.Current) && !(vars.dirtybsps_long.Contains(vars.H4_bspstate.Current)))
					{
						vars.dirtybsps_long.Add(vars.H4_bspstate.Current);
						return true;
					}
				} 
				break;
				


				case 5: //ODST

				//Death Counter
				if (settings["deathcounter"])
				{
					if (vars.ODST_deathflag.Current && !vars.ODST_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
				}

				checklevel = vars.ODST_levelname.Current;

				if (settings["Loopmode"] && checklevel == vars.startedlevel && vars.loopsplit == false)
				{
					if (vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5)
					{
						vars.loopsplit = true;
						vars.dirtybsps_int.Clear();
					}
				}
				
				
				if (settings["bspmode"])
				{
					if (settings["bsp_cache"])
					{
						return (vars.IGT_float.Current > 0.5 && vars.ODST_bspstate.Current != vars.ODST_bspstate.Old && Array.Exists((uint[]) vars.ODST_levellist[checklevel], x => x == vars.ODST_bspstate.Current));	
					}

					if (vars.IGT_float.Current > 0.5 && vars.ODST_bspstate.Current != vars.ODST_bspstate.Old && Array.Exists((uint[]) vars.ODST_levellist[checklevel], x => x == vars.ODST_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.ODST_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.ODST_bspstate.Current);
						return true;
					}
				} 
				break;
				
				
				
				//Reach
				case 6:

				//Death counter check
				if (settings["deathcounter"])
				{
					if (vars.HR_deathflag.Current && !vars.HR_deathflag.Old)
					{
						print ("adding death");
						vars.DeathCounter += 1;
						vars.UpdateDeathCounter();
					}
				}

				checklevel = vars.HR_levelname.Current;
				
				if (settings["Loopmode"] && vars.HR_levelname.Current == vars.startedlevel)
				{
					if (vars.IGT_float.Current > 0.167 && vars.IGT_float.Current < 0.5 && vars.loopsplit == false)
					{
						vars.loopsplit = true;
						vars.dirtybsps_int.Clear();
					}
				}
				
				if (settings["bspmode"])
				{
					if (settings["bsp_cache"])
					{
						return (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.HR_levellist[checklevel], x => x == vars.HR_bspstate.Current));
					}
					
					if (vars.HR_bspstate.Current != vars.HR_bspstate.Old && Array.Exists((uint[]) vars.HR_levellist[checklevel], x => x == vars.HR_bspstate.Current) && !(vars.dirtybsps_int.Contains(vars.HR_bspstate.Current)))
					{
						vars.dirtybsps_int.Add(vars.HR_bspstate.Current);
						return true;
					}
				}
				break;
			}
		}
	}
}


reset
{
	if ((settings["ILmode"])&& (!(settings["Loopmode"])) && vars.menuindicator.Current != 7 && timer.CurrentPhase != TimerPhase.Ended)
	{
		return true;
	}
	
	if ((!(settings["Loopmode"])) && vars.menuindicator.Current == 7)
	{
		byte test = vars.gameindicator.Current;
		switch (test)
		{
			//H1
			case 0:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.H1_levelname.Current == vars.startedlevel && vars.startedgame == 0 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.H1_IGT.Current < vars.H1_IGT.Old && vars.H1_IGT.Current < 10) || (vars.stateindicator.Current == 44 && vars.H1_IGT.Current == 0));
					} 
				}
				else
				{
					if (vars.H1_levelname.Current == "a10" && vars.startedgame == 0 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.H1_IGT.Current < vars.H1_IGT.Old && vars.H1_IGT.Current < 10) || (vars.stateindicator.Current != 44 && vars.stateindicator.Old == 44 && vars.H1_tickcounter.Current < 60));
					} 
				}
			break;
			
			//H2
			case 1:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.H2_levelname.Current == vars.startedlevel && vars.startedgame == 1 && timer.CurrentPhase != TimerPhase.Ended)
					{				
						return ((vars.H2_IGT.Current < vars.H2_IGT.Old && vars.H2_IGT.Current < 10) || (vars.stateindicator.Current == 44 && vars.H2_IGT.Current == 0)); 
					}
				}
				else
				{
					if ((vars.H2_levelname.Current == "01a" || (vars.H2_levelname.Current == "01b" && vars.startedlevel != "01a") || vars.H2_levelname.Current == "00a") && vars.startedgame == 1 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.H2_IGT.Current < vars.H2_IGT.Old && vars.H2_IGT.Current < 10) || (vars.stateindicator.Current != 44 && vars.stateindicator.Old == 44 && vars.H2_tickcounter.Current < 60));
					}
				}
			break;
			
			//H3
			case 2:
				if (vars.startedgame == 2 && timer.CurrentPhase != TimerPhase.Ended)
				{
					if (settings["ILmode"])
					{
						return (vars.H3_levelname.Current == vars.startedlevel && vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167);
					}
					else
					{
						if (settings["anylevel"]) //reset on all levels
						{
							return (vars.H3_levelname.Current == vars.startedlevel && vars.H3_theatertime.Current > 0 && vars.H3_theatertime.Current < 15);
						}
						else return ((vars.H3_levelname.Current == "005" || vars.H3_levelname.Current == "010") && vars.H3_theatertime.Current > 0 && vars.H3_theatertime.Current < 15);	
					}
				} 
			break;
			
			//H4
			case 3:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.H4_levelname.Current == vars.startedlevel && vars.startedgame == 3 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167) || (vars.stateindicator.Current == 44 && vars.IGT_float.Current == 0));
					}
				}
				else
				{
					if (vars.H4_levelname.Current == "m10" && vars.startedgame == 3 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167) || (vars.stateindicator.Current == 44 && vars.IGT_float.Current == 0));
					}
				}
			break;
			
			//ODST
			case 5:
				if (settings["anylevel"] || settings["ILmode"])
				{
					if (vars.ODST_levelname.Current == vars.startedlevel && vars.startedscene == vars.ODST_streets.Current && vars.startedgame == 5 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167) || (vars.stateindicator.Current == 44 && vars.IGT_float.Current == 0));
					}
				}
				else
				{
					if ((vars.ODST_levelname.Current == "c100" || (vars.ODST_levelname.Current == "h100" && vars.ODST_streets.Current == 0)) && vars.startedgame == 5 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167) || (vars.stateindicator.Current == 44 && vars.IGT_float.Current == 0));
					}
				}
			break;
			
			//Reach
			case 6:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.HR_levelname.Current == vars.startedlevel && vars.startedgame == 6 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167) || (vars.stateindicator.Current == 44 && vars.IGT_float.Current == 0));
					}
				}
				else
				{
					if (vars.HR_levelname.Current == "m10" && vars.startedgame == 6 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.IGT_float.Current < vars.IGT_float.Old && vars.IGT_float.Current < 0.167) || (vars.stateindicator.Current == 44 && vars.IGT_float.Current == 0));
					}
				}
			break;
		}
	}
}

isLoading
{
	byte test = vars.gameindicator.Current;
	
	if (vars.multigamepause) {return true;}
	
	if (settings["menupause"] && (vars.stateindicator.Current == 44 || vars.menuindicator.Current != 7)) {return true;}
	
	//also should prolly code load removal to work in case of restart/crash
	switch (test)
	{
		case 0: //halo 1
			if (settings["IGTmode"]) {return true;}
			else return vars.loading;
		break;
		
		case 1: //halo 2
			if ((settings["ILmode"] && vars.H2_levelname.Current != "01a") || settings["IGTmode"]) {return true;}
			else
			{
				//Graphics swap load pausing. Just leaving it here for now unless issues start happening
				if (vars.loading == false && vars.H2_graphics.Current == 1 && vars.stateindicator.Current == 255)
				{
					if ((vars.H2_tickcounter.Current == vars.oldtick) || (vars.H2_tickcounter.Current == vars.oldtick + 1)) {return true;} else {vars.oldtick = -2;}
					if (vars.H2_graphics.Old == 0) {vars.oldtick = vars.H2_tickcounter.Current;}
				}
				return vars.loading;
			}
		break;
		
		case 2:
		case 3:
		case 5:
		case 6:
			return true;
		break;
	}
}


gameTime
{
	if (vars.gameindicator.Current == 0 && vars.menuindicator.Current == 7)
	{
		if (!vars.multigamepause && vars.isvalid && !vars.loading)
		{
			TimeSpan test = TimeSpan.Zero;
			TimeSpan comp = new TimeSpan(0, 0, 0);
			if (timer.CurrentTime.GameTime.HasValue) {test = (TimeSpan)timer.CurrentTime.GameTime;}
			if (test.Seconds == 11 && test.Milliseconds < 35)
			{
				vars.diff = timer.CurrentTime.RealTime;
				vars.ctime = timer.CurrentTime.GameTime;
				return comp;
			}
			else if (vars.ctime != TimeSpan.Zero)
			{
				test = (vars.ctime + (timer.CurrentTime.RealTime - vars.diff));
				vars.ctime = TimeSpan.Zero;
				return (test);
			}
		}
	}

	if (vars.multigamepause && vars.forcesplit == false)
	{
		if (vars.multigametime != timer.CurrentTime.GameTime)
		{
			vars.ingametime = 0;
			vars.multigametime = timer.CurrentTime.GameTime;
		}
		return;
	}
	else if (vars.menuindicator.Current == 7 && (settings["IGTmode"] || !(vars.gameindicator.Current == 0 || (vars.gameindicator.Current == 1 && (!settings["ILmode"] || vars.H2_levelname.Current == "01a")))))
	{
		return vars.gametime;
	}
}


exit
{
	//timer.IsGameTimePaused = false; //unpause the timer on gamecrash UNLESS it was paused for multi-game-pause option.
}