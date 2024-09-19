import SwiftUI

// TODO: Declare any additional structs, classes, enums, or protocols here!
protocol GameObject {
    var name: String { get set }
    var description: String { get set }
    var commands: String { get set }
    
    func displayContent() -> String
    
    func displayCommands() -> String
}

struct Char: GameObject {
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
        return "\(name): 'Ok buddy, you can \(commands)'"
    }
}

struct Location: GameObject {
    var name: String
    var description: String
    var commands: String
    var otherLocations: Array<Location?>
    var char: Char?
    
    init (n: String, desc: String, coms: String, locations: Array<Location?>, charac: Char?) {
        name = n
        description = desc
        commands = coms
        otherLocations = locations
        char = charac
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
    private let amiya: Char = Char(n: "Amiya", desc: "A cautus, which is one of the ancient races on Terra. She has black rings that seem to suppress her power. Perhaps she may help you if you ask?", coms: "help, ask, ignore", reacts: ("She hands you one of her rings. As you leave, she says: 'Go North, stranger. May your journey be safe.'", "You move on in peace."))
    private let talulah: Char = Char(n: "Talulah", desc: "A draco, which is another one of the ancient races on Terra. She has a long sword by her waist. She is injured and lying down, but something seems suspicious.", coms: "help, aid, leave", reacts: ("As you approach her, she suddenly gets up and swings her sword, now in flames, at you. You couldn't dodge in time and you die.", "As you leave, she suddenly gets up and starts chasing you. You began running away as fast as possible. As you run, you see a sign that says the following: west - cave."))

    private var yan: Location? = nil
    private var cave: Location? = nil
    private var deadEnd: Location? = nil
    private var kazdel: Location? = nil
    private var leithania: Location? = nil
    private var victoria: Location? = nil
    private var beginning: Location? = nil
    
    private var curLocation: Location? = nil
    private var curChar: Char? = nil
    private var picked: Bool = false
    private var displayedChar: Bool = false
    private var displayedLoc: Bool = false
    private var locationCommand: String = ""
    /// Returns a title to be displayed at the top of the game.
    ///
    /// You can generate this dynamically based on your game's state.
    var title: String {
        // TODO: Change this title
        return "Terra Exploration"
    }
    
    /// Runs at the start of every game.
    ///
    /// Use this function to introduce the game to the player.
    ///
    /// - Parameter context: The object you use to write output and end the game.
    mutating func start(context: AdventureGameContext) {
        yan = Location(n: "Yan", desc: "A prosperous nation with a stable government and a strong economy. While you still have no idea where your family is, you breathe a sigh of relief that you are not chased anymore. You decide that this is a good place to settle for now before proceeding to search for your family.", coms: "", locations: [], charac: nil)
        cave = Location(n: "Cave", desc: "A cave whose depth is unknown. As you run for who knows how long, you finally arrive at a sharp turn. Lo and behold, you see a ray of light from the South.", coms: "help, south", locations: [yan], charac: nil)
        deadEnd = Location(n: "Unknown Area", desc: "A misty area engulfed in darkness. You wander around for days on end, but to no avail. In the end, you manage to escape. How, you may ask. Through death.", coms: "", locations: [], charac: nil)
        kazdel = Location(n: "Kazdel", desc: "A wartorn nation filled with dead bodies and the stench of blood. With Talulah still chasing you, you have no choice but to move on and ignore the cries for help from the victims of war.", coms: "help, west, north, south", locations: [cave, deadEnd, deadEnd], charac: nil)
        leithania = Location(n: "Leithania", desc: "A small nation filled with nobles that has managed to weaponized music. You managed to successfully enter the nation, and you managed to find out that people who looked like you went west.", coms: "help, west", locations: [kazdel], charac: talulah)
        victoria = Location(n: "Victoria", desc: "A glorious nation with steam knights defending it. However, those knights are nowhere to be seen. You feel a dangerous aura around, so you hurry and try to leave.", coms: "help, north, east, west", locations: [leithania, deadEnd, deadEnd], charac: nil)
        beginning = Location(n: "Plains", desc: "A plain field with nothing but grass. While there are no directions around, your gut tells you to go east. Perhaps you can find more information about your family there.", coms: "help, east", locations: [victoria], charac: amiya)
        
        
        context.write("Welcome to " + title + "!")
        curLocation = beginning
        context.write(curLocation!.displayContent())
        displayedLoc = true
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
        
        let arg = arguments[0]
        
        // Only runs if the character's description is rendered
        if displayedChar {
            if arg == "help" {
                context.write(curChar!.displayCommands())
                return
            } else {
                let commands = curChar!.commands.split(separator: ", ")
                // Cases based on char interaction
                switch arg {
                    case commands[1]:
                        context.write(curChar!.reactions.0)
                        if (curChar!.name == "Amiya") {
                            picked = true
                        } else {
                            var attributedString = AttributedString("Game Over")
                            attributedString.swiftUI.foregroundColor = .red
                            context.write(attributedString)
                            context.endGame()
                            return
                        }
                    case commands[2]:
                        context.write(curChar!.reactions.1)
                        if (curChar!.name == "Talulah") {
                            // Case where item picked from Amiya affects game and doesn't end game.
                            if picked {
                                context.write("Before you realize it, Talulah was at your heels! Thankfully, the ring you received from Amiya started activating, unleashing some mystical black magic onto Talulah and causing her to fall onto the ground. You take this chance to quickly run away while thinking about where you've seen this before.")
                            } else {
                                context.write("Before you realize it, Talulah was at your heels! You try to put more distance between yourself and Talulah, but she keeps on getting closer. Eventually, you run out of energy and collapse while leaving yourself at the mercy of her flaming sword.")
                                var attributedString = AttributedString("Game Over")
                                attributedString.swiftUI.foregroundColor = .red
                                context.write(attributedString)
                                context.endGame()
                                return
                            }
                        }
                    default:
                        context.write("Invalid command.")
                        return
                }
                displayedChar = false
                curChar = nil
            }
            displayedChar = false
            curChar = nil
        }
        // Checks to see if location description is already shown
        if !displayedLoc {
            displayedLoc = true
        }
        let commands = curLocation!.commands.split(separator: ", ")
        let locations = curLocation!.otherLocations
        
        // Cases depending on user input
        if arg == "help" {
            context.write(curLocation!.displayCommands())
        } 
        // Case to determine whether to display character or not depending on whether location has it or not
        else if commands.count > 1 && (arg == commands[1] || locationCommand == commands[1]) {
            if locationCommand == "" {
                curChar = curLocation!.char
            }
            if curChar != nil && !displayedChar {
                context.write(curChar!.displayContent())
                displayedChar = true
                locationCommand = String(arg)
            } else {
                curLocation = locations[0]
                context.write(curLocation!.displayContent())
                locationCommand = ""
            }
            displayedLoc = false
        } else if commands.count > 2 && arg == commands[2] {
            curLocation = locations[1]
            context.write(curLocation!.displayContent())
            displayedLoc = false
        } else if commands.count > 3 && arg == commands[3] {
            curLocation = locations[2]
            context.write(curLocation!.displayContent())
            displayedLoc = false
        } else {
            context.write("Invalid command")
        }
        if curLocation!.commands == "" {
            var attributedString = AttributedString("Game Over")
            if curLocation!.name == "Yan" {
                attributedString.swiftUI.foregroundColor = .green
            } else {
                attributedString.swiftUI.foregroundColor = .red
            }
            context.write(attributedString)
            context.endGame()
        }
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
YourGame.display()
