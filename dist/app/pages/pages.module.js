(function() {
    'use strict';

    angular
        .module('app.pages', [
            'app.pages.try', 'app.pages.review', 'app.pages.item', 'app.pages.mypage', 'app.pages.help', 'app.pages.service'
        ])
        .service('imagesLoaded', imagesLoaded);

    function imagesLoaded () {
        var images = [];
        var loadCount = 0;
        var loadLimit = 0;
        var opt = {};

        var callbackHandler;

        function init () {
            images = [];
            loadCount = 0;
            loadLimit = 0;
            opt = {};
            callbackHandler = null;
        }

        function imgLoaded () {
            loadCount++;
            if(loadCount == loadLimit) imgAllLoaded();
        }
        function imgAllLoaded () {
            if(opt) {
                var last = angular.extend({}, images[0], opt);
                images.push(last)
            }
            callbackHandler(images);
        }
        return {
            init: function (arr, lastOptions, callback) {
                init();
                callbackHandler = callback;
                opt = lastOptions;
                images = angular.copy(arr);
                loadLimit = images.length;
                for(var i=0; i<loadLimit; i++) {
                    images[i].element = angular.element('<img/>');
                    images[i].element.on('load', {index: i}, imgLoaded);
                    //CDN 업로드 여부 체크 0511 현재 API 변동 가능성 Written By Leo
                    images[i].serviceName = images[i][images[i].cdnUploaded == 'Y'? 'modName':'orgName'];
                    images[i].element.attr({src: images[i].serviceName});
                }
            }
        }
    }

})();
