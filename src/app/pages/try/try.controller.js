(function() {
    'use strict';

    angular
        .module('app.pages.try')
        .controller('TryController', TryController);

    /* @ngInject */
    function TryController($scope, $timeout, commonLayout, Restangular, $translate, angularGridInstance) {
        
        commonLayout.updateLayoutFromType();
        var vm = this;
        vm.api = Restangular.all('');
        vm.campaigns = [];
        vm.param = {
            'offset' : 0,
            'limit' : 9,
            'target' : 'all',
            'type': 'hot',
            'locale': $translate.use()
        };
        vm.moreItems = moreItems;
        vm.targetSelect = targetSelect;
        vm.typeSelect = typeSelect;
        vm.scrollUp   = scrollUp;

        // $scope.refresh = function(){
        //     angularGridInstance.gallery.refresh();
        // };

        vm.nowTime = new Date().getTime() / 1000;
        vm.init = (init)();
        /////////////////////
        function init() {
            vm.moreItems({init:true});
        }


        function moreItems(param) {
            if(param && param.init === true) { vm.campaigns = []; }
      //      $(window).unbind('scroll');
            vm.api.customGET('campaigns', vm.param).then(function (response) {
                if(response.status.code === '0000') {

                    vm.campaigns = $.merge( vm.campaigns, response.result.campaigns );
                    if(response.result.campaigns.length === vm.param.limit) {
                        $timeout(function() {
                            $(window).bind("scroll", function() {
                                if($(window).scrollTop() + $(window).height() === $(document).height()) {
                                    vm.param.offset = vm.param.offset + vm.param.limit;
                                    vm.moreItems();
                                }
                                if($(window).scrollTop()>$(window).height()+180)
                                {
                                    $('.scrollup').show();
                                }
                                else
                                {
                                    $('.scrollup').hide();
                                }
                            });
                        });
                    }
                }
            });
        }

        function targetSelect(target) {
            vm.param = {
                'offset' : 0,
                'limit' : 9,
                'type': target,
                'target' : 'all'
            };
            vm.moreItems({init:true});
            $('.categoryFilter li a').removeClass('active');
            $('.categoryFilter li[target=' + target +'] a').addClass('active');
        }

        function typeSelect() {
            $timeout(function() {
                vm.moreItems({init:true});
            });
        }
        
        function scrollUp() {
            $('body, html').animate({scrollTop : 0},800);
        }
    }
})();
