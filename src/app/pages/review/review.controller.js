(function() {
    'use strict';

    angular
        .module('app.pages.review')
        // 2016.4.19 written by leo
        .filter('shortly', function () {
            return function (input) {
                var result = input;

                if(input.length > 12) {
                    result = result.substring(0, 12);
                }
                return result;
            }
        })
        .directive('timeleft', function () {
            function link(scope, element, attrs) {
                var utcTime = Date.now() + (new Date().getTimezoneOffset() * 60000);
                var time = Math.floor((utcTime - scope.st)/1000);
                var output = {};
                var unit =
                //{ d: 'day', h: 'hour', m: 'minute', s: 'second', now: 'now', ss: 's', tail: 'ago'};
                { d: '일', h: '시간', m: '분', s: '초', now: '지금', ss: '', tail: '전'};

                if(time < 10) output = { unit: 'now', n: 0 };
                else if(time < 60) output = { unit: 's', n: time };
                else if(time < 3600) output = { unit: 'm', n: (time/60) };
                else if(time < 216000) output = { unit: 'h', n: (time/3600) };
                else output = { unit: 'd', n: (time/216000) };

                output.n = Math.floor(output.n);

                output.text = [
                    (output.n > 0 ? output.n : ''),
                    unit[output.unit]+(output.n > 1 ? unit.ss : ''),
                    unit.tail
                ].join(' ');

                element.text(output.text);
            }
            return {
                restrict: 'E',
                scope: {
                    st: '=time'
                },
                link: link
            }
        })
        .controller('ReviewlistController', ReviewlistController);

    /* @ngInject */
    function ReviewlistController($scope, $timeout, $window, commonLayout, Restangular, $translate, $stateParams,  angularGridInstance) {

        commonLayout.updateLayoutFromType();

        var path = 'reviews';
        if($stateParams.campaign) {
            path = 'campaigns/'+ $stateParams.campaign + '/reviews/';
        }

        var vm = this;
        vm.api = Restangular.all('');
        vm.reviews = [];
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
            if(param && param.init === true) { vm.reviews = []; }
            $(window).unbind('scroll');
            vm.api.customGET(path, vm.param).then(function (response) {

                if(response.status.code === '0000') {
                    var res = response.result.reviews;

                    // 테스트를 위해 결과값 변경
                    for(var key in res) {
                        res[key].yesno = 'YES';
                    }
                    //res[0].content = '긴 텍스트를 테스트하고 있습니다. 이 제품을 쓰니 너무 좋아요.';
                    // end

                    vm.reviews = $.merge( vm.reviews, response.result.reviews );
                    if(response.result.reviews.length === vm.param.limit) {
                        $timeout(function() {
                            $(window).bind("scroll", function() {
                                if($(window).scrollTop() + $(window).height() === $(document).height()) {
                                    vm.param.offset = vm.param.offset + vm.param.limit;
                                    vm.moreItems();
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
                'target' : target
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

    }
})();
