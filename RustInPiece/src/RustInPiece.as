package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import citrus.core.starling.StarlingCitrusEngine;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	
	public class RustInPiece extends StarlingCitrusEngine
	{
		private var loader:Loader
		//constructor function
		public function RustInPiece()
		{
			//Sound set up
			sound.addSound('heroJump', {sound:"../sounds/Sound Effects/hero_jump.mp3"});
			sound.addSound('collectBattery', {sound:"../sounds/Sound Effects/collectBattery.mp3"});
			
			//to play a loop sound
			sound.addSound('backgroundMusic', {sound:"../sounds/Level Music/levelOneMusic.mp3", loops:-1, volume: 0.3});
			
			//Start Starling world
			setUpStarling(true);
			//state = new StarLevel();
			//importing the external swf flie
			loader = new Loader();
			loader.load(new URLRequest("../fla/levelOne.swf"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			//state = new GameState();
		}
		
		protected function onComplete(event:Event):void
		{
			state = new FlashLevel(event.target.content as MovieClip);
		}
	}
}