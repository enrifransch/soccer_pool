'use strict';

var myApp = angular.module('soccerLogin', []);

myApp.controller('loginController', ['$scope', '$http', '$window', function($scope, $http, $window){

    $scope.signUpF = false;
	$scope.loginF = true;

    $scope.username = '';
    $scope.password = '';

    $scope.signUp = function(){
        $scope.signUpF = true;
        $scope.loginF = false;
    }

    $scope.login = function(){
        $scope.loginF = true;
        $scope.signUpF = false;
    }

    $scope.attemptLogin = function(username, password){
        var User = {
            username: username,
            password: password
        };

        $http({
            method: 'POST',
            url: 'users/login',
            data: User
        }).then(function(res){
            $window.location.href = '/';
        }).catch(function(err){
            console.log(err);
            $window.alert('User does not exist or password is wrong');
        });
    }

    $scope.attemptSignUp = function(username, email, password, emailConfirm, passwordConfirm){
        //console.log(username, password, email, emailConfirm, passwordConfirm);
        if(password!==passwordConfirm){
            $window.alert('Passwords do not match')
            return;
        }
        if(email!==emailConfirm){
            $window.alert('Emails do not match or are incorrect');
            return;
        }

        var User = {
            username: username,
            email: email,
            password: password,
        };

        $http({
            method: 'POST',
            url: 'new/user',
            data: User
        }).then(function(res){
            $window.alert('User created succesfully');
            $scope.login();
        }).catch(function(err){
            if(err.status===500){
                $window.alert('User created succesfully');
                $scope.login();
            } else {
                console.log(err);
                $window.alert('User already exists');
            }                
        });
    }
}]);