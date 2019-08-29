$(document).ready(function() {
  console.log("--------------- onload ---------------");

  const twitter = require('twitter-text')
  const cloudinary = require('cloudinary-core');

  var cl = cloudinary.Cloudinary.new({cloud_name: "cenatus"});
  cl.responsive();

  if ($('#disqus_thread').length) {
    (function() { // DON'T EDIT BELOW THIS LINE
      var d = document, s = d.createElement('script');
      s.src = 'https://cenatus.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();
  }


  const home = (window.location.pathname === "/");
  // $('.hotspot').hover(
  //   function(event) {
  //     console.log('enter');
  //     event.preventDefault();
  //     $( this ).parents('.col-md-6').find('.overlay').fadeIn();
  //   },
  //   function(event) {
  //     console.log('leave');
  //     event.preventDefault();
  //     $( this ).parents('.col-md-6').find('.overlay').fadeOut();
  //   }
  // );

  $('.hotspot').hover(function() {
    $( this ).parents('.col-md-6').find('.overlay').stop().fadeToggle('fast', function() {
      if ($(this).is(':visible'))
        $(this).css('display','flex');
    });
  });

  const runAnimation = (mix_env != 'dev');

  TweenLite.set("header", {visibility:"visible"});
  TweenLite.set("main",   {visibility:"visible"});
  TweenLite.set("footer", {visibility:"visible"});

  if (runAnimation) {
    const tl = new TimelineLite({onComplete:startLogoAnimation});
    const t2 = new TimelineMax({repeat:-1, repeatDelay:0.2, yoyo: true, paused: true});

    function startLogoAnimation() {
      t2.staggerTo(".logo-circle", 0.1, { cycle: { alpha: [0,1] }, scale:1, ease: Back.easeOut}, 0.1)
        // .staggerTo(".logo-letter", 0.01, {cycle: { y: [0,100] }, autoAlpha:0, scale:1, ease: Back.easeOut }, 0.05)
        .play();
    }

    if (home) {
      tl.to('.home .cenatus', 1, { opacity:1 })
        .from(".home .header ", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .from(".home .logo ", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.2)
        .staggerFrom(".logo-circle", 0.01, {autoAlpha:0, scale:1, ease: Back.easeOut}, 0.05)
        .staggerFrom(".logo-letter", 0.01, {autoAlpha:0, scale:1, ease: Back.easeOut }, 0.1)
        .staggerFrom(".home .category ", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .from('.articles', 0.1, { opacity:0 })
        .staggerFrom(".articles .preview", 0.2, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .from(".home .meta ", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .staggerFrom(".home .meta aside", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.2)
        .from('.home footer', 1, { opacity:0 })


    } else {
      tl.from('.articles', 0.2, { opacity:0 })
        .from("header ", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .staggerFrom(".articles .preview", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .from(".meta ", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.1)
        .staggerFrom(".meta aside", 0.3, { scale:0.8, opacity:0, delay:0.1, ease:Expo.easeOut, force3D:true}, 0.2)
        .from('footer', 1, { opacity:0 })
    }
  }

  const tweets = $('.tweet .text');

  $.each(tweets, function( index, tweet ) {
    $(tweet).html(
      twitter.autoLink(
        twitter.htmlEscape($(tweet).text())
      )
    );
  });

  console.log("------------- DONE onload -------------");
});
