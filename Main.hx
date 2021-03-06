import haxe.Timer;
import haxe.io.Path;
import mcli.CommandLine;
import mcli.Dispatch;
import sys.FileSystem;
import sys.io.File;

/**
	A small utility for changing the background on Linux, for the Cinnamon desktop
	environment.
**/
class Main extends CommandLine {

	private var switchTimer:haxe.Timer;
	private var currentImg:Int = 0;

	/**
		How much time to wait before each wallpaper change.
		@:alias t
	**/
	public var time:Int = 10 * 60 * 1000; // defualt of 10 minutes

	/**
		What wallpapers to use.
		@:alias i
	**/
	public var images:Array<String> = [];

	/**
		Folder to pull wallpapers from.
		@:alias f
	**/
	 public var folder:String = "";

	public function help() {
		Sys.println(this.showUsage());
		Sys.exit(0);
	}

	public function runDefault() {
		evalFolder();
		if (images.length == 0) help();
		
		switchBackground();
		switchTimer = new haxe.Timer(time);
		switchTimer.run = switchBackground;
	}

	private function switchBackground() {
		evalFolder();
		checkImages();
		
		var img = images[currentImg++];
		Sys.println('Switching to $img');
		
		if (currentImg >= images.length) currentImg = 0;
		
		var args = ['set', 'org.cinnamon.desktop.background', 'picture-uri', 'file://$img'];
		Sys.command('gsettings', args);
	}

	private function evalFolder() {
		if (folder == "") return;
		
		var isFolder = FileSystem.exists(folder);
		isFolder = isFolder && FileSystem.isDirectory(folder);
		if(!isFolder) return;
		
		for (item in FileSystem.readDirectory(folder)) {
			var path = Path.join([folder, item]);
			if (FileSystem.isDirectory(path)) continue;
			if (images.lastIndexOf(path) != -1) continue;
			images.push(path);
		}
	}

	private function checkImages() {
		var imgsCopy = images;
		for (image in imgsCopy) {
			if (!FileSystem.exists(image)) {
				images.remove(image);
			}
		}
	}
	
	public static function main() {
		Dispatch.addDecoder(new ListDecoder());
		new Dispatch(Sys.args()).dispatch(new Main());
	}
}

class ListDecoder {
	public function new() {}
	public function fromString(s:String):Array<String> {
		return s.split(',');
	}
}
