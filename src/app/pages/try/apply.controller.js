(function() {
    'use strict';

    angular
        .module('app.pages.try')
        .controller('ApplyController', ApplyController);

    /* @ngInject */
    function ApplyController($rootScope, $scope, $timeout, $state, $location, Authentication, commonLayout, getCampaignRsv, Restangular) {
        commonLayout.updateLayoutFromType('');

        var vm = this;
        vm.api = Restangular.all('/campaigns/apply');
        vm.memberApi = Restangular.all('/members/');
        vm.member = {};
        vm.campaign = {};
        vm.apply = {};
        // vm.api = Restangular.all('campaigns/'+ $stateParams.id + '/',{},{ac:'',token});
        vm.searchPostcode = searchPostcode;
        vm.postApply = postApply;

        vm.init = (init)();
        //////////////////////
        function init() {
            if(getCampaignRsv.status.code === '0000') {

                vm.campaign = getCampaignRsv.result.campaign;
                vm.campaign.title = 'VENT 36.5 CC CUSHION';
                if(getCampaignRsv.result.campaignApply) {
                    vm.campaignApply = getCampaignRsv.result.campaignApply;
                }
                else {
                    vm.campaignApply = {
                        snsCode: '',
                        optionAnswer: ''
                    }
                }

                vm.campaignApply.options = [
                    {
                        optionID: 12312313,
                        title: 'SIZE',
                        selection: ('XXL,XL,L,M,S,XS').split(','),
                        optionCode: '0001',
                        requiredYN: '',
                        position: 1,
                        placeHolder: '사이즈를 입력해주세요.'
                    },
                    {
                        optionID: 12312313,
                        title: 'COLOR',
                        selection: '',
                        optionCode: '0000',
                        requiredYN: '',
                        position: 1,
                        placeHolder: '원하시는 색상을 입력하세요s'
                    },
                    {
                        optionID: 12312313,
                        title: 'TYPE',
                        selection: ('건성,지성,반건성').split(','),
                        optionCode: '0001',
                        requiredYN: '',
                        position: 1,
                        placeHolder: '피부타입을 골라주세요'
                    }
                ];

                swal.setDefaults({
                    showCancelButton: true,
                    closeOnCancel: false,
                    cancelButtonText: '확인'
                })

                $scope.alertList = [
                    'applied',
                    'expired',
                    'blacklist',
                    'required',
                    'country'
                ];

                $scope.alertMsg = {
                    applied: {
                        title: '이미 신청함',
                        text: '이미 이 제품의 에디터로 응모하셨습니다. 응모 제한시간이 끝나면 MESSAGE 메뉴와 푸시 알림으로 결과를 확인할 수 있습니다.',
                        targetUrl: '/mypage/mytry',
                        confirmButtonText: '마이페이지로 이동'
                    },
                    expired: {
                        title: '신청기간지남',
                        text: '캠페인 신청기간이 완료되어 신청하실 수 없습니다. 추후 다시 신청하시려면',
                        targetUrl: '/mypage/mytry',
                        confirmButtonText: 'Brand를 팔로우하러가기'
                    },
                    blacklist: {
                        title: '블랙리스트',
                        text: '에디터님은 리뷰를 작성하지 않아 블랙리스트에 등록되었습니다. 작성하지 않은 리뷰를 남기시고 다시 신청해주세요.',
                        targetUrl: '/mypage/profile',
                        hash: 'stateTab',
                        confirmButtonText: '경고/블랙리스트 내역 보기'
                    },
                    required: {
                        title: '여성 전용',
                        text: '고객님에게 경험하실 수 없는 캠페인입니다. 해당 캠페인을 참여하시려면 마이 프로필에서 고객님을 프로필을 작성, 인증하고 참여해주세요.',
                        targetUrl: '/mypage/profile',
                        confirmButtonText: '프로필 정보 수정하기'
                    },
                    country: {
                        title: '응모할 수 없는 국가',
                        text: '한국에서는 응모할 수 없는 제품입니다.',
                        targetUrl: '/mypage/mytry',
                        confirmButtonText: '마이페이지로 이동'
                    }
                };

                $scope.count = 0;
                $scope.callback = function (isConfirm) {
                    if(isConfirm) {
                        var target = $scope.alertMsg[$scope.alertList[$scope.count]].targetUrl;
                        var hash = $scope.alertMsg[$scope.alertList[$scope.count]].hash;
                        $location.path(target);
                        if(hash) $location.hash(hash);
                        $state.reload();
                    }
                    else {
                        $scope.count += 1;
                        var params;
                        if ($scope.count == $scope.alertList.length) {
                            console.log('fin');

                        }
                        else {
                            if ($scope.count == $scope.alertList.length - 1) {
                                $scope.alertMsg[$scope.alertList[$scope.count]].closeOnConfirm = true;
                                $scope.alertMsg[$scope.alertList[$scope.count]].showCancelButton = false;
                            }
                            else {

                            }
                            params = [$scope.alertMsg[$scope.alertList[$scope.count]], $scope.callback];
                            swal.apply(false, params);
                        }
                    }

                };

                if($scope.alertList.length) {
                    if($scope.alertList.length == 1) $scope.alertMsg[$scope.alertList[$scope.count]].showCancelButton = false;
                    swal.apply(false, [$scope.alertMsg[$scope.alertList[$scope.count]], $scope.callback]);
                }

                if($rootScope.globals.currentUser.id) {
                    vm.memberApi.get($rootScope.globals.currentUser.id).then(function(response) {
                        vm.member = response.result.member;
                        vm.apply = {
                            // memberId: vm.member.id,
                            campaignId: vm.campaign.id,
                            name: vm.member.name,
                            phone: vm.member.phone,
                            postNum: vm.member.address.postNum,
                            address: vm.member.address.address,
                            detail: vm.member.address.detail,
                            snsCode: vm.campaignApply.snsCode,
                            optionAnswer: vm.campaignApply.optionAnswer
                        };
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
        }

        function postApply() {
            swal({
                title: "PROGRESS",
                text: '<div class="progress progress-striped active"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div></div><p>\' 경험하고 사는 곳, 0.8L(공팔리터) \'</p>',
                html: true,
                showConfirmButton: false
            });
            vm.apply = {
                memberId: vm.member.id,
                campaignId: vm.campaign.id,
                name: vm.member.name,
                phone: vm.member.phone,
                postNum: vm.member.address.postNum,
                address: vm.member.address.address,
                detail: vm.member.address.detail,
                snsCode: vm.campaignApply.snsCode.snsCode,
                optionAnswer: vm.campaignApply.optionAnswer
            };
            vm.api.post(vm.apply).then(function(response) {
                if(response.status.code === '0000') {
                    swal.close();
                    $location.path('/try');
                    //완료시 -> 마이페이지 마이트라이 페이지로 이동
                }
            });
        }

        function searchPostcode(e) {
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


    }
})();