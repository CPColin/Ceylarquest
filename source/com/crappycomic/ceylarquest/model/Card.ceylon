"A representation of a card, like Chance cards in Monopoly, that is drawn at certain points in the
 game and requires the player to take a certain action. To ease serialization, instances with the
 same [[description]] are considered to be equivalent."
shared class Card(shared String description, shared CardAction action) {}
