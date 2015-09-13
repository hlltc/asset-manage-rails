/*global angular*/

//= require angular
//= require ng-admin
//= require ng-file-upload

(function () {
    var app = angular.module('myApp', ['ng-admin']);

    app.config(['NgAdminConfigurationProvider', 'RestangularProvider', function (NgAdminConfigurationProvider, RestangularProvider) {
        var nga = NgAdminConfigurationProvider;

        function truncate(value) {
            if (!value) {
                return '';
            }
            return value.length > 40 ? value.substr(0, 40) + '...' : value;
        };

        // use the custom query parameters function to format the API request correctly
        RestangularProvider.addFullRequestInterceptor(function(element, operation, what, url, headers, params) {
            if(params._filters && typeof params._filters == 'object'){
                var keys = [];
                for(var key in params._filters){
                    if(params._filters.hasOwnProperty(key) && key.indexOf('_id')>0){
                        params[key] = params._filters[key];
                        keys.push(key);
                    }
                }
                for(var key in keys){
                    delete params._filters.key;
                }
            }
            return { params: params };
        });

        RestangularProvider.addResponseInterceptor(function(data, operation, what, url, response, deferred) {
            if (operation === "getList") {
                var headers = response.headers();
                if (headers['content-range']) {
                    response.totalCount = headers['content-range'].split('/').pop();
                }
            }

            return data;
        });

        var admin = nga.application('Asset management') // application main title
            .debug(false) // debug disabled
            .baseApiUrl('/v1/'); // main API endpoint

        var asset = nga.entity('asset');
        var variant = nga.entity('variant');
        admin.addEntity(asset);
        admin.addEntity(variant);

        asset.listView()
            .title('List all assets')
            .fields([
                nga.field('id'),
                nga.field('title').map(truncate),
                nga.field('description').map(truncate),
                nga.field('created_at', 'date')
                    .label('Created At')
            ])
            .listActions(['show', 'edit', 'delete']);
        asset.creationView()
            .fields([
                nga.field('title') // the default edit field type is "string", and displays as a text input
                    .attributes({ placeholder: 'the asset title' }) // you can add custom attributes, too
                    .validation({ required: true, minlength: 3, maxlength: 100 }), // add validation rules for fields
                nga.field('description', 'text') // text field type translates to a textarea
            ]);
        asset.showView() // a showView displays one entry in full page - allows to display more data than in a a list
            .fields([
                nga.field('title'),
                nga.field('description'),
                nga.field('created_at')
                    .label('Created At'),
                nga.field('variant', 'referenced_list') // display list of related comments
                    .targetEntity(nga.entity('variant'))
                    .targetReferenceField('asset_id')
                    .targetFields([
                        nga.field('id').isDetailLink(true),
                        nga.field('device'),
                        nga.field('size'),
                        nga.field('language'),
                        nga.field('file_name')
                    ])
                    .sortField('created_at')
                    .sortDir('DESC')
            ]);
        asset.editionView()
            .title('Edit asset #{{ entry.values.id }}') // title() accepts a template string, which has access to the entry
            .actions(['list', 'show', 'delete']) // choose which buttons appear in the top action bar. Show is disabled by default
            .fields([
                asset.creationView().fields() // fields() without arguments returns the list of fields. That way you can reuse fields from another view to avoid repetition
            ]);

        variant.listView()
            .title('List all asset variants')
            .fields([
                nga.field('id'),
                nga.field('device'),
                nga.field('size'),
                nga.field('language'),
                nga.field('asset_id', 'reference')
                    .label('Asset')
                    .targetEntity(asset)
                    .targetField(nga.field('title').map(truncate))
                    .cssClasses('hidden-xs'),
                nga.field('created_at', 'date')
                    .label('Created At')
            ])
            .listActions(['show', 'edit', 'delete']);
        variant.creationView()
            .fields([
                nga.field('device', 'choice') // a choice field is rendered as a dropdown in the edition view
                    .choices([ // List the choice as object literals
                        { label: 'all', value: 'all' },
                        { label: 'Android', value: 'Android' },
                        { label: 'iPad', value: 'iPad' },
                        { label: 'iPhone', value: 'iPhone' }
                    ])
                    .validation({ required: true }),
                nga.field('size', 'choice') // a choice field is rendered as a dropdown in the edition view
                    .choices([ // List the choice as object literals
                        { label: 'all', value: 'all' },
                        { label: '320x480', value: '320x480' },
                        { label: '320x568', value: '320x568' },
                        { label: '375x667', value: '375x667' },
                        { label: '414x736', value: '414x736' },
                        { label: '768x1024', value: '768x1024' }
                    ])
                    .validation({ required: true }),
                nga.field('language', 'choice') // a choice field is rendered as a dropdown in the edition view
                    .choices([ // List the choice as object literals
                        { label: 'all', value: 'all' },
                        { label: 'en', value: 'en' },
                        { label: 'zh', value: 'zh' },
                        { label: 'de', value: 'de' },
                        { label: 'fr', value: 'fr' },
                        { label: 'it', value: 'it' }
                    ])
                    .validation({ required: true }),
                nga.field('asset_id', 'reference')
                    .label('Asset')
                    .targetEntity(asset)
                    .targetField(nga.field('title'))
                    .sortField('title')
                    .sortDir('ASC')
                    .validation({ required: true })
                    .remoteComplete(true, {
                        refreshDelay: 200,
                        searchQuery: function(search) { return { q: search }; }
                    })
            ]);
        variant.showView()
            .fields([
                nga.field('device'),
                nga.field('size'),
                nga.field('language'),
                nga.field('asset_id', 'reference')
                    .label('Asset')
                    .targetEntity(asset)
                    .targetField(nga.field('title'))
                    .cssClasses('hidden-xs'),
                nga.field('version'),
                nga.field('file_name'),
                nga.field('file_size'),
                nga.field('content_type'),
                nga.field('url', 'template').label('File link').template('<a href={{entry.values.url}} target="_blank">{{entry.values.url}}</a>'),
                nga.field('created_at')
                    .label('Created At')
            ]);
        variant.editionView()
            .title('Edit variant #{{ entry.values.id }}') // title() accepts a template string, which has access to the entry
            .actions(['list', 'show', 'delete']) // choose which buttons appear in the top action bar. Show is disabled by default
            .fields([
                variant.creationView().fields(),
                nga.field('attach', 'template').label('Attach file').template('<attach-file entry="entry"></attach-file>')     
            ]);

        nga.configure(admin);
    }]);

    var uploadTemplate = '<div class="btn btn-success btn-s" ngf-select="upload($file)">Select file to upload</div>';
    app.directive('attachFile', ['Upload', 'notification', function (Upload, notification) {
        return {
            scope: { entry: '&' },
            template: uploadTemplate,
            link: function ($scope) {
                // upload on file select or drop
                $scope.upload = function (file) {
                    if(file && $scope.entry().values.id){
                        Upload.upload({
                            url: '/v1/variant/'+$scope.entry().values.id,
                            method: 'PUT',
                            file: {'variant[attach]': file}
                        }).success(function (data, status, headers, config) {
                            notification.log('File upload succeeded: ' + file.name, {addnCls: 'humane-flatty-success'});
                        }).error(function (data, status, headers, config) {
                            notification.log('File upload failed: ' + file.name, {addnCls: 'humane-flatty-error'});
                        });
                    }
                };
            }
        };
    }]);
}());