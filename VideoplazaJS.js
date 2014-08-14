/*
TODO:
- License
- Placement and size, including resize event 
*/

var VideoplazaJS = (function(jQuery, window){
  return function(callback, config){
    $this = this;
    $this.available = false;
    $this.callback = callback||function(){};
    $this.config = $.extend({
      container:'vpcontainer',
      swfFile:'VideoplazaJS.swf',
      autoPlay: false,
      playing:false,
      volume:1,
      position:0,
      duration:NaN,
      vphost:'http://vp-validation.videoplaza.tv',
      vpcategory: 'validation',
      vptags: 'standard',
      vpflags: '',
      contentForm: '',
      contentId: '',
      contentPartner: '',			
      cuePoints:'',
    }, config||{});
    $this.flash = null;

    $this.setEnableControls = function(enable){
    }
    $this.setVolume = function(volume){
    }
    $this.setPlaying = function(playing){
    }
    $this.update = function(event, playing, position, duration, volume){
      $this.config.playing = playing;
      $this.config.position = position;
      $this.config.duration = duration;
      $this.config.volume = volume;
      $this.flash.receiveEvent(event, $this.config);
    }
    window.VideoplazaJSEvent = function(event, context){
      ////console.debug('VideoplazaJS', 'Event', event, context);
      switch(event) {
      case 'videoplazaReady':
        $this.available = true;
        $this.callback(true);
        break;
      case 'videoplazaFail':
        $this.callback(false);
        break;
      case 'flashloaded':
        $this.flash = document.getElementById('VideoplazaJS');
        $this.flash.init($this.config);
        break;
      }
    }
    window.VideoplazaJSCallback = function(method, value){
      ////console.debug('VideoplazaJS', 'Run', method + '(' + value + ')');
      $this[method](value);
    }
    $this.loadFlash = function(){
      ////$this.callback(false); return;    // uncomment to test fallback

      swfobject.embedSWF($this.config.swfFile, $this.config.container,  '100%', '10%', '10.1.0', '', {}, {allowscriptaccess:'always', allowfullscreen:'true', wmode:'transparent'}, {id:'VideoplazaJS', name:'VideoplazaJS'}, function(success, id, ref) {
        if(!success) $this.callback(false);
      });
    };
    $this.loadFlash();    
    return $this;
  }
})(jQuery, window);

if(window.VideoplazaJSLibraryAvailable) window.VideoplazaJSLibraryAvailable();