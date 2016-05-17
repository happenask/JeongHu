(function() {
    'use strict';

    angular
        .module('app.pages.try')
        .controller('DetailController', DetailController);

    /* @ngInject */
    function DetailController($stateParams, commonLayout, getCampaignRsv, Restangular) {
        commonLayout.updateLayoutFromType('try/detail');

        var vm = this;
        vm.campaign = null;
        vm.toggleFollow = toggleFollow;
        // vm.api = Restangular.all('campaigns/'+ $stateParams.id + '/');

        vm.init = (init)();

        //////////////////////
        function init() {
            vm.slickHeight = $(window).height()-102 + 'px';
            if(getCampaignRsv.status.code === '0000') {
                vm.campaign = getCampaignRsv.result.campaign;
                if(getCampaignRsv.result.campaignApply) {
                    vm.applied = true;
                }
            }
        }

        function toggleFollow(e) {
            e.preventDefault();
            if(vm.campaign.brandFollow) vm.campaign.brandFollow = !vm.campaign.brandFollow;
            else vm.campaign.brandFollow = true;
            console.log(vm.campaign.brandFollow);
        }

    }
})();