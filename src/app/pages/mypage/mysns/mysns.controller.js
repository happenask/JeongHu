(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('MysnsController', MysnsController);

    /* @ngInject */
    function MysnsController($timeout, commonLayout, Restangular, $rootScope , $window, faceBookManage, instagramManage ) {


        commonLayout.updateLayoutFromType('myPage');



        var vm = this;
        var faceBookConnect = '';
        var faceBookLoginSuccess = '';
        var instagramConnect = '';

        vm.api = Restangular.all('sns/sync');


        vm.param ={};
        vm.fbState={};
        vm.instaState={};
        vm.fbResult = {};
        vm.instaResult = {};
        vm.minFeedNum = 5;
        vm.minFollowerNum = 150;
        vm.passFBYnText = "MYSNS.FAIL_CONTEXT";
        vm.passInstaYnText = "MYSNS.FAIL_CONTEXT";
        vm.passFBCheckIcon = true;
        vm.passInstaCheckIcon = true;


        vm.param.memberId = $rootScope.globals.currentUser.id;



        vm.refreshFaceBook = function(){

            vm.param.snsCode = '1000';
            vm.passCheckIcon = false;

            faceBookConnect  =  faceBookManage.fbConnect();

            if(faceBookConnect==='connected')
            {
                vm.fbState.state =false;
                syncFbSns();
            }
            else
            {
                faceBookManage.fbLogin(loginCallback);

            }

        };

        function loginCallback(response)
        {

            var fbResponse = response;

            if(fbResponse.status === 'connected')
            {
                vm.param.accessToken = fbResponse.authResponse.accessToken;

                vm.fbState.state = true;
                syncFbSns();

            }

        }

        vm.refreshInstagram = function(){

           vm.param.snsCode = '2000';


            instagramManage.instaLogin(function(accessToken){
                vm.param.accessToken = accessToken;

                syncInstaSns();
            });



        };

        function syncFbSns(){

            swal({
                title: "PROGRESSING!",
                text: '<div class="progress progress-striped active"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div></div>"',
                html: true,
                showConfirmButton: false
            });

            vm.api.post(vm.param).then(function(response) {


                swal.close();
                if(response.status.code === '0000') {
                    vm.fbResult=response.result;
                    vm.fbResult.followerNo = vm.fbResult.followerNo? vm.fbResult.followerNo:0;
                    vm.fbResult.feedNoin30 = vm.fbResult.feedNoin30? vm.fbResult.feedNoin30:0;

                    if((vm.fbResult.feedNoin30>vm.minFeedNum)&&(vm.fbResult.followerNo>vm.minFollowerNum))
                    {
                        vm.passFBYnText="MYSNS.PASS_CONTEXT";
                        vm.passFBCheckIcon= false;
                    }
                    else
                    {
                        vm.passFBCheckIcon= true;
                    }
                    console.log(response.result);
                }
                else
                {

                }
            });

        };

        function syncInstaSns(){

            swal({
                title: "PROGRESSING!",
                text: '<div class="progress progress-striped active"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div></div>"',
                html: true,
                showConfirmButton: false
            });


            vm.api.post(vm.param).then(function(response) {


                swal.close();
                if(response.status.code === '0000') {
                    vm.instaResult=response.result;
                    vm.instaResult.followerNo = vm.instaResult.followerNo? vm.instaResult.followerNo:0;
                    vm.instaResult.feedNoin30 = vm.instaResult.feedNoin30? vm.instaResult.feedNoin30:0;

                    if((vm.instaResult.feedNoin30>vm.minFeedNum)&&(vm.instaResult.followerNo>vm.minFollowerNum))
                    {
                        vm.passInstaYnText="MYSNS.PASS_CONTEXT";
                        vm.passInstaCheckIcon= false;
                    }
                    else
                    {
                        vm.passInstaCheckIcon= true;
                    }
                    console.log(response.result);
                }
                else
                {

                }
            });

        };



    }
})();
