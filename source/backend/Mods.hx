package backend;

import haxe.Json;

import sys.FileSystem;

typedef ModsList = {
	enabled:Array<String>,
	disabled:Array<String>,
	all:Array<String>
};

class Mods
{
	static public var currentModDirectory:String = '';

	public static final ignoreModFolders:Array<String> = [
		'characters',
		'custom_events',
		'custom_notetypes',
		'data',
		'songs',
		'music',
		'sounds',
		'shaders',
		'videos',
		'images',
		'stages',
		'weeks',
		'fonts',
		'scripts',
		'achievements'
	];

	private static var globalMods:Array<String> = [];

	inline public static function getGlobalMods()
		return globalMods;

	inline public static function pushGlobalMods()
	{
		globalMods = [];
		
        if (FileSystem.exists(Paths.mods(''))) 
		{
            var items = FileSystem.readDirectory(Paths.mods(''));

            var folders = items.filter(item -> FileSystem.isDirectory(Paths.mods(item)));

            for (folder in folders) {
                globalMods.push(folder);
            }
        }
	}
	
	inline public static function mergeAllTextsNamed(path:String, ?defaultDirectory:String = null, allowDuplicates:Bool = false)
	{
		if(defaultDirectory == null) defaultDirectory = Paths.getSharedPath();
		defaultDirectory = defaultDirectory.trim();
		if(!defaultDirectory.endsWith('/')) defaultDirectory += '/';
		if(!defaultDirectory.startsWith('assets/')) defaultDirectory = 'assets/$defaultDirectory';

		var mergedList:Array<String> = [];
		var paths:Array<String> = directoriesWithFile(defaultDirectory, path);

		var defaultPath:String = defaultDirectory + path;
		if(paths.contains(defaultPath))
		{
			paths.remove(defaultPath);
			paths.insert(0, defaultPath);
		}

		for (file in paths)
		{
			var list:Array<String> = CoolUtil.coolTextFile(file);
			for (value in list)
				if((allowDuplicates || !mergedList.contains(value)) && value.length > 0)
					mergedList.push(value);
		}
		return mergedList;
	}

	inline public static function directoriesWithFile(path:String, fileToFind:String, mods:Bool = true)
	{
		var foldersToCheck:Array<String> = [];
		if(FileSystem.exists(path + fileToFind))
			foldersToCheck.push(path + fileToFind);

		if(Paths.currentLevel != null && Paths.currentLevel != path)
		{
			var pth:String = Paths.getFolderPath(fileToFind, Paths.currentLevel);
			if(FileSystem.exists(pth))
				foldersToCheck.push(pth);
		}

		#if MODS_ALLOWED
		if(mods)
		{
			// Global mods first
			for(mod in Mods.getGlobalMods())
			{
				var folder:String = Paths.mods(mod + '/' + fileToFind);
				if(FileSystem.exists(folder) && !foldersToCheck.contains(folder)) foldersToCheck.push(folder);
			}

			// Then "PsychEngine/mods/" main folder
			var folder:String = Paths.mods(fileToFind);
			if(FileSystem.exists(folder) && !foldersToCheck.contains(folder)) foldersToCheck.push(Paths.mods(fileToFind));

			// And lastly, the loaded mod's folder
			if(Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
			{
				var folder:String = Paths.mods(Mods.currentModDirectory + '/' + fileToFind);
				if(FileSystem.exists(folder) && !foldersToCheck.contains(folder)) foldersToCheck.push(folder);
			}
		}
		#end
		return foldersToCheck;
	}
}