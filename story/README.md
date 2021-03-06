# convert.py
This script converts a Twine json file into a text document of SQL statements.

### Usage
`python3 convert.py <ghost id> <level>`

The script will look for `<ghost id>/<level>.json` and output `<ghost id>/<level>.txt`

`python3 convert.py 1 2` will look at `1/2.json` and create `1/2.txt`

# Levels & Story points
At levels 0 and 1 the ghost does not initiate a conversation. The ghost barely responds to you.

0. Initial state. Ghost is extremely transparent, responds only with sounds or just `...`. Gets to level 1 is quite quick, within 1 night cycle.
1. Ghost becomes half-visible. Responds with "Hello" or "What do you want" sometimes to default questions.
2. Ghost becomes fully visible. Starts to send its first notifications. Speaks for the first time to the player, saying `Hello`
3. Ghost reveals where it's from
4. Ghost reveals its vocation/job
5. Ghost reveals its name
6. Ghost reveals when it was born and its age
7. Ghost reveals its marital/family status
8. Ghost reveals where it was when it died
9. Ghost reveals what it was doing when it died
10. Ghost reveals how exactly it died
