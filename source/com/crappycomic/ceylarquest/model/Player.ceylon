import ceylon.language.meta {
    classDeclaration
}
shared abstract class Player(shared Color color)
        of blue | cyan | green | magenta | red | yellow {
    shared actual String string {
        // This value is null when run in a browser.
        // See: https://github.com/ceylon/ceylon/issues/6881
        value objectValue = classDeclaration(this).objectValue;
        
        assert (exists objectValue);
        
        return objectValue.name;
    }
}

object blue extends Player(Color(0, 0, 255)) {}
object cyan extends Player(Color(0, 255, 255)) {}
object green extends Player(Color(0, 255, 0)) {}
object magenta extends Player(Color(255, 0, 255)) {}
object red extends Player(Color(255, 0, 0)) {}
object yellow extends Player(Color(255, 255, 0)) {}

shared {<Player -> String>+} testPlayers = {
    blue -> "Blue",
    cyan -> "Cyan",
    green -> "Green",
    magenta -> "Magenta",
    red -> "Red",
    yellow -> "Yellow"
};