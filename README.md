# *Terra Exploration*

## Explanations

**What locations/rooms does your game have?**

1. Plains
2. Victoria
3. Leithania
4. Kazdel
5. Unknown Area
6. Cave
7. Yan

**What items does your game have?**

1. Black ring (can be obtained by interacting with Amiya and 'aid' her)

**Explain how your code is designed. In particular, describe how you used structs or enums, as well as protocols.**

*I designed a protocol called GameObject which my structs, Location and Character, used. The GameObject protocol requires anything interactable to have a name, a description, and commands. It also forces anything implementing the protocol to have a way of displaying their "content", aka their name and description, as well as the commands that a user can use to interact with the object. Besides the variables and functions required in the GameObject protocol, the Location struct also contains information on other locations that it is connected to as well as a character associated to it, with the character potentially being nil. The Character struct also contains a variable storing the 'reactions' that the character can have depending on the user's commands.*

**How do you use optionals in your program?**

*I used optionals nontrivially to allow a location to have the option to store nil as the character associated to it. Hence, when I check to see if I should display a character's information, one of the conditions that I check is if the character is nil.*

**What extra credit features did you implement, if any?**

* *I added rich text by changing the color of game over depending on how the game ended. If the player dies, it is red, and if the player survives till the end, it is green.*

## Endings

### Ending 1

```
east ask north west leave west south
```

### Ending 2

```
east leave north west leave
```
