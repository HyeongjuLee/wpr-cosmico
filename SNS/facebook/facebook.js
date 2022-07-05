 //meta facebook 개발 중지요청 2022-06-28 10:22

  window.fbAsyncInit = function() {
    FB.init({
      appId      : '',
      cookie     : true,
      xfbml      : true,
      version    : 'v14.0'
    });

    FB.AppEvents.logPageView();

  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));