import ceylon.http.common {
    get
}
import ceylon.http.server {
    newServer,
    startsWith,
    AsynchronousEndpoint,
    Request
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
    
    value staticEp = AsynchronousEndpoint(
        startsWith("/"),
        serveStaticFile("www", mapper),
        { get }
    );
    
    value server = newServer { modulesEp, staticEp };
    
    server.start();
}
