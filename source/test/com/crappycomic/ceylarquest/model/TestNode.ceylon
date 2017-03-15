import com.crappycomic.ceylarquest.model {
    Node
}

"A class that can be used in an `object` declaration to create [[Node]] instances for performing
 unit testing."
shared class TestNode() satisfies Node {
    location = [0, 0];
    
    name => id;
}
