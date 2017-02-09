import ceylon.language.meta {
    classDeclaration
}

shared abstract class Player(shared Color color)
        of blue | cyan | green | magenta | red | yellow {
    shared actual String string => classDeclaration(this).name;
}

object blue extends Player(Color(0, 0, 255)) {}
object cyan extends Player(Color(0, 255, 255)) {}
object green extends Player(Color(0, 255, 0)) {}
object magenta extends Player(Color(255, 0, 255)) {}
object red extends Player(Color(255, 0, 0)) {}
object yellow extends Player(Color(255, 255, 0)) {}
