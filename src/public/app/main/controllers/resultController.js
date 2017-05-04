angular.module('soccerApp')
    .controller('resultController', ['$scope', '$rootScope', '$location', '$http', '$window', 
    function($scope, $rootScope, $location, $http, $window){

        $http.get('/pools').success(function(data){
            
            for(var i = data.length - 1; i >= 0; i--){
                if(data[i].pool_status === 1){
                    data.splice(i, 1);
                }
            }

            $scope.pools = data;            
        });

        $http.get('/users').success(function(data){
            
            for(var i = data.length - 1; i >= 0; i--){
                if(data[i].role === 1){
                    data.splice(i, 1);
                }
            }

            $scope.users = data;            
        });

    }]);