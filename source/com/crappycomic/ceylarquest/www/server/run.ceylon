import ceylon.http.common {
    get
}
import ceylon.http.server {
    AsynchronousEndpoint,
    Request,
    endsWith,
    newServer
}
import ceylon.http.server.endpoints {
    RepositoryEndpoint,
    serveStaticFile
}

"Run the module `com.acme.server`."
shared void run() {
    value modulesEp = RepositoryEndpoint("/modules");
    
    function mapper(Request req)
            => req.path == "/" then "/index.html" else req.path;
    
    value resourceEp = AsynchronousEndpoint(
        endsWith(".png"),
        serveStaticFile("resource", mapper),
        { get }
    );
    
    value staticEp = AsynchronousEndpoint(
        endsWith(".html"),
        serveStaticFile("www", mapper),
        { get }
    );
    
    value server = newServer { modulesEp, resourceEp, staticEp };
    
    server.start();
}
