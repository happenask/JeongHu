(function() {
    'use strict';

    angular
        .module('app.pages.try')
        .controller('ReviewWriteController', ReviewWriteController);

    /* @ngInject */
    function ReviewWriteController($scope, $rootScope, $state, $stateParams, $cookieStore, commonLayout, $timeout, Base64, Upload, getCampaignRsv, API_CONFIG) {
        if(!$stateParams.id) $state.go('common.leftSideMenu.mytry');

        commonLayout.updateLayoutFromType('myPage');
        var vm = this;

        var authdata = Base64.decode($cookieStore.get('authdata'));

        vm.campaign = {};
        vm.review = {
            files: [],
            memberId: $rootScope.globals.currentUser.id,
            campaignId: $stateParams.id,
            designScore: 3,
            priceScore: 3,
            serviceScore: 3,
            shipmentScore: 3,
            etc1Score: 3,
            etc2Score: 3,
            content: ""
        };

        vm.scoreText = [
            '완전 비추',
            '별로 추천하진 않아요',
            '그닥 좋은지 모르겠어요',
            '난 모르겠지만 넌 한번',
            '너에게 좋을 수 있는',
            '후회하지 않는 선택',
            '진짜 좋으니 한번 써봐',
            '꼭 써봐야 하는 아이템',
            '이건 인생템이야!'
        ];
        vm.stateYesNo = 'YES';

        vm.customTag = '';
        vm.customTagChanged = function () {
            var string = vm.customTag;

            string.replace(/\B#\w*[a-zA-Z]+\w+\s/g, function (p, p1) {
                console.log(p);
                return '<span>'+p+'</span>';
            });

            console.log('changed');
        }

        vm.init = (init)();

        //////////////////////
        function init() {
            if(getCampaignRsv.status.code === '0000') {
                vm.campaign = getCampaignRsv.result.campaign;
                vm.review.campaignId = vm.campaign.id;
            }
        }

        vm.removeFile = function (index) {
            console.log(index);
            vm.review.files.splice(index, 1);
        }

        vm.postReview = function () {

            console.log(vm.review);
            Upload.upload({
                url: API_CONFIG.host + 'reviews',
                method: 'POST',
                headers: {'X-08liter-Token': authdata + $rootScope.globals.currentUser.id},
                arrayKey: '[i]',
                data: vm.review
            }).then(function (resp) {
                swal({
                    title: "",
                    text: "리뷰가 성공적으로 제출 되었습니다",
                    showCancelButton: false,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "확인"
                    },
                    function(isConfirm){
                        if (isConfirm) {
                            $timeout(function(){
                                $state.go('common.leftSideMenu.mytry');
                                //$location.search('id', null);
                            });
                        } else {

                        }
                    });

            }, function (resp) {
                console.log('Error status: ' + resp.status);
                alert("[Error] 리뷰 작성 실패!! 다시 시도해 주십시오.");
            }, function (evt) {

            });

        }

        vm.adjustScore = function (name, value) {
          if(angular.isNumber(vm.review[name])) {
              vm.review[name] += value;
          } else {}
        };

        $('.spinner .btn:first-of-type').on('click', function() {
            var name = $(this).parent().siblings('input').attr('name');
            console.log(name);

            var input = $(this).parent().prev();

            if (input.attr('max') == undefined || parseFloat(input.val()) < parseFloat(input.attr('max'))) {

                vm.review[name] = parseFloat(input.val()) + 0.5;
                input.val(vm.review[name]);
            } else {
                $(this).next("disabled", true);
            }


        });
        $('.spinner .btn:last-of-type').on('click', function() {

            var input = $(this).parent().prev();

            if (input.attr('min') == undefined || parseFloat(input.val()) > parseFloat(input.attr('min'))) {
                input.val(parseFloat(input.val()) - 0.5);
            } else {
                $(this).prev("disabled", true);
            }
        });

    }



})();