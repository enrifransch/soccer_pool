angular.module('soccerApp')
    .controller('poolController', ['$scope', '$rootScope', '$http', '$routeParams', '$location', '$window', '$uibModal',
    function($scope, $rootScope, $http, $routeParams, $location, $window, $uibModal){

        $http.get('/pool/'+$routeParams.id).success(function(data){
            $scope.pool = data;
        });

        $http.get('/pool_matches/'+$routeParams.id).success(function(data){
            $scope.pool_matches = data;
        });

        $http.get('/user_matches/'+$routeParams.id).success(function(data){
            if (data==undefined) $scope.user_matches = [];
            else $scope.user_matches = data;
        });

        $scope.editing = false;

        $scope.updateTable = function(data){                       
            $http({
                method: 'PUT',
                url: '/update_score',
                data: data
            }).then(function(res){
                $window.location.reload();
            }).catch(function(err){
                console.log(err);
                    $window.alert('Could not update scores');
            });
        }

        $scope.updatePredictions = function(data){
            $http({
                method: 'PUT',
                url: '/update_prediction',
                data: data
            }).then(function(res){
                $window.location.reload();
            }).catch(function(err){
                console.log(err);
                    $window.alert('Could not update user prediciton');
            });
        }

        $scope.setPick = function(data){
            $scope.editing = !$scope.editing;
        }

        $scope.setScore = function(){
            $scope.editing = !$scope.editing;
        }

        $scope.getUserMatch = function(id){
            if($scope.user_matches===undefined){ return null; }
            var res = null;
            try{
                $scope.user_matches.forEach(function(match){
                    if(match.match_id === id){
                        res = match.prediction;
                    }
                });
            } catch (err){

            }
            return res;
        }

        $scope.getPick = function(pool_match, prediction){
            if (prediction === null){
                return '-';
            }
            if (prediction === 0){
                return 'TIE';
            }
            else if (prediction === 1){
                return pool_match.home;
            } else {
                return pool_match.away;
            }
        }

        $scope.getWinner = function(pool_match){
            if(pool_match.away_score === null || pool_match.home_score === null){
                $scope.matchesUndone = true;
                return '-';
            }
            else if(pool_match.away_score > pool_match.home_score){
                return pool_match.away;
            }
            else if (pool_match.away_score < pool_match.home_score){
                return pool_match.home;
            } else {
                return 'TIE';
            }
        }

        $scope.closePool = function(){
            $http({
                method: 'PUT',
                url: '/close_pool/'+ +$routeParams.id
            }).then(function(res){
                $window.location.href = '/';
            }).catch(function(err){
                console.log(err);
                    $window.alert('Could not close pool');
            });
        }

        $scope.addMatch = function(){
            var dialogInst = $uibModal.open({
                    templateUrl: 'main/modals/matchModal.html',
                    controller: 'teamModalController',
                    size: 'lg',
                    resolve: {
                        selectedTeam: function(){
                            return $scope.form;
                        }
                    }
                });

                dialogInst.result.then(function(res){
                    var Match = {
                        poolId: $scope.pool.id,
                        homeId: res.homeId, 
                        homeScore: res.homeScore, 
                        awayId: res.awayId, 
                        awayScore: res.awayScore
                    };
    
                    $http({
                        method: 'POST',
                        url: '/new_match',
                        data: Match
                    }).then(function(res){
                        $window.location.reload();
                    }).catch(function(err){
                        console.log(err);
                         $window.alert('Could not create match');
                    });
                });
            }
        
    }])
    .controller('teamModalController', function($scope, $uibModalInstance, selectedTeam,$rootScope){

        $scope.form = selectedTeam;

        $scope.submitMatch = function(){
            $uibModalInstance.close($scope.form);
        }

        $scope.cancel = function(){
            $uibModalInstance.dismiss('cancel');
        }
    });