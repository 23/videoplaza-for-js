package  {
  import com.videoplaza.bridge.core.VideoplazaLoader;
  import com.videoplaza.bridge.core.VpAdPlayer;
  import com.videoplaza.bridge.events.PlayerState;
  import com.videoplaza.bridge.utils.IVideoplazaPlugin;
  
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.display.StageDisplayState;
  import flash.events.Event;
  import flash.external.ExternalInterface;
  import flash.system.Security;
  
  import se.videoplaza.kit.api.utils.ItemInfo;
  
  public class VideoplazaJS extends Sprite implements IVideoplazaPlugin {
    private var _vpAdPlayer:VpAdPlayer;
    private var _startNewAdSection:Boolean = true;
    private var videoPlayerInfo:Object = {
      videoPlayerInfo:false,
      volume:0,
      position:0,
      duration:NaN,

      vphost:'',
      vpcategory: '',
      vptags: '',
      vpflags: '',
      contentForm: '',
      contentId: '',
      contentPartner: '',			
      cuePoints:''
    }
    
    private function log(s:String):void {
      trace(s);
      try {
	ExternalInterface.call("console.log", "VideoplazaJS", s);
      }catch(e:Error){}
    }

    public function VideoplazaJS():void {
      Security.allowDomain('*');
      if (ExternalInterface.available) {
	ExternalInterface.addCallback("receiveEvent", receiveEvent);
	ExternalInterface.addCallback("init", init);
	log('Loaded ExternalInterface');
	sendEvent('flashloaded');
      }
    }
    
    public function init(info:Object):void {
      videoPlayerInfo = info;
      var vpLoader:VideoplazaLoader = new VideoplazaLoader();
      vpLoader.init(this);
    }
    
    private function callMethod(method:String, value:Object):void {
      ExternalInterface.call("VideoplazaJSCallback", method, value);
    }
    private function sendEvent(event:String, context:String=""):void {
      ExternalInterface.call("VideoplazaJSEvent", event, context);
    }
    private function receiveEvent(event:String, info:Object):void {
      videoPlayerInfo = info; 
      switch(event) {
      case 'new':
        _startNewAdSection = true;
        break;
      case 'play':
	if (_startNewAdSection) { 
	  sendEvent('videoplazaPause');
	  _startNewAdSection = false;
	  setNewItem();
	}
	_vpAdPlayer.setPlayerState(PlayerState.PLAYING);
	break;
      case 'pause':
	_vpAdPlayer.setPlayerState(PlayerState.PAUSED);
	break;
      case 'volumechange':
	_vpAdPlayer.setPlayerState(PlayerState.VOLUME_CHANGE);
	break;
      case 'timeupdate':
	break;
      case 'durationchange':
	if (videoPlayerInfo.duration) _vpAdPlayer.setMetaData(videoPlayerInfo);
	break;
      case 'complete':
	_vpAdPlayer.setPlayerState(PlayerState.CLIP_COMPLETE);
	_startNewAdSection = true;
	break;
      case 'resize':
	_vpAdPlayer.setPlayerState(PlayerState.RESIZE);
	break;
      }
      //
    }
    
    //***************************************************************************************************
    //************************************* VIDEOLAZA INTERFACE *****************************************
    //***************************************************************************************************
    public function get videoplazaConfig():Object {	
      return videoPlayerInfo;
    }
    
    /**
     * FAIL: Start the videoplayer without videoplaza plugin
     */
    public function videoplazaLoadedFail(errorMessage:String):void {
      trace(errorMessage);
      sendEvent('videoplazaFail', errorMessage);
    }
    
    
    /**
     * SUCCESS: Add videoplaza plugin to the stage
     */
    public function videoplazaLoadedSuccess(vpAdPlayer:VpAdPlayer):void {
      _vpAdPlayer = vpAdPlayer;
      stage.addChild(_vpAdPlayer);
      
      //if autoplay, start a new ad section straightaway
      if (videoPlayerInfo.autoPlay) {
	_startNewAdSection = false;
	setNewItem();
	_vpAdPlayer.setPlayerState(PlayerState.PAUSED);
      }
      
      // Tell the player videoplaza is ready, now you can start!
      sendEvent('videoplazaReady');
    }
    
    /**
     * REQUEST NEW AD SECTION: here we passe the configuration for the 
     * request using the itemInfo object, _vpAdPlayer.setNewItem will trigger
     * a new HTTP request to videoplaza backend and get a JSON/XML response
     * containing ads.
     * 
     * @param media = a reference to the current media object
     */
    public function setNewItem(media:Object=null):void {
      var videoplazaConfig:Object = videoPlayerInfo;
      
      var itemInfo:ItemInfo = new ItemInfo();
      itemInfo.category = (videoplazaConfig.vpcategory) ? videoplazaConfig.vpcategory : '';
      itemInfo.tags = (videoplazaConfig.vptags) ? videoplazaConfig.vptags.split(',') : [];
      itemInfo.flags = (videoplazaConfig.vpflags) ? videoplazaConfig.vpflags.split(',') : [];
      itemInfo.contentForm = (videoplazaConfig.contentForm) ? videoplazaConfig.contentForm : '';
      itemInfo.contentId = (videoplazaConfig.contentId) ? videoplazaConfig.contentId : '';
      itemInfo.contentPartner = (videoplazaConfig.contentPartner) ? videoplazaConfig.contentPartner : '';
      
      //cuepoints must be formated as {name:'vpspot', time:10}
      if (videoplazaConfig.cuepoints) {
	var cuePointMarkers:Array = videoplazaConfig.cuepoints.split(",");
	var formatedMarkers:Array = [];
	for each (var time:String in cuePointMarkers) {
	  formatedMarkers.push({name:'vpspot', time:time});
	}
	itemInfo.cuePoints = formatedMarkers;
      }
      
      _vpAdPlayer.setNewItem(itemInfo);
    }
    
    /**
     * Every time a new ad module is created it will fire this method, this can be 
     * used to add further costumizations and listeners to the ad modules.
     */
    public function onAdModuleCreated(moduleEvent:Event):void {		
    }
    
    
    //***************************************************************************************************
    //******************************************* GET/SET ***********************************************
    //***************************************************************************************************
    
    public function get isMuted():Boolean {
      return (videoPlayerInfo.volume==0);
    }
    
    public function get isFullScreen():Boolean {
      return (stage.displayState == StageDisplayState.FULL_SCREEN) ? true : false;
    }
    
    public function getStage():Stage {
      return stage;
    }
    
    public function getScreenX():Number {
      return 0;
    }
    public function getScreenY():Number {
      return 0;
    }
    public function getScreenWidth():Number {
      if (isFullScreen) {
	return stage.fullScreenWidth;
      } else {
	return stage.stageWidth;
      }
    }
    public function getScreenHeight():Number{
      if (isFullScreen) {
	return stage.fullScreenHeight;
      } else {
	return stage.stageHeight;
      }
    }
    
    public function getPlayerVolume():Number {
      return videoPlayerInfo.volume;
    }
    
    public function getVideoPosition():Number {
      return videoPlayerInfo.position;
    }
    
    public function setScreenPosition(x:Number,y:Number):void {
      // no op
    }
    
    public function setScreenSize(w:Number,h:Number):void {
      // no op
    }
    
    public function setPlayerVolume(volume:Number):void {
      callMethod('setVolume', volume);
    }
    
    public function setPlayerPlay():void {
      callMethod('setPlaying', true);
    }
    
    public function setPlayerPause():void {
      callMethod('setPlaying', false);
    }
    
    public function setPlayerControlsEnable(enable:Boolean):void {
      callMethod('setEnableControls', enable); 
    }
    
    /**
     * Expose vp adplayer so other classes in your player can listen or manipulate 
     * the adplayer object
     */		
    public function get adPlayer():VpAdPlayer {
      return _vpAdPlayer;
    }
  }
}