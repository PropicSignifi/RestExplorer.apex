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
        this.method = 'PATCH';
        return this;
    }

    public RestExplorer doDelete() {
        this.method = 'DELETE';
        return this;
    }

    public RestExplorer setSessionId(String sessionId) {
        this.sessionId = sessionId;
        return this;
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

    private String endpoint;
    private Map<String, Object> parameters = new Map<String, Object>();
    private String method = 'GET';
    private String sessionId;
    private String body;

    private String encodeParameters() {
        if (this.parameters.isEmpty())
            return '';

        String result = '/?';

        for (String key : this.parameters.keySet()) {
            result += EncodingUtil.urlEncode(key, 'UTF-8') + '=' +
                EncodingUtil.urlEncode(String.valueOf(this.parameters.get(key)), 'UTF-8') + '&';
        }

        return result.removeEnd('&');
    }

    private static String getSessionId() {
        return Page.SessionIdPage.getContent().toString().replace('\n', '');
    }
}