'use strict';

/**
 * @ngdoc function
 * @name Jason
 * @module common
 * @kind function
 *
 * @description
 *
 * Handles the admin view
 */
(function() {
    'use strict';

    angular
        .module('common.layouts')
        .controller('DefaultLayoutController', DefaultLayoutController);

    /* @ngInject */
    function DefaultLayoutController($scope, $element, $timeout, $window, commonLayout, MOBILE) {

        // we need to use the scope here because otherwise the expression in md-is-locked-open doesnt work
        commonLayout.layout.mobile = MOBILE[commonLayout.layout.mobileDevice];
        $scope.layout = commonLayout.layout; //eslint-disable-line

        function goToUri(uri, href) {
            var start, end, elapsed;

            // start a timer
            start = new Date().getTime();

            // attempt to redirect to the uri:scheme
            // the lovely thing about javascript is that it's single threadded.
            // if this WORKS, it'll stutter for a split second, causing the timer to be off
            document.location = uri;

            // end timer
            end = new Date().getTime();

            elapsed = (end - start);

            // if there's no elapsed time, then the scheme didn't fire, and we head to the url.
            if (elapsed < 1) {
                document.location = href;
            }
        }

        $scope.launchApp = function (evt) {
            var target = evt.target;
            goToUri($(target).data('scheme'), $(target).attr('href'));
            evt.preventDefault();
        }
        

        //vm.activateHover = activateHover;
        //vm.removeHover  = removeHover;
        //
        //////////////////
        //
        //function activateHover() {
        //    if(commonLayout.layout.sideMenuSize === 'icon') {
        //        $element.find('.admin-sidebar-left').addClass('hover');
        //        $timeout(function(){
        //            $window.dispatchEvent(new Event('resize'));
        //        },300);
        //    }
        //}
        //
        //function removeHover () {
        //    if(commonLayout.layout.sideMenuSize === 'icon') {
        //        $element.find('.admin-sidebar-left').removeClass('hover');
        //        $timeout(function(){
        //            $window.dispatchEvent(new Event('resize'));
        //        },300);
        //    }
        //}
    }
})();