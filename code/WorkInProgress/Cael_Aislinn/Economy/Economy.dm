
var/const/RIOTS = 1
var/const/WILD_ANIMAL_ATTACK = 2
var/const/INDUSTRIAL_ACCIDENT = 3
var/const/BIOHAZARD_OUTBREAK = 4
var/const/WARSHIPS_ARRIVE = 5
var/const/PIRATES = 6
var/const/CORPORATE_ATTACK = 7
var/const/ALIEN_RAIDERS = 8
var/const/AI_LIBERATION = 9
var/const/MOURNING = 10
var/const/CULT_CELL_REVEALED = 11
var/const/SECURITY_BREACH = 12
var/const/ANIMAL_RIGHTS_RAID = 13
var/const/FESTIVAL = 14

var/const/RESEARCH_BREAKTHROUGH = 15
var/const/BARGAINS = 16
var/const/SONG_DEBUT = 17
var/const/MOVIE_RELEASE = 18
var/const/BIG_GAME_HUNTERS = 19
var/const/ELECTION = 20
var/const/GOSSIP = 21
var/const/TOURISM = 22
var/const/CELEBRITY_DEATH = 23
var/const/RESIGNATION = 24

var/const/DEFAULT = 1

var/const/ADMINISTRATIVE = 2
var/const/CLOTHING = 3
var/const/SECURITY = 4
var/const/SPECIAL_SECURITY = 5

var/const/FOOD = 6
var/const/ANIMALS = 7

var/const/MINERALS = 8

var/const/ECON_EMERGENCY = 9
var/const/ECON_GAS = 10
var/const/MAINTENANCE = 11
var/const/ELECTRICAL = 12
var/const/ROBOTICS = 13
var/const/BIOMEDICAL = 14

var/const/EVA = 15

//---- The following corporations are friendly with NanoTrasen and loosely enable trade and travel:
//Corporation NanoTrasen - Generalised / high tech research and plasma exploitation.
//Corporation Vessel Contracting - Ship and station construction, materials research.
//Corporation Osiris Atmospherics - Atmospherics machinery construction and chemical research.
//Corporation Second Red Cross Society - 26th century Red Cross reborn as a dominating economic force in biomedical science (research and materials).
//Corporation Blue Industries - High tech and high energy research, in particular into the mysteries of bluespace manipulation and power generation.
//Corporation Kusanagi Robotics - Founded by robotics legend Kaito Kusanagi in the 2070s, they have been on the forefront of mechanical augmentation and robotics development ever since.
//Corporation Free traders - Not so much a corporation as a loose coalition of spacers, Free Traders are a roving band of smugglers, traders and fringe elements following a rigid (if informal) code of loyalty and honour. Mistrusted by most corporations, they are tolerated because of their uncanny ability to smell out a profit.

//---- Descriptions of destination types
//Space stations can be purpose built for a number of different things, but generally require regular shipments of essential supplies.
//Corvettes are small, fast warships generally assigned to border patrol or chasing down smugglers.
//Battleships are large, heavy cruisers designed for slugging it out with other heavies or razing planets.
//Yachts are fast civilian craft, often used for pleasure or smuggling.
//Destroyers are medium sized vessels, often used for escorting larger ships but able to go toe-to-toe with them if need be.
//Frigates are medium sized vessels, often used for escorting larger ships. They will rapidly find themselves outclassed if forced to face heavy warships head on.

var/setup_economy = 0
/proc/setup_economy()
	if(setup_economy)
		return
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = "Tau Ceti Daily"
	newChannel.author = "[HEADQUARTERS_NAME] Minister of Information"
	newChannel.locked = 1
	newChannel.is_admin_channel = 1
	news_network.network_channels += newChannel

	newChannel = new /datum/feed_channel
	newChannel.channel_name = "The Gibson Gazette"
	newChannel.author = "Editor Mike Hammers"
	newChannel.locked = 1
	newChannel.is_admin_channel = 1
	news_network.network_channels += newChannel

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	setup_economy = 1