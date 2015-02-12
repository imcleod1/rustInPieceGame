package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	import Box2D.Dynamics.Contacts.b2PolyAndCircleContact;
	
	import citrus.core.CitrusObject;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.starlingview.AnimationSequence;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class FlashLevel extends StarlingState
	{
		//importing and embedding dragonbones animation file
		[Embed(source="../dragon bones/rusty.png", mimeType="application/octet-stream")]
		private var heroAnimBitmapAndXML:Class;
		
		
		
		[Embed(source  ="../images/spinningRedBattery.png")]//For battery animation
		private var spinningRedBatterySpriteSheet:Class;
		[Embed(source  ="../images/spinningRedBattery.xml", mimeType="application/octet-stream")]
		private var spinningRedBatteryXml:Class;
		
		
		private var factory:StarlingFactory;
		private var armature:Armature;
		
		private var coinCollection:Vector.<CitrusObject>
		private var coin:Coin;
		
		
		private var flashMovieClip:MovieClip
		
		//constructor code
		
		public function FlashLevel(movieClip:MovieClip)
		{
			super();
			flashMovieClip = movieClip;
			var objects:Array = [CitrusSprite,Enemy,Coin,Hero,Platform];
				
		}
		override public function initialize():void{
			super.initialize();
			
			var physics:Box2D = new Box2D('physics');
			add(physics);
			physics.visible = true;
			
		
			
			//adding character
			ObjectMaker2D.FromMovieClip(flashMovieClip);
			var hero:Hero = Hero(getObjectByName('rustyHero'));
			
			//Adding DragonBone animation -note: we are using inline function here
			var armature:Armature; // the dragonbone armature
			var factory:StarlingFactory = new StarlingFactory();
			factory.addEventListener(Event.COMPLETE, function(event:Event):void{
				armature = factory.buildArmature("hero"); // passing the name of our animation file in parameter
				
				hero.view = armature;
			});
			
			factory.parseData(new heroAnimBitmapAndXML());
			
			//adding camera
			view.camera.setUp(hero,new Rectangle(0,0,4000,915),null,new Point(.5,.25));

			//adding background music
			_ce.sound.playSound('backgroundMusic');
			
			//adding sound effects
			//add hero action first; to create a function
			hero.onJump.add(heroJump)
			
				//coin thing
			//setting up the coin texture and animation sequence
			var tcoin:Texture = Texture.fromBitmap(new spinningRedBatterySpriteSheet());
			var xmLcoin:XML = XML(new spinningRedBatteryXml());
			var lTextureAtlas:TextureAtlas = new TextureAtlas(tcoin, xmLcoin);
			
			//getting all the coins  from the swf file- It returns a Vector of CitrusObjects
				
				
		coinCollection = getObjectsByType(Coin);
				
		for (var i:int=0; i< coinCollection.length; i++){
			coin = coinCollection[i];
			coin.view = new AnimationSequence(lTextureAtlas, ["redBattery"], "redBattery", 24, true);
			coin.onBeginContact.add(collectBattery);
			
		}
				
			
				
		}
		
		
		//jump sound function
		private function heroJump():void
		{
			_ce.sound.playSound('heroJump');
		}
		
		//collect battery sound effect
		private function collectBattery(cb:b2PolyAndCircleContact):void
		{
			_ce.sound.playSound('collectBattery');
			
		}
		
	}
}