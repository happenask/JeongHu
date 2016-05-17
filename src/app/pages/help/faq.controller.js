(function() {
    'use strict';

    angular
        .module('app.pages.help')
        .controller('FaqController', FaqController);

    /* @ngInject */
    function FaqController($rootScope, commonLayout, $translate, commonSettings) {

        commonLayout.updateLayoutFromType();
        var vm = this;

            
        vm.changeTab = function(e,id){

           $('.faq-tab-content').addClass('hide');
            var target = id;
            $(target).removeClass('hide');

            $('.faq-category-filter a').removeClass('active');
            $(e.target).addClass('active');




            var faqNum = $('#faqNum').val();

            $('#collapse' + faqNum).addClass('in');

        };

        vm.il18n = '/app/pages/help/faq-con-' + $translate.use() + '.tmpl.html';
        $rootScope.$on('changeLanguage', function(){
            vm.il18n = '/app/pages/help/faq-con-' + $translate.use() + '.tmpl.html';
        })

    }
})();
