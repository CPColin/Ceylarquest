import ceylon.html {
    Body,
    Caption,
    Content,
    Dd,
    Dl,
    Doctype,
    Dt,
    FlowCategory,
    H1,
    H2,
    Head,
    Html,
    Li,
    P,
    Style,
    Table,
    Td,
    Th,
    Title,
    Tr,
    Ul,
    renderTemplate
}

import com.crappycomic.ceylarquest.model {
    ActionTrigger,
    Administration,
    CostsFuelToLeave,
    FuelSalable,
    FuelStationable,
    Game,
    Ownable,
    RollType,
    Well
}

shared object manual {
    shared String render(Game game) {
        value stringBuilder = StringBuilder();
        
        renderTemplate(html(game), stringBuilder.append);
        
        return stringBuilder.string;
    }
    
    alias Children => {Content<FlowCategory>*};
    
    Children board(Game game) => {
        H2 { "The Board" },
        Dl {
            Dt { game.board.start.name },
            Dd { start(game) },
            *nodeTypeDescriptions(game)
        },
        nodeTypeChart(game)
    };
    
    Children cards(Game game) =>
        let (rollType = game.rules.cardRollType)
        if (rollType == RollType.never)
        then empty
        else {
            H2 { "``game.board.strings.card`` Cards" },
            P {
                "When a player rolls ``rollType.description``, he or she does not move, but instead
                 draws a ``game.board.strings.card`` card and follows the directions indicated."
            }
        };
    
    // TODO
    Children fuel(Game game) => empty;
    
    Html html(Game game) => Html {
        doctype = Doctype.html5;
        Head {
            Title { game.board.strings.game },
            style
        },
        Body {
            children = intro(game)
                .chain(setup(game))
                .chain(board(game))
                .chain(property(game))
                .chain(fuel(game))
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
             creditor. When running out of ``game.board.strings.fuel.lowercased``, everything the
             player owned becomes the property of the ``game.board.strings.leagueShort``. All
             ``game.board.strings.fuelStation.lowercased``s that were placed on properties remain
             where they are."
        }
    };
    
    Table nodeTypeChart(Game game) => Table {
        Caption { "Features of the Various Locations" },
        Tr {
            Th {},
            Th { "Can ``game.board.strings.landVerb``" },
            Th { "Costs ``game.board.strings.fuel`` To Leave" },
            Th { "Can Own" },
            Th { "Can ``game.board.strings.purchaseFuel``" },
            Th { "Can Sell Properties" },
            Th { "Can Buy and Sell ``game.board.strings.fuelStation``s"},
            Th { "Has Other Effects" }
        },
        {
            for ([type, name, _] in game.board.strings.nodeTypes)
                Tr {
                    Td { name },
                    Td { yesNo(!type.subtypeOf(`Well`)) },
                    Td { yesNo(type.subtypeOf(`CostsFuelToLeave`)) },
                    Td { yesNo(type.subtypeOf(`Ownable`)) },
                    Td {
                        type.subtypeOf(`FuelStationable`)
                        then "With ``game.board.strings.fuelStation``"
                        else yesNo(type.subtypeOf(`FuelSalable`))
                    },
                    Td { yesNo(type.subtypeOf(`Administration`)) },
                    Td { yesNo(type.subtypeOf(`Administration`)) },
                    Td { yesNo(type.subtypeOf(`ActionTrigger`)) }
                }
        }
    };
    
    {Dt|Dd*} nodeTypeDescriptions(Game game) => expand {
        for ([_, name, description] in game.board.strings.nodeTypes)
            [Dt { name }, Dd { description }]
    };
    
    Children property(Game game) => {
        H2 { "Property" },
        P {
            "Players may purchase some of the properties they
             ``game.board.strings.landOn.lowercased`` (see the \"Features\" chart above). Players
             that ``game.board.strings.landOn.lowercased`` an owned property must pay the owner for
             the privilege. The amount of money increases if the owner owns more properties in the
             same color group. It never costs anything for a player to
             ``game.board.strings.landOn.lowercased`` a property he or she owns or
             ``game.board.strings.landPreposition.lowercased`` a property that belongs to the
             ``game.board.strings.leagueShort``."
        },
        P {
            "Players may sell unwanted properties back to the ``game.board.strings.leagueShort`` at
             certain times (see the \"Features\" shart above). Players may sell properties to settle
             a debt owed to another player. The player receives the full price on the deed, plus
             $``game.rules.fuelStationPrice``, if a ``game.board.strings.fuelStation.lowercased`` is
             present."
        }
    };
    
    Children setup(Game game) => {
        H2 { "Setup" },
        P { "Each player starts on ``game.board.start.name`` with:" },
        Ul {
            Li { "$``format(game.rules.initialCash)`` in ``game.board.strings.leagueLong``
                  ``game.board.strings.cashUnit``" },
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
    
    String start(Game game) {
        value node = game.board.start;
        value string = StringBuilder();
        
        string.append("Home of the ``game.board.strings.leagueLong`` and the location where players
                       start the game.");
        
        if (game.rules.passStartCash > 0) {
            string.append(" The ``game.board.strings.leagueShort`` pays players a bonus of
                           $``game.rules.passStartCash`` every time they pass ``node.name``.");
        }
        
        if (is ActionTrigger node) {
            string.append(" Players who ``game.board.strings.landOn.lowercased`` ``node.name``
                           receive an additional bonus!");
        }
        
        if (is FuelSalable node) {
            string.append(" ``game.board.strings.fuel`` is available on ``node.name`` for
                           $``node.fuels[0]`` per ``game.board.strings.fuelUnit``.");
        }
        
        return string.string;
    }
    
    Style style => Style {
        type = "text/css";
        "body
         {
            margin: 5px;
         }
         
         caption
         {
            font-weight: bold;
         }
         
         dt
         {
            font-weight: bold;
         }
         
         h2
         {
            margin-top: 15px;
            margin-bottom: 0;
         }
         
         th, td
         {
            border: 1px solid black;
         }"
    };
    
    Children winning => {
        H2 { "Winning the Game" },
        P {
            "The last player standing is the winner. Alternately, players can agree on a time limit,
             in which case the player with the greatest net worth when time is up is the winner."
        }
    };
    
    String yesNo(Boolean boolean) => boolean then "Yes" else "No";
}
