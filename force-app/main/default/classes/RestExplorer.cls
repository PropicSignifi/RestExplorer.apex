public class RestExplorer {

    public RestExplorer() {}

    public RestExplorer(String endpoint) {
        setService(endpoint);
    }

    public RestExplorer setEndpoint(String endpoint) {
        this.endpoint = endpoint;
        return this;
    }

    public RestExplorer setService(String service) {
        this.endpoint = '/services/data/v48.0/' + service.removeStart('/');
        return this;
    }

    public RestExplorer doGet() {
        this.method = 'GET';
        return this;
    }

    public RestExplorer doPost() {
        this.method = 'POST';
        return this;
    }

    public RestExplorer doPut() {
        this.method = 'PUT';
        return this;
    }

    public RestExplorer doPatch() {
        // https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_update_fields.htm
        this.method = 'POST';
        addParameter('_HttpMethod', 'PATCH');
        return this;
    }

    public RestExplorer doDelete() {
        this.method = 'DELETE';
        return this;
    }

    public static void setSessionId(String id) {
        sessionId = id;
    }

    public RestExplorer addParameter(String key, Object value) {
        this.parameters.put(key, value);
        return this;
    }

    public RestExplorer addParameters(Map<String, Object> parameters) {
        this.parameters.putAll(parameters);
        return this;
    }

    public RestExplorer setBody(String body) {
        this.body = body;
        return this;
    }

    public RestExplorer setBody(Object body) {
        this.body = JSON.serialize(body);
        return this;
    }

    public HttpRequest getRequest() {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' +
            (sessionId != null ? sessionId : getSessionID()));
        req.setHeader('Content-Type', 'application/json');
        req.setMethod(method);
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +
            endpoint + encodeParameters());
        if (body != null) req.setBody(body);

        return req;
    }

    public HttpResponse getResponse() {
        return new Http().send(getRequest());
    }

    public String getResult() {
        return getResponse().getBody();
    }

    public Object getJsonResult() {
        return JSON.deserializeUntyped(getResult());
    }

    public static MockResponse mock(String body) {
        return new MockResponse(body);
    }

    private String endpoint;
    private Map<String, Object> parameters = new Map<String, Object>();
    private String method = 'GET';
    private String body;

    private static String sessionId;

    private String encodeParameters() {
        if (this.parameters.isEmpty())
            return '';

        String result = '?';

        for (String key : this.parameters.keySet()) {
            result += EncodingUtil.urlEncode(key, 'UTF-8') + '=' +
                EncodingUtil.urlEncode(String.valueOf(this.parameters.get(key)), 'UTF-8') + '&';
        }

        return result.removeEnd('&');
    }

    private static String getSessionId() {
        return Page.SessionIdPage.getContent().toString().replace('\n', '');
    }

    public class MockResponse implements HttpCalloutMock {
        public MockResponse(String body) {
            this.body = body;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(body);

            return res;
        }

        private String body;
    }
}
