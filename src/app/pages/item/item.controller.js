// (function() {
//     'use strict';
//
//     angular
//         .module('app.pages.item')
//         .controller('ReviewlistController', ReviewlistController);
//
//     /* @ngInject */
//     function ReviewlistController($scope, $timeout, commonLayout, Restangular, $translate, angularGridInstance, dataThrough) {
//         //console.log(dataThrough.vars);
//         commonLayout.updateLayoutFromType();
//         var vm = this;
//         vm.api = Restangular.all('');
//         vm.reviews = [];
//         vm.param = {
//             'offset' : 0,
//             'limit' : 9,
//             'target' : 'all',
//             'type': 'hot',
//             'locale': $translate.use()
//         };
//         vm.moreItems = moreItems;
//         vm.targetSelect = targetSelect;
//         vm.typeSelect = typeSelect;
//
//         // $scope.refresh = function(){
//         //     angularGridInstance.gallery.refresh();
//         // };
//
//         vm.nowTime = new Date().getTime() / 1000;
//         vm.init = (init)();
//         /////////////////////
//         function init() {
//             vm.moreItems({init:true});
//         }
//
//
//         function moreItems(param) {
//             if(param && param.init === true) { vm.reviews = []; }
//             $(window).unbind('scroll');
//             vm.api.customGET('reviews', vm.param).then(function (response) {
//
//                 if(response.status.code === '0000') {
//                     var res = response.result.reviews;
//
//                     // 테스트를 위해 결과값 변경
//                     for(var key in res) {
//                         res[key].yesno = 'YES';
//                     }
//                     //res[0].content = '긴 텍스트를 테스트하고 있습니다. 이 제품을 쓰니 너무 좋아요.';
//                     // end
//
//                     vm.reviews = $.merge( vm.reviews, response.result.reviews );
//                     if(response.result.reviews.length === vm.param.limit) {
//                         $timeout(function() {
//                             $(window).bind("scroll", function() {
//                                 if($(window).scrollTop() + $(window).height() === $(document).height()) {
//                                     vm.param.offset = vm.param.offset + vm.param.limit;
//                                     vm.moreItems();
//                                 }
//                             });
//                         });
//                     }
//                 }
//             });
//         }
//
//         function targetSelect(target) {
//             vm.param = {
//                 'offset' : 0,
//                 'limit' : 9,
//                 'target' : target
//             };
//             vm.moreItems({init:true});
//             $('.categoryFilter li a').removeClass('active');
//             $('.categoryFilter li[target=' + target +'] a').addClass('active');
//         }
//
//         function typeSelect() {
//             $timeout(function() {
//                 vm.moreItems({init:true});
//             });
//         }
//
//     }
// })();
