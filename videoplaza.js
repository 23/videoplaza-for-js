/*
TODO:
- License
- Placement and size, including resize event 
*/

var VideoplazaJS = (function(jQuery, window){
  return function(callback, config){
    $this = this;
    $this.callback = callback||function(){};
    $this.config = $.extend({
      container:'vpcontainer',
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
      cuePoints:''
    }, config||{});
    $this.flash = null;

    $this.setEnableControls = function(enable){
    }
    $this.setVolume = function(volume){
    }
    $this.setPlaying = function(playing){
    }
    $this.update = function(event, playing, position, duration, volume){
      console.debug('update');
      $this.config.playing = playing;
      $this.config.position = position;
      $this.config.duration = duration;
      $this.config.volume = volume;
      $this.flash.receiveEvent(event, $this.config);
    }
    window.VideoplazaJSEvent = function(event, context){
      console.debug('VideoplazaJS', 'Event', event, context);
      switch(event) {
      case 'videoplazaReady':
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
      console.debug('VideoplazaJS', 'Run', method + '(' + value + ')');
      $this[method](value);
    }
    $this.loadFlash = function(){
      console.debug('embed');
      swfobject.embedSWF("VideoplazaJS.swf", $this.config.container,  '100%', '100%', '10.1.0', '', {}, {allowscriptaccess:'always', allowfullscreen:'true', wmode:'opaque', bgcolor:'#000000'}, {id:'VideoplazaJS', name:'VideoplazaJS'});
    };
    $this.loadFlash();
    return $this;
  }
})(jQuery, window);