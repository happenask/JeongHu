(function() {
    'use strict';

    angular
        .module('app')
        .config(translateConfig)
        .config(ngFabFormProvider)
        .config(locationProvider)
        .config(restangularProvider)

        // .factory('restangularUrlTest', restangularUrlTest)
        .run(run);

    /* @ngInject */
    function translateConfig(commonSettingsProvider, commonRouteProvider, APP_LANGUAGES) {
        var now = new Date();
        // set app name & logo (used in loader, sidemenu, footer, login pages, etc)
        commonSettingsProvider.setName('common');
        commonSettingsProvider.setCopyright('&copy;' + now.getFullYear() + ' 08liter.com');
        commonSettingsProvider.setLogo('assets/images/logo.png');
        // set current version of app (shown in footer)
        commonSettingsProvider.setVersion('2.5.1');
        // set the document title that appears on the browser tab
        commonRouteProvider.setTitle('08liter');
        commonRouteProvider.setSeparator('|');

        // setup available languages in triangular
        for (var lang = APP_LANGUAGES.length - 1; lang >= 0; lang--) {
            commonSettingsProvider.addLanguage({
                name: APP_LANGUAGES[lang].name,
                key: APP_LANGUAGES[lang].key
            });
        }
    }

    function ngFabFormProvider(ngFabFormProvider) {
        ngFabFormProvider.extendConfig({
            validationsTemplate: 'app/common/default-validation-msgs.html',
            // prevent submission of invalid forms
            preventInvalidSubmit: true,

// prevent double clicks
            preventDoubleSubmit: true,

// double click delay duration
            preventDoubleSubmitTimeoutLength: 1000,

// show validation-messages on failed submit
            setFormDirtyOnSubmit: true,

// autofocus first error-element
            scrollToAndFocusFirstErrorOnSubmit: true,

// set in ms
            scrollAnimationTime: 500,

// fixed offset for scroll to element
            scrollOffset: -100

        });
    }

    /* @ngInject */
    function locationProvider($locationProvider, $httpProvider) {
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: true
        }).hashPrefix('!');
        $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';

    }

    /* @ngInject */
    function restangularProvider(RestangularProvider, API_CONFIG) {

        RestangularProvider.setBaseUrl(API_CONFIG.host);
        RestangularProvider.addResponseInterceptor(function(data, operation, what, url, response, deferred) {
            var extractedData;
            if (operation === "getList") {
                extractedData = [];
                extractedData['status'] = data.status;
                extractedData['result'] = data.result;
            } else {
                extractedData = data;
            }
            return extractedData;
        });

        var token = "";
        // if($cookieStore.get('authdata')) {
        //     token = $cookieStore.get('authdata');
        // }
        RestangularProvider.setDefaultHeaders(
            {
                "Content-Type": "application/json"
            }
        );
        //RestangularProvider.setRequestSuffix('.json');
        //RestangularProvider.setExtraFields(['name']);
        //RestangularProvider.setResponseExtractor(function(response, operation) {
        //    return response.data;
        //});
        //
        //RestangularProvider.addElementTransformer('accounts', false, function(element) {
        //    element.accountName = 'Changed';
        //    return element;
        //});
        //
        //RestangularProvider.setDefaultHttpFields({cache: true});
        //RestangularProvider.setMethodOverriders(["put", "patch"]);
        //
        //// In this case we are mapping the id of each element to the _id field.
        //// We also change the Restangular route.
        //// The default value for parentResource remains the same.
        //RestangularProvider.setRestangularFields({
        //    id: "_id",
        //    route: "restangularRoute",
        //    selfLink: "self.href"
        //});
        //
        //RestangularProvider.setRequestSuffix('.json');
        //
        //// Use Request interceptor
        //RestangularProvider.setRequestInterceptor(function(element, operation, route, url) {
        //    delete element.name;
        //    return element;
        //});
        //
        //// ..or use the full request interceptor, setRequestInterceptor's more powerful brother!
        //RestangularProvider.setFullRequestInterceptor(function(element, operation, route, url, headers, params, httpConfig) {
        //    delete element.name;
        //    return {
        //        element: element,
        //        params: _.extend(params, {single: true}),
        //        headers: headers,
        //        httpConfig: httpConfig
        //    };
        //});

    }

    /* @ngInject */
    function run($rootScope, $location, $cookieStore, Restangular, leftSideMenu, $anchorScroll, Authentication, Base64) {
        if($cookieStore.get('authdata')) {
            var authdata = Base64.decode($cookieStore.get('authdata'));
            if ($cookieStore.get('globals') && $cookieStore.get('globals').currentUser) {
                // 변경예정: authdata + user + locale + version 0503 Leo
                Restangular.setDefaultHeaders({"Content-Type": "application/json", "X-08liter-Token": authdata + $cookieStore.get('globals').currentUser.id});
            }
        }
        else {
            $rootScope.globals = {
                sign : false
            }
        }

        

        if($cookieStore.get('globals') && $cookieStore.get('authdata')) {
            var passwdUpdateApi = Restangular.all('certs/token/verify');
            passwdUpdateApi.post({token:Base64.decode($cookieStore.get('authdata')), memberId: $cookieStore.get('globals').currentUser.id}).then(function(response) {
                if(response.status.code === '0000') {
                    Authentication.setCredentials(response.result.member);
                }
                else {
                    Authentication.clearCredentials('reload');
                    $location.path('/try');
                }
            });
        }
        else {
            $rootScope.globals = {
                sign : false
            }
        }

        //페이지 이동시마다 체크
        $rootScope.$on('$locationChangeStart', function (event, next, current) {
            
            // redirect to login page if not logged in and trying to access a restricted page
            $anchorScroll();
            var restrictedPage = $.inArray($location.path(), ['/', '/signin', '/signup', '/try', '/try/detail', '/help', '/help/howtouse', '/help/faq', '/help/certificationInfo']) === -1;
            if(!$rootScope.globals) {
                $rootScope.globals = $cookieStore.get('globals');
            }
            for(var i = 0; i < leftSideMenu.menu.length; i++) {
                if(leftSideMenu.menu[i].href === $location.path()) {
                    leftSideMenu.menu[i].active = 'active';
                }
                else {
                    leftSideMenu.menu[i].active = null;
                }
            }

            //todo 로그인패스 처리
            if (restrictedPage && !$rootScope.globals.currentUser) {
                swal("로그인이 필요합니다.");
                $location.path('/signin');
            }
            else {
                if($rootScope.globals) {
                    if($rootScope.globals.currentUser) {
                        if(!$rootScope.globals.currentUser.newMsgCount || $rootScope.globals.currentUser.newMsgCount === 0) {
                            Restangular.one('members/'+ $rootScope.globals.currentUser.id + '/messages/count').get().then(function(response) {
                                $rootScope.globals.currentUser.newMsgCount = response.result.count;
                            });
                        }
                    }
                }

            }
        });
    }

    // function restangularUrlTest(Restangular) {
    //     return Restangular.withConfig(function(RestangularConfigurer) {
    //         RestangularConfigurer.setBaseUrl('http://leon.oodada.com/api/index.php/');
    //     });
    // }

})();