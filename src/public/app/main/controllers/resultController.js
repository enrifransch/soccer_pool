'use strict';

angular.module('soccerApp')
    .controller('resultController', ['$scope', '$rootScope', '$location', '$http', '$window', 
    function($scope, $rootScope, $location, $http, $window){

        $scope.user_results = [];
        $scope.match_score = [];
        $scope.tableValues = [];
        
        $http.get('/users').success(function(data){       
            for(var i = data.length - 1; i >= 0; i--){
                if(data[i].role === 1){
                    data.splice(i, 1);
                } else {
                    $scope.user_results.push({
                        user_id: data[i].id,
                        username: data[i].username,
                        score: 0
                    });
                }
            }
        }).then(
            $http.get('/pools').success(function(data){               
                for(var i = data.length - 1; i >= 0; i--){
                    if(data[i].pool_status === 1){
                        data.splice(i, 1);
                    } else {
                        $scope.match_score.push({
                            match: data[i].id,
                            users: JSON.parse(JSON.stringify($scope.user_results))
                        });
                    }
                }  
        })).then(
            $http.get('/results').success(function(data){        
                for(var i = 0; i < data.length; i++){
                    for(var j = 0; j < $scope.match_score.length; j++){
                        if(data[i].pool_id === $scope.match_score[j].match){
                            for(var k = 0; k < $scope.match_score[j].users.length; k++){
                                if(data[i].id === $scope.match_score[j].users[k].user_id){
                                    if(data[i].prediction===0 && (data[i].home_score===data[i].away_score)){
                                        $scope.match_score[j].users[k].score ++;
                                    }
                                    else if (data[i].prediction === 1 && (data[i].home_score > data[i].away_score)){
                                        $scope.match_score[j].users[k].score ++;
                                    }
                                    else if (data[i].prediction === 2 && (data[i].home_score < data[i].away_score)){
                                        $scope.match_score[j].users[k].score ++;
                                    } 
                                }
                            }
                        }
                    }
                }         
                formatList($scope.match_score.reverse());
        }));

        var formatList = function(arr){
            for(var i = 0; i < arr[0].users.length; i++){ 
                $scope.tableValues[i] = { 
                     username: arr[0].users[i].username,
                     scores: [],
                     total: 0
                 }
                 for (var j = 0; j < arr.length; j++){ 
                     $scope.tableValues[i].scores.push(arr[j].users[i].score);
                     $scope.tableValues[i].total += arr[j].users[i].score;
                 }
            }
        }

    }]);
