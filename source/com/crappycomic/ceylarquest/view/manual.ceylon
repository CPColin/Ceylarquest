import ceylon.html {
    Body,
    Content,
    Doctype,
    FlowCategory,
    H1,
    H2,
    Head,
    Html,
    Li,
    P,
    Title,
    Ul,
    renderTemplate
}

import com.crappycomic.ceylarquest.model {
    Game,
    RollType
}

shared object manual {
    shared String render(Game game) {
        value stringBuilder = StringBuilder();
        
        renderTemplate(html(game), stringBuilder.append);
        
        return stringBuilder.string;
    }
    
    alias Children => {Content<FlowCategory>*};
    
    Children cards(Game game) {
        value rollType = game.rules.cardRollType;
        
        if (rollType == RollType.never) {
            return empty;
        }
        else {
            return {
                H2 { "``game.board.strings.card`` Cards" },
                P {
                    "When a player rolls ``rollType.description``, he or she does not move, but
                     instead draws a ``game.board.strings.card`` card and follows the directions
                     indicated."
                }
            };
        }
    }
    
    Html html(Game game) => Html {
        doctype = Doctype.html5;
        Head {
            Title { game.board.strings.game }
        },
        Body {
            children = intro(game)
                .chain(setup(game))
                .chain(cards(game))
                .chain(winning)
                .chain(losing(game));
        }
    };
    
    Children intro(Game game) => {
        H1 { game.board.strings.game },
        P {
            "``game.board.strings.game`` is a game of real estate market domination, this time not
             set in Atlantic City. Players compete with each other to travel around the board,
             buying and consolidating properties along the way."
        }
    };
    
    Children losing(Game game) => {
        H2 { "Losing the Game" },
        P { "Players can be eliminated from the game in the following ways:" },
        Ul {
            Li { "Declaring bankruptcy when faced with an insurmountable debt." },
            Li {
                "Becomining marooned at a location that costs ``game.board.strings.fuel.lowercased``
                 to leave by rolling the dice with fewer than ``game.rules.dieCount``
                 ``pluralize(game.board.strings.fuelUnit, game.rules.dieCount)`` of
                 ``game.board.strings.fuel.lowercased``."
            },
            if (game.rules.cardRollType == RollType.never)
            then null
            else Li {
                "Drawing a ``game.board.strings.card`` card that requires the use of more
                 ``game.board.strings.fuel.lowercased`` than the player currently has."
            }
        },
        P {
            "When declaring bankruptcy, everything the player owned becomes the property of the
             creditor or the attacker. When running out of ``game.board.strings.fuel.lowercased``,
             everything the player owned becomes the property of the
             ``game.board.strings.leagueShort``. All ``game.board.strings.fuelStation.lowercased``s
             that were placed on properties remain where they are."
        }
    };
    
    Children setup(Game game) => {
        H2 { "Setup" },
        P { "Each player starts on ``game.board.start.name`` with:" },
        Ul {
            Li { "``format(game.rules.initialCash)`` ``game.board.strings.cashUnit``" },
            Li { "``format(game.rules.maximumFuel)``
                  ``pluralize(game.board.strings.fuelUnit, game.rules.maximumFuel)`` of
                  ``game.board.strings.fuel.lowercased``" },
            Li { "``format(game.rules.initialFuelStationCount)``
                  ``pluralize(game.board.strings.fuelStation.lowercased,
                      game.rules.initialFuelStationCount)``" }
        },
        P {
            "The order in which the players play is randomized when the game starts. This game uses
             the equivalent of ``game.rules.dieCount`` dice with ``game.rules.diePips`` sides each."
        }
    };
    
    Children winning => {
        H2 { "Winning the Game" },
        P {
            "The last player standing is the winner. Alternately, players can agree on a time limit,
             in which case the player with the greatest net worth when time is up is the winner."
        }
    };
}
