shared abstract class Player(shared Color color)
    of red | cyan | yellow | magenta | blue | green {}

object red extends Player(Color(255, 0, 0)) {}
object cyan extends Player(Color(0, 255, 255)) {}
object yellow extends Player(Color(255, 255, 0)) {}
object magenta extends Player(Color(255, 0, 255)) {}
object blue extends Player(Color(0, 0, 255)) {}
object green extends Player(Color(0, 255, 0)) {}

shared Map<Player, String> testPlayers = map {
    red -> "Red",
    cyan -> "Cyan",
    yellow -> "Yellow",
    magenta -> "Magenta",
    blue -> "Blue",
    green -> "Green"
};