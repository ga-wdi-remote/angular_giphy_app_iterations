function HomeController($scope, $http) {
  var self = this;
  var server = 'http://localhost:3000'

  $scope.$on('userLoggedIn', function(event, data){
    self.currentUser = data;
  });

  $scope.$on('userLoggedOut', function(event, data) {
    self.currentUser = null;
  });
}
