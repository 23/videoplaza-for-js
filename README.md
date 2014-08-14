VideoplazaJS is a wrapper library for the Videoplaza Flash SDK, designed to make it possible to use the feature set in modern web video player based off of JavaScript and HTML5.


## Motivation

[Videoplaza](http://www.videoplaza.com/) is an online advertising platform provider. The company provides a Flash SDK, which offers features not yet available to JavaScript video players. Since [23 Video](http://www.23video.com) is designed with multiple platforms in mind while running only a single video player, a piece of glue is needed to be able to provide decent Videoplaza functionality within 23 Video.


## Building the project

1. Clone the project from Github.
2. Bring in Flash integration ressources from Videoplaza. Specifically, this was built against `videoplaza_lib_public_2.4.14.9.0.swc` and the folders `com/videoplaza/` and `uk/` available from the `vp_flash_integration_demo.zip` files. All of these are [downloadable from Videoplaza](http://videoplaza.zendesk.com/entries/38224086-Flash-Integration-Resources).
3. Update `./build.sh` for your local environmnet. I've been using the Flex 4.1 SDK, but anything from 3.6 upwards should work.

## Starting the project

The project requires jQuery and SWFObject to run, so bootstrapping the code requires a few lines of code:

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script type="text/javascript" src="bin-debug/swfobject.js"></script>
    <script type="text/javascript" src="videoplaza.js"></script>
    <div id="vpcontainer"></div>
    <script>
      var vp = new VideoplazaJS(function(available){
        alert(available);
      });
    </script>

## Configuring the library

VideoplazaJS forwards a number of parameters to Videoplaza, specifically these are available with defaults:

    vphost = 'http://vp-validation.videoplaza.tv'
    vpcategory = 'validation'
    vptags = 'standard'
    vpflags = ''
    contentForm = ''
    contentId = ''
    contentPartner = ''
    cuePoints:''

Each can be set during load:

    var vp = new VideoplazaJS(function(available){
      alert(available);
    }, {vphost:'http://vp-validation.videoplaza.tv', vpcategory:'23video'});

## Integrating with your JavaScript player

The Videoplaza plugin must be able to control state of your player in some context, and this is done through a set of callbacks that you're expected to define for your integration -- and to program to control your player:

    var vp = new VideoplazaJS(...);
    vp.setEnableControls = function(enable){
      // Show or hide player controls
    }
    vp.setVolume = function(volume){
      // Update player volume
    }
    vp.setPlaying = function(playing){
      // Update playing state
    }

When playback state, time, duration or volume updates in your player you will need to tell the Videoplaza plugin about it:

    vp.update(event, playing, position, duration, volume);

The `event` parameter can be any of these strings:

    play
    pause
    stop
    end
    mute
    unmute
    volumechange
    timeupdate
    durationchange
    complete



