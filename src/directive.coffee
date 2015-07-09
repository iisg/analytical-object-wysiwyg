analyticalObjectWysiwyg.directive('analyticalObjectWysiwyg',
  ['$timeout', 'TaggableObjectQuillFormat', ($timeout, TaggableObjectQuillFormat) ->
    scope:
      'toolbar': '@?',
      'readOnly': '@?',
      'ngModel': '='
    require: 'ngModel'
    restrict: 'E'
    templateUrl: 'templates/analyticalObjectWysiwygEditor.html'
    link: ($scope, element, attr, ngModel) ->
      TaggableObjectQuillFormat.register()
      config =
        theme: 'base'
        readOnly: $scope.readOnly || false

      editor = new Quill(element[0].querySelector('.editor-container'), config)
      $scope.$emit('quill.created', editor)

      if ($scope.toolbar && $scope.toolbar == 'true')
        editor.addModule('toolbar',
          container: element[0].querySelector('.toolbar-container')
          formats:
            tooltip:
              object: 'object'
        )

      # Set initial value of the editor
      isFresh = true
      $scope.$watch('ngModel', (text) ->
        editor.setHTML(text) if text? && isFresh
        isFresh = false
      )

      # Watch editor changes to update model accordingly
      editor.on('text-change', ->
        $scope.modelLength = editor.getLength()
        ngModel.$setViewValue(editor.getHTML())
      )

      # Clean up
      element.on('destroy', -> editor.destroy())

      # Emit event that Quill is ready
      $scope.$emit('quill.ready', editor)
])
