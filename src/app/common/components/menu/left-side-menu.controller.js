(function() {
    'use strict';

    angular
        .module('common.components')
        .controller('LeftSideMenuController', LeftSideMenuController);

    /* @ngInject */
    function LeftSideMenuController($scope, $rootScope, $location, Authentication, API_CONFIG, ALT_IMG, Upload) {
        var vm = this;
        vm.ALT_IMG = ALT_IMG;
        if($rootScope.globals) {
            $scope.currentUser = $rootScope.globals.currentUser;
            vm.updateProfilePic = function(file, errFiles) {
                swal({
                    title: "프로필 이미지 수정 중입니다!",
                    text: '<div class="progress progress-striped active"><div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div></div"',
                    html: true,
                    showConfirmButton: false
                });
                $scope.f = file;
                $scope.errFile = errFiles && errFiles[0];
                if (file) {
                    file.upload = Upload.upload({
                        url: API_CONFIG.host + 'members/' + $scope.currentUser.id +'/profile',
                        method: 'POST',
                        data: {file: file, width:100, height: 100}
                    });
                    file.upload.then(function (response) {
                        if(response.data.status.code === '0000') {
                            if(response.data.result.image.rootPath) {
                                response.data.result.image.modName = response.data.result.image.rootPath + response.data.result.image.modName;
                                console.log(response.data.result.image);
                            }
                            $scope.currentUser.profileImg = response.data.result.image.modName;
                            Authentication.updateCredentials($scope.currentUser);
                            swal.close();
                        }
                        else {
                            Authentication.clearCredentials('reload');
                            alert('로그인 정보가 없습니다.');
                            $location.path('/signin');
                        }

                    }, function (response) {
                        console.log('errorMsg');
                        if (response.status > 0)
                            $scope.errorMsg = response.status + ': ' + response.data;
                    }, function (evt) {
                        file.progress = Math.min(100, parseInt(100.0 *
                            evt.loaded / evt.total));
                    });
                }
            }
        }
    }
})();
