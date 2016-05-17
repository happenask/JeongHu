(function() {
    'use strict';

    angular
        .module('app.pages.review')
        .directive('imgOnLoad', ['$parse', function ($parse) {
            return {
                restrict: 'A',
                link: function (scope, elem, attrs) {
                    var fn = $parse(attrs.imgOnLoad);
                    elem.on('load', function (event) {
                        elem.parent().css({height: event.target.height});
                        scope.$apply(function() {
                            fn(scope, { $event: event });
                        });
                    });
                }
            };
        }])
        .controller('ReviewdetailController', ReviewdetailController);

    /* @ngInject */
    function ReviewdetailController($state, $stateParams, commonLayout, getReviewRsv, Restangular, $translate) {

        if(!$stateParams.rid) $state.go('common.default.review-list');

        commonLayout.updateLayoutFromType('try/detail');

        var vm = this;
        var imgCount = 0;
        vm.reviews = null;

        var path = 'reviews';

        vm.api = Restangular.all('');
        vm.tailList = [];
        vm.param = {
            'offset' : 0,
            'limit' : 3,
            'target' : 'all',
            'type': 'hot',
            'locale': $translate.use()
        };
        vm.imgAllLoadedFlag = false;
        vm.yesnoPopup = false;
        vm.moreItems = moreItems;
        vm.targetSelect = targetSelect;
        vm.typeSelect = typeSelect;
        vm.imgLoaded = function (evt) {
            console.log(evt.target.width,evt.target.height);
            vm.reviews.images[evt.data.index].height = evt.target.height;
            imgCount++;
            if(imgCount == vm.reviews.images.length) imgAllLoaded();
        };

        // vm.api = Restangular.all('campaigns/'+ $stateParams.id + '/');

        function imgAllLoaded() {
            var images = vm.reviews.images;
            images.push(angular.copy(images[0]));
            images[images.length-1].brandInfo = 'info-container';
            vm.slickImages = images;
        }

        vm.init = (init)();

        //////////////////////
        function init() {
      //      vm.slickHeight = $(window).height()-180 + 'px';
            if(getReviewRsv.status.code === '0000') {
                vm.reviews = getReviewRsv.result.review;
                vm.reviews.ascore = ((vm.reviews.designScore + vm.reviews.priceScore + vm.reviews.etc1Score + vm.reviews.etc2Score)/4).toFixed(1);
                vm.reviews.yesno = 'YES';
                for(var i=0; i<vm.reviews.images.length; i++) {
                    vm.reviews.images[i].element = angular.element('<img/>');
                    vm.reviews.images[i].element.on('load', {index: i}, vm.imgLoaded);
                    vm.reviews.images[i].element.attr({src: vm.reviews.images[i].modName, width: 750});

                }
            }
            vm.moreItems({init:true});
        }

        vm.nowTime = new Date().getTime() / 1000;

        function moreItems(param) {
            vm.api.customGET(path, vm.param).then(function (response) {
                if(response.status.code === '0000') {
                    vm.tailList = response.result.reviews;
                }
            });
        };
        // function moreItems(param) {
        //     if(param && param.init === true) { vm.tailList = []; }
        //     $(window).unbind('scroll');
        //     vm.api.customGET(path, vm.param).then(function (response) {
        //
        //         if(response.status.code === '0000') {
        //             var res = response.result.reviews;
        //
        //             // 테스트를 위해 결과값 변경
        //             for(var key in res) {
        //                 res[key].yesno = 'YES';
        //             }
        //             //res[0].content = '긴 텍스트를 테스트하고 있습니다. 이 제품을 쓰니 너무 좋아요.';
        //             // end
        //
        //             vm.tailList = $.merge( vm.tailList, res );
        //             if(response.result.reviews.length === vm.param.limit) {
        //                 $timeout(function() {
        //                     $(window).bind("scroll", function() {
        //                         if($(window).scrollTop() + $(window).height() === $(document).height()) {
        //                             vm.param.offset = vm.param.offset + vm.param.limit;
        //                             vm.moreItems();
        //                         }
        //                     });
        //                 });
        //             }
        //         }
        //     });
        // }

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