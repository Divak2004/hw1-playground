import SwiftUI

// TODO: Declare any additional structs, classes, enums, or protocols here!
protocol GameObject {
    var name: String { get set }
    var description: String { get set }
    var commands: String { get set }
    
    func displayContent() -> String
    
    func displayCommands() -> String
}

struct Character: GameObject {
    var name: String
    var description: String
    var commands: String
    var reactions: (String, String)
    
    init (n: String, desc: String, coms: String, reacts: (String, String)) {
        name = n
        description = desc
        commands = coms
        reactions = reacts
    }
    
    func displayContent() -> String {
        return "You have encountered \(name): \(description)"
    }
    
    func displayCommands() -> String {
        return "Ok buddy, you can \(commands)"
    }
}

struct Location: GameObject {
    var name: String
    var description: String
    var commands: String
    var otherLocations: Array<Location>
    var character: Character?
    
    init (n: String, desc: String, coms: String, locations: Array<Location>, char: Character?) {
        name = n
        description = desc
        commands = coms
        otherLocations = locations
        character = char
    }
    
    func displayContent() -> String {
        return "You have arrived at \(name): \(description)"
    }
    
    func displayCommands() -> String {
        return "The wind whispers that you can \(commands)"
    }
}


/// Declare your game's behavior and state in this struct.
///
/// This struct will be re-created when the game resets. All game state should
/// be stored in this struct.
struct YourGame: AdventureGame {
    private var test: String = "test"
    /// Returns a title to be displayed at the top of the game.
    ///
    /// You can generate this dynamically based on your game's state.
    var title: String {
        // TODO: Change this title
        return "Generic Adventure Game"
    }
    
    /// Runs at the start of every game.
    ///
    /// Use this function to introduce the game to the player.
    ///
    /// - Parameter context: The object you use to write output and end the game.
    mutating func start(context: AdventureGameContext) {
        // TODO: Remove this and implement logic to start your game!
        playIntroduction()
        context.write("Welcome to " + title + "!")
    }
    
    /// Runs when the user enters a line of input.
    ///
    /// Generally, you parse the user's command, update game state as necessary, then
    /// write output.
    ///
    /// To display a line to the user, use the `context.write(_)` function and pass in
    /// a ``String``, like this:
    ///
    /// ```swift
    /// context.write("You have been eaten by a grue.")
    /// ```
    ///
    /// If you'd like to end the game (say, if the player dies), call context.endGame().
    /// Note that this does *not* display a game over message - it merely disables
    /// the buttons and forces the user to reset.
    ///
    /// **Sidenote:** context.write() supports AttributedString for rich text formatting.
    /// Consult the [homework instructions](https://www.seas.upenn.edu/~cis1951/assignments/hw/hw1)
    /// for guidance.
    ///
    /// - Parameters:
    ///   - input: The line the user typed.
    ///   - context: The object you use to write output and end the game.
    mutating func handle(input: String, context: AdventureGameContext) {
        // TODO: Parse the input and implement your game logic!
        let arguments = input.split(separator: " ")
        if arguments.isEmpty {
            context.write("Please enter a command.")
            return
        }
        
        switch arguments[0] {
            case "help":
                context.write("You seek the guidance of the Great Sage: help, north, south, east, west")
            case "north":
                context.write("You decide to \(input). It's not very effective.")
            case "south":
                context.write("You decide to \(input). It's not very effective.")
            case "east":
                context.write("You decide to \(input). It's not very effective.")
            case "west":
                context.write("You decide to \(input). It's not very effective.")
            default:
                context.write("Invalid command.")
        }
        context.write("You decide to \(input). It's not very effective.")
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
YourGame.display()
