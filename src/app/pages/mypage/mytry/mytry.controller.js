(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .controller('MytryController', MytryController);

    /* @ngInject */
    function MytryController($location, $rootScope,Restangular,commonLayout, angularGridInstance) {
        
        commonLayout.updateLayoutFromType('myPage');
        var vm = this;
        var memberId = $rootScope.globals.currentUser.id;

        vm.api = Restangular.all('members/'+memberId);

        vm.listState = 'campaignApplies';
        vm.listview = [];
        vm.campaignApplies = [];
        vm.campaignWins = [];
        vm.campaignFails = [];
        vm.campaignTries = [];



        var exp_param_try = {
            followCount: 30,
            reviewYn: 'N',
            resultCode:'3000',
            averageScore:'4.4'
        };



        vm.emptyList = false;

        vm.api.customGET("campaigns").then(function(response) {
            if(response.status.code === '0000') {
                console.log(response.result);
                vm.emptyList = response.result.campaignApplies.length == 0;
                vm.campaignApplies = response.result.campaignApplies;

                for(var index in vm.campaignApplies)
                {
                    var array = ['1000','2000','3000','1000','2000','3000','1000','2000','3000','1000']
                    var reviewYn = Math.round(Math.random());
                    var resultCode = Math.floor(Math.random()*10);

                    exp_param_try.reviewYn = (reviewYn === 1)?'Y':'N';
                    exp_param_try.resultCode = array[resultCode];


                    $.extend(vm.campaignApplies[index],exp_param_try);

                    if(exp_param_try.resultCode==='1000')
                    {
                        vm.campaignWins.push(vm.campaignApplies[index]);
                    }
                    else if(exp_param_try.resultCode==='2000')
                    {
                        vm.campaignFails.push(vm.campaignApplies[index]);
                    }
                    else if(exp_param_try.resultCode==='3000')
                    {
                        vm.campaignTries.push(vm.campaignApplies[index]);
                    }


                }

                console.log(vm.campaignTries);
                console.log(vm.campaignWins);
                console.log(vm.campaignFails);
                vm.listview = vm.campaignTries;
            }
            else {

            }
        });





/*        vm.api.customGET("reviews").then(function(response) {
            if(response.status.code === '0000') {
                console.log(response.result);
                vm.campaignReviews = response.result.reviews;

            }
            else {

            }
        });*/



        vm.onClickWin = function() {

            vm.listview = vm.campaignWins;

             $('.category-try').removeClass('active');
             $('.category-fail').removeClass('active');
             $('.category-win').addClass('active');
        }

        vm.onClickFail = function() {
            vm.listview = vm.campaignFails;

            $('.category-try').removeClass('active');
            $('.category-win').removeClass('active');
            $('.category-fail').addClass('active');
        }
        
        vm.onClickApply = function() {
            vm.listview = vm.campaignTries;


             $('.category-win').removeClass('active');
             $('.category-fail').removeClass('active');
             $('.category-try').addClass('active');
        }


        angular.element('.appliedEvent img').load(function () {
            var width = $('.appliedEvent img').width();
            $('.appliedEvent img').height(width * 0.8);

        });
        angular.element('.reviewEvent img').load(function () {
            var width = $('.reviewEvent img').width();
            $('.reviewEvent img').height(width * 0.8);

        });

    }
})();
