(function() {
    'use strict';

    angular
        .module('app.pages.service')
        .controller('CertController', CertController);

    /* @ngInject */
    function CertController($rootScope, $http, commonLayout, $translate, commonSettings) {
        commonLayout.updateLayoutFromType('popup');
        var vm = this;
        vm.state = false;

        vm.countryCode = {};
        vm.selectedCountryCode = '';

        $http.get('https://restcountries.eu/rest/v1/all')
            .then(function (res) {
                if(res.status == 200) {
                    console.log(res);
                    var result = res.data;
                    result = result.filter(function (v) {
                        return v.callingCodes[0];
                    });
                    vm.countryCode = result;

                    var lang = $translate.use();
                    var selected = result.filter(function (v) {
                        return ~v.languages.indexOf(lang);
                    });

                    vm.selectedCountryCode = selected[0].callingCodes[0];
                }

                //console.log(vm.countryCode);
            });

        vm.countryCodeChanged = function () {
            console.log(vm.selectedCountryCode);
        };

        vm.countDownCallback = function () {
            swal('인증시간이 만료됬습니다.', '다시시도해주세요', 'error');
        };

        vm.formReset = function () {
            vm.state = false;
        };


        vm.sendPhoneNumber = function () {
            vm.state = true;
        };
    }
})();
