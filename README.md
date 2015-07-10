# Analytical Object WYSIWYG

## Installation

Just require the package using bower:

```
bower install iisg/analytical-object-wysiwyg --save
```

## Usage

*1st step*: Require the `AnalyticalObjectWysiwyg` in your main module.

*2nd step*: Set up object formatting during configuration phase:

    app.config((TaggableObjectQuillFormatProvider) ->
        TaggableObjectQuillFormatProvider.on('search', ->
            (text, context) ->
                id: 0
                label: text
        )
    )

You can use promises as well:

    app.config((TaggableObjectQuillFormatProvider) ->
        TaggableObjectQuillFormatProvider.on('search', ['$q', ($q) ->
            (text, context) ->
                promise = $q.defer()
                onMyEvent.then((object) ->
                    promise.resolve(object)
                return promise.promise
        ])
    )

*3rd step*: Add `<analytical-object-wysiwyg ng-model="document">` to your template.

*4th step*: Profit.

### Available events

You can add your own services for these events:

* `search` - fired when a object formatting button is clicked, should return a promise that resolves into the object (or the object itself) you want to add to the text
* `node.add` - fired when node is being added to the text, after DOM element creation, before adding to text, you can format the node according to values in the object (resolved in `search`)
* `node.remove` - fired when node is being removed from the document (i.e. when text being decorated is removed completely), you need to remove every attribute you have added to the node during `node.add` phase
* `node.value` - fired when node value is fetched (i.e. when you copy tagged text), needs to return a value for the tagged object that can be used to create new object from scratch

### Available directive options

* `ng-model` (REQUIRED) - your model to handle data
* `toolbar` - set to true to load toolbar
    * `<analytical-object-wysiwyg ng-model="document" toolbar="true">`
* `read-only` - set to true to force editor to be read-only
    * `<analytical-object-wysiwyg ng-model="document" read-only="true">`
* `context` - set the object that will be passed to event handlers
    * `<analytical-object-wysiwyg ng-model="document.content" context="document">`


## Templating

By default editor comes with predefined template. You can easily override it using `$provide` Angular service:

    app.config(['$provide', ($provide) ->
        $provide.decorator('analyticalObjectWysiwygDirective', ($delegate) ->
            $delegate[0].templateUrl = 'path/to/your/template.html'
            return $delegate
        )
    ])
