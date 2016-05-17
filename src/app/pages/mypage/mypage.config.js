(function() {
    'use strict';

    angular
        .module('app.pages.mypage')
        .config(moduleConfig);

    /* @ngInject */
    function moduleConfig($routeProvider, $translatePartialLoaderProvider, $stateProvider, leftSideMenuProvider) {

        $translatePartialLoaderProvider.addPart('app/pages/mypage');

        $stateProvider
            //.state('common.default.user', {
            //    url: '/user',
            //    templateUrl: 'app/pages/mypage/signin/signin.tmpl.html',
            //    controller: 'UserController'
            //})
            .state('common.leftSideMenu.profile', {
                url: '/mypage/profile',
                templateUrl: 'app/pages/mypage/profile/profile.tmpl.html',
                controller: 'ProfileController',
                controllerAs: 'vm'
            })
            .state('common.leftSideMenu.message', {
                url: '/mypage/message',
                templateUrl: 'app/pages/mypage/message/message.tmpl.html',
                controller: 'MessageController',
                controllerAs: 'vm'
            })
            .state('fullBackground.noFooter.signup', {
                url: '/signup',
                templateUrl: 'app/pages/mypage/signup/signup.tmpl.html',
                controller: 'SignUpController',
                controllerAs: 'vm'
            })
            .state('fullBackground.noFooter.signin', {
                url: '/signin',
                templateUrl: 'app/pages/mypage/signin/signin.tmpl.html',
                controller: 'SignInController',
                controllerAs: 'vm'
            })
            .state('common.leftSideMenu.mytry', {
                url: '/mypage/mytry',
                templateUrl: 'app/pages/mypage/mytry/mytry.tmpl.html',
                controller: 'MytryController',
                controllerAs: 'vm'
            })
            .state('common.leftSideMenu.like', {
                url: '/mypage/like',
                templateUrl: 'app/pages/mypage/like/like.tmpl.html',
                controller: 'LikeController',
                controllerAs: 'vm'
            })
            .state('common.leftSideMenu.mysns', {
                url: '/mypage/mysns',
                templateUrl: 'app/pages/mypage/mysns/mysns.tmpl.html',
                controller: 'MysnsController',
                controllerAs: 'vm'
            })
            .state('common.default.snsMgmt', {
                url: '/user/snsMgmt',
                templateUrl: 'app/pages/mypage/signup/snsMgmt.tmpl.html',
                controller: 'snsMgmtController',
                controllerAs: 'vm'
            });

        leftSideMenuProvider.setMenu([{
            name: 'MENU.MYPAGE.MYTRY',
            icon: 'fa-list',
            priority: 3.0,
            href: '/mypage/mytry'
        },{
            name: 'MENU.MYPAGE.LIKE',
            icon: 'fa-heart',
            href: '/mypage/like'
        },{
            name: 'MENU.MYPAGE.MYSNS',
            icon: 'fa-share-alt-square',
            href: '/mypage/mysns'
        },{
            name: 'MENU.MYPAGE.PROFILE',
            icon: 'fa-user',
            href: '/mypage/profile'
        },{
            name: 'MENU.MYPAGE.MESSAGE',
            icon: 'fa-bell',
            href: '/mypage/message'
        }]);
    }
})();