'use strict';

var soccerApp = angular.module('soccerApp', ['ngRoute', 'ui.bootstrap'])
    .config(function($routeProvider, $locationProvider){
            $routeProvider.when('/',{
                templateUrl: '/main/views/menu.html'
            }).when('/pool/:id',{
                templateUrl: '/main/views/pool.html'
            }).when('/results',{
                templateUrl: '/main/views/results.html',
                controller: 'resultController',
            });          
    }).run(function($rootScope){
            $rootScope.username;
            $rootScope.role;
            $rootScope.user_id;
            $rootScope.email;  
            $rootScope.teams;
    })
    .controller('mainController', ['$scope', '$rootScope', '$location', '$http', '$window', function($scope, $rootScope, $location, $http, $window){

        $http.get('/pools').success(function(data){
            $scope.pools = data;
        });

         $http.get('/teams').success(function(data){
            $rootScope.teams = data;
        });

        $scope.isOpen = function(){
            var flag = false;
            $scope.pools.forEach(function(pool){
                if (pool.pool_status === 1) 
                    flag = true;
            });
            return flag;
        }

        $scope.newPool = function(){
            if (!$scope.isOpen()){
                $http({
                    method: 'POST',
                    url: '/new/pool',
                }).then(function(res){
                    $window.location.reload();
                }).catch(function(err){
                    console.log(err);
                    $window.alert('Pool could not be created');
                });
            } else {
                $window.alert('There is currently an open pool!');
            }
        }

        $scope.getPool = function(pool){
            $location.path('/pool/' + pool.id);
        };

        $scope.logout = function(){
            $http.delete('/users/login').success(function(data){
            });
            $scope.goBack();
        };

        $scope.goBack = function(){
            $window.location.href = '/';
            $window.location.reload();
        };

        $http({
            method: 'GET',
            url: '/current_user',
        }).then(function(res){
            $rootScope.username = res.data.username;
            $rootScope.role = res.data.role;
            $rootScope.user_id = res.data.user_id;
            $rootScope.email = res.data.email;
        }).catch(function(err){
            console.log(err);
        });

    }]);