//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
All coders need to follow these rules, if you want your code to be commited.

- Constants names, which are declared as var/const/, should be all uppercase and each word should be
	broken by a underscore. ex: I_AM_AN_EXAMPLE
- All other types of vars and procs names should be mostly lowercase and for each following word the
	first letter should be uppercase. ex: iAmAnExample  Acronyms are considered one word.
- Class names are like the example above except for the first word has its first letter uppercased. ex: IAmAnExample
	When a name isn't set for a class, it will use the class name so be sure you set it.
- NEVER USE #define MACROS. They are easy to mess up, esp. when someone else comes in after you and edits your code.
	Use constants instead.
- Minimize the use of global non-constants and procs.  When I say global, I mean any var or proc that is
	declared outside a class.  The compiler won't check if something is used or not if it is global.
- Discribe your code in a comment if it gets difficult or time consuming to read.  No one wants to have to trace
	a loop within loop, a proc that does multiple things or a var that is used in multiple files.
- Don't be lazy and name your stuff that does not relate to the current code.  If you use "weaselWackin", then
	it better be about weasel wackin'.
- Don't use short non-sense var names(ex: "Bl") unless it is for a loop or a small proc.  If the proc can fit on
	your screen without having to scroll up or down, it is a small proc.
- All procs should type check when possible.
- Don't declare classes and procs without the full name.  It should look this: datum/reagents/proc/reaction_mob(.
	It is annoying trying to trace what class a proc belongs to by having to follow the indents up 30 pages of code.
	In addition, it moves the whole code off the right side of the screen.
- Don't put an empty return statement at the bottom of a proc.  It shows you don't know what you are doing.
- Lastly, if you are editing something in the code and notice something that doesn't follow these rules, take it
	upon yourself to fix it.
*/

//#define TESTING

var/global/obj/effect/datacore/dataCore = null // Stores data related to records, pda, etc.
var/global/obj/effect/overlay/plasmaMasterOverlay = null // Stores an overlay for plasma in the air
var/global/obj/effect/overlay/sleepAgentMasterOverlay = null // Stores an overlay for N2O in the air

// Items that ask to be called every cycle

var/global/list/machines = list()
var/global/list/processingObjects = list()
var/global/list/activeDiseases = list()
var/global/list/events = list()

var/global/deferPowernetRebuild = 0 // true if net rebuild will be called manually after an event

var/global/list/globalMap = null

var/list/paperTagWhitelist = list("center","p","div","span","h1","h2","h3","h4","h5","h6","hr","pre",	\
	"big","small","font","i","u","b","s","sub","sup","tt","br","hr","ol","ul","li","caption","col",	\
	"table","td","th","tr")
var/list/paperBlacklist = list("java","onblur","onchange","onclick","ondblclick","onfocus","onkeydown",	\
	"onkeypress","onkeyup","onload","onmousedown","onmousemove","onmouseout","onmouseover",	\
	"onmouseup","onreset","onselect","onsubmit","onunload")

//Genetic - Which block has mutations

var/BLINDBLOCK = 0
var/DEAFBLOCK = 0
var/HULKBLOCK = 0
var/TELEBLOCK = 0
var/FIREBLOCK = 0
var/XRAYBLOCK = 0
var/CLUMSYBLOCK = 0
var/FAKEBLOCK = 0
var/COUGHBLOCK = 0
var/GLASSESBLOCK = 0
var/EPILEPSYBLOCK = 0
var/TWITCHBLOCK = 0
var/NERVOUSBLOCK = 0
var/MONKEYBLOCK = 27

var/BLOCKADD = 0
var/DIFFMUT = 0

var/HEADACHEBLOCK = 0
var/NOBREATHBLOCK = 0
var/REMOTEVIEWBLOCK = 0
var/REGENERATEBLOCK = 0
var/INCREASERUNBLOCK = 0
var/REMOTETALKBLOCK = 0
var/MORPHBLOCK = 0
var/BLENDBLOCK = 0
var/HALLUCINATIONBLOCK = 0
var/NOPRINTSBLOCK = 0
var/SHOCKIMMUNITYBLOCK = 0
var/SMALLSIZEBLOCK = 0

	///////////////
var/eventchance = 10 //% per 5 mins
var/event = 0
var/hadevent = 0
var/blobevent = 0
	///////////////

var/diary = null
var/diaryofmeanpeople = null
var/href_logfile = null
var/station_name = "NSS Nilith"
var/game_version = "Specious Station 13"
var/changelog_hash = ""

var/datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
var/going = 1.0
var/master_mode = "extended"//"extended"
var/secret_force_mode = "secret" // if this is anything but "secret", the secret rotation will forceably choose this mode

var/datum/engine_eject/engine_eject_control = null
var/host = null
var/aliens_allowed = 0
var/ooc_allowed = 1
var/dooc_allowed = 1
var/traitor_scaling = 1
//var/goonsay_allowed = 0
var/dna_ident = 1
var/abandon_allowed = 1
var/enter_allowed = 1
var/guests_allowed = 1
var/shuttle_frozen = 0
var/shuttle_left = 0
var/tinted_weldhelh = 1

var/list/jobMax = list()
var/list/bombers = list(  )
var/list/admin_log = list (  )
var/list/lastsignalers = list(	)	//keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges = list(  ) //Stores who uploaded laws to which silicon-based lifeform, and what the law was
var/list/shuttles = list(  )
var/list/reg_dna = list(  )
//	list/traitobj = list(  )

var/mouse_respawn_time = 5 //Amount of time that must pass between a player dying as a mouse and repawning as a mouse. In minutes.

var/CELLRATE = 0.002  // multiplier for watts per tick <> cell storage (eg: .002 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
var/CHARGELEVEL = 0.001 // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

var/shuttle_z = 2	//default
var/airtunnel_start = 68 // default
var/airtunnel_stop = 68 // default
var/airtunnel_bottom = 72 // default
var/list/monkeystart = list()
var/list/wizardstart = list()
var/list/newplayer_start = list()
var/list/latejoin = list()
var/list/prisonwarp = list()	//prisoners go to these
var/list/holdingfacility = list()	//captured people go here
var/list/xeno_spawn = list()//Aliens spawn at these.
//	list/mazewarp = list()
var/list/tdome1 = list()
var/list/tdome2 = list()
var/list/tdomeobserve = list()
var/list/tdomeadmin = list()
var/list/prisonsecuritywarp = list()	//prison security goes to these
var/list/prisonwarped = list()	//list of players already warped
var/list/blobstart = list()
var/list/ninjastart = list()
//	list/traitors = list()	//traitor list
var/list/cardinal = list( NORTH, SOUTH, EAST, WEST )
var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

var/datum/station_state/start_state = null
var/datum/configuration/config = null
var/datum/sun/sun = null

var/list/combatlog = list()
var/list/IClog = list()
var/list/OOClog = list()
var/list/adminlog = list()


var/list/powernets = list()

var/Debug = 0	// global debug switch
var/Debug2 = 0

var/datum/debug/debugobj

var/datum/moduletypes/mods = new()

var/wavesecret = 0
var/gravity_is_on = 1

var/shuttlecoming = 0

var/join_motd = null
var/forceblob = 0

	//airlockWireColorToIndex takes a number representing the wire color, e.g. the orange wire is always 1, the dark red wire is always 2, etc. It returns the index for whatever that wire does.
	//airlockIndexToWireColor does the opposite thing - it takes the index for what the wire does, for example AIRLOCK_WIRE_IDSCAN is 1, AIRLOCK_WIRE_POWER1 is 2, etc. It returns the wire color number.
	//airlockWireColorToFlag takes the wire color number and returns the flag for it (1, 2, 4, 8, 16, etc)
var/list/airlockWireColorToFlag = RandomAirlockWires()
var/list/airlockIndexToFlag
var/list/airlockIndexToWireColor
var/list/airlockWireColorToIndex
var/list/APCWireColorToFlag = RandomAPCWires()
var/list/APCIndexToFlag
var/list/APCIndexToWireColor
var/list/APCWireColorToIndex
var/list/BorgWireColorToFlag = RandomBorgWires()
var/list/BorgIndexToFlag
var/list/BorgIndexToWireColor
var/list/BorgWireColorToIndex
var/list/AAlarmWireColorToFlag = RandomAAlarmWires()
var/list/AAlarmIndexToFlag
var/list/AAlarmIndexToWireColor
var/list/AAlarmWireColorToIndex

var/const/SPEED_OF_LIGHT = 3e8 //not exact but hey!
var/const/SPEED_OF_LIGHT_SQ = 9e+16
var/const/FIRE_DAMAGE_MODIFIER = 0.0215 //Higher values result in more external fire damage to the skin (default 0.0215)
var/const/AIR_DAMAGE_MODIFIER = 2.025 //More means less damage from hot air scalding lungs, less = more damage. (default 2.025)
var/const/INFINITY = 1e31 //closer then enough

	//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
var/const/MAX_MESSAGE_LEN = 1024
var/const/MAX_PAPER_MESSAGE_LEN = 3072
var/const/MAX_BOOK_MESSAGE_LEN = 9216
var/const/MAX_NAME_LEN = 26

var/const/shuttle_time_in_station = 1800 // 3 minutes in the station
var/const/shuttle_time_to_arrive = 6000 // 10 minutes to arrive

//away missions
var/list/awaydestinations = list()	//a list of landmarks that the warpgate can take you to

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null
