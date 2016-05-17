(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .provider('instagramManage', instagramManage);




    function instagramManage($windowProvider)
    {

        var $window = $windowProvider.$get();

        var instagramAppId  = '940c045ed17b41938a983d01fe476a3c';
        var redirect_uri    = 'http://localhost:3000/callbackPopupInsta.html';


        function instagramLogin(callback)
        {

            var instaAccessToken = '';
            $window.open("https://instagram.com/oauth/authorize?client_id="+ instagramAppId +"&redirect_uri="+redirect_uri+"&response_type=token", "", "width=600, height=500");

            $window.callback = function(accessToken){
                if(accessToken)
                {
                console.log(accessToken);
                    callback(accessToken);
                }
                else
                {


                }
            };
            
        }


        return {

            $get: function(){
                return {
                    instaLogin: instagramLogin

                }
            }



        }
    }

})();