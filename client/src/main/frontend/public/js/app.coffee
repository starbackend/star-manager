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
    "angular-bootstrap-file-field"
    "ng-file-upload"
    "angular-flex-splitter"
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
      'bootstrap.fileField'
      'ngFileUpload'
      'splitter'
    ]
      .directive 'emptyToNull', ()->
        restrict: 'A'
        require: 'ngModel'
        link: (scope, elem, attrs, ctrl)->
          ctrl.$parsers.push (viewValue) -> if viewValue == "" then null else viewValue
      .directive 'clickAndDisable', ()->
        return {}=
          scope:
            clickAndDisable: '&'
          link: (scope, iElement, iAttrs) ->
            iElement.bind 'click', ->
              iElement.prop 'disabled', true
              scope.clickAndDisable().finally ->
                iElement.prop 'disabled', false
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
          warning: (msg) ->
            notify
              message: msg
              classes: 'alert-warning'
              duration: 3000
          success: (msg) ->
            notify
              message: msg
              classes: 'alert-success'
              duration: 3000
          error: (error) ->
            notify 
              message: error?.data?.message or error?.message or error
              classes: 'alert-danger'
              duration: 3000
        
      .controller "MainCtrl", ($scope, $resource) ->
        $scope.tabs = []
        $scope.environments = $resource('/api/environments').query()
        
        tabId = 0
        
        tabHead = null
        
        $scope.selectedTab = null
        
        $scope.setTabHead = (tab) ->
          if tab?
            unlinkTab tab
            tab.$prev = tabHead
            tab.$next = null
            if tabHead?
              tabHead.$next = tab
            tabHead = tab
            
        $scope.addTab = addTab = (tab) ->
          tab.id = tabId++
          $scope.tabs.push tab
          $scope.setTabHead tab
          $scope.selectedTab = tab
          
        $scope.addImdateProjects = (env) ->
          tab = 
            title: -> "IMDatE Projects - #{ tab.data.environment }"
            templateUrl: 'partials/imdateProjects.html'
            data:
              environment: env
              
          addTab tab
        
        $scope.addImdateProjectsOvr = (env) ->
          tab =  
            title: -> "IMDatE Projects OVR - #{ tab.data.environment }"
            templateUrl: 'partials/imdateProjectsOvr.html'
            data:
              environment: env
          addTab tab
              
        $scope.addImdateOvr = (env) ->
          tab = 
            title: -> "IMDatE OVR - #{ tab.data.environment }"
            templateUrl: 'partials/imdateOvr.html'
            data:
              environment: env
          addTab tab
        
        unlinkTab = (tab) ->
          if tab.$next? then tab.$next.$prev = tab.$prev
          if tab.$prev? then tab.$prev.$next = tab.$next
            
        $scope.closeTab = (tab) ->
          unlinkTab tab
          $scope.tabs.splice $scope.tabs.indexOf(tab), 1
          if tab == tabHead
            tabHead = tabHead.$prev
            $scope.selectedTab = tabHead
          
            
            
          
          
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
                
                
      .controller 'ImdateProjectsOvrCtrl', ($scope, $resource, myNotify, Upload) ->
        Projects = null
        ProjectsOvr = null
        
        $scope.refreshProjects = ->
          $scope.projects = Projects.query()
          
        $scope.refreshProjectsOvr = ->
          $scope.projectsOvr = if $scope.project? then ProjectsOvr.get() else {}
          
        $scope.refreshUploads = ->
          $scope.uploads = $resource('/api/projectsOvr/uploads').query()
          
        $scope.refreshUploads()
          
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
            
            $scope.format = null
           
            if $scope.project  
              for format in $scope.formats
                if $scope.project.name in format.projects
                  $scope.format = format
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
            
        $scope.formats = $resource('/api/projectsOvr/formats').query()
        
        $scope.doUpload = ->
          $scope.upload = Upload.upload
            url: '/api/projectsOvr/uploads'
            method: 'POST'
            fields:
              format: $scope.format.name
              parameters: '{}' # TODO
            file: $scope.uploadFile
            fileFormDataName: 'data'
          
          $scope.upload.then (response) ->
            data = response.data
            if data.errorCount == 0
              myNotify.success data.fileName + ' uploaded with no errors.'
            else
              myNotify.success data.fileName + ' uploaded with some errors.'
              
            $scope.refreshUploads()
          
        $scope.sendCdf = (upload) ->
          send = $resource('/api/projectsOvr/uploads/:uploadId', {uploadId: upload.id}).save {environment: $scope.tab.data.environment}, '',
            (->
              myNotify.success 'Upload number ' + upload.id + ' sent successfully.'
              $scope.refreshProjectsOvr()
            ), 
            ((error)->
              myNotify.danger error?.data?.message or error?.message or error
            )
            
          return send.$promise
          
        $scope.deleteUpload = (upload) ->
          $resource('/api/projectsOvr/uploads/:uploadId', {uploadId: upload.id}).delete {},
            (->
              myNotify.success 'Upload number ' + upload.id + ' deleted successfully.'
              $scope.refreshUploads()
            ), 
            ((error)->
              myNotify.danger error?.data?.message or error?.message or error
            )
            
        $scope.viewUpload = (upload) ->
          tab =
            title: -> "IMDatE Project Ovr Upload no. #{ tab.data.id }"
            templateUrl: 'partials/imdateProjectsOvrUpload.html'
            data: upload
            
          $scope.addTab tab
            
            
          
          
        return
            
      .controller 'ImdateProjectsOvrUploadCtrl', ($scope, $http, myNotify, $resource) ->
        
        $scope.sourceOptions = 
          mode: if $scope.tab.data.fileFormat == 'csv' then 'text' else $scope.tab.data.fileFormat
          onLoad: (ace) ->
            ace.setReadOnly true
            ace.$blockScrolling = Infinity
            $scope.showLine = (error) ->
              ace.gotoLine error.lineNumber
              
        
        $scope.sourcePromise = $http.get '/api/projectsOvr/uploads/source', {params:{uploadId: $scope.tab.data.id}}
          .then ((response)->
              $scope.source = response.data
            ),
            myNotify.error
            
        $scope.errors = $resource('/api/projectsOvr/uploads/:uploadId/errors', {uploadId: $scope.tab.data.id}).query()  
          
              
          
        
            
          
        
              
              
          
        
        
            
          
          
          
              
    angular.element(document).ready ->
      angular.bootstrap document, ['star.manager']
      $('.dropdown-submenu > a').submenupicker()
      
    
      
      #panel1 = myDocker.addPanel 'Panel1', wcDocker.DOCK.LEFT
      #
      #myDocker.addPanel 'Panel2', wcDocker.DOCK.BOTTOM, panel1
      #
      #myDocker.addPanel 'Panel3', wcDocker.DOCK.RIGHT, null, {w:200,h:200}
      
      
      
      
        
        


