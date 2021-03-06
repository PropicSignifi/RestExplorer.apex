@isTest
public class RestExplorerTest {
    @isTest
    static void testPostRequest() {
        RestExplorer.setSessionId(UserInfo.getSessionId());
        HttpRequest req = new RestExplorer('/tooling/sobjects/MetadataContainer')
            .doPost()
            .setBody(new Map<String, Object>{'Name' => 'TestContainer'})
            .getRequest();

        System.assertEquals(req.getHeader('Authorization'), 'Bearer ' + UserInfo.getSessionId());
        System.assertEquals(req.getHeader('Content-Type'), 'application/json');
        System.assertEquals(req.getBody(), '{"Name":"TestContainer"}');
        System.assertEquals(req.getMethod(), 'POST');
        System.assertEquals(req.getEndpoint(),
            URL.getSalesforceBaseUrl().toExternalForm() +
            '/services/data/v48.0/tooling/sobjects/MetadataContainer');
    }

    @isTest
    static void testGetRequest() {
        RestExplorer.setSessionId(UserInfo.getSessionId());
        String query = 'SELECT Id,Name From MetadataContainer WHERE Name = \'MyMeta\'';
        HttpRequest req = new RestExplorer('/tooling/query')
            .doGet()
            .addParameter('q', query)
            .getRequest();

        System.assertEquals(req.getHeader('Authorization'), 'Bearer ' + UserInfo.getSessionId());
        System.assertEquals(req.getHeader('Content-Type'), 'application/json');
        System.assertEquals(req.getMethod(), 'GET');
        System.assertEquals(req.getEndpoint(),
            URL.getSalesforceBaseUrl().toExternalForm() +
            '/services/data/v48.0/tooling/query?' +
            'q=SELECT+Id%2CName+From+MetadataContainer+WHERE+Name+%3D+%27MyMeta%27');
    }
}
