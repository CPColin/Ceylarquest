import com.crappycomic.ceylarquest.model {
    Player
}
import ceylon.language.meta.declaration {
    OpenClassType
}

"Provides a value that tests can pass when constructing objects like [[testGame]]."
shared [<Player -> String>+] testPlayerNames {
    value testPlayers = [
        for (caseType in `class Player`.caseTypes.narrow<OpenClassType>())
            if (exists objectValue = caseType.declaration.objectValue)
                let (player = objectValue.apply<Player>().get())
                player -> player.string
    ];
    
    assert (nonempty testPlayers);
    
    return testPlayers;
}
