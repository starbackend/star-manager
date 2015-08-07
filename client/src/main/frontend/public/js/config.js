require.config({
  shim: {
    "jquery.contextMenu": {
      deps: [
        "jquery"
      ]
    },
    "jquery.ui.position": {
      deps: [
        "jquery"
      ]
    },
    angular: {
      deps: [
        "jquery"
      ],
      exports: "angular"
    },
    bootstrap: {
      deps: [
        "jquery"
      ]
    },
    "bootstrap-submenu": {
      deps: [
        "bootstrap"
      ]
    },
    "angular-resource": {
      deps: [
        "angular"
      ]
    },
    "angular-smart-table": {
      deps: [
        "angular"
      ]
    },
    "schema-form": {
      deps: [
        "angular"
      ]
    },
    "bootstrap-decorator": {
      deps: [
        "angular",
        "schema-form"
      ]
    },
    "angular-animate": {
      deps: [
        "angular"
      ]
    },
    "angular-busy": {
      deps: [
        "angular-animate"
      ]
    },
    "angular-notify": {
      deps: [
        "angular"
      ]
    },
    "angular-bootstrap": {
      deps: [
        "angular"
      ]
    },
    "angular-ui-ace": {
      deps: [
        "angular",
        "ace"
      ]
    },
    ngcompile: {
      deps: [
        "angular"
      ]
    }
  },
  paths: {
    angular: "../libs/angular/angular",
    wcDocker: "../libs/wcDocker/Build/wcDocker",
    "font-awesome": "../libs/font-awesome/fonts/*",
    "jquery.contextMenu": "../libs/jQuery-contextMenu/src/jquery.contextMenu",
    "jquery.ui.position": "../libs/jQuery-contextMenu/src/jquery.ui.position",
    jquery: "../libs/jquery/dist/jquery",
    "schema-form": "../libs/angular-schema-form/dist/schema-form",
    "bootstrap-decorator": "../libs/angular-schema-form/dist/bootstrap-decorator",
    requirejs: "../libs/requirejs/require",
    "angular-sanitize": "../libs/angular-sanitize/angular-sanitize",
    objectpath: "../libs/objectpath/lib/ObjectPath",
    tv4: "../libs/tv4/tv4",
    "angular-bootstrap-scrolling-tabs": "../libs/angular-bootstrap-scrolling-tabs/scrolling-tabs",
    bootstrap: "../libs/bootstrap/dist/js/bootstrap",
    "angular-smart-table": "../libs/angular-smart-table/dist/smart-table",
    "angular-bootstrap": "../libs/angular-bootstrap/ui-bootstrap-tpls",
    "bootstrap-submenu": "../libs/bootstrap-submenu/dist/js/bootstrap-submenu",
    "angular-resource": "../libs/angular-resource/angular-resource",
    "angular-animate": "../libs/angular-animate/angular-animate",
    "angular-busy": "../libs/angular-busy/dist/angular-busy",
    "angular-notify": "../libs/angular-notify/dist/angular-notify",
    ngcompile: "../libs/ngcompile/directives/ngcompile",
    ace: "../libs/ace-builds/src-min-noconflict/ace",
    "angular-ui-ace": "../libs/angular-ui-ace/ui-ace"
  },
  packages: [

  ]
});
