(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('snsMgmtController', snsMgmtController);

    /* @ngInject */
    function snsMgmtController(Restangular, $rootScope, $location, faceBookManage, instagramManage) {
        var vm = this;

        var vm = this;
        var faceBookConnect = '';

        vm.api = Restangular.all('sns/sync');


        vm.param ={};
        vm.fbState={};
        vm.instaState={};

        vm.param.memberId = $rootScope.globals.currentUser.id;



        swal({
            title: "",
            text: "가입이 완료되었습니다!",
            type: "warning",
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "확인",
            closeOnConfirm: true
        });

        vm.fnLinkToSns = function(snsCode){


            if(snsCode === '1000')
            {
                vm.param.snsCode = snsCode;

                faceBookConnect  =  faceBookManage.fbConnect();

                if(faceBookConnect==='connected')
                {
                    vm.fbState.state =false;
                    syncSns();
                }
                else
                {
                    var fbResponse =  faceBookManage.fbLogin();

                    if(fbResponse.status === 'connected')
                    {


                        vm.param.accessToken = fbResponse.authResponse.accessToken;

                        vm.fbState.state = true;
                        syncSns();
                    }
                }
            }
            else if(snsCode === '2000')
            {
                vm.param.snsCode = '2000';


                instagramManage.instaLogin(function(accessToken){
                    vm.param.accessToken = accessToken;

                    syncSns();
                });
            }


        };



        function syncSns(){

            swal({
                title: "연동 중입니다!",
                text: '<div class="progress progress-striped active"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div></div>"',
                html: true,
                showConfirmButton: false
            });

            vm.api.post(vm.param).then(function(response) {

                console.log(response);
                swal.close();
                if(response.status.code === '0000') {
                    $location.path('/mypage/mysns');
                }
                else
                {
                    alert("SNS 연동 실패!!!!")
                }
            });

        };



        }
})();
