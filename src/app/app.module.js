(function() {
    'use strict';

    angular
        .module('app', [
            'common',
            'ngRoute', 'ngAnimate', 'ngCookies', 'ngSanitize', 'ngResource',
            'ui.router', 'pasvaz.bindonce', 'restangular', 'pascalprecht.translate', 'LocalStorageModule', 'ngFabForm', 'timer', 'slick', 'angularGrid', 'ngFileUpload', 'ng-sweet-alert', 'switcher',
            'services', 
            //https://github.com/danialfarid/ng-file-upload
            // 'seed-module'
            // uncomment above to activate the example seed module
            'app.pages'
        ])
        // create a constant for languages so they can be added to both triangular & translate
        .constant('APP_LANGUAGES', [{
            name: 'LANGUAGES.CHINESE',
            key: 'zh'
        },{
            name: 'LANGUAGES.ENGLISH',
            key: 'en'
        },{
            name: 'LANGUAGES.KOREAN',
            key: 'ko'
        }])
        // set a constant for the API we are connecting to
        .constant('ALT_IMG', {
            'rootPath': '/assets/images/alt/',
            'profile':  '/assets/images/alt/img_no_profile_img.gif'
        })
        .constant('API_CONFIG', {
            //'host':  'http://192.168.0.84:8080/api/'
            'host' : 'http://ec2-54-199-177-211.ap-northeast-1.compute.amazonaws.com/api/'
        })
        .constant('MOBILE', {
            'ios': {
                'launch':'youtube://',
                'install': 'https://itunes.apple.com/kr/app/youtube/id544007664?mt=8#'
            },
            'android': {
                'launch': 'youtube://',
                'install': 'https://play.google.com/store/apps/details?id=com.google.android.youtube&hl=ko'
            }
        });
})();