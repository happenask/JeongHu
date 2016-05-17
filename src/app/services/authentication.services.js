(function () {
    'use strict';

    angular
        .module('app')
        .factory('Authentication', Authentication)
        .service('Base64', Base64);

    function Authentication($http, $cookieStore, $rootScope, Restangular, Base64, $window, $location) {
        var service = {};

        service.signIn = Restangular.service('members/signin');
        service.signUp = Restangular.service('members/signup');
        service.setCredentials = setCredentials;
        service.updateCredentials = updateCredentials;
        service.clearCredentials = clearCredentials;
        return service;

        function setCredentials(member, reload) {
            var authdata = Base64.encode(member.memberCert.token);
            $rootScope.globals = {
                currentUser: {
                    id: member.id,
                    name: member.name,
                    email: member.email,
                    nickname: member.nickname,
                    profileImg: member.profileImg,
                    locale: member.locale,
                    username: member.email
                },
                sign: true
            };
            //$http.defaults.headers.common['Authorization'] = 'Basic ' + authdata; // jshint ignore:line
            $cookieStore.put('authdata', authdata);
            $cookieStore.put('globals', $rootScope.globals);
            if($cookieStore.get('authdata')) {
                var authdata = Base64.decode($cookieStore.get('authdata'));
                if ($rootScope.globals.currentUser) {
                    Restangular.setDefaultHeaders({"Content-Type": "application/json", "X-08liter-Token": authdata + $cookieStore.get('globals').currentUser.id});
                }
            }

            if(reload === 'reload') {
                $location.path('/try');
                $window.location.reload();
            }
        }

        function updateCredentials(member) {
            if(member.nickname) {
                $rootScope.globals.currentUser.nickname = member.nickname;
            }
            if(member.locale) {
                $rootScope.globals.currentUser.locale = member.locale;
            }
            if(member.profileImg) {
                $rootScope.globals.currentUser.profileImg = member.profileImg;
            }
            $cookieStore.put('globals', $rootScope.globals);
        }

        function clearCredentials(reload) {
            if($rootScope.globals && $rootScope.globals.currentUser) {
                Restangular.service('members/signout').post({"id" : $rootScope.globals.currentUser.id});
            }
            $rootScope.globals = {};
            $cookieStore.remove('globals');
            $http.defaults.headers.common.Authorization = 'Basic';
            if(reload === 'reload') {
                $location.path('/try');
                $window.location.reload();
            }
        }
    }

    // Base64 encoding service used by AuthenticationService
    function Base64() {
        var service = {
            keyStr: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=',

            encode: function (input) {
                var output = "";
                var chr1, chr2, chr3 = "";
                var enc1, enc2, enc3, enc4 = "";
                var i = 0;

                do {
                    chr1 = input.charCodeAt(i++);
                    chr2 = input.charCodeAt(i++);
                    chr3 = input.charCodeAt(i++);

                    enc1 = chr1 >> 2;
                    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                    enc4 = chr3 & 63;

                    if (isNaN(chr2)) {
                        enc3 = enc4 = 64;
                    } else if (isNaN(chr3)) {
                        enc4 = 64;
                    }

                    output = output +
                        this.keyStr.charAt(enc1) +
                        this.keyStr.charAt(enc2) +
                        this.keyStr.charAt(enc3) +
                        this.keyStr.charAt(enc4);
                    chr1 = chr2 = chr3 = "";
                    enc1 = enc2 = enc3 = enc4 = "";
                } while (i < input.length);

                return output;
            },

            decode: function (input) {
                var output = "";
                var chr1, chr2, chr3 = "";
                var enc1, enc2, enc3, enc4 = "";
                var i = 0;

                // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
                var base64test = /[^A-Za-z0-9\+\/\=]/g;
                if (base64test.exec(input)) {
                    window.alert("There were invalid base64 characters in the input text.\n" +
                        "Valid base64 characters are A-Z, a-z, 0-9, '+', '/',and '='\n" +
                        "Expect errors in decoding.");
                }
                input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

                do {
                    enc1 = this.keyStr.indexOf(input.charAt(i++));
                    enc2 = this.keyStr.indexOf(input.charAt(i++));
                    enc3 = this.keyStr.indexOf(input.charAt(i++));
                    enc4 = this.keyStr.indexOf(input.charAt(i++));

                    chr1 = (enc1 << 2) | (enc2 >> 4);
                    chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                    chr3 = ((enc3 & 3) << 6) | enc4;

                    output = output + String.fromCharCode(chr1);

                    if (enc3 != 64) {
                        output = output + String.fromCharCode(chr2);
                    }
                    if (enc4 != 64) {
                        output = output + String.fromCharCode(chr3);
                    }

                    chr1 = chr2 = chr3 = "";
                    enc1 = enc2 = enc3 = enc4 = "";

                } while (i < input.length);

                return output;
            }
        };
        return service;
    }

})();