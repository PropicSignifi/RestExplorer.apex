# RestExplorer

An APEX implementation of the REST Explorer

## Features

- Allows user to call REST API to its own org, in APEX code
- No OAuth is needed
- Resolves the session Id problem in lightning context

## Examples

Get a description of all available objects in Tooling API:

```javascript
String result = new RestExplorer('/tooling/sobjects').getResult();
```

Create a new Tooling API object:

```javascript
String result = new RestExplorer('/tooling/sobjects/MetadataContainer/')
    .doPost()
    .setBody(new Map<String, Object>{'Name' => 'TestContainer'})
    .getResult();
```

Run a query on Tooling API:

```javascript
String query = 'SELECT Id, Name From MetadataContainer WHERE Name = \'MyMeta\'';
String reusult = new RestExplorer('/tooling/query')
    .addParameter('q', query)
    .getResult();
```

Query all datasets in Wave API and convert the JSON result to a map:

```javascript
Map<String, Object> result =
    (Map<String, Object>)new RestExplorer('/wave/datasets/').getJsonResult();
```
