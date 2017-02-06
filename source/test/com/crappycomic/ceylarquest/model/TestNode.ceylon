import com.crappycomic.ceylarquest.model {
    Node
}

"A class that can be used in an `object` declaration to create [[Node]] instances for performing
 unit testing."
shared class TestNode(
        "This manual specification of the name will not be necessary if/when objects declared within
         functions pick up `objectDeclaration` attributes.
         
         See: [ceylon/2081](https://github.com/ceylon/ceylon/issues/2081)"
        shared actual String name) satisfies Node {
    id = name;
    
    location = [0, 0];
}
