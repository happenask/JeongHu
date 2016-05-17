(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('SignInController', SignInController);

    /* @ngInject */
    function SignInController($scope, $rootScope, Authentication, $location, faceBookManage) {
        Authentication.clearCredentials();
        var vm = this;
        if($rootScope.globals.sign) {
            $location.path('/try');
        }
        vm.sign = {
            email : null,
            passwd : null
        };
        //test
        vm.sign = {
            email : "jason@08liter.com",
            passwd : "123456"
        };
        vm.doSignIn = doSignIn;
        vm.loginFacebook = loginFacebook;


        function loginFacebook(){

            var faceBookConnect  =  faceBookManage.fbConnect();

            console.log(faceBookConnect);
            if(faceBookConnect==='connected')
            {
            }
            else
            {
                faceBookManage.fbLogin(loginCallback);


            }
        }

        function loginCallback(response)
        {

            var fbResponse = response;

            if(fbResponse.status === 'connected')
            {
                console.log(fbResponse);
                //            vm.param.accessToken = fbResponse.authResponse.accessToken;

            }

        }


        ////////////
        function doSignIn() {
            Authentication.signIn.post(vm.sign).then(function(user) {
                if(user.status.code === "0000") {
                    Authentication.setCredentials(user.result.member);
                    $location.path('/try');
                }
                else {
                    vm.loginAlert.msg = user.status.msg;
                    vm.loginAlert.show = "on";
                }
            });
        }


    }
})();
