(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .provider('faceBookManage', faceBookManage);




    function faceBookManage()
    {


        var faceBookAppId   = '1542090409427397';

        FB.init({
            appId: faceBookAppId,
            status: true,
            cookie: true,
            xfbml: true,
            version: 'v2.4'
        });


        function faceBookConnect()
        {
            var message='';
            FB.getLoginStatus(function (response) {

                console.log(response);
                if (response.status === 'connected') {

                    message = "connected";
                }
                else
                {
                    message = "disconnected";

                }

            });
            return message;
        }



        function faceBookLogin(callback)
        {
            var message = '';
            FB.login(function(response){
                // Handle the response object, like in statusChangeCallback() in our demo
                // code.
                console.log(response);

                if (response.status === 'connected') {

                }


                callback(response);
            });

        }

        function faceBookLogout()
        {
            FB.logout();
        }

        return {

            $get: function(){
                return {
                    fbConnect:faceBookConnect,
                    fbLogin: faceBookLogin,
                    fbLogout: faceBookLogout
                }
            }



        }
    }

})();