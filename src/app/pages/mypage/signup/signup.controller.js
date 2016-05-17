(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('SignUpController', SignUpController);

    /* @ngInject */
    function SignUpController($rootScope, $translate, Authentication, $location) {
        var vm = this;
        if($rootScope.globals.sign) {
            $location.path('/try');
        }

        vm.alert = {
            show: "off",
            msg: null
        };
        vm.sign = {
            email : null,
            passwd : null,
            kPasswd : null,
            nickname : null,
            aggrement : false
        };
        //test
        vm.sign = {
            email : "jason@08liter.com",
            passwd : "123456",
            ckPasswd : "123456",
            nickname : "jason",
            aggrement : true,
            locale: $translate.use()
        };
        vm.doSignUp = doSignUp;



        ////////////
        function doSignUp() {

            if(!vm.sign.email) {
                vm.alert.show = "on";
                vm.alert.msg = '이메일을 입력해주세요.';
            }
            else if(!vm.sign.passwd) {
                vm.alert.show = "on";
                vm.alert.msg = '비밀번호는 7자리 이상 입력해주세요.';
            }
            else if(vm.sign.ckPasswd != vm.sign.passwd) {
                vm.alert.show = "on";
                vm.alert.msg = '비밀번호가 일치하지 않습니다.';
            }
            else if(!vm.sign.nickname) {
                vm.alert.show = "on";
                vm.alert.msg = '닉네임을 입력해주세요.';
            }
            else if(!vm.sign.aggrement) {
                vm.alert.show = "on";
                vm.alert.msg = '약관에 동의해주세요.';
            }
            else {
                Authentication.signUp.post(vm.sign).then(function(response) {
                    if(response.status.code === "0000") {
                        Authentication.signIn.post(vm.sign).then(function(user) {
                            if(user.status.code === "0000") {
                                Authentication.setCredentials(user.result.member);

                                $location.path('/user/snsMgmt');
                            }
                            else {
                                vm.alert.msg = user.status.msg;
                                vm.alert.show = "on";
                            }
                        });
                    }
                    else {
                        if(response.status.code === "1001") {
                            vm.alert.msg = "이미 사용 중인 이메일입니다.";
                            vm.alert.show = "on";
                        }
                        else {
                            vm.alert.msg = "가입이 되지 않았습니다. 잠시 후에 이용해 주세요.";
                            vm.alert.show = "on";
                        }
                    }
                });
            }
        }
        
    }
})();
