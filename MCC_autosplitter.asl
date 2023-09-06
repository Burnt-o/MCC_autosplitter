//Halo: The Master Chief Collection Autosplitter
//by Burnt and Cambid

//NOTES
/*
	Game isn't doing comp splits dirty tracking anymore. Might have to add it here at some point.
*/

state("MCC-Win64-Shipping") {}
state("MCC-Win64-Shipping-WinStore") {} 
state("MCCWinStore-Win64-Shipping") {} //what the fuck 343?!


init //hooking to game to make memorywatchers
{
	if (settings["perfmode"])	//Set autosplitter refresh rate. Probably doesn't help much. Whatever
	{
		refreshRate = 30;
	}
	else 
	{
		refreshRate = 60;
	}

	var message = "It looks like MCC has received a new patch that will "+
	"probably break me (the autosplitter). \n"+
	"Autosplitter was made for version: "+ "1.3251.0.0" + "\n" + 
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

		case "1.3073.0.0":
			version = "1.3073.0.0";
		break;

		case "1.3251.0.0":
			version = "1.3251.0.0";
		break;
		
		default: 
			version = "1.3251.0.0";
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
	//Create watchers
	vars.watchers_mcc = new MemoryWatcherList();
	vars.watchers_game = new MemoryWatcherList();
	vars.watchers_igt = new MemoryWatcherList();
	vars.watchers_comptimer = new MemoryWatcherList();

	vars.watchers_h1 = new MemoryWatcherList();
	vars.watchers_h1cs = new MemoryWatcherList();
	vars.watchers_h1xy = new MemoryWatcherList();
	vars.watchers_h1fade = new MemoryWatcherList();
	vars.watchers_h1load = new MemoryWatcherList();
	vars.watchers_h1death = new MemoryWatcherList();
	vars.watchers_h1other = new MemoryWatcherList();

	vars.watchers_h2 = new MemoryWatcherList();
	vars.watchers_h2fg = new MemoryWatcherList();
	vars.watchers_h2xy = new MemoryWatcherList();
	vars.watchers_h2fade = new MemoryWatcherList();
	vars.watchers_h2bsp = new MemoryWatcherList();
	vars.watchers_h2death = new MemoryWatcherList();

	vars.watchers_h3 = new MemoryWatcherList();
	vars.watchers_h3fg = new MemoryWatcherList();
	vars.watchers_h3bsp = new MemoryWatcherList();
	vars.watchers_h3death = new MemoryWatcherList();

	vars.watchers_hr = new MemoryWatcherList();
	vars.watchers_hrbsp = new MemoryWatcherList();
	vars.watchers_hrdeath = new MemoryWatcherList();

	vars.watchers_odst = new MemoryWatcherList();
	vars.watchers_odstbsp = new MemoryWatcherList();
	vars.watchers_odstdeath = new MemoryWatcherList();

	vars.watchers_h4 = new MemoryWatcherList();
	vars.watchers_h4bsp = new MemoryWatcherList();

	switch (version)
	{
	case "1.3251.0.0":
			if (modules.First().ToString().Equals("MCC-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Steam
			{
				vars.dllPointer = 0x3FFD608;

				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3EC6A29)) { Name = "menuindicator" });
				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3FBA369)) { Name = "stateindicator" });
				vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3FFD548, 0x0)) { Name = "gameindicator" });
				vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3FFD600)) { Name = "IGT_float" });
				vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3FFD560, 0x1AC)) { Name = "comptimerstate" });
			}
			else if (modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Winstore
			{
				vars.dllPointer = 0x3E4BAB0; 

				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3D154A9)) { Name = "menuindicator" });
				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3E08969)) { Name = "stateindicator" });
				vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3E4B9E8, 0x0)) { Name = "gameindicator" });
				vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3E4BAA8)) { Name = "IGT_float" });
				vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3E4BA00, 0x1AC)) { Name = "comptimerstate" });
			}

			vars.H1_core = 0x2B23700;
			vars.H1_map = 0x2B22744;
			vars.H1_cinflags = 0x2EA0208;
			vars.H1_coords = 0x2D9B9C4;
			vars.H1_fade = 0x2EA8718;

			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2B6F5E4)) { Name = "tickcounter" });
			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2EA31D4)) { Name = "IGT" });
			vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, 0x1B860A4)) { Name = "bspstate" });

			vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x20), 32) { Name = "levelname" });
			vars.watchers_h1load.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x1)) { Name = "gamewon" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0A)) { Name = "cinematic" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0B)) { Name = "cutsceneskip" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords)) { Name = "xpos" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C0)) { Name = "fadetick" });
			vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C4)) { Name = "fadelength" });
			vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C6)) { Name = "fadebyte" });
			vars.watchers_h1death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x17)) { Name = "deathflag" });
			vars.watchers_h1other.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x64)) { Name = "checksum" });
			vars.watchers_h1other.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x68)) { Name = "h1aflags" });

			vars.H2_cinflags = 0x15F5788;
			vars.H2_coords = 0xE7F5E8;
			vars.H2_fade = 0x15EA778;

			vars.watchers_h2.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x28, 0xE6FE68), 3) { Name = "levelname" });
			vars.watchers_h2.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x15A2EA0)) { Name = "IGT" });
			vars.watchers_h2bsp.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xDF8D74)) { Name = "bspstate" });
			vars.watchers_h2death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x28, 0xE7FA50, -0xEF)) { Name = "deathflag" });
			vars.watchers_h2fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x15E3074)) { Name = "tickcounter" });
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xE20278)) { Name = "graphics" });

			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x92E)) { Name = "fadebyte" });
			vars.watchers_h2fg.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x938)) { Name = "letterbox" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords)) { Name = "xpos" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h2fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x0)) { Name = "fadetick" });
			vars.watchers_h2fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x4)) { Name = "fadelength" });

			vars.watchers_h3.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x48, 0x20A8118), 3) { Name = "levelname" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x2135F70)) { Name = "theatertime" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x2D3C04C)) { Name = "tickcounter" });
			vars.watchers_h3bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x48, 0xA4E170, 0x2C)) { Name = "bspstate" });
			vars.watchers_h3death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x48, 0x202F2D8, 0xFDCD)) { Name = "deathflag" });

			vars.watchers_hr.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xC8, 0x2A1F597), 3) { Name = "levelname" });
			vars.watchers_hrbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xC8, 0x4E2FBA8)) { Name = "bspstate" });
			vars.watchers_hrdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xC8, 0x24FB718, 0x1ED09)) { Name = "deathflag" });

			vars.watchers_odst.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xA8, 0x20EF128), 4) { Name = "levelname" });
			vars.watchers_odst.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0xA8, 0x21F05F8)) { Name = "streets" });
			vars.watchers_odstbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xA8, 0x46E261C)) { Name = "bspstate" });
			vars.watchers_odstdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xA8, 0x100CB3C, -0x913)) { Name = "deathflag" });

			vars.watchers_h4.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x68, 0x2AFF81F), 3) { Name = "levelname" });
			vars.watchers_h4bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x68, 0x275D550)) { Name = "bspstate" });

		break;


		case "1.3073.0.0":
			if (modules.First().ToString().Equals("MCC-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Steam
			{
				vars.dllPointer = 0x3FFD608;

				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3EE3FA9)) { Name = "menuindicator" });
				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3FD8E99)) { Name = "stateindicator" });
				vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x401C1C0, 0x0)) { Name = "gameindicator" });
				vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x401C204)) { Name = "IGT_float" });
				vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x401C1D8, 0x1AC)) { Name = "comptimerstate" });
			}
			else if (modules.First().ToString().Equals("MCC-Win64-Shipping-WinStore.exe", StringComparison.OrdinalIgnoreCase) || modules.First().ToString().Equals("MCCWinStore-Win64-Shipping.exe", StringComparison.OrdinalIgnoreCase)) //Winstore
			{
				vars.dllPointer = 0x3E4BAB0; 

				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3D33AA9)) { Name = "menuindicator" });
				vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3E28465)) { Name = "stateindicator" });
				vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3E6B810, 0x0)) { Name = "gameindicator" });
				vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3E6B854)) { Name = "IGT_float" });
				vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3E6B828, 0x1AC)) { Name = "comptimerstate" });
			}

			vars.H1_core = 0x2CA0780;
			vars.H1_map = 0x2C9F7C4;
			vars.H1_cinflags = 0x3005198;
			vars.H1_coords = 0x2F00954;
			vars.H1_fade = 0x300D678;

			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2CEBD34)) { Name = "tickcounter" });
			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x3008134)) { Name = "IGT" });
			vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, 0x1CECDFC)) { Name = "bspstate" });

			vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x20), 32) { Name = "levelname" });
			vars.watchers_h1load.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x1)) { Name = "gamewon" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0A)) { Name = "cinematic" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0B)) { Name = "cutsceneskip" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords)) { Name = "xpos" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C0)) { Name = "fadetick" });
			vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C4)) { Name = "fadelength" });
			vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C6)) { Name = "fadebyte" });
			vars.watchers_h1death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x17)) { Name = "deathflag" });
			vars.watchers_h1other.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x64)) { Name = "checksum" });
			vars.watchers_h1other.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x68)) { Name = "h1aflags" });

			vars.H2_cinflags = 0x15F42B8;
			vars.H2_coords = 0xE7E308;
			vars.H2_fade = 0xE7E308;

			vars.watchers_h2.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x28, 0xE6ED78), 3) { Name = "levelname" });
			vars.watchers_h2.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x15A1BA0)) { Name = "IGT" });
			vars.watchers_h2bsp.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xDF7D74)) { Name = "bspstate" });
			vars.watchers_h2death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x28, 0xE7E760, -0xEF)) { Name = "deathflag" });
			vars.watchers_h2fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x15E1D74)) { Name = "tickcounter" });
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xE1F178)) { Name = "graphics" });

			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x92E)) { Name = "fadebyte" });
			vars.watchers_h2fg.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x938)) { Name = "letterbox" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords)) { Name = "xpos" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h2fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x0)) { Name = "fadetick" });
			vars.watchers_h2fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x4)) { Name = "fadelength" });

			vars.watchers_h3.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x48, 0x1E92AB8), 3) { Name = "levelname" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x1F2084C)) { Name = "theatertime" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x2B34F2C)) { Name = "tickcounter" });
			vars.watchers_h3bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x48, 0xA39220, 0x2C)) { Name = "bspstate" });
			vars.watchers_h3death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x48, 0x1E19C98, 0xFDCD)) { Name = "deathflag" });

			vars.watchers_hr.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xC8, 0x2A2F6D7), 3) { Name = "levelname" });
			vars.watchers_hrbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xC8, 0x3B9C020)) { Name = "bspstate" });
			vars.watchers_hrdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xC8, 0x250B808, 0x1ED09)) { Name = "deathflag" });

			vars.watchers_odst.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xA8, 0x20C0DA8), 4) { Name = "levelname" });
			vars.watchers_odst.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0xA8, 0x21463B4)) { Name = "streets" });
			vars.watchers_odstbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xA8, 0x33FD0DC)) { Name = "bspstate" });
			vars.watchers_odstdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xA8, 0xFDEAFC, -0x913)) { Name = "deathflag" });

			vars.watchers_h4.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x68, 0x2AE485F), 3) { Name = "levelname" });
			vars.watchers_h4bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x68, 0x2746930)) { Name = "bspstate" });

		break;


		//Legacy Steam Support - No Winstore
		case "1.2969.0.0":
			vars.dllPointer = 0x3F94F90;

			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3E5DF29)) { Name = "menuindicator" });
			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3F519E9)) { Name = "stateindicator" });
			vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3F94E90, 0x0)) { Name = "gameindicator" });
			vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3F94F88)) { Name = "IGT_float" });
			vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3F94F60, 0x1A4)) { Name = "comptimerstate" });

			vars.H1_core = 0x2CC5860;
			vars.H1_map = 0x2EEB024;
			vars.H1_cinflags = 0x2FFBD28;
			vars.H1_coords = 0x1DF5FF8;
			vars.H1_fade = 0x30041A8;

			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2CECFD4)) { Name = "tickcounter" });
			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x14872C0)) { Name = "IGT" });
			vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, 0x1CE4920)) { Name = "bspstate" });

			vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x20), 32) { Name = "levelname" });
			vars.watchers_h1load.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x1)) { Name = "gamewon" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0A)) { Name = "cinematic" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0B)) { Name = "cutsceneskip" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords)) { Name = "xpos" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C0)) { Name = "fadetick" });
			vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C4)) { Name = "fadelength" });
			vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C6)) { Name = "fadebyte" });
			vars.watchers_h1death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x17)) { Name = "deathflag" });
			vars.watchers_h1other.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x64)) { Name = "checksum" });
			vars.watchers_h1other.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x68)) { Name = "h1aflags" });

			vars.H2_cinflags = 0x14D9448;
			vars.H2_coords = 0xD63A28;
			vars.H2_fade = 0x14CEB68;

			vars.watchers_h2.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x28, 0xD54498), 3) { Name = "levelname" });
			vars.watchers_h2.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x14872C0)) { Name = "IGT" });
			vars.watchers_h2bsp.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCB2D74)) { Name = "bspstate" });
			vars.watchers_h2death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x28, 0xD63E80, -0xEF)) { Name = "deathflag" });
			vars.watchers_h2fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x14C7494)) { Name = "tickcounter" });
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCD8998)) { Name = "graphics" });

			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x92E)) { Name = "fadebyte" });
			vars.watchers_h2fg.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x938)) { Name = "letterbox" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords)) { Name = "xpos" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h2fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x0)) { Name = "fadetick" });
			vars.watchers_h2fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x4)) { Name = "fadelength" });

			vars.watchers_h3.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x48, 0x1EABB78), 3) { Name = "levelname" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x1F3DD5C)) { Name = "theatertime" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x2B4178C)) { Name = "tickcounter" });
			vars.watchers_h3bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x48, 0xA41D20, 0x2C)) { Name = "bspstate" });
			vars.watchers_h3death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x48, 0x1E30758, 0x1074D)) { Name = "deathflag" });

			vars.watchers_hr.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xC8, 0x2A39A8F), 3) { Name = "levelname" });
			vars.watchers_hrbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xC8, 0x3BB32A0)) { Name = "bspstate" });
			vars.watchers_hrdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xC8, 0x2514A88, 0x1F419)) { Name = "deathflag" });

			vars.watchers_odst.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xA8, 0x20D68F8), 4) { Name = "levelname" });
			vars.watchers_odst.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0xA8, 0x21DD308)) { Name = "streets" });
			vars.watchers_odstbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xA8, 0x3417D4C)) { Name = "bspstate" });
			vars.watchers_odstdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xA8, 0xFB940C, -0x913)) { Name = "deathflag" });

			vars.watchers_h4.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x68, 0x2B03887), 3) { Name = "levelname" });
			vars.watchers_h4bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x68, 0x27564B0)) { Name = "bspstate" });

		break;


		case "1.2904.0.0":
			vars.dllPointer = 0x3F7BA50;

			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3E45529)) { Name = "menuindicator" });
			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3F2FBC9)) { Name = "stateindicator" });
			vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3F7C380, 0x0)) { Name = "gameindicator" });
			vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3F7C33C)) { Name = "IGT_float" });
			vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3F7C358, 0x1A4)) { Name = "comptimerstate" });

			vars.H1_core = 0x2B611A0;
			vars.H1_map = 0x2D66A24;
			vars.H1_cinflags = 0x2E773D8;
			vars.H1_coords = 0x2D7313C;
			vars.H1_fade = 0x2E7F868;

			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2B88764)) { Name = "tickcounter" });
			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2E7A354)) { Name = "IGT" });
			vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, 0x1B661CC)) { Name = "bspstate" });

			vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x20), 32) { Name = "levelname" });
			vars.watchers_h1load.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x1)) { Name = "gamewon" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0A)) { Name = "cinematic" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0B)) { Name = "cutsceneskip" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords)) { Name = "xpos" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C0)) { Name = "fadetick" });
			vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C4)) { Name = "fadelength" });
			vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C6)) { Name = "fadebyte" });
			vars.watchers_h1death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x17)) { Name = "deathflag" });
			vars.watchers_h1other.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x64)) { Name = "checksum" });
			vars.watchers_h1other.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x68)) { Name = "h1aflags" });

			vars.H2_cinflags = 0x1520498;
			vars.H2_coords = 0xD5A148;
			vars.H2_fade = 0x14C5228;

			vars.watchers_h2.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x28, 0xD4ABF8), 3) { Name = "levelname" });
			vars.watchers_h2.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x147D9F0)) { Name = "IGT" });
			vars.watchers_h2bsp.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCACD74)) { Name = "bspstate" });
			vars.watchers_h2death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x28, 0xD5A5A0, -0xEF)) { Name = "deathflag" });
			vars.watchers_h2fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x14BDBC4)) { Name = "tickcounter" });
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCCF280)) { Name = "graphics" });

			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x92E)) { Name = "fadebyte" });
			vars.watchers_h2fg.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x938)) { Name = "letterbox" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords)) { Name = "xpos" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h2fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x0)) { Name = "fadetick" });
			vars.watchers_h2fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x4)) { Name = "fadelength" });

			vars.watchers_h3.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x48, 0x1E092E8), 3) { Name = "levelname" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x1E9B4BC)) { Name = "theatertime" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x29E194C)) { Name = "tickcounter" });
			vars.watchers_h3bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x48, 0x99FCA0, 0x2C)) { Name = "bspstate" });
			vars.watchers_h3death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x48, 0x1D8DF48, 0x1073D)) { Name = "deathflag" });

			vars.watchers_hr.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xC8, 0x28A4C3F), 3) { Name = "levelname" });
			vars.watchers_hrbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xC8, 0x3719E24)) { Name = "bspstate" });
			vars.watchers_hrdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xC8, 0x23CC7D8, 0x1F419)) { Name = "deathflag" });

			vars.watchers_odst.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xA8, 0x202EA58), 4) { Name = "levelname" });
			vars.watchers_odst.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0xA8, 0x21353D8)) { Name = "streets" });
			vars.watchers_odstbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xA8, 0x2F9FD4C)) { Name = "bspstate" });
			vars.watchers_odstdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xA8, 0xF3EB8C, -0x913)) { Name = "deathflag" });

			vars.watchers_h4.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x68, 0x29A3743), 3) { Name = "levelname" });
			vars.watchers_h4bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x68, 0x25DC188)) { Name = "bspstate" });

		break;


		case "1.2645.0.0":
			vars.dllPointer = 0x3B80E98;

			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3A4A7C9)) { Name = "menuindicator" });
			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x3b40d69)) { Name = "stateindicator" });
			vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3B81270, 0x0)) { Name = "gameindicator" });
			vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3B80FF8)) { Name = "IGT_float" });
			vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3B81380, 0x1A4)) { Name = "comptimerstate" });

			vars.H1_core = 0x2AF8240;
			vars.H1_map = 0x2A52D84;
			vars.H1_cinflags = 0x2AF89B8;
			vars.H1_coords = 0x2A5EFF4;
			vars.H1_fade = 0x2B88E58;

			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2B5FC04)) { Name = "tickcounter" });
			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2AFB954)) { Name = "IGT" });
			vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, 0x19F748C)) { Name = "bspstate" });

			vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x20), 32) { Name = "levelname" });
			vars.watchers_h1load.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x1)) { Name = "gamewon" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0A)) { Name = "cinematic" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0B)) { Name = "cutsceneskip" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords)) { Name = "xpos" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C0)) { Name = "fadetick" });
			vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C4)) { Name = "fadelength" });
			vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C6)) { Name = "fadebyte" });
			vars.watchers_h1death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x17)) { Name = "deathflag" });
			vars.watchers_h1other.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x64)) { Name = "checksum" });
			vars.watchers_h1other.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x68)) { Name = "h1aflags" });

			vars.H2_cinflags = 0x15186A0;
			vars.H2_coords = 0xD523A8;
			vars.H2_fade = 0x14BD450;

			vars.watchers_h2.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x28, 0xD42E68), 3) { Name = "levelname" });
			vars.watchers_h2.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x1475C10)) { Name = "IGT" });
			vars.watchers_h2bsp.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCA4D74)) { Name = "bspstate" });
			vars.watchers_h2death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x28, 0xD52800, -0xEF)) { Name = "deathflag" });
			vars.watchers_h2fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0x14B5DE4)) { Name = "tickcounter" });
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCC74A8)) { Name = "graphics" });

			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x92E)) { Name = "fadebyte" });
			vars.watchers_h2fg.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x938)) { Name = "letterbox" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords)) { Name = "xpos" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h2fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x0)) { Name = "fadetick" });
			vars.watchers_h2fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x4)) { Name = "fadelength" });

			vars.watchers_h3.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x48, 0x1E0D358), 3) { Name = "levelname" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x1EDAA9C)) { Name = "theatertime" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x2A1F34C)) { Name = "tickcounter" });
			vars.watchers_h3bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x48, 0x9A4Ba0, 0x2C)) { Name = "bspstate" });
			vars.watchers_h3death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x48, 0x1D91E68, 0x1077D)) { Name = "deathflag" });

			vars.watchers_hr.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xC8, 0x2907107), 3) { Name = "levelname" });
			vars.watchers_hrbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xC8, 0x3716270)) { Name = "bspstate" });
			vars.watchers_hrdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xC8, 0xEEF330, 0x594249)) { Name = "deathflag" });

			vars.watchers_odst.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xA8, 0x2020CA8), 4) { Name = "levelname" });
			vars.watchers_odst.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0xA8, 0x2116FD8)) { Name = "streets" });
			vars.watchers_odstbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xA8, 0x2F91A9C)) { Name = "bspstate" });
			vars.watchers_odstdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xA8, 0xF3020c, -0x913)) { Name = "deathflag" });

			vars.watchers_h4.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x68, 0x2836433), 3) { Name = "levelname" });
			vars.watchers_h4bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x68, 0x2472A88)) { Name = "bspstate" });

		break;


		case "1.2448.0.0":
			vars.dllPointer = 0x3A24FF8;

			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x38EF0A9)) { Name = "menuindicator" });
			vars.watchers_mcc.Add(new MemoryWatcher<byte>(new DeepPointer(0x39E4DE9)) { Name = "stateindicator" });
			vars.watchers_game.Add(new MemoryWatcher<byte>(new DeepPointer(0x3A253A0, 0x0)) { Name = "gameindicator" });
			vars.watchers_igt.Add(new MemoryWatcher<float>(new DeepPointer(0x3A25188)) { Name = "IGT_float" });
			vars.watchers_comptimer.Add(new MemoryWatcher<uint>(new DeepPointer(0x3A254B0, 0x1A4)) { Name = "comptimerstate" });

			vars.H1_core = 0x2AF10D0;
			vars.H1_map = 0x2A4BC04;
			vars.H1_cinflags = 0x2AF1868;
			vars.H1_coords = 0x2A57E74;
			vars.H1_fade = 0x2B81CE8;

			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2B58A24)) { Name = "tickcounter" });
			vars.watchers_h1.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, 0x2AF477C)) { Name = "IGT" });
			vars.watchers_h1.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, 0x19F0400)) { Name = "bspstate" });

			vars.watchers_h1.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x20), 32) { Name = "levelname" });
			vars.watchers_h1load.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x1)) { Name = "gamewon" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0A)) { Name = "cinematic" });
			vars.watchers_h1cs.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_cinflags, 0x0B)) { Name = "cutsceneskip" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords)) { Name = "xpos" });
			vars.watchers_h1xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h1fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C0)) { Name = "fadetick" });
			vars.watchers_h1fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C4)) { Name = "fadelength" });
			vars.watchers_h1fade.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_fade, 0x3C6)) { Name = "fadebyte" });
			vars.watchers_h1death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_core + 0x17)) { Name = "deathflag" });
			vars.watchers_h1other.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x64)) { Name = "checksum" });
			vars.watchers_h1other.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x8, vars.H1_map + 0x68)) { Name = "h1aflags" });

			vars.H2_cinflags = 0x143ACA0;
			vars.H2_coords = 0xDA5CD8;
			vars.H2_fade = 0x13DFC58;

			vars.watchers_h2.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x28, 0xE63FB3), 3) { Name = "levelname" });
			vars.watchers_h2.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0xE22F40)) { Name = "IGT" });
			vars.watchers_h2bsp.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCD7D74)) { Name = "bspstate" });
			vars.watchers_h2death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x28, 0xDA6140, -0xEF)) { Name = "deathflag" });
			vars.watchers_h2fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, 0xE63144)) { Name = "tickcounter" });
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, 0xCFB918)) { Name = "graphics" });
			
			vars.watchers_h2fg.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x92E)) { Name = "fadebyte" });
			vars.watchers_h2fg.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_cinflags, -0x938)) { Name = "letterbox" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords)) { Name = "xpos" });
			vars.watchers_h2xy.Add(new MemoryWatcher<float>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_coords + 0x4)) { Name = "ypos" });
			vars.watchers_h2fade.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x0)) { Name = "fadetick" });
			vars.watchers_h2fade.Add(new MemoryWatcher<ushort>(new DeepPointer(vars.dllPointer, 0x28, vars.H2_fade, 0x4)) { Name = "fadelength" });

			vars.watchers_h3.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x48, 0x1D2C460), 3) { Name = "levelname" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x1DDC3BC)) { Name = "theatertime" });
			vars.watchers_h3fg.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0x48, 0x2961E0C)) { Name = "tickcounter" });
			vars.watchers_h3bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x48, 0x9F3EF0, 0x2C)) { Name = "bspstate" });
			vars.watchers_h3death.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0x48, 0x1CB15C8, 0x1051D)) { Name = "deathflag" });

			vars.watchers_hr.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xC8, 0x2868777), 3) { Name = "levelname" });
			vars.watchers_hrbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xC8, 0x36778E0)) { Name = "bspstate" });
			vars.watchers_hrdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xC8, 0xEEFEB0, 0x544249)) { Name = "deathflag" });

			vars.watchers_odst.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0xA8, 0x1CDF200), 4) { Name = "levelname" });
			vars.watchers_odst.Add(new MemoryWatcher<byte>(new DeepPointer(vars.dllPointer, 0xA8, 0x1DB2568)) { Name = "streets" });
			vars.watchers_odstbsp.Add(new MemoryWatcher<uint>(new DeepPointer(vars.dllPointer, 0xA8, 0x2E46964)) { Name = "bspstate" });
			vars.watchers_odstdeath.Add(new MemoryWatcher<bool>(new DeepPointer(vars.dllPointer, 0xA8, 0xE8520C, -0x913)) { Name = "deathflag" });

			vars.watchers_h4.Add(new StringWatcher(new DeepPointer(vars.dllPointer, 0x68, 0x276ACA3), 3) { Name = "levelname" });
			vars.watchers_h4bsp.Add(new MemoryWatcher<ulong>(new DeepPointer(vars.dllPointer, 0x68, 0x2441AB8, -0x560)) { Name = "bspstate" });

		break;
	}
		

	//version dependent constants
	switch (version)
	{
		case "1.3251.0.0":
			vars.h1_checklist = new Dictionary<string, uint>{{"a10", 1731967100},{"a30", 2334900663},{"a50", 2345488806},{"b30", 389775619},{"b40", 232036917},{"c10", 3544120777},{"c20", 2188406812},{"c40", 687169669},{"d20", 485256620},{"d40", 1783204841},};
			vars.fadescale = 0.067;
		break;

		case "1.3073.0.0":
			vars.h1_checklist = new Dictionary<string, uint>{{"a10", 3589325267},{"a30", 3649693672},{"a50", 1186687708},{"b30", 1551598635},{"b40", 1100623455},{"c10", 3494823778},{"c20", 2445460720},{"c40", 3759075146},{"d20", 3442848200},{"d40", 1751474532},};
			vars.fadescale = 0.067;
		break;

		case "1.2969.0.0":
			vars.h1_checklist = new Dictionary<string, uint>{{"a10", 2023477633},{"a30", 1197744442},{"a50", 522123179},{"b30", 2022995318},{"b40", 4112928798},{"c10", 4250424451},{"c20", 1165450382},{"c40", 2733116763},{"d20", 1722772470},{"d40", 3775314541},};
			vars.fadescale = 0.067;
		break;

		case "1.2904.0.0":
			vars.h1_checklist = new Dictionary<string, uint>{{"a10", 89028072},{"a30", 1083179843},{"a50", 2623582826},{"b30", 1895318681},{"b40", 1935970024},{"c10", 974037405},{"c20", 714510620},{"c40", 2859044941},{"d20", 1178559651},{"d40", 3253884125},};
			vars.fadescale = 0.067;
		break;

		case "1.2645.0.0":
			vars.h1_checklist = new Dictionary<string, uint>{{"a10", 4031641132},{"a30", 1497905037},{"a50", 2613596386},{"b30", 4057206713},{"b40", 2439716616},{"c10", 2597150717},{"c20", 1656675814},{"c40", 1573304389},{"d20", 1507739304},{"d40", 2038583061},};
			vars.fadescale = 0.067;
		break;

		case "1.2448.0.0":
			vars.h1_checklist = new Dictionary<string, uint>{{"a10", 2495112808},{"a30", 1196246201},{"a50", 3037603536},{"b30", 682311759},{"b40", 326064131},{"c10", 645721511},{"c20", 540616268},{"c40", 1500399674},{"d20", 2770760039},{"d40", 1695151528},};
			vars.fadescale = 0.183;
		break;
	}
}



startup //variable init and settings
{ 	
	//MOVED VARIABLE INIT TO STARTUP TO PREVENT BUGS WHEN RESTARTING (OR CRASHING) MCC MID RUN
	vars.brokenupdateshowed = false;
	vars.h3resetflag = false;
	vars.loopcount = 0;

	//GENERAL VARS INIT - most of these need to be reinit on timer reset
	vars.varsreset = false;

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
	vars.h1_checklist = new Dictionary<string, uint>{};


	//BOOL DICTIONARIES
	vars.multigamepauseBools = new Dictionary<byte, Func<bool>>
	{
		{ 0, () => vars.watchers_h1["levelname"].Current == "d40" && !vars.watchers_h1cs["cinematic"].Old && vars.watchers_h1cs["cinematic"].Current && !vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1xy["xpos"].Current > 1000 && !vars.watchers_h1death["deathflag"].Current }, //poa
		{ 1, () => vars.watchers_h2["levelname"].Current == "08b" && (vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2fg["letterbox"].Current > 0.96 && vars.watchers_h2fg["letterbox"].Old <= 0.96  && vars.watchers_h2fg["letterbox"].Old != 0 && vars.H2_tgjreadyflag && ( vars.watchers_h2fg["tickcounter"].Current > (vars.H2_tgjreadytime + 300))) }, //h2
		{ 2, () => vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44 && vars.watchers_h3["levelname"].Current == "130" && !settings["anylevel"] }, //h3
		{ 3, () => vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57 && vars.watchers_mcc["stateindicator"].Old != 190 && vars.watchers_h4["levelname"].Current == "m90" && !settings["anylevel"] }, //h4
		{ 5, () => vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57 && vars.watchers_mcc["stateindicator"].Old != 190 && vars.watchers_odst["levelname"].Current == "l300" && !settings["anylevel"] }, //odst
		{ 6, () => vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57 && vars.watchers_mcc["stateindicator"].Old != 190 && vars.watchers_hr["levelname"].Current == "m70" && !settings["anylevel"] }, //hr
	};

	vars.multigameresume = new Dictionary<byte, Func<bool>>
	{
		{ 0, () => vars.watchers_h1["levelname"].Current == "a10" && vars.watchers_h1["bspstate"].Current == 0 && vars.watchers_h1xy["xpos"].Current < -55 && vars.watchers_h1["tickcounter"].Current > 280 && vars.watchers_h1cs["cinematic"].Current == false && vars.watchers_h1cs["cinematic"].Old == true }, //h1
		{ 1, () => (vars.watchers_h2["levelname"].Current == "01a" && vars.watchers_h2fg["tickcounter"].Current >= 26 &&  vars.watchers_h2fg["tickcounter"].Current < 30) || (vars.watchers_h2["levelname"].Current == "01b" && vars.watchers_mcc["stateindicator"].Current != 44 && vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_h2fg["tickcounter"].Current < 30) }, //h2
		{ 2, () => vars.watchers_h3["levelname"].Current == "010" && vars.watchers_h3fg["theatertime"].Current > 15 && vars.watchers_h3fg["theatertime"].Current < 30 }, //h3
		{ 3, () => vars.watchers_h4["levelname"].Current == "m10" && vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5 }, //h4
		{ 5, () => vars.watchers_odst["levelname"].Current == "h100" && vars.watchers_odst["streets"].Current == 0 && vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5 }, //odst
		{ 6, () => vars.watchers_hr["levelname"].Current == "m10" && vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5 }, //hr
	};

	vars.H1_ILstart = new Dictionary<string, Func<bool>>
	{
		{"a10", () => vars.watchers_h1["bspstate"].Current == 0 && vars.watchers_h1xy["xpos"].Current < -55 && vars.watchers_h1["tickcounter"].Current > 280 && !vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old }, //poa
		{"a30", () => ((vars.watchers_h1["tickcounter"].Current >= 182 && vars.watchers_h1["tickcounter"].Current < 190) || (!vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old && vars.watchers_h1["tickcounter"].Current > 500 && vars.watchers_h1["tickcounter"].Current < 900)) && !vars.watchers_h1cs["cutsceneskip"].Current }, //halo
		{"a50", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 900 && !vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old }, //tnr
		{"b30", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 1060 && !vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old }, //sc
		{"b40", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 950 && !vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old }, //aotcr
		{"c10", () => vars.watchers_h1["tickcounter"].Current > 30 && vars.watchers_h1["tickcounter"].Current < 700 && !vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old }, //343
		{"c20", () => !vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1cs["cutsceneskip"].Old }, //library
		{"c40", () => !vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1cs["cutsceneskip"].Old }, //tb
		{"d20", () => !vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1cs["cutsceneskip"].Old }, //keyes
		{"d40", () => !vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1cs["cutsceneskip"].Old }, //maw
	};
	
	vars.H1_ILendsplits = new Dictionary<string, Func<bool>>
	{
		{"a10", () => vars.watchers_h1["bspstate"].Current == 6 && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current }, //poa
		{"a30", () => vars.watchers_h1["bspstate"].Current == 1 && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current }, //halo
		{"a50", () => (vars.watchers_h1["bspstate"].Current == 3 || vars.watchers_h1["bspstate"].Current == 2) && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1fade["fadelength"].Current == 15 }, //tnr
		{"b30", () => vars.watchers_h1["bspstate"].Current == 0 && !vars.watchers_h1cs["cinematic"].Current && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current }, //sc
		{"b40", () => vars.watchers_h1["bspstate"].Current == 2 && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current }, //aotcr
		{"c10", () => vars.watchers_h1["bspstate"].Current != 2 && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current }, //343
		{"c20", () => vars.watchers_h1cs["cinematic"].Current && !vars.watchers_h1cs["cinematic"].Old && vars.watchers_h1["tickcounter"].Current > 30 }, //library
		{"c40", () => vars.watchers_h1["tickcounter"].Current > 30 && !vars.watchers_h1cs["cutsceneskip"].Old && vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1fade["fadebyte"].Current != 1 }, //tb
		{"d20", () => vars.watchers_h1fade["fadelength"].Current == 30 && !vars.watchers_h1cs["cinematic"].Old && vars.watchers_h1cs["cinematic"].Current}, //keyes
		{"d40", () => !vars.watchers_h1cs["cinematic"].Old && vars.watchers_h1cs["cinematic"].Current && !vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1xy["xpos"].Current > 1000 && !vars.watchers_h1death["deathflag"].Current}, //maw
	};


	//BSP LEVEL LIST
	//HALO 1
	vars.H1_levellist = new Dictionary<string, byte[]>
	{
		{"a10", new byte[] { 1, 2, 3, 4, 5, 6 }}, //poa
		{"a30", new byte[] { 1 }}, //halo
		{"a50", new byte[] { 1, 2, 3 }}, //tnr
		{"b30", new byte[] { 1 }}, //sc
		{"b40", new byte[] { 0, 1, 2, 4, 8, 9, 10, 11 }}, //aotcr - put the others in for fullpath andys
		{"c10", new byte[] { 1, 3, 4, 5 }}, //343
		{"c20", new byte[] { 1, 2, 3 }}, //library
		{"c40", new byte[] { 12, 10, 1, 9, 8, 6, 0, 5 }}, //tb
		{"d20", new byte[] { 4, 3, 2 }}, //keyes
		{"d40", new byte[] { 1, 2, 3, 4, 5, 6, 7 }}, //maw
	};

	//HALO 2
	vars.H2_levellist = new Dictionary<string, byte[]>
	{
		{"01a", new byte[] {  }}, //armory
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
	vars.H3_levellist = new Dictionary<string, ulong[]>
	{
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
	vars.HR_levellist = new Dictionary<string, uint[]>
	{
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
	vars.H4_levellist = new Dictionary<string, ulong[]>
	{
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
	vars.ODST_levellist = new Dictionary<string, uint[]>
	{
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
	if(timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
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
		"You'll need to add a lot of extra splits for this option, see this spreadsheet for a count of how many per level of each game (outdated): \n" +
		"tinyurl.com/bspsplit"
	);

	settings.Add("bsp_cache", false, "Split on non-unique loads too", "bspmode");
	settings.SetToolTip("bsp_cache", "With this disabled, only the first time you enter a specific bsp will cause a split. \n" +
		"This is so that if you hit a load, then die and revert to before the load, and hit again, you won't get duplicate splits. \n" +
		"You probably shouldn't turn this on, unless you're say, practicing a specific segment of a level (from one load to another)."
	);

	settings.Add("compsplits", false, "Use in-game competitive timer splits", "bspmode");
	settings.SetToolTip("compsplits", "Splits according to the built-in splitting functionality of the MCC in-game competitive timer instead of bsp loads. \n" +
		"For use with ODST and Halo 4 IL's only"
	);

	settings.Add("anylevel", false, "Start full-game runs on any level (READ THE TOOLTIP)");
	settings.SetToolTip("anylevel", "You probably don't need to use this. This option starts the timer on any level instead of just the first level for full-game runs. Breaks multi-game.");

	settings.Add("menupause", true, "Pause when in Main Menu", "anylevel");
	settings.Add("sqsplit", false, "Split when loading a new level from menu", "anylevel");
	settings.SetToolTip("sqsplit", "Useful for categories like Hunter%. Only for Halo CE");

	settings.Add("anystart", false, "Start the timer on custom maps (Halo: CE Only)", "anylevel");
	settings.SetToolTip("anystart", "Starts the timer on levels that aren't part of the base game such as custom campaigns like Lumoria. \n" +
		"You don't need this for Cursed Halo full-game as PoA is part of the base game. You will probably have to set a starting offset in Edit Splits"
	);

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
		if(vars.TextDeathCounter == null)
		{
			foreach (dynamic component in timer.Layout.Components)
			{
				if (component.GetType().Name != "TextComponent") continue;
				
				if (component.Settings.Text1 == "Deaths:")
				{
					vars.TextDeathCounter = component.Settings;
					break;
				}
			}
			if(vars.TextDeathCounter == null)
			{
				vars.TextDeathCounter = vars.CreateTextComponent("Deaths:");
			}
		}
		vars.TextDeathCounter.Text2 = vars.DeathCounter.ToString();
	});

	vars.CreateTextComponent = (Func<string, dynamic>)((name) =>
	{
		var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
		dynamic textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
		timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
		textComponent.Settings.Text1 = name;
		return textComponent.Settings;
	}); 


	//Clear dirty bsp function
	vars.ClearDirtyBsps = (Action)(() =>
	{
		vars.dirtybsps_byte.Clear();
		vars.dirtybsps_int.Clear();
		vars.dirtybsps_long.Clear();
	});
} 



update 
{
	vars.loopcount++;
	if (vars.loopcount == 60)
	{
		vars.loopcount = 0;
	}


	//Pointlessly overcomplicated watcher update method
	vars.watchers_mcc.UpdateAll(game);
	if (vars.watchers_mcc["menuindicator"].Current == 0)	//Stuff to do on the main menu
	{
		vars.watchers_game.UpdateAll(game);
		if (vars.watchers_game["gameindicator"].Current == 0)
		{
			vars.watchers_comptimer.UpdateAll(game);
		}
		if (vars.h3resetflag || settings["ILmode"] || settings["anylevel"])
		{
			vars.h3resetflag = false;
		}
		if (vars.pgcrexists)
		{
			vars.pgcrexists = false; //sanity check. Should never come up normally
		}
	}
	else //Once actually in game, update these
	{
		if (vars.loopcount == 0)
		{
			vars.watchers_game.UpdateAll(game);
		}

		byte test = vars.watchers_game["gameindicator"].Current;
		switch (test)
		{
			//H1
			case 0:
				vars.watchers_h1.UpdateAll(game);
				if (timer.CurrentPhase == TimerPhase.NotRunning || vars.multigamepause || (settings["Loopmode"] && vars.loading)) {
					vars.watchers_h1cs.UpdateAll(game);
					if (vars.watchers_h1["levelname"].Current == "a10")
					{
						vars.watchers_h1xy.UpdateAll(game);
					}
				}
				else {
					if (settings["ILmode"])
					{
						vars.watchers_h1cs.UpdateAll(game);
						if (vars.watchers_h1["levelname"].Current == "a50" || vars.watchers_h1["levelname"].Current == "c40" || vars.watchers_h1["levelname"].Current == "d20")
						{
							vars.watchers_h1fade.UpdateAll(game);
						}
						if (vars.watchers_h1["levelname"].Current == "d40")
						{
							vars.watchers_h1xy.UpdateAll(game);
							vars.watchers_h1death.UpdateAll(game);
						}
					}
					else {
						vars.watchers_h1load.UpdateAll(game);
						vars.watchers_comptimer.UpdateAll(game);
						if (vars.watchers_h1["levelname"].Current == "d40")
						{
							vars.watchers_h1cs.UpdateAll(game);
							vars.watchers_h1xy.UpdateAll(game);
							vars.watchers_h1death.UpdateAll(game);
						}
					}
				}

				if (settings["deathcounter"])
				{
					vars.watchers_h1death.UpdateAll(game);
				}
			break;

			//H2
			case 1:
				vars.watchers_h2.UpdateAll(game);

				if (!(settings["ILmode"] && vars.watchers_h2["levelname"].Current != "01a"))
				{
					vars.watchers_h2fg.UpdateAll(game);
					vars.watchers_h2bsp.UpdateAll(game);
					if((timer.CurrentPhase == TimerPhase.NotRunning || vars.loading) && vars.watchers_h2["levelname"].Current == "03a")
					{
						vars.watchers_h2fade.UpdateAll(game);
					}
				}

				if (settings["bspmode"])
				{
					if (settings["ILmode"])
					{
						vars.watchers_h2bsp.UpdateAll(game); //should already be updating if in fg mode
					}
					if (vars.watchers_h2["levelname"].Current == "08b")
					{
						vars.watchers_h2xy.UpdateAll(game);
					}
				}

				if (settings["deathcounter"])
				{
					vars.watchers_h2death.UpdateAll(game);
				}
			break;

			//H3
			case 2:
				vars.watchers_h3.UpdateAll(game);

				if (settings["ILmode"])
				{
					vars.watchers_igt.UpdateAll(game);
				}
				else
				{
					vars.watchers_h3fg.UpdateAll(game);
				}

				if (settings["bspmode"])
				{
					vars.watchers_h3bsp.UpdateAll(game);
				}

				if (settings["deathcounter"])
				{
					vars.watchers_h3death.UpdateAll(game);
				}
			break;

			//H4
			case 3:
				vars.watchers_h4.UpdateAll(game);
				vars.watchers_igt.UpdateAll(game);

				if (settings["bspmode"])
				{
					vars.watchers_h4bsp.UpdateAll(game);
					if (settings["compsplits"])
					{
						vars.watchers_comptimer.UpdateAll(game);
					}
				}

			break;

			//ODST
			case 5:
				vars.watchers_odst.UpdateAll(game);
				vars.watchers_igt.UpdateAll(game);

				if (settings["bspmode"])
				{
					vars.watchers_odstbsp.UpdateAll(game);
					if (settings["compsplits"])
					{
						vars.watchers_comptimer.UpdateAll(game);
					}
				}

				if (settings["deathcounter"])
				{
					vars.watchers_odstdeath.UpdateAll(game);
				}
			break;

			//HR
			case 6: 
				vars.watchers_hr.UpdateAll(game);
				vars.watchers_igt.UpdateAll(game);

				if (settings["bspmode"])
				{
					vars.watchers_hrbsp.UpdateAll(game);
				}

				if (settings["deathcounter"])
				{
					vars.watchers_hrdeath.UpdateAll(game);
				}
			break;
		}
	}


	//var reset
	if (timer.CurrentPhase == TimerPhase.Running && !vars.varsreset)
	{
		vars.varsreset = true;
	}
	else if (timer.CurrentPhase == TimerPhase.NotRunning && vars.varsreset)
	{
		vars.varsreset = false;
		vars.ClearDirtyBsps();

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
		if (settings["deathcounter"])
		{
			vars.UpdateDeathCounter();
		}

		if (vars.watchers_game["gameindicator"].Current == 2)
		{
			if (!settings["ILmode"] && !settings["anylevel"] && vars.watchers_h3["levelname"].Current == "010" && vars.watchers_h3fg["theatertime"].Current >= 15)
			{
				vars.h3resetflag = true;
			}
		}
		print ("Autosplitter vars reinitalized!");
	}


	//Things that only need to happen after timer has started
	if (timer.CurrentPhase == TimerPhase.Running)
	{
		byte test = vars.watchers_game["gameindicator"].Current;
		//If someone is manually starting the timer for some reason
		if (vars.watchers_mcc["menuindicator"].Current > 0 && (vars.startedlevel == "000" || vars.startedlevel == null))
		{
			switch (test)
			{
				case 0:
					vars.startedlevel = vars.watchers_h1["levelname"].Current;
					vars.startedgame = 0;
				break;

				case 1:
					vars.startedlevel = vars.watchers_h2["levelname"].Current;
					vars.startedgame = 1;
				break;

				case 2:
					vars.startedlevel = vars.watchers_h3["levelname"].Current;
					vars.startedgame = 2;
				break;

				case 3:
					vars.startedlevel = vars.watchers_h4["levelname"].Current;
					vars.startedgame = 3;
				break;

				case 5:
					vars.startedlevel = vars.watchers_odst["levelname"].Current;
					vars.startedscene = vars.watchers_odst["streets"].Current;
					vars.startedgame = 5;
				break;

				case 6:
					vars.startedlevel = vars.watchers_hr["levelname"].Current;
					vars.startedgame = 6;
				break;
			}
			print ("Manual timer start detected, updating startedlevel");
		}


		if (!vars.multigamepause)
		{
			//IGT function
			if (vars.watchers_mcc["menuindicator"].Current > 0 && (settings["IGTmode"] || !(test == 0 || (test == 1 && (!settings["ILmode"] || vars.watchers_h2["levelname"].Current == "01a")) || (vars.h3resetflag && !settings["ILmode"]))))
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
						IGT = vars.watchers_h1["IGT"].Current;
						IGTold = vars.watchers_h1["IGT"].Old;
						tickrate = 30;
						level = vars.watchers_h1["levelname"].Current;
					break;

					case 1:
						IGT = vars.watchers_h2["IGT"].Current;
						IGTold = vars.watchers_h2["IGT"].Old;
						tickrate = 60;
						level = vars.watchers_h2["levelname"].Current;
					break;

					case 2:
						if (settings["ILmode"])
						{
							IGT = (uint)Math.Round(vars.watchers_igt["IGT_float"].Current * 60);
							IGTold = (uint)Math.Round(vars.watchers_igt["IGT_float"].Old * 60);
							tickrate = 60;
							level = vars.watchers_h3["levelname"].Current;
						}
						else
						{
							IGT = vars.watchers_h3fg["theatertime"].Current;
							IGTold = vars.watchers_h3fg["theatertime"].Old;
							tickrate = 60;
							level = vars.watchers_h3["levelname"].Current;
						}
					break;

					case 3:
						IGT = (uint)Math.Round(vars.watchers_igt["IGT_float"].Current * 60);
						IGTold = (uint)Math.Round(vars.watchers_igt["IGT_float"].Old * 60);
						tickrate = 60;
						level = vars.watchers_h4["levelname"].Current;
						break;

					case 5:
						IGT = (uint)Math.Round(vars.watchers_igt["IGT_float"].Current * 60);
						IGTold = (uint)Math.Round(vars.watchers_igt["IGT_float"].Old * 60); 
						tickrate = 60;
						level = vars.watchers_odst["levelname"].Current; //Streets might cause problems in loopmode if someone does something weird
					break;

					case 6:
						IGT = (uint)Math.Round(vars.watchers_igt["IGT_float"].Current * 60);
						IGTold = (uint)Math.Round(vars.watchers_igt["IGT_float"].Old * 60);
						tickrate = 60;
						level = vars.watchers_hr["levelname"].Current;
					break;

				}

				//Squiggily mess is squiggily. Don't touch this unless really need to.
				if (settings["ILmode"]) //ILs
				{
					if (settings["Loopmode"])
					{
						if (vars.leveltime == 0)
						{
							if (vars.watchers_mcc["stateindicator"].Current != 44 && !(vars.pgcrexists) && vars.startedlevel == level)
							{
								vars.leveltime = IGT;
							}
						}
						else if ((IGT - IGTold) > 0 && (IGT - IGTold) < 300 && vars.startedlevel == level)
						{
							vars.leveltime = vars.leveltime + (IGT - IGTold);
						}
						
						if (vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57 && vars.watchers_mcc["stateindicator"].Old != 190) //add times
						{
							vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
							vars.leveltime = 0;
							vars.pgcrexists = true;
							vars.forcesplit = true;
						}
						else if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44)
						{
							if (!(vars.pgcrexists))
							{
								vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
								vars.leveltime = 0;
								vars.forcesplit = true;
							}
							vars.pgcrexists = false;
						}
						else if (IGT < IGTold && IGT < 10 && vars.watchers_mcc["stateindicator"].Current != 44)
						{
							if (!settings["IGTadd"])
							{
								if ((vars.leveltime % tickrate) > (0.5 * tickrate))
								{
									vars.ingametime = vars.ingametime + (vars.leveltime + (tickrate - (vars.leveltime % tickrate)));
								}
								else
								{
									vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
								}
							}
							else
							{
								vars.ingametime = vars.ingametime + vars.leveltime;
							}
							vars.leveltime = 0;
						}
						
						if (level != vars.startedlevel || vars.watchers_mcc["stateindicator"].Current == 44)
						{
							vars.gametime = TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime));
						}
						else
						{
							vars.gametime = TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime + vars.leveltime));
						}		
					}
					else
					{
						if (vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57 && vars.watchers_mcc["stateindicator"].Old != 190) //add times
						{
							vars.pgcrexists = true;
							vars.forcesplit = true;
						}
						else if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44)
						{
							if (!(vars.pgcrexists))
							{
								vars.forcesplit = true;
							}
							vars.pgcrexists = false;
						}
						vars.gametime = TimeSpan.FromMilliseconds((1000.0 / tickrate) * (IGT));
					}
				}
				else //Fullgame or anylevel
				{
					if (vars.leveltime == 0)
					{
						if (vars.watchers_mcc["stateindicator"].Current != 44 && !(vars.pgcrexists))
						{
							vars.leveltime = IGT;
						}
					}
					else if ((IGT - IGTold) > 0 && (IGT - IGTold) < 300)
					{
						vars.leveltime = vars.leveltime + (IGT - IGTold);
					}

					if (test == 2) //Want to do the math on the loading screen for theatre timing
					{
						if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44)
						{
							vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
							vars.leveltime = 0;
						}
					}
					else
					{
						if (vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57 && vars.watchers_mcc["stateindicator"].Old != 190) //add times
						{
							vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
							vars.leveltime = 0;
							vars.pgcrexists = true;
							vars.forcesplit = true;
						}
						else if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44)
						{
							if (!(vars.pgcrexists))
							{
								vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
								vars.leveltime = 0;
								vars.forcesplit = true;
							}
							vars.pgcrexists = false;
						}
						else if (IGT < IGTold && IGT < 10 && vars.watchers_mcc["stateindicator"].Current != 44)
						{
							if (!settings["IGTadd"])
							{
								if ((vars.leveltime % tickrate) > (0.5 * tickrate))
								{
									vars.ingametime = vars.ingametime + (vars.leveltime + (tickrate - (vars.leveltime % tickrate)));
								}
								else
								{
									vars.ingametime = vars.ingametime + ((vars.leveltime) - ((vars.leveltime) % tickrate));
								}
							}
							else
							{
								vars.ingametime = vars.ingametime + vars.leveltime;
							}
							vars.leveltime = 0;
						}
					}

					if (vars.watchers_mcc["stateindicator"].Current == 44)
					{
						vars.gametime = (TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime)) + vars.multigametime);
					}
					else
					{
						vars.gametime = (TimeSpan.FromMilliseconds((1000.0 / tickrate) * (vars.ingametime + vars.leveltime)) + vars.multigametime);
					}
				}
			}

			//RTA load removal stuff. Moved here to prevent conflict with multigamepause and other types of timer pause logic
			//Halo 1
			else if (vars.watchers_game["gameindicator"].Current == 0 && !((settings["IGTmode"]) || settings["ILmode"]))
			{
				if (!vars.loading) //if not currently loading, determine whether we need to be.
				{
					if (vars.watchers_mcc["menuindicator"].Current > 0) //between level loads.
					{
						if (vars.watchers_h1load["gamewon"].Current && !vars.watchers_h1load["gamewon"].Old)
						{
							vars.loading = true;
						}
					}
					else if (vars.watchers_comptimer["comptimerstate"].Current == 0 && vars.watchers_comptimer["comptimerstate"].Old != 0) 	//main menu to level loads
					{
						vars.loading = true;
					}
				}
				else //if currently loading, determine whether we need to not be.
				{
					if (vars.watchers_h1["tickcounter"].Current == (vars.watchers_h1["tickcounter"].Old + 1)) //determine whether to unpause the timer, ie tick counter starts incrementing again
					{
						vars.loading = false;
					}
				}
			}

			///Halo 2
			else if (vars.watchers_game["gameindicator"].Current == 1 && !(settings["ILmode"] || settings["IGTmode"]))
			{
				if (!vars.loading) //if not currently loading, determine whether we need to be
				{
					if (vars.watchers_mcc["menuindicator"].Current > 0) //between level loads.
					{
						string H2_checklevel = vars.watchers_h2["levelname"].Current;
						switch (H2_checklevel)
						{
							case "01a": //Armory
								if (vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["stateindicator"].Current == 57)
								{
									vars.loading = true;
								}
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
								if ((vars.watchers_h2fg["tickcounter"].Current > 60 && vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_h2fg["letterbox"].Current > 0.96 && vars.watchers_h2fg["letterbox"].Old <= 0.96 && vars.watchers_h2fg["letterbox"].Old != 0) || vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["stateindicator"].Current == 57)
								{
									vars.loading = true;
								}
							break;

							case "04b": //Oracle
							case "05b": //Regret
								if (!vars.lastinternal && (vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2fg["letterbox"].Current > 0.96 && vars.watchers_h2fg["letterbox"].Old <= 0.96 && vars.watchers_h2fg["letterbox"].Old != 0))
								{
									if (vars.watchers_h2["levelname"].Current == "04b" && vars.watchers_h2bsp["bspstate"].Current == 5)
									{
										vars.lastinternal = true;
									}
									else if (vars.watchers_h2["levelname"].Current == "05b" && vars.watchers_h2bsp["bspstate"].Current == 2)
									{
										vars.lastinternal = true;
									}
								}
								else if ((vars.watchers_h2fg["tickcounter"].Current > 60 && vars.lastinternal && vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_h2fg["letterbox"].Current > 0.96 && vars.watchers_h2fg["letterbox"].Old <= 0.96 && vars.watchers_h2fg["letterbox"].Old != 0) || vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["stateindicator"].Current == 57)
								{
									vars.loading = true;	
									vars.lastinternal = false;
								}
							break;

							case "06b":	//Quarantine Zone
								if ((vars.watchers_h2fg["tickcounter"].Current > 60 && vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_h2fg["letterbox"].Current > 0.96 && vars.watchers_h2fg["letterbox"].Old <= 0.96 && vars.watchers_h2fg["letterbox"].Old != 0) || vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["stateindicator"].Current == 57)
								{
									if (vars.watchers_h2bsp["bspstate"].Current == 4  || vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["stateindicator"].Current == 57)
									{
										vars.loading = true;
									}
								}
							break;
						}
					}
					else if (vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["stateindicator"].Current == 57)	//main menu to level loads.
					{
						vars.loading = true;
					}
				}
				else	//if currently loading, determine whether we need not be
				{
					if (vars.watchers_mcc["menuindicator"].Current > 0 && vars.watchers_mcc["stateindicator"].Current != 44 && vars.H2_levellist.ContainsKey(vars.watchers_h2["levelname"].Current)) //between level loads.
					{
						if (vars.watchers_h2["levelname"].Current == "03a")
						{
							if (vars.watchers_mcc["stateindicator"].Current != 44)
							{
								if (vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2bsp["bspstate"].Current == 0 && vars.watchers_h2fg["tickcounter"].Current > 10 && vars.watchers_h2fg["tickcounter"].Current < 100)
								{
									if (vars.watchers_h2fade["fadelength"].Current > 15 && vars.watchers_h2fg["tickcounter"].Current >= (vars.watchers_h2fade["fadetick"].Current + (uint)Math.Round(vars.watchers_h2fade["fadelength"].Current * vars.fadescale)))
									{
										vars.loading = false;
									}
								}
								else if (vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["tickcounter"].Current > vars.watchers_h2fg["tickcounter"].Old && vars.watchers_h2fg["tickcounter"].Current > 10)
								{
									vars.loading = false;
								}
							}
						}
						else if (vars.watchers_h2["levelname"].Current == "01a")
						{
							if (vars.watchers_h2fg["tickcounter"].Current >= 26 &&  vars.watchers_h2fg["tickcounter"].Current < 30)
							{
								vars.loading = false;
							}
							else if (vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["tickcounter"].Current > vars.watchers_h2fg["tickcounter"].Old && vars.watchers_h2fg["tickcounter"].Current > 10)
							{
								vars.loading = false;
							}
						}
						else
						{
							if (vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_mcc["stateindicator"].Current != 129 && vars.watchers_h2bsp["bspstate"].Current != 255)
							{
								vars.loading = false;
								vars.lastinternal = false;
							}
							else if (vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["tickcounter"].Current > vars.watchers_h2fg["tickcounter"].Old && vars.watchers_h2fg["tickcounter"].Current > 10 && vars.watchers_h2bsp["bspstate"].Current != 255)
							{
								vars.loading = false;
							}
						}
					}
				}
				//TGJ cutscene rubbish
				if (vars.watchers_h2["levelname"].Current == "08b" && !vars.H2_tgjreadyflag) 
				{
					if (vars.watchers_h2bsp["bspstate"].Current == 3)
					{
						vars.H2_tgjreadyflag = true;
						vars.H2_tgjreadytime = vars.watchers_h2fg["tickcounter"].Current;
						print ("H2 tgj ready flag set");
					} 
				}
			}
			else if (vars.watchers_game["gameindicator"].Current == 2 && !(settings["ILmode"] || settings["IGTmode"]) && vars.h3resetflag)
			{
				if ((vars.watchers_mcc["stateindicator"].Current == 57 && vars.watchers_mcc["stateindicator"].Old != 57) || (vars.watchers_mcc["stateindicator"].Current == 255 && vars.watchers_comptimer["comptimerstate"].Current == 0 && vars.watchers_comptimer["comptimerstate"].Old > 0))
				{
					vars.loading = true;
				}

				if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44)	//Convert RTA to ticks and truncate
				{
					TimeSpan tempspan = TimeSpan.Zero;
					uint tickcount = 0;

					if (timer.CurrentTime.GameTime.HasValue)  //Get current gametime
					{
						tempspan = (TimeSpan)timer.CurrentTime.GameTime;
					}
					vars.ingametime = (uint)(60 * ((tempspan.Days * 60 * 60 * 24) + (tempspan.Hours * 60 * 60) + (tempspan.Minutes * 60) + (tempspan.Seconds))); //get in-game time in ticks, truncating the ms component
					
					vars.gametime = TimeSpan.FromMilliseconds((1000.0 / 60) * (vars.ingametime));
					vars.h3resetflag = false;
					vars.leveltime = 0;	//This shouldn't be necessary but funny things have been happening
					vars.loading = false;
				}
			}

			if (!settings["ILmode"])
			{
				//Save and quit splitting level tracking. Should probably get it working in other games, but eh
				if (settings["sqsplit"] && vars.watchers_game["gameindicator"].Current == 0)
				{
					if (vars.levelloaded == "000")
					{
						vars.levelloaded = vars.startedlevel;
					}
					else if (vars.forcesplit2 == false && vars.watchers_h1["levelname"].Current != "" && vars.watchers_h1["levelname"].Old == "" && vars.H1_levellist.ContainsKey(vars.watchers_h1["levelname"].Current)) //determine if there is a level swap thus a split required
					{
						if (vars.watchers_h1["levelname"].Current != vars.startedlevel) //dont split if loading the starting level, probably a reset/loopmode. Otherwise split.
						{
							vars.levelloaded = vars.watchers_h1["levelname"].Current;
							vars.forcesplit2 = true;
						}
					}
				}

				//Moved multigamepuse logic here as was pausing 1 cycle late in RTA games previously.
				foreach (var entry in vars.multigamepauseBools)
				{
					if (entry.Key == vars.watchers_game["gameindicator"].Current)
					{
						if (entry.Value())
						{
							if (entry.Key == 0 || entry.Key == 2)
							{
								if (!settings["anylevel"])
								{
									vars.multigamepause = true;
								}
								vars.forcesplit = true;
							}
							if (entry.Key == 1)
							{
								if (settings["anylevel"])
								{
									vars.loading = true;
								}
								else
								{
									vars.multigamepause = true;
								}
								vars.H2_tgjreadyflag = false;
								vars.forcesplit = true;
							}
							else
							{
								vars.multigamepause = true;
							}
							print ("multigamepause is true");
						}
					}
				}
			}
		}
		else //mutligame resume check
		{
			foreach (var entry in vars.multigameresume)
			{
				if (entry.Key == vars.watchers_game["gameindicator"].Current)
				{
					if (entry.Value())
					{
						vars.multigamepause = false;
						print ("multigamepause is false");
					}
				}
			}
		}

		if (vars.isvalid == false && test == 0 && vars.loopcount == 0)
		{
			if (vars.watchers_mcc["menuindicator"].Current > 0 && vars.watchers_mcc["stateindicator"].Current != 44 && vars.H1_levellist.ContainsKey(vars.watchers_h1["levelname"].Current))
			{
				vars.watchers_h1other.UpdateAll(game);
				if (vars.watchers_h1["tickcounter"].Current < 500 && vars.h1_checklist.Count > 0 && vars.h1_checklist[vars.watchers_h1["levelname"].Current] != vars.watchers_h1other["checksum"].Current && vars.watchers_h1other["h1aflags"].Current == 0)
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

	if (vars.watchers_mcc["menuindicator"].Current > 0 && !vars.varsreset) 
	{
		byte test = vars.watchers_game["gameindicator"].Current;
		vars.startedgame = test; //Why did 343 reuse reach level names in H4 smh my head!

		switch (test)
		{
			//Halo 1
			case 0:
				if (vars.watchers_h1["levelname"].Current != "")
				{
					if (vars.H1_ILstart.ContainsKey(vars.watchers_h1["levelname"].Current))
					{
						foreach (var entry in vars.H1_ILstart)
						{
							if (entry.Key == vars.watchers_h1["levelname"].Current && (entry.Key == "a10" || (settings["ILmode"] || settings["anylevel"])))
							{
								if (entry.Value())
								{
									vars.startedlevel = entry.Key;
									return true;
								}
							}
						}
					}
					else if (settings["anystart"])
					{
						if ((!vars.watchers_h1cs["cutsceneskip"].Current && vars.watchers_h1cs["cutsceneskip"].Old) || (vars.watchers_h1["tickcounter"].Current > 30 && !vars.watchers_h1cs["cinematic"].Current && vars.watchers_h1cs["cinematic"].Old))
						{
							vars.startedlevel = vars.watchers_h1["levelname"].Current;
							return true;
						}
					}
				}
			break;


			//Halo 2
			case 1:
				if (settings["ILmode"] && vars.watchers_h2["levelname"].Current != "01a") //If IL mode and not on armory
				{
					if (vars.watchers_h2["IGT"].Current > 10 && vars.watchers_h2["IGT"].Current < 30)
					{
						vars.startedlevel = vars.watchers_h2["levelname"].Current;
						return true;
					}
				}
				else
				{
					if (vars.watchers_h2["levelname"].Current == "01a" && vars.watchers_h2fg["tickcounter"].Current >= 26 &&  vars.watchers_h2fg["tickcounter"].Current < 30) //start on armory
					{
						vars.startedlevel = "01a";
						return true;
					}
					else if (vars.watchers_h2["levelname"].Current == "01b" && vars.watchers_mcc["stateindicator"].Current != 44 && vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_h2fg["tickcounter"].Current < 30) //start on cairo
					{
						vars.startedlevel = "01b";
						return true;
					}
					else if ((settings["anylevel"] || settings["ILmode"]) && vars.watchers_mcc["stateindicator"].Current != 44) //start on any other level
					{	
						if (vars.watchers_h2["levelname"].Current == "03a") //outskirts
						{
							if (vars.watchers_h2fg["fadebyte"].Current == 1 && vars.watchers_h2bsp["bspstate"].Current == 0 && vars.watchers_h2fg["tickcounter"].Current > 10 && vars.watchers_h2fg["tickcounter"].Current < 100)
							{
								if (vars.watchers_h2fade["fadelength"].Current > 15 && vars.watchers_h2fg["tickcounter"].Current >= (vars.watchers_h2fade["fadetick"].Current + (uint)Math.Round(vars.watchers_h2fade["fadelength"].Current * vars.fadescale)))
								{
									vars.startedlevel = "03a";
									return true;
								}
							}
						}
						else if (vars.watchers_h2fg["fadebyte"].Current == 0 && vars.watchers_h2fg["fadebyte"].Old == 1 && vars.watchers_h2fg["tickcounter"].Current < 120) //everything else
						{
							vars.startedlevel = vars.watchers_h2["levelname"].Current;
							return true;
						}
					} 
				}
			break;


			//Halo 3
			case 2:
				if (settings["ILmode"])
				{
					if (vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5)
					{
						vars.startedlevel = vars.watchers_h3["levelname"].Current;
						return true;
					}
				}
				else if (settings["anylevel"] || vars.watchers_h3["levelname"].Current == "010")
				{
					
					if (vars.watchers_mcc["stateindicator"].Current != 44 && vars.watchers_h3fg["theatertime"].Current > 15 && vars.watchers_h3fg["theatertime"].Current < 30)
					{
						vars.startedlevel = vars.watchers_h3["levelname"].Current;
						return true;
					}
					else if (vars.h3resetflag && vars.watchers_h3["levelname"].Current == "010" && vars.watchers_h3fg["tickcounter"].Current > 0 && vars.watchers_h3fg["tickcounter"].Current < 15 && vars.watchers_h3fg["tickcounter"].Current > vars.watchers_h3fg["tickcounter"].Old)
					{
						vars.startedlevel = vars.watchers_h3["levelname"].Current;
						return true;
					}
				}
			break;


			//Halo 4
			case 3:
				if ((settings["ILmode"] || settings["anylevel"] || vars.watchers_h4["levelname"].Current == "m10") && vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5)
				{
					vars.startedlevel = vars.watchers_h4["levelname"].Current;
					return true;
				}
			break;


			//ODST
			case 5:
				if ((settings["ILmode"] || settings["anylevel"] || (vars.watchers_odst["levelname"].Current == "h100" && vars.watchers_odst["streets"].Current == 0)) && vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5)
				{
					vars.startedlevel = vars.watchers_odst["levelname"].Current;
					vars.startedscene = vars.watchers_odst["streets"].Current;
					return true;
				}
			break;


			//Reach
			case 6:
				if ((settings["ILmode"] || settings["anylevel"] || vars.watchers_hr["levelname"].Current == "m10") && vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5)
				{
					vars.startedlevel = vars.watchers_hr["levelname"].Current;
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
		vars.ClearDirtyBsps();
		return true;
	}

	if (vars.watchers_mcc["menuindicator"].Current > 0)
	{
		if (vars.forcesplit) //for IGT game splits and RTA end game splits
		{
			vars.forcesplit = false;
			vars.ClearDirtyBsps();
			if (settings["Loopmode"])
			{
				vars.loopsplit = false;
			}
			return true;
		}

		if (!vars.multigamepause)
		{
			byte test = vars.watchers_game["gameindicator"].Current;
			string checklevel;

			switch (test)
			{
				//Halo 1
				case 0:

					//Death counter check
					if (settings["deathcounter"])
					{
						if (vars.watchers_h1death["deathflag"].Current && !vars.watchers_h1death["deathflag"].Old)
						{
							print ("adding death");
							vars.DeathCounter += 1;
							vars.UpdateDeathCounter();
						}
					}

					checklevel = vars.watchers_h1["levelname"].Current;

					//Loop mode unpause timer at IL start
					if (settings["Loopmode"] && vars.watchers_h1["levelname"].Current == vars.startedlevel && vars.loading && vars.watchers_h1["IGT"].Current < 100)
					{
						foreach (var entry in vars.H1_ILstart)
						{
							if (entry.Key == vars.watchers_h1["levelname"].Current)
							{
								if (entry.Value())
								{
									vars.ClearDirtyBsps();
									vars.loading = false;
								}
							}
						}
					}

					if (settings["bspmode"])
					{
						
						if (settings["bsp_cache"])
						{
							if (checklevel == "b40")
							{
								if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && vars.watchers_h1["tickcounter"].Current > 30)
								{
									if (vars.watchers_h1["bspstate"].Current == 0)
									{
										if (vars.watchers_h1xy["ypos"].Current > (-19.344 - 0.2) && vars.watchers_h1xy["ypos"].Current < (-19.344 + 0.2))
										{
											return true;
										}
										else
										{
											return false;
										}
									} 
									else
									{
										return true;
									}
								}
							}
							else if (checklevel == "c40")
							{
								if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && vars.watchers_h1["tickcounter"].Current > 30)
								{
									if (vars.watchers_h1["bspstate"].Current == 0)
									{
										//update xy, check for match
										if (vars.watchers_h1xy["xpos"].Current > 171.87326 && vars.watchers_h1xy["xpos"].Current < 185.818526 && vars.watchers_h1xy["ypos"].Current > -295.3629 && vars.watchers_h1xy["ypos"].Current < -284.356986)
										{
											return true;
										}
										else
										{
											return false;
										}
									} 
									else
									{
										return true;
									}
								}
							}
							else
							{
								return (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current));
							}
						}
						
						if (checklevel == "b40")
						{
							if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h1["bspstate"].Current)))
							{
								if (vars.watchers_h1["bspstate"].Current == 0)
								{
									if (vars.watchers_h1xy["ypos"].Current > (-19.344 - 0.2) && vars.watchers_h1xy["ypos"].Current < (-19.344 + 0.2))
									{
										vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
										return true;
									}
									else
									{
										return false;
									}
								} 
								else
								{
									vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
									return true;
								}
							}
						}
						else if (checklevel == "c40")
						{
							if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h1["bspstate"].Current)) && vars.watchers_h1["tickcounter"].Current > 30)
							{
								if (vars.watchers_h1["bspstate"].Current == 0)
								{
									//update xy, check for match
									if (vars.watchers_h1xy["xpos"].Current > 171.87326 && vars.watchers_h1xy["xpos"].Current < 185.818526 && vars.watchers_h1xy["ypos"].Current > -295.3629 && vars.watchers_h1xy["ypos"].Current < -284.356986)
									{
										vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
										return true;
									}
									else
									{
										return false;
									}
								} 
								else
								{
									vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
									return true;
								}
							}
						}
						else
						{
							if (vars.watchers_h1["bspstate"].Current != vars.watchers_h1["bspstate"].Old && Array.Exists((byte[]) vars.H1_levellist[checklevel], x => x == vars.watchers_h1["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h1["bspstate"].Current)))
							{
								vars.dirtybsps_byte.Add(vars.watchers_h1["bspstate"].Current);
								return true;
							}
						}
					}
					
					if (!settings["IGTmode"]) //Just leaving this here for debugging igt code. It's mostly all copypasta anyway
					{
						if (settings["ILmode"]) //IL End level splits
						{
							foreach (var entry in vars.H1_ILendsplits)
							{
								if (entry.Key == vars.watchers_h1["levelname"].Current)
								{
									if (entry.Value())
									{
										vars.ClearDirtyBsps();
										if (settings["Loopmode"]) 
										{
											vars.loading = true;
										}
										return true;
									}
								}
							}
 						}
						else	//fullgame or anylevel
						{
							if (vars.watchers_h1load["gamewon"].Current && !vars.watchers_h1load["gamewon"].Old) //split on game_won call
							{
								vars.ClearDirtyBsps();
								return true;
							}
						}
					}
				break;


				//Halo 2
				case 1:

					if (settings["deathcounter"])
					{
						if (vars.watchers_h2death["deathflag"].Current && !vars.watchers_h2death["deathflag"].Old)
						{
							print ("adding death");
							vars.DeathCounter += 1;
							vars.UpdateDeathCounter();
						}
					}

					checklevel = vars.watchers_h2["levelname"].Current;
					
					if (settings["Loopmode"] && vars.watchers_h2["levelname"].Current == vars.startedlevel)
					{
						if (vars.watchers_h2["IGT"].Current > 10 && vars.watchers_h2["IGT"].Current < 30 && !vars.loopsplit)
						{
							vars.ClearDirtyBsps();
							vars.loopsplit = true;
						}
					}

					if (settings["bspmode"])
					{
						if (settings["bsp_cache"])
						{
							return (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.watchers_h2bsp["bspstate"].Current));
						}

						switch (checklevel)
						{
							case "01b":
								if (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.watchers_h2bsp["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h2bsp["bspstate"].Current)))
								{
									if (vars.watchers_h2bsp["bspstate"].Current == 0 && !(vars.dirtybsps_byte.Contains(2)))	// hacky workaround for the fact that the level starts on bsp 0 and returns there later
									{
										return false;
									}
									vars.dirtybsps_byte.Add(vars.watchers_h2bsp["bspstate"].Current);
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
								if (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.watchers_h2bsp["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h2bsp["bspstate"].Current)))
								{
									vars.dirtybsps_byte.Add(vars.watchers_h2bsp["bspstate"].Current);
									return true;
								}
							break;
							
							case "04a":
								if (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.watchers_h2bsp["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h2bsp["bspstate"].Current)))
								{
									if (vars.watchers_h2bsp["bspstate"].Current == 0 && !(vars.dirtybsps_byte.Contains(3))) // hacky workaround for the fact that the level starts on bsp 0 and returns there later
									{
										return false;
									}
									vars.dirtybsps_byte.Add(vars.watchers_h2bsp["bspstate"].Current);
									return true;
								}
							break;
							
							case "04b":
								if (vars.watchers_h2bsp["bspstate"].Current == 3 && !(vars.dirtybsps_byte.Contains(3)))
								{
									print ("e");
									vars.dirtybsps_byte.Add(3);	//prevent splitting on starting bsp
								}
								if (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.watchers_h2bsp["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h2bsp["bspstate"].Current)))
								{
									print ("a");
									if (vars.watchers_h2bsp["bspstate"].Current == 0 && (vars.dirtybsps_byte.Contains(3)))
									{
										print ("b");
										return true;
									} // hacky workaround for the fact that the level starts on bsp 0 and returns there later
									
									vars.dirtybsps_byte.Add(vars.watchers_h2bsp["bspstate"].Current);
									return true;
								}
							break;
							
							case "08a":
								if (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old && Array.Exists((byte[]) vars.H2_levellist[checklevel], x => x == vars.watchers_h2bsp["bspstate"].Current) && !(vars.dirtybsps_byte.Contains(vars.watchers_h2bsp["bspstate"].Current)))
								{
									if (vars.watchers_h2bsp["bspstate"].Current == 0 && !(vars.dirtybsps_byte.Contains(1)))	// hacky workaround for the fact that the level starts on bsp 0 and returns there later
									{
										return false;
									}
									vars.dirtybsps_byte.Add(vars.watchers_h2bsp["bspstate"].Current);
									return true;
								}
							break;

							case "08b":
								//TGJ -- starts 0 and in cs, then goes to 1, then 0, then 1, then 0, then 3 (skipping 2 cos it's skippable)
								//so I have jank logic cos it does so much backtracking and backbacktracking
								if (vars.watchers_h2bsp["bspstate"].Current != vars.watchers_h2bsp["bspstate"].Old)
								{
									//print ("x: " + vars.watchers_h2xy["xpos"].Current);
									//print ("y: " + vars.watchers_h2xy["ypos"].Current);
									
									byte checkbspstate = vars.watchers_h2bsp["bspstate"].Current;
									switch (checkbspstate)
									{
										case 1:
										if (!(vars.dirtybsps_byte.Contains(1)) && vars.watchers_h2xy["xpos"].Current > -2 && vars.watchers_h2xy["xpos"].Current < 5 && vars.watchers_h2xy["ypos"].Current > -35 && vars.watchers_h2xy["ypos"].Current < -15)
										{
											vars.dirtybsps_byte.Add(1);
											//print ("first");
											return true;
										}
										else if (!(vars.dirtybsps_byte.Contains(21)) && (vars.dirtybsps_byte.Contains(10))  && vars.watchers_h2xy["xpos"].Current > 15 && vars.watchers_h2xy["xpos"].Current < 25 && vars.watchers_h2xy["ypos"].Current > 15 && vars.watchers_h2xy["ypos"].Current < 30)
										{
											vars.dirtybsps_byte.Add(21);
											//print ("third");
											return true;
										}
										
										break;
										
										case 0:
										if (!(vars.dirtybsps_byte.Contains(10)) && vars.watchers_h2xy["xpos"].Current > -20 && vars.watchers_h2xy["xpos"].Current < -10 && vars.watchers_h2xy["ypos"].Current > 20 && vars.watchers_h2xy["ypos"].Current < 30)
										{
											vars.dirtybsps_byte.Add(10);
											//print ("second");
											return true;
										}
										else if (!(vars.dirtybsps_byte.Contains(20)) && (vars.dirtybsps_byte.Contains(21))  && vars.watchers_h2xy["xpos"].Current > 45 && vars.watchers_h2xy["xpos"].Current < 55 && vars.watchers_h2xy["ypos"].Current > -5 && vars.watchers_h2xy["ypos"].Current < 10)
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
						if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44 && checklevel != "00a") 
						{
							vars.ClearDirtyBsps();
							return true;
						}
					}
				break;


				//Halo 3
				case 2:
					if (settings["deathcounter"])
					{
						if (vars.watchers_h3death["deathflag"].Current && !vars.watchers_h3death["deathflag"].Old)
						{
							print ("adding death");
							vars.DeathCounter += 1;
							vars.UpdateDeathCounter();
						}
					}
					
					checklevel = vars.watchers_h3["levelname"].Current;

					if (settings["Loopmode"] && vars.watchers_h3["levelname"].Current == vars.startedlevel && !vars.loopsplit)
					{
						if (vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5)
						{
							vars.loopsplit = true;
							vars.ClearDirtyBsps();
						}
					}

					if (settings["bspmode"])
					{
						if (settings["bsp_cache"])
						{
							return (vars.watchers_h3bsp["bspstate"].Current != vars.watchers_h3bsp["bspstate"].Old && Array.Exists((ulong[]) vars.H3_levellist[checklevel], x => x == vars.watchers_h3bsp["bspstate"].Current));		
						}
						
						if (vars.watchers_h3bsp["bspstate"].Current != vars.watchers_h3bsp["bspstate"].Old && Array.Exists((ulong[]) vars.H3_levellist[checklevel], x => x == vars.watchers_h3bsp["bspstate"].Current) && !(vars.dirtybsps_long.Contains(vars.watchers_h3bsp["bspstate"].Current)))
						{
							vars.dirtybsps_long.Add(vars.watchers_h3bsp["bspstate"].Current);
							return true;
						}
					} 

					if (!settings["ILmode"])	//Split on loading screen
					{
						if (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_mcc["stateindicator"].Old != 44)
						{
							vars.ClearDirtyBsps();
							return true;
						}
					} 
				break;


				//Halo 4
				case 3:
					//Death counter code goes here if we ever bother to add it

					checklevel = vars.watchers_h4["levelname"].Current;

					if (settings["Loopmode"] && vars.watchers_h4["levelname"].Current == vars.startedlevel)
					{
						if (vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5 && !vars.loopsplit)
						{
							vars.loopsplit = true;
							vars.ClearDirtyBsps();
						}
					}

					if (settings["compsplits"])
					{
						if (vars.watchers_mcc["stateindicator"].Current == 255 && vars.watchers_comptimer["comptimerstate"].Changed && vars.watchers_comptimer["comptimerstate"].Current != 0 && vars.watchers_igt["IGT_float"].Current > 2.0) {return true;}
					}	
					else if (settings["bspmode"])
					{
						if (settings["bsp_cache"])
						{
							return (vars.watchers_h4bsp["bspstate"].Current != vars.watchers_h4bsp["bspstate"].Old && !Array.Exists((ulong[]) vars.H4_levellist[checklevel], x => x == vars.watchers_h4bsp["bspstate"].Current));
						}
						
						if (vars.watchers_h4bsp["bspstate"].Current != vars.watchers_h4bsp["bspstate"].Old && !Array.Exists((ulong[]) vars.H4_levellist[checklevel], x => x == vars.watchers_h4bsp["bspstate"].Current) && !(vars.dirtybsps_long.Contains(vars.watchers_h4bsp["bspstate"].Current)))
						{
							vars.dirtybsps_long.Add(vars.watchers_h4bsp["bspstate"].Current);
							return true;
						}
					} 
				break;


				case 5: //ODST

					//Death Counter
					if (settings["deathcounter"])
					{
						if (vars.watchers_odstdeath["deathflag"].Current && !vars.watchers_odstdeath["deathflag"].Old)
						{
							print ("adding death");
							vars.DeathCounter += 1;
							vars.UpdateDeathCounter();
						}
					}

					checklevel = vars.watchers_odst["levelname"].Current;

					if (settings["Loopmode"] && checklevel == vars.startedlevel && !vars.loopsplit)
					{
						if (vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5)
						{
							vars.loopsplit = true;
							vars.ClearDirtyBsps();
						}
					}

					if (settings["compsplits"])
					{
						if (checklevel == "l300")
						{
							if (vars.watchers_mcc["stateindicator"].Current == 255 && vars.watchers_comptimer["comptimerstate"].Changed && vars.watchers_comptimer["comptimerstate"].Current != 876414390 && vars.watchers_comptimer["comptimerstate"].Current != 0 && vars.watchers_igt["IGT_float"].Current > 2.0) {return true;}
						}
						else
						{
							if (vars.watchers_mcc["stateindicator"].Current == 255 && vars.watchers_comptimer["comptimerstate"].Changed && vars.watchers_comptimer["comptimerstate"].Current != 0 && vars.watchers_igt["IGT_float"].Current > 2.0) {return true;}
						}
					}
					else if (settings["bspmode"])
					{
						if (settings["bsp_cache"])
						{
							return (vars.watchers_igt["IGT_float"].Current > 0.5 && vars.watchers_odstbsp["bspstate"].Current != vars.watchers_odstbsp["bspstate"].Old && Array.Exists((uint[]) vars.ODST_levellist[checklevel], x => x == vars.watchers_odstbsp["bspstate"].Current));	
						}

						if (vars.watchers_igt["IGT_float"].Current > 0.5 && vars.watchers_odstbsp["bspstate"].Current != vars.watchers_odstbsp["bspstate"].Old && Array.Exists((uint[]) vars.ODST_levellist[checklevel], x => x == vars.watchers_odstbsp["bspstate"].Current) && !(vars.dirtybsps_int.Contains(vars.watchers_odstbsp["bspstate"].Current)))
						{
							vars.dirtybsps_int.Add(vars.watchers_odstbsp["bspstate"].Current);
							return true;
						}
					} 
				break;
				
				
				//Reach
				case 6:

					//Death counter check
					if (settings["deathcounter"])
					{
						if (vars.watchers_hrdeath["deathflag"].Current && !vars.watchers_hrdeath["deathflag"].Old)
						{
							print ("adding death");
							vars.DeathCounter += 1;
							vars.UpdateDeathCounter();
						}
					}

					checklevel = vars.watchers_hr["levelname"].Current;

					if (settings["Loopmode"] && vars.watchers_hr["levelname"].Current == vars.startedlevel)
					{
						if (vars.watchers_igt["IGT_float"].Current > 0.167 && vars.watchers_igt["IGT_float"].Current < 0.5 && !vars.loopsplit)
						{
							vars.loopsplit = true;
							vars.ClearDirtyBsps();
						}
					}

					if (settings["bspmode"])
					{
						if (settings["bsp_cache"])
						{
							return (vars.watchers_hrbsp["bspstate"].Current != vars.watchers_hrbsp["bspstate"].Old && Array.Exists((uint[]) vars.HR_levellist[checklevel], x => x == vars.watchers_hrbsp["bspstate"].Current));
						}
						
						if (vars.watchers_hrbsp["bspstate"].Current != vars.watchers_hrbsp["bspstate"].Old && Array.Exists((uint[]) vars.HR_levellist[checklevel], x => x == vars.watchers_hrbsp["bspstate"].Current) && !(vars.dirtybsps_int.Contains(vars.watchers_hrbsp["bspstate"].Current)))
						{
							vars.dirtybsps_int.Add(vars.watchers_hrbsp["bspstate"].Current);
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
	if ((settings["ILmode"])&& (!(settings["Loopmode"])) && vars.watchers_mcc["menuindicator"].Current == 0 && timer.CurrentPhase != TimerPhase.Ended)
	{
		return true;
	}

	if ((!(settings["Loopmode"])) && vars.watchers_mcc["menuindicator"].Current > 0)
	{
		byte test = vars.watchers_game["gameindicator"].Current;
		switch (test)
		{
			//H1
			case 0:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.watchers_h1["levelname"].Current == vars.startedlevel && vars.startedgame == 0 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_h1["IGT"].Current < vars.watchers_h1["IGT"].Old && vars.watchers_h1["IGT"].Current < 10) || (vars.watchers_comptimer["comptimerstate"].Current != 0 && vars.watchers_comptimer["comptimerstate"].Old == 0 && vars.watchers_h1["tickcounter"].Current < 60));
					} 
				}
				else
				{
					if (vars.watchers_h1["levelname"].Current == "a10" && vars.startedgame == 0 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_h1["IGT"].Current < vars.watchers_h1["IGT"].Old && vars.watchers_h1["IGT"].Current < 10) || (vars.watchers_comptimer["comptimerstate"].Current != 0 && vars.watchers_comptimer["comptimerstate"].Old == 0 && vars.watchers_h1["tickcounter"].Current < 60));
					} 
				}
			break;

			//H2
			case 1:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.watchers_h2["levelname"].Current == vars.startedlevel && vars.startedgame == 1 && timer.CurrentPhase != TimerPhase.Ended)
					{				
						return ((vars.watchers_h2["IGT"].Current < vars.watchers_h2["IGT"].Old && vars.watchers_h2["IGT"].Current < 10) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_h2["IGT"].Current == 0)); 
					}
				}
				else
				{
					if ((vars.watchers_h2["levelname"].Current == "01a" || (vars.watchers_h2["levelname"].Current == "01b" && vars.startedlevel != "01a") || vars.watchers_h2["levelname"].Current == "00a") && vars.startedgame == 1 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_h2["IGT"].Current < vars.watchers_h2["IGT"].Old && vars.watchers_h2["IGT"].Current < 10) || (vars.watchers_mcc["stateindicator"].Current != 44 && vars.watchers_mcc["stateindicator"].Old == 44 && vars.watchers_h2fg["tickcounter"].Current < 60));
					}
				}
			break;

			//H3
			case 2:
				if (vars.startedgame == 2 && timer.CurrentPhase != TimerPhase.Ended)
				{
					if (settings["ILmode"])
					{
						return (vars.watchers_h3["levelname"].Current == vars.startedlevel && vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167);
					}
					else
					{
						if (settings["anylevel"]) //reset on all levels
						{
							return (vars.watchers_h3["levelname"].Current == vars.startedlevel && vars.watchers_h3fg["theatertime"].Current > 0 && vars.watchers_h3fg["theatertime"].Current < 15);
						}
						else if (vars.watchers_h3["levelname"].Current == "005")
						{
							return (vars.watchers_mcc["stateindicator"].Current != 44 && vars.watchers_mcc["stateindicator"].Old == 44 && vars.watchers_h3fg["tickcounter"].Current < 60);
						}
						else if (vars.watchers_h3["levelname"].Current == "010") 
						{
							return ((vars.watchers_h3fg["theatertime"].Current > 0 && vars.watchers_h3fg["theatertime"].Current < 15) || (vars.watchers_h3fg["theatertime"].Current >= 15 && vars.watchers_h3fg["tickcounter"].Current < vars.watchers_h3fg["tickcounter"].Old && vars.watchers_h3fg["tickcounter"].Current < 10 && vars.watchers_mcc["stateindicator"].Current != 44));
						}
					}
				}
			break;

			//H4
			case 3:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.watchers_h4["levelname"].Current == vars.startedlevel && vars.startedgame == 3 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_igt["IGT_float"].Current == 0));
					}
				}
				else
				{
					if (vars.watchers_h4["levelname"].Current == "m10" && vars.startedgame == 3 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_igt["IGT_float"].Current == 0));
					}
				}
			break;

			//ODST
			case 5:
				if (settings["anylevel"] || settings["ILmode"])
				{
					if (vars.watchers_odst["levelname"].Current == vars.startedlevel && vars.startedscene == vars.watchers_odst["streets"].Current && vars.startedgame == 5 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_igt["IGT_float"].Current == 0));
					}
				}
				else
				{
					if ((vars.watchers_odst["levelname"].Current == "c100" || (vars.watchers_odst["levelname"].Current == "h100" && vars.watchers_odst["streets"].Current == 0)) && vars.startedgame == 5 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_igt["IGT_float"].Current == 0));
					}
				}
			break;

			//Reach
			case 6:
				if (settings["ILmode"] || settings["anylevel"])
				{
					if (vars.watchers_hr["levelname"].Current == vars.startedlevel && vars.startedgame == 6 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_igt["IGT_float"].Current == 0));
					}
				}
				else
				{
					if (vars.watchers_hr["levelname"].Current == "m10" && vars.startedgame == 6 && timer.CurrentPhase != TimerPhase.Ended)
					{
						return ((vars.watchers_igt["IGT_float"].Current < vars.watchers_igt["IGT_float"].Old && vars.watchers_igt["IGT_float"].Current < 0.167) || (vars.watchers_mcc["stateindicator"].Current == 44 && vars.watchers_igt["IGT_float"].Current == 0));
					}
				}
			break;
		}
	}
}



isLoading
{
	byte test = vars.watchers_game["gameindicator"].Current;

	if (vars.multigamepause)
	{
		return true;
	}

	if (settings["menupause"] && (vars.watchers_mcc["stateindicator"].Current == 44 || vars.watchers_mcc["menuindicator"].Current == 0))
	{
		return true;
	}

	//also should prolly code load removal to work in case of restart/crash
	switch (test)
	{
		case 0: //halo 1
			if (settings["IGTmode"])
			{
				return true;
			}
			else return vars.loading;
		break;

		case 1: //halo 2
			if ((settings["ILmode"] && vars.watchers_h2["levelname"].Current != "01a") || settings["IGTmode"])
			{
				return true;
			}
			else
			{
				//Graphics swap load pausing. Just leaving it here for now unless issues start happening
				if (vars.loading == false && vars.watchers_h2fg["graphics"].Current == 1 && vars.watchers_mcc["stateindicator"].Current == 255)
				{
					if ((vars.watchers_h2fg["tickcounter"].Current == vars.oldtick) || (vars.watchers_h2fg["tickcounter"].Current == vars.oldtick + 1)) {return true;} else {vars.oldtick = -2;}
					if (vars.watchers_h2fg["graphics"].Old == 0) {vars.oldtick = vars.watchers_h2fg["tickcounter"].Current;}
				}
				return vars.loading;
			}
		break;

		case 2:
			if (settings["ILmode"] || !vars.h3resetflag)
			{
				return true;
			}
			else if (vars.h3resetflag)
			{
				if (vars.watchers_mcc["stateindicator"].Current == 129 || vars.loading)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		break;

		case 3:
		case 5:
		case 6:
			return true;
		break;
	}
}



gameTime
{
	if (vars.watchers_game["gameindicator"].Current == 0 && vars.watchers_mcc["menuindicator"].Current > 0)
	{
		if (!vars.multigamepause && vars.isvalid && !vars.loading)
		{
			TimeSpan test = TimeSpan.Zero;
			TimeSpan comp = new TimeSpan(0, 0, 0);
			if (timer.CurrentTime.GameTime.HasValue)
			{
				test = (TimeSpan)timer.CurrentTime.GameTime;
			}
			if (test.Seconds == 13 && test.Milliseconds < 35)
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


	if (vars.multigamepause && !vars.forcesplit)
	{
		if (vars.multigametime != timer.CurrentTime.GameTime)
		{
			vars.ingametime = 0;
			vars.multigametime = timer.CurrentTime.GameTime;
		}
		return;
	}
	else if (vars.watchers_mcc["menuindicator"].Current > 0 && (settings["IGTmode"] || !(vars.watchers_game["gameindicator"].Current == 0 || (vars.watchers_game["gameindicator"].Current == 1 && (!settings["ILmode"] || vars.watchers_h2["levelname"].Current == "01a")) || (vars.h3resetflag && !settings["ILmode"]))))
	{
		return vars.gametime;
	}
}



exit
{
	//timer.IsGameTimePaused = false; //unpause the timer on gamecrash UNLESS it was paused for multi-game-pause option.
}