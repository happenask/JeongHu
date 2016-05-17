(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('ProfileController', ProfileController);

    /* @ngInject */
    function ProfileController($scope, $rootScope, $window, $timeout, $location, commonLayout, Restangular, Authentication) {
        commonLayout.updateLayoutFromType('myPage');

        var tabFlag = false;
        var anchors = $('.nav-tabs a[href]');
        anchors.on('click', function (e) {
            tabFlag = true;
        });

        var vm = this;
        vm.api = Restangular.all('members');
        vm.member = {};
        vm.passwdData = {};
        vm.editMode = false;
        vm.certifiedPopupUrl = '/service/certification'; //"/callbackPopup.html";http://192.168.0.180:8080/cert/test/success

        vm.init = (init)();
        vm.updateMember = updateMember;
        vm.updatePasswd = updatePasswd;
        vm.searchPostcode = searchPostcode;
        vm.certifiedPopupCallback = certifiedPopupCallback;

        vm.warning = [
            {
                targetId: 14,
                image: 'http://static.08liter.com/images/event/thumbnail/07134d51-4529-4216-b8b8-7dd7881efa32.jpg',
                context: 'PROFILE.BLACK_LIST.WARNING_DELAY',
                count: 2,
                productName: 'VANT 36.5 CC CUSHION',
                date: Date.now()
            }
        ];

        $window.onhashchange = getHash;

        //////////////////////
        function init() {
            if($rootScope.globals.currentUser.id) {
                getHash();
                vm.api.get($rootScope.globals.currentUser.id).then(function(response) {
                    vm.member = response.result.member;
                    Authentication.updateCredentials(vm.member);
                    if(vm.member) {
                        if(vm.member.gender === 'M') {
                            vm.member.genderStr = "남자";
                        }
                        else if(vm.member.gender === 'F') {
                            vm.member.genderStr = "여자";
                        }
                    }
                });
            }
            else {
                $location.path('/try');
            }

        }

        function getHash() {
            if(tabFlag) tabFlag = false;
            else {
                var hash = $location.hash();
                var selector = '.nav-tabs a:first';
                if(hash) selector = '.nav-tabs a[href="#'+hash+'"]';
                $(selector).tab('show');
            }
        }

        function updateMember() {
            vm.editMode = false;
            var updateMember = {
                id: vm.member.id,
                nickname: vm.member.nickname,
                address: vm.member.address
            };
            vm.api.post(updateMember).then(function(response) {
                if(response.status.code === '0000' && response.result.member) {
                    vm.member = response.result.member;
                    Authentication.updateCredentials(vm.member);
                }
            });
        }

        function updatePasswd() {

            if(!vm.passwdData.oldPasswd) {
                vm.passwdErrMsg = "PROFILE.PWD_CHANGE.SUB_CONTEXT8"
            }
            else if(!vm.passwdData.newPasswd) {
                vm.passwdErrMsg = "PROFILE.PWD_CHANGE.SUB_CONTEXT9"
            }
            else if(vm.passwdData.newPasswd.length < 7) {
                vm.passwdErrMsg = "PROFILE.PWD_CHANGE.SUB_CONTEXT10"
            }
            else if(vm.passwdData.newPasswd != vm.passwdData.checkPasswd) {
                vm.passwdErrMsg = "PROFILE.PWD_CHANGE.SUB_CONTEXT11"
            }
            else {
                vm.passwdData.id = vm.member.id;
                delete vm.passwdData.checkPasswd;
                var passwdUpdateApi = Restangular.all('/members/passwd');
                passwdUpdateApi.post(vm.passwdData).then(function(response) {
                    if(response.status.code === '0000') {
                        vm.passwdErrMsg = null;
                        vm.passwdData = {};
                        window.location.reload()
                    }
                    else {
                        if(response.status.code === "1004") {
                            vm.passwdErrMsg = "PROFILE.PWD_CHANGE.SUB_CONTEXT12";
                        }
                        else {
                            if(response.status.msg) {
                                vm.passwdErrMsg = response.status.msg.replace(/ /g,'_').toUpperCase();
                            }
                        }
                    }
                });
            }
        }

        function searchPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    $timeout(function() {
                        vm.member.address = {
                            address: data.address,
                            postNum: data.postcode
                        }
                    });
                    //todo 주소상세 input로 포커스 이동, 주소 업데이트, 비밀번호 수정, 프로필 이미지 수정 ( left side menu 영역 )

                }
            }).open();
        }

        function certifiedPopupCallback(response) {
            console.log(response);
        }

    }
})();
