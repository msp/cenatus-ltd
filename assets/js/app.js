// Import dependencies
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

// https://github.com/twitter/twitter-text/tree/master/js/pkg
import twitter from "../vendor/twitter-text-3.1.0.min"

// https://github.com/cloudinary/pkg-cloudinary-core
import cloudinary from "../vendor/cloudinary-core-shrinkwrap.min"

// https://github.com/metafizzy/ev-emitter
import ev_emitter from "../vendor/ev-emitter"

// https://github.com/desandro/imagesloaded
import foo from "../vendor/imagesloaded.pkgd"


////////////////////////////////////////////////////////////////////////////////
// Onload!
////////////////////////////////////////////////////////////////////////////////
$(document).ready(function() {
  console.log("--------------- onload ---------------");
  console.log(Date.now());

  var cl = cloudinary.Cloudinary.new({ cloud_name: "cenatus" });
  cl.responsive();

  const home = (window.location.pathname === "/");
  const blog = (window.location.pathname === "/blog");
  const articlesSelector = blog ? ".blog-articles" : ".articles";
  const runAnimation = (mix_env != 'dev');
  const mobileView = $('.navbar-toggler:visible').length > 0;
  const tweets = $('.tweet .text');

  $('main').imagesLoaded()
    .always(function(instance) {
      console.log('all images loaded!');
    })
    .done(function(instance) {
      console.log('all images successfully loaded!');

      $('#spinner').hide();

      if (runAnimation) {
        startAnimation(home, mobileView, articlesSelector);
      } else {
        TweenLite.set("header", { visibility: "visible" });
        TweenLite.set("main", { visibility: "visible" });
        TweenLite.set(`${articlesSelector} .preview`, { visibility: "visible" });
        TweenLite.set("footer", { visibility: "visible" });
      }
    })
    .fail(function() {
      console.log('all images loaded, at least one is broken!');
    })
    .progress(function(instance, image) {
      var result = image.isLoaded ? 'loaded' : 'broken';
      if (mix_env == 'dev') {
        console.log('image is ' + result + ' for ' + image.img.src);
      }
    });


  if ($('#disqus_thread').length) {
    (function() { // DON'T EDIT BELOW THIS LINE
      var d = document, s = d.createElement('script');
      s.src = 'https://cenatus.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();
  }

  $.each(tweets, function(index, tweet) {
    $(tweet).html(
      twitter.autoLink(
        twitter.htmlEscape($(tweet).text())
      )
    );
  });

  console.log("------------- DONE onload -------------");
});


function mobileAnimation(tl, articlesSelector) {
  tl.to('header', 0.01, { visibility: "visible" })
    .to('.home .cenatus', 0.01, { opacity: 1 })
    .to('main', 0.01, { visibility: "visible" })
    .to(articlesSelector, 0.1, { visibility: "visible" })
    .from(articlesSelector, 0.1, { opacity: 0 })
    .staggerFrom(`${articlesSelector} .preview`, 1.5, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.2)
    .to('footer', 0.01, { visibility: "visible" })
}

function startAnimation(home, mobileView, articlesSelector) {
  console.log('startAnimation >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  const tl = new TimelineLite({ onComplete: startLogoAnimation });
  const t2 = new TimelineMax({ repeat: -1, repeatDelay: 0.2, yoyo: true, paused: true });

  function startLogoAnimation() {
    t2.staggerTo(".logo-circle", 0.1, { cycle: { alpha: [0, 1] }, scale: 1, ease: Back.easeOut }, 0.1)
      // .staggerTo(".logo-letter", 0.01, {cycle: { y: [0,100] }, autoAlpha:0, scale:1, ease: Back.easeOut }, 0.05)
      .play();
  }

  if (home) {
    if (!mobileView) {
      tl.to('.home .cenatus', 0.001, { opacity: 1 })
        .from(".home .logo ", 0.3, { scale: 0.1, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.2)
        .to('header', 0.01, { visibility: "visible" })
        .staggerFrom(".logo-circle", 0.01, { autoAlpha: 0, scale: 1, ease: Back.easeOut }, 0.05)
        .staggerFrom(".logo-letter", 0.01, { autoAlpha: 0, scale: 1, ease: Back.easeOut }, 0.1)
        .staggerFrom(".home .header .nav-item ", 0.3, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.3)
        .staggerFrom(".home .category ", 0.3, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.1)
        .to('main', 0.01, { visibility: "visible" })
        .to(articlesSelector, 0.1, { visibility: "visible" })
        .staggerFrom(`${articlesSelector} .preview`, 1.0, { scale: 0.1, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.3)
        .to('footer', 0.01, { visibility: "visible" })
        .from(".home .meta ", 0.3, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.1)
        .staggerFrom(".home .meta aside", 0.3, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.2)
        .from('.home footer', 1, { opacity: 0 })
    } else {
      mobileAnimation(tl, articlesSelector);
    }

  } else {
    if (!mobileView) {
      tl.to('main', 0.01, { visibility: "visible" })
        .to(articlesSelector, 0.1, { visibility: "visible" })
        .staggerFrom(`${articlesSelector} .preview`, 1.0, { scale: 0.1, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.3)
        .staggerFrom(".blog-aside", 0.3, { scale: 0.1, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.3)
        .to('footer', 0.01, { visibility: "visible" })
        .from(".meta ", 0.3, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.1)
        .staggerFrom(".meta aside", 0.3, { scale: 0.8, opacity: 0, delay: 0.1, ease: Expo.easeOut, force3D: true }, 0.2)
        .from('footer', 1, { opacity: 0 })
    } else {
      mobileAnimation(tl, articlesSelector);
    }
  }
}