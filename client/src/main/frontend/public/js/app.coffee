require ["config"], ->
    
  requirejs [
    "angular"
    "angular-resource"
    "angular-bootstrap"
    "bootstrap"
    "bootstrap-submenu"
    "angular-smart-table"
    "schema-form"
    "bootstrap-decorator"
    "angular-busy"
    "angular-notify"
    "ngcompile"
    "angular-ui-ace"
  ], ->
    
    angular.module 'star.manager', [
      'ngResource'
      'ui.bootstrap'
      'smart-table'
      'schemaForm'
      'cgBusy'
      'cgNotify'
      'compile'
      'ui.ace'
    ]
      .directive 'emptyToNull', ()->
        restrict: 'A'
        require: 'ngModel'
        link: (scope, elem, attrs, ctrl)->
          ctrl.$parsers.push (viewValue) -> if viewValue == "" then null else viewValue
      .factory 'myNotify', (notify) ->
        notify.config
          duration: 3000
          position: 'right'
        return {}=
          danger: (msg) ->
            notify 
              message: msg
              classes: 'alert-danger'
              duration: 3000
          success: (msg) ->
            notify
              message: msg
              classes: 'alert-success'
              duration: 3000
        
      .controller "MainCtrl", ($scope, $resource) ->
        $scope.tabs = []
        $scope.environments = $resource('/api/environments').query()
        
        tabId = 0
        
        visibleTab = null
        
        addTab = (tab) ->
          tab.id = tabId++
          $scope.tabs.push tab
          $scope.showTab(tab)
          
        $scope.addImdateProjects = (env) ->
          addTab 
            title: 'IMDatE Projects - {{tab.data.environment}}'
            templateUrl: 'partials/imdateProjects.html'
            data:
              environment: env
        
        $scope.addImdateProjectsOvr = (env) ->
          addTab 
            title: 'IMDatE Projects OVR - {{tab.data.environment}}'
            templateUrl: 'partials/imdateProjectsOvr.html'
            data:
              environment: env
              
        $scope.addImdateOvr = (env) ->
          addTab 
            title: 'IMDatE OVR - {{tab.data.environment}}'
            templateUrl: 'partials/imdateOvr.html'
            data:
              environment: env
        
        $scope.closeTab = (tab) ->
          $scope.tabs.splice $scope.tabs.indexOf(tab), 1
          
        $scope.showTab = (tab) ->
          visibleTab.visible = false if visibleTab?
          tab.visible = true
          visibleTab = tab
          
      .controller 'ImdateOvrCtrl', ($scope, $resource, $http, myNotify) ->
        
        Ovr = null
        
        $scope.refreshOvr = ->
          $scope.searchOvr.submitted = angular.copy $scope.searchOvr.model
          $scope.ovr = Ovr.query($scope.searchOvr.submitted)
          
        $scope.xml =
          data: ''
        $scope.refreshXml = ->
          $scope.xml = 
            $promise: $http.get '/api/xml/ovr', { params: $scope.searchOvr.model }
          
          $scope.xml.$promise.then (response) -> $scope.xml.data = response.data
          
        $scope.sendXml = ->
          Ovr.save {}, $scope.xml.data, 
            ((response)->
              myNotify.success 'OVR update sent successfully.'
              $scope.refreshOvr()
            ),
            ((error)->
              console.log error
              myNotify.danger 'Error sending OVR update. ' + error?.data?.message or error?.message or error
            )
          
        $scope.$watch ((scope)->scope.tab.data.environment), 
          ((env) -> 
            Ovr = $resource('/api/env/:env/ovr', {env: env})
            $scope.refreshOvr()
          )
          
        $scope.searchOvr =
          model: {}
        
      .controller 'ImdateProjectsCtrl', ($scope, $resource, myNotify) ->
        Projects = null
        
        $scope.refreshProjects = ->
          $scope.projects = Projects.query()
          
        $scope.$watch ((scope)->scope.tab.data.environment), 
          ((env) -> 
            Projects = $resource('/api/env/:env/projects', {env: env})
            $scope.refreshProjects()
          )
          
        $scope.createProject =
          schema:
            type: 'object'
            properties:
              name:
                type: 'string'
                title: 'Project Name'
              description:
                type: 'string'
                title: 'Description'
          form: [
            '*'
            {
              type: 'submit'
              title: 'Create Project'
            }
          ]
          model: {}
          submit: (form) ->
            $scope.$broadcast 'schemaFormValidate'
            if form.$valid
              projectName = $scope.createProject.model.name
              Projects.save $scope.createProject.model, 
                ((response)->
                  myNotify.success 'Project ' + projectName + ' created.'
                  $scope.refreshProjects()
                ), 
                ((error)->
                  console.log error
                  myNotify.danger error?.data?.message or error?.message or error
                )
                
                
      .controller 'ImdateProjectsOvrCtrl', ($scope, $resource, myNotify) ->
        Projects = null
        ProjectsOvr = null
        
        $scope.refreshProjects = ->
          $scope.projects = Projects.query()
          
        $scope.refreshProjectsOvr = ->
          $scope.projectsOvr = if $scope.project? then ProjectsOvr.get() else {}
          
        $scope.$watch ((scope)->scope.tab.data.environment), 
          ((env) -> 
            Projects = $resource('/api/env/:env/projects', {env: env})
            $scope.refreshProjects()
            $scope.project = null
          )
          
        $scope.$watch ((scope)->scope.project), 
          ((project) -> 
            ProjectsOvr = $resource('/api/env/:env/projects/:projectName/projectsOvr', {env: $scope.tab.data.environment, projectName: project?.name})
            $scope.refreshProjectsOvr()
          )
          
        $scope.deleteProjectsOvr = ->
          ProjectsOvr.delete {}, 
            ((success)->
              myNotify.success 'Project specific OVR records for ' + $scope.project.name + ' deleted.'  
              $scope.refreshProjectsOvr()
            ),
            ((error)->
              myNotify.danger error?.data?.message or error?.message or error
            )
              
          
        
        
            
          
          
          
              
    angular.element(document).ready ->
      angular.bootstrap document, ['star.manager']
      $('.dropdown-submenu > a').submenupicker()
      
    
      
      #panel1 = myDocker.addPanel 'Panel1', wcDocker.DOCK.LEFT
      #
      #myDocker.addPanel 'Panel2', wcDocker.DOCK.BOTTOM, panel1
      #
      #myDocker.addPanel 'Panel3', wcDocker.DOCK.RIGHT, null, {w:200,h:200}
      
      
      
      
        
        


