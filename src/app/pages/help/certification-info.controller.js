(function() {
    'use strict';

    angular
        .module('app.pages.help')
        .controller('CertificationInfoController', CertificationInfoController);

    /* @ngInject */
    function CertificationInfoController(commonLayout,$timeout) {
        commonLayout.updateLayoutFromType();
        var vm = this;

     //   $timeout(function() {

            angular.element(document).ready(function () {
                var slider = $('.story-container .slides');

                slider.bxSlider({
                    controls:true,
                    pager: false,
                    startSlide: 1,
                    infiniteLoop: false,
                    autoHover: true,
                    adaptiveHeight: false,
                    onSlideAfter: function($slideElement, oldIndex, newIndex) {
                        $('span.page').text(slider.getCurrentSlide() + 1 + '/' + slider.getSlideCount());
                    }
                });
            });

    //    });



    }
})();
