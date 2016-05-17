(function() {
    'use strict';

    angular
        .module('app.pages.item')
        .controller('ItemdetailController', ItemdetailController);

    /* @ngInject */
    function ItemdetailController($scope, $compile, $stateParams, commonLayout, getItemRsv, getReviewRsv, Restangular, imagesLoaded) {
        commonLayout.updateLayoutFromType('try/detail');

        var vm = this;
        vm.campaign = null;
        vm.loadedImages;
        vm.surveyChart = {
            yes: {
                people: 85,
                gender: {
                    man: 85,
                    women: 15
                },
                age: [4,24,30,28,14]
            },
            no: {
                people: 15,
                gender: {
                    man: 55,
                    women: 45
                },
                age: [10,24,25,18,23]
            },
            rate: [2,4,12,10,3]
        };

        // vm.api = Restangular.all('campaigns/'+ $stateParams.id + '/');

        vm.init = (init)();

        //////////////////////
        function init() {
            vm.slickHeight = $(window).height()-102 + 'px';
            if(getItemRsv.status.code === '0000') {
                vm.campaign = getItemRsv.result.campaign;
                imagesLoaded.init(vm.campaign.images, {info: 'info-container'}, function (img) {
                    vm.loadedImages = img;
                });
            }

            if(getReviewRsv.status.code === '0000') {
                vm.reviews = getReviewRsv.result.reviews;
                //if(vm.reviews.length);
            }
        }

        vm.chartClick = function () {
            console.log('sss');
        }

        var width = 360, height = 220;

        var data = [ 2, 4, 12, 10, 3 ];
        

        var vMargin = 10;
        var vStep = (width-vMargin*2)/(data.length-1);

        var shape = [
            {x: width, y: data[data.length-1]},
            {x: width, y: 0},
            {x: 0, y: 0},
            {x: 0, y: data[0]}
        ];
        var chart = [];

        for(var i=0; i<data.length; i++) {
            var coord = { x: i*vStep+vMargin, y: data[i] };
            shape.push(coord);
            // coord.elem = $document.createElement('div');
            // coord.elem.className = 'graph-label';
            // coord.elem.appendChild()
            chart.push(coord);
        }

        var fnY = d3.scale.linear()
            .domain([0, d3.max(data)])
            .range([0, height-80]);

        var drawLine = d3.svg.line()
            .x(function(d) { return d.x; })
            .y(function(d) { return height-fnY(d.y); })
            .interpolate("linear");

        var svg = d3.select('#graph-wrap')
            .append('svg')
            .attr('oncontextmenu', 'return false;')
            .attr('width', width)
            .attr('height', height);

        svg.append('path')
            .attr('d', drawLine(shape))
            .attr('fill', '#ebebeb');

        d3.select('#graph-wrap')
            .selectAll('.graph-label')
                .data(chart)
            .enter()
                .append('div')
                .attr('class', 'graph-label')
                .attr('style', function (d) {
                    return 'top:'+(205-fnY(d.y))+'px;left:'+(d.x+4)+'px;';
                })
                .html(function (d) {
                    return '<div class="graph-label-value">'+d.y+'</div><div class="graph-label-button fa fa-check" ng-click="vm.chartClick()"></div>';
                });

        $compile(angular.element('#graph-wrap'))($scope);



        // var node = d3.select('#graph-wrap').selectAll('.graph-label').node();
        // console.log(node);
//graph-value-button fa fa-check

    }
})();