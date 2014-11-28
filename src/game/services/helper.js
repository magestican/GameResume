angular.module('Services')
  .service('Helper', ['$q', '$rootScope', '$location', 'CompanyFactory', 'StaffFactory', 'CredentialsFactory', 'InsuranceFactory', function ($q, $rootScope, $location, CompanyFactory, StaffFactory, CredentialsFactory, InsuranceFactory) {

      this.setCompanyInfo = function (appId, secureCode) {
          var deferred = $q.defer();

          // Load company information
          var companyInfo;
          companyInfo = CompanyFactory.getCompanyInfo(appId, secureCode);
          companyInfo.then(function (response) {
              $rootScope.global.company = response;
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.setStaffInfo = function(appId, secureCode) {
          var deferred = $q.defer();

          // Load staff information
          var staffInfo;
          staffInfo = StaffFactory.getStaffInfo(appId, secureCode);
          staffInfo.then(function (response) {
              $rootScope.global.staffs = response;
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.setCredentialsInfo = function(appId, secureCode) {
          var deferred = $q.defer();

          // Load staff information
          var credentialsInfo;
          credentialsInfo = CredentialsFactory.getCredentialsInfo(appId, secureCode);
          credentialsInfo.then(function (response) {
              $rootScope.global.credentials = response;
              
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.setInsuranceInfo = function(appId, secureCode) {
          var deferred = $q.defer();

          // Load staff information
          var insuranceInfo;
          insuranceInfo = InsuranceFactory.getInsuranceInfo(appId, secureCode);
          insuranceInfo.then(function (response) {
              $rootScope.global.insurance = response;
              deferred.resolve();
          });

          return deferred.promise;
      }

      this.goToLocation = function(page, appId, secureCode) {
          $location.path('/' + page + '/' + appId + '/' + secureCode);
      }

      this.getLocation = function() {
        return $location.path().split('/')[1];
      }

      this.resetPropertiesOf = function (objectToReset) {
          for (var property in objectToReset) {
              if (objectToReset.hasOwnProperty(property)) {
                  if (typeof (property) == 'null')
                      objectToReset[property] = {};
                  if (typeof (property) == 'boolean')
                      objectToReset[property] = false;
                  if (typeof (property) == 'number')
                      objectToReset[property] = 0;
                  if (typeof (property) == 'string')
                      objectToReset[property] = "";
              }
          }
      }

      this.clone = function (obj) {
          if (null == obj || "object" != typeof obj) return obj;
          var copy = obj.constructor();
          for (var attr in obj) {
              if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
          }
          return copy;
      }


  }]);
