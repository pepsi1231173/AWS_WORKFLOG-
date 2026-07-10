---
title: 'Introduction'
date: 2024-08-07
weight: 1
chapter: false
pre: ' <b> 5.1. </b> '
---

### Introduction to the Rough Life Game Project

- Rough Life is a 2D top-down action-adventure game project that focuses on combat mechanics against monsters and bosses across different areas. The game is built with Unity, uses C# as the main programming language, and is developed to support both offline gameplay and online co-op multiplayer.
- In the game, players control a character to move around the map, pick up weapons, use combat skills, and enter boss rooms to overcome challenges. Each weapon in Rough Life has its own usage mechanics, where the left mouse button is usually used for the main attack, while the right mouse button is used for the secondary skill. Some typical weapons include Sword, Bow, Staff, and Spear, each designed with different attack styles and abilities.
- One of the highlights of Rough Life is the boss fight system. Players can enter boss rooms such as Phoenix, Slime, Centaur, and other bosses to fight. Each boss has its own mechanics, health bar, sound effects, background music, and rewards after being defeated. When a boss dies, the game can spawn rewards such as upgraded weapons to help players increase their strength.
- For the online mode, Rough Life is developed as a co-op game that supports up to 4 players. Players can create rooms, join rooms, and fight together in real time. The online system uses Unity Netcode to synchronize characters, weapons, item pickups, combat states, and in-game interactions. In addition, the game also includes supporting systems such as the current weapon UI, weapon description panel when approaching items, death/revive mechanics, and scene transitions between the Lobby and boss rooms.

### Overview of the Rough Life Game Project

**1. Menu**

The menu includes basic function buttons such as Online, Offline, Setting, and Exit. Players can choose Offline to play alone, choose Online to join multiplayer mode, open Setting to adjust the audio, or select Exit to quit the game.
![overview](/images/5-Workshop/5.1-Workshop-overview/Menu.jpg)
**2. Offline Mechanic**

**2.1. Offline Map Lobby**

- After the player selects Offline mode from the main menu, the game will switch to the Map Lobby area. This is the main waiting area for single-player mode, where players can move freely, get familiar with the interface, and prepare before entering boss battles.
- In the Map Lobby, players can pick up different weapons placed on the map. When the character approaches a weapon, the system displays a description panel showing the weapon name, icon, and basic information. After picking up a weapon, the skill UI in the corner of the screen is updated to show the left mouse and right mouse skills corresponding to the equipped weapon.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Maplobby.jpg)
- In addition, the Map Lobby is also where players choose boss stages. Players can approach the boss selection area to view stage information, then press the interaction key to enter the corresponding boss room.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Maplobby1.jpg)

**2.2. Minotaur Boss Map**

- The Minotaur Boss Map is designed as a battle stage against a bull-like creature holding an axe, with moderate attack damage.
- When entering the boss room, the player will fight directly against the Minotaur. The boss has a large size, creating pressure for the player during combat. In this stage, the player uses the weapon selected from the Lobby to attack the boss, dodge attacks, and try to reduce the boss’s health to 0. If the player is defeated by the boss, the system will return the player to the Map Lobby. After defeating the boss, upgraded weapons will appear as rewards.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/MapBoss1.jpg)

**2.3. Phoenix Boss Map**

- The Phoenix Boss Map is designed as a battle stage against a fire-themed creature with flexible attacks and high damage.
- During the battle, the player needs to use movement skills and weapons to avoid Phoenix’s attacks. The Phoenix boss can be designed with area-of-effect skills, fire effects, or fast attack patterns, creating a different and more difficult experience compared to the Minotaur boss.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Mapphonix.jpg)

**3. Online Mechanic**

**3.1. Online Lobby Scene**

- When the player selects Online mode from the main menu, the game will switch to the Online Lobby Scene interface. Here, the player needs to enter a character name before joining a room. After creating a room and pressing the Online button, the system generates a unique room code that other players can use to join.
- The Online Lobby supports two room modes: Public and Private. With a Public room, other players can see the room in the room list and join directly. With a Private room, players need to enter the correct room code to join. This mechanic gives players flexibility when creating either a public room or a private room for friends.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Lobbyscene.jpg)

**3.2. Public Room List**

- When a player creates a room and sets it to Public mode, that room will be displayed in the room list. Other players can press the Enter Room button to view available rooms and select a room to join.
- In the room list, the system displays basic information such as the room name, room status, and current number of players. Each room supports up to 4 players, which matches the online co-op mechanic of Rough Life.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Public.jpg)

**3.3. Joining a Room Using a Code**

- Besides joining a Public room, players can also enter a room code to join a specific room directly.
- This mechanic is suitable for Private rooms or when players want to invite friends to a specific room.
- After entering the correct room code and pressing Join, the player will be brought into the online waiting room. In this room, the system displays the list of joined players, including the Host and other Clients. When there are enough players or when the Host wants to begin, the Host can press Start Game to move all players into the Online Map Lobby.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Online.jpg)

**3.4. Online Map Lobby**

- After the Host starts the game, all players in the room will be transferred to the Online Map Lobby. This is the shared waiting area for online mode, where up to 4 players can appear at the same time and prepare before entering a boss room.
- In the Online Map Lobby, players can move around, observe other players, pick up weapons, and prepare their combat skills. Weapons on the map are synchronized between players, allowing everyone to see the weapon state after a player picks up or changes a weapon.
- The Online Map Lobby is also where the group gathers before entering boss stages. Having multiple players appear in the same area creates a clearer co-op experience compared to Offline mode.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Maplobbyonline.jpg)

**3.5. Boss Battle in Online Mode**

- When players enter a boss stage, the whole group will fight the boss together on the same map. In Online mode, the game synchronizes character positions, combat states, weapons, and important interactions so that players can cooperate with each other.
- Each player can use their selected weapon to attack the boss. The combat mechanics remain the same as in Offline mode, where the left mouse button is used for the main attack and the right mouse button is used for the secondary skill. However, in Online mode, actions such as movement, weapon pickup, and combat must be synchronized so that all players see the same state during the battle.
- When a player is defeated, the system handles the death or revive state depending on the stage mechanic. If all players are defeated, the group will be returned to the Lobby. If the group wins, upgraded weapons will drop as rewards, and the players can continue to the next boss stage.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Mapbossonline.jpg)

**4. Setting System**

- The Setting system is designed so players can adjust the game audio during gameplay. Players can open the Setting panel using the button in the top-right corner of each scene, then change the volume of Music and SFX using sliders.
- The Music section is used to adjust the background music volume, including music in the menu, lobby, and boss stages.
- The SFX section is used to adjust sound effects such as attack sounds, skill sounds, and button click sounds.
- The Setting interface is simple, easy to read, and includes a close button so players can return to the current gameplay screen. With this system, players can customize the audio experience without needing to exit the game.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Setting.jpg)
