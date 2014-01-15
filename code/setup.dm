//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

#define DEBUG
#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/"+(MODE))))

var/const/PI = 3.1415

var/const/R_IDEAL_GAS_EQUATION = 8.31 //kPa*L/(K*mol)
var/const/ONE_ATMOSPHERE = 101.325	//kPa

var/const/CELL_VOLUME = 2500	//liters in a cell
var/const/MOLES_CELLSTANDARD = (ONE_ATMOSPHERE * CELL_VOLUME / (T20C * R_IDEAL_GAS_EQUATION))	//moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC

var/const/O2STANDARD = 0.21
var/const/N2STANDARD = 0.79

var/const/MOLES_O2STANDARD = MOLES_CELLSTANDARD*O2STANDARD	// O2 standard value (21%)
var/const/MOLES_N2STANDARD = MOLES_CELLSTANDARD*N2STANDARD	// N2 standard value (79%)

var/const/MOLES_PLASMA_VISIBLE = 0.7 //Moles in a standard cell after which plasma is visible
var/const/MIN_PLASMA_DAMAGE = 1
var/const/MAX_PLASMA_DAMAGE = 10

var/const/BREATH_VOLUME = 0.5	//liters in a normal breath
var/const/BREATH_MOLES = (ONE_ATMOSPHERE * BREATH_VOLUME / (T20C * R_IDEAL_GAS_EQUATION))
var/const/BREATH_PERCENTAGE = BREATH_VOLUME / CELL_VOLUME
	//Amount of air to take a from a tile
var/const/HUMAN_NEEDED_OXYGEN = MOLES_CELLSTANDARD * BREATH_PERCENTAGE * 0.16
	//Amount of air needed before pass out/suffocation commences

// Pressure limits.
var/const/HAZARD_HIGH_PRESSURE = 550	//This determins at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
var/const/WARNING_HIGH_PRESSURE = 325 	//This determins when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
var/const/WARNING_LOW_PRESSURE = 50 	//This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
var/const/HAZARD_LOW_PRESSURE = 20		//This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)

var/const/TEMPERATURE_DAMAGE_COEFFICIENT = 1.5	//This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
var/const/BODYTEMP_AUTORECOVERY_DIVISOR = 12 //This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
var/const/BODYTEMP_AUTORECOVERY_MINIMUM = 10 //Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
var/const/BODYTEMP_COLD_DIVISOR = 6 //Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
var/const/BODYTEMP_HEAT_DIVISOR = 6 //Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
var/const/BODYTEMP_COOLING_MAX = 30 //The maximum number of degrees that your body can cool in 1 tick, when in a cold area.
var/const/BODYTEMP_HEATING_MAX = 30 //The maximum number of degrees that your body can heat up in 1 tick, when in a hot area.

var/const/BODYTEMP_HEAT_DAMAGE_LIMIT = 360.15 // The limit the human body can take before it starts taking damage from heat.
var/const/BODYTEMP_COLD_DAMAGE_LIMIT = 260.15 // The limit the human body can take before it starts taking damage from coldness.

var/const/SPACE_HELMET_MIN_COLD_PROTECITON_TEMPERATURE =  2.0 //what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
var/const/SPACE_SUIT_MIN_COLD_PROTECITON_TEMPERATURE = 2.0 //what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
var/const/SPACE_SUIT_MAX_HEAT_PROTECITON_TEMPERATURE = 5000	//These need better heat protect
var/const/FIRESUIT_MAX_HEAT_PROTECITON_TEMPERATURE = 30000 //what max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
var/const/FIRE_HELMET_MAX_HEAT_PROTECITON_TEMPERATURE = 30000 //for fire helmet quality items (red and white hardhats)
var/const/HELMET_MIN_COLD_PROTECITON_TEMPERATURE = 160	//For normal helmets
var/const/HELMET_MAX_HEAT_PROTECITON_TEMPERATURE = 600	//For normal helmets
var/const/ARMOR_MIN_COLD_PROTECITON_TEMPERATURE = 160	//For armor
var/const/ARMOR_MAX_HEAT_PROTECITON_TEMPERATURE = 600	//For armor

var/const/GLOVES_MIN_COLD_PROTECITON_TEMPERATURE = 2.0	//For some gloves (black and)
var/const/GLOVES_MAX_HEAT_PROTECITON_TEMPERATURE = 1500		//For some gloves
var/const/SHOE_MIN_COLD_PROTECITON_TEMPERATURE = 2.0	//For gloves
var/const/SHOE_MAX_HEAT_PROTECITON_TEMPERATURE = 1500		//For gloves

var/const/PRESSURE_DAMAGE_COEFFICIENT = 4 //The amount of pressure damage someone takes is equal to (pressure / HAZARD_HIGH_PRESSURE)*PRESSURE_DAMAGE_COEFFICIENT, with the maximum of MAX_PRESSURE_DAMAGE
var/const/MAX_HIGH_PRESSURE_DAMAGE = 4	//This used to be 20... I got this much random rage for some retarded decision by polymorph?! Polymorph now lies in a pool of blood with a katana jammed in his spleen. ~Errorage --PS: The katana did less than 20 damage to him :(
var/const/LOW_PRESSURE_DAMAGE = 2 	//The amounb of damage someone takes when in a low pressure area (The pressure threshold is so low that it doesn't make sense to do any calculations, so it just applies this flat value).

var/const/PRESSURE_SUIT_REDUCTION_COEFFICIENT = 0.8 //This is how much (percentual) a suit with the flag STOPSPRESSUREDMAGE reduces pressure.
var/const/PRESSURE_HEAD_REDUCTION_COEFFICIENT = 0.4 //This is how much (percentual) a helmet/hat with the flag STOPSPRESSUREDMAGE reduces pressure.

// Doors!
var/const/DOOR_CRUSH_DAMAGE = 10

// Factor of how fast mob nutrition decreases
var/const/HUNGER_FACTOR = 0.05

// How many units of reagent are consumed per tick, by default.
var/const/REAGENTS_METABOLISM = 0.2

// By defining the effect multiplier this way, it'll exactly adjust
// all effects according to how they originally were with the 0.4 metabolism
var/const/REAGENTS_EFFECT_MULTIPLIER = REAGENTS_METABOLISM / 0.4


var/const/MINIMUM_AIR_RATIO_TO_SUSPEND=  0.05
	//Minimum ratio of air that must move to/from a tile to suspend group processing
var/const/MINIMUM_AIR_TO_SUSPEND = MOLES_CELLSTANDARD * MINIMUM_AIR_RATIO_TO_SUSPEND
	//Minimum amount of air that has to move before a group processing can be suspended

var/const/MINIMUM_MOLES_DELTA_TO_MOVE = MOLES_CELLSTANDARD * MINIMUM_AIR_RATIO_TO_SUSPEND //Either this must be active
var/const/MINIMUM_TEMPERATURE_TO_MOVE = T20C + 100 		  //or this (or both, obviously)

var/const/MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND = 0.012
var/const/MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND = 4
	//Minimum temperature difference before group processing is suspended
var/const/MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER = 0.5
	//Minimum temperature difference before the gas temperatures are just set to be equal

var/const/MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION = T20C + 10
var/const/MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	= T20C + 200

var/const/FLOOR_HEAT_TRANSFER_COEFFICIENT = 0.4
var/const/WALL_HEAT_TRANSFER_COEFFICIENT = 0.0
var/const/DOOR_HEAT_TRANSFER_COEFFICIENT = 0.0
var/const/SPACE_HEAT_TRANSFER_COEFFICIENT = 0.2 //a hack to partly simulate radiative heat
var/const/OPEN_HEAT_TRANSFER_COEFFICIENT = 0.4
var/const/WINDOW_HEAT_TRANSFER_COEFFICIENT = 0.1 //a hack for now
	//Must be between 0 and 1. Values closer to 1 equalize temperature faster
	//Should not exceed 0.4 else strange heat flow occur

var/const/FIRE_MINIMUM_TEMPERATURE_TO_SPREAD = 150 + T0C
var/const/FIRE_MINIMUM_TEMPERATURE_TO_EXIST = 100 + T0C
var/const/FIRE_SPREAD_RADIOSITY_SCALE = 0.85
var/const/FIRE_CARBON_ENERGY_RELEASED = 500000 //Amount of heat released per mole of burnt carbon into the tile
var/const/FIRE_PLASMA_ENERGY_RELEASED = 3000000 //Amount of heat released per mole of burnt plasma into the tile
var/const/FIRE_GROWTH_RATE = 40000 //For small fires

// Fire Damage
var/const/CARBON_LIFEFORM_FIRE_RESISTANCE = 200 + T0C
var/const/CARBON_LIFEFORM_FIRE_DAMAGE = 4

//Plasma fire properties
var/const/PLASMA_MINIMUM_BURN_TEMPERATURE = 100 + T0C
var/const/PLASMA_FLASHPOINT = 246 + T0C
var/const/PLASMA_UPPER_TEMPERATURE = 1370 + T0C
var/const/PLASMA_MINIMUM_OXYGEN_NEEDED = 2
var/const/PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO = 20
var/const/PLASMA_OXYGEN_FULLBURN = 10

var/const/T0C = 273.15					// 0degC
var/const/T20C = 293.15					// 20degC
var/const/TCMB = 2.7					// -270.3degC

var/turf/space/Space_Tile = locate(/turf/space) // A space tile to reference when atmos wants to remove excess heat.

var/const/TANK_LEAK_PRESSURE = (30 * ONE_ATMOSPHERE)	// Tank starts leaking
var/const/TANK_RUPTURE_PRESSURE = (40 * ONE_ATMOSPHERE) // Tank spills all contents into atmosphere

var/const/TANK_FRAGMENT_PRESSURE = (50 * ONE_ATMOSPHERE) // Boom 3x3 base explosion
var/const/TANK_FRAGMENT_SCALE = (10 * ONE_ATMOSPHERE) // +1 for each SCALE kPa aboe threshold
								// was 2 atm
var/const/MAX_EXPLOSION_RANGE = 12

var/const/HUMAN_STRIP_DELAY = 40 //takes 40ds = 4s to strip someone.

var/const/ALIEN_SELECT_AFK_BUFFER = 1 // How many minutes that a person can be AFK before not being allowed to be an alien.

var/const/NORMPIPERATE = 30					//pipe-insulation rate divisor
var/const/HEATPIPERATE = 8					//heat-exch pipe insulation

var/const/FLOWFRAC = 0.99				// fraction of gas transfered per process

var/const/SHOES_SLOWDOWN = -1.0			// How much shoes slow you down by default. Negative values speed you up

//ITEM INVENTORY SLOT BITMASKS
var/const/SLOT_OCLOTHING 	= 1
var/const/SLOT_ICLOTHING 	= 2
var/const/SLOT_GLOVES 		= 4
var/const/SLOT_EYES 		= 8
var/const/SLOT_EARS 		= 16
var/const/SLOT_MASK 		= 32
var/const/SLOT_HEAD 		= 64
var/const/SLOT_FEET 		= 128
var/const/SLOT_ID 			= 256
var/const/SLOT_BELT 		= 512
var/const/SLOT_BACK 		= 1024
var/const/SLOT_POCKET 		= 2048 //this is to allow items with a w_class of 3 or 4 to fit in pockets.
var/const/SLOT_DENYPOCKET 	= 4096 //this is to deny items with a w_class of 2 or 1 to fit in pockets.

//FLAGS BITMASK
//This flag is used on the flags variable for SUIT and HEAD items which stop pressure damage. Note that the flag 1 was previous used as
//  ONBACK, so it is possible for some code to use (flags & 1) when checking if something can be put on your back. Replace this code with
//  (inv_flags & SLOT_BACK) if you see it anywhere.

//To successfully stop you taking all pressure damage you must have both a suit and head item with this flag.
var/const/STOPSPRESSUREDMAGE	= 1
var/const/TABLEPASS				= 2 // can pass by a table or rack

var/const/MASKINTERNALS = 8	// mask allows internals

var/const/USEDELAY = 16		// 1 second extra delay on use (Can be used once every 2s)
var/const/NODELAY = 32768	// 1 second attackby delay skipped (Can be used once every 0.2s). Most objects have a 1s attackby delay, which doesn't require a flag.
var/const/NOSHIELD = 32		// weapon not affected by shield
var/const/CONDUCT = 64		// conducts electricity (metal etc.)
var/const/FPRINT = 256		// takes a fingerprint
var/const/ON_BORDER = 512		// item has priority to check when entering or leaving

var/const/GLASSESCOVERSEYES = 1024
var/const/MASKCOVERSEYES = 1024		// get rid of some of the other retardation in these flags
var/const/HEADCOVERSEYES = 1024		// feel free to realloc these numbers for other purposes
var/const/MASKCOVERSMOUTH = 2048		// on other items, these are just for mask/head
var/const/HEADCOVERSMOUTH = 2048

var/const/NOSLIP = 1024 		//prevents from slipping on wet floors, in space etc

var/const/OPENCONTAINER = 4096	// is an open container for chemistry purposes

var/const/BLOCK_GAS_SMOKE_EFFECT = 8192	// blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
var/const/ONESIZEFITSALL = 8192
var/const/PLASMAGUARD = 16384			//Does not get contaminated by plasma.

var/const/NOREACT = 16384 			//Reagents dont' react inside this container.

var/const/BLOCKHEADHAIR = 4             // temporarily removes the user's hair overlay. Leaves facial hair.
var/const/BLOCKHAIR = 32768			// temporarily removes the user's hair, facial and otherwise.

//flags for pass_flags
var/const/PASSTABLE = 1
var/const/PASSGLASS = 2
var/const/PASSGRILLE = 4
var/const/PASSBLOB = 8

//turf-only flags
var/const/NOJAUNT = 1


//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
var/const/HIDEGLOVES = 1	//APPLIES ONLY TO THE EXTERIOR SUIT!!
var/const/HIDESUITSTORAGE = 2	//APPLIES ONLY TO THE EXTERIOR SUIT!!
var/const/HIDEJUMPSUIT = 4	//APPLIES ONLY TO THE EXTERIOR SUIT!!
var/const/HIDESHOES = 8	//APPLIES ONLY TO THE EXTERIOR SUIT!!
var/const/HIDEMASK = 1	//APPLIES ONLY TO HELMETS/MASKS!!
var/const/HIDEEARS = 2	//APPLIES ONLY TO HELMETS/MASKS!! (ears means headsets and such)
var/const/HIDEEYES = 4	//APPLIES ONLY TO HELMETS/MASKS!! (eyes means glasses)
var/const/HIDEFACE = 8	//APPLIES ONLY TO HELMETS/MASKS!! Dictates whether we appear as unknown.

//slots
var/const/slot_back = 1
var/const/slot_wear_mask = 2
var/const/slot_handcuffed = 3
var/const/slot_l_hand = 4
var/const/slot_r_hand = 5
var/const/slot_belt = 6
var/const/slot_wear_id = 7
var/const/slot_ears = 8
var/const/slot_glasses = 9
var/const/slot_gloves = 10
var/const/slot_head = 11
var/const/slot_shoes = 12
var/const/slot_wear_suit = 13
var/const/slot_w_uniform = 14
var/const/slot_l_store = 15
var/const/slot_r_store = 16
var/const/slot_s_store = 17
var/const/slot_in_backpack = 18
var/const/slot_legcuffed = 19

//Cant seem to find a mob bitflags area other than the powers one

// bitflags for clothing parts
var/const/HEAD = 1
var/const/UPPER_TORSO = 2
var/const/LOWER_TORSO = 4
var/const/LEG_LEFT = 8
var/const/LEG_RIGHT = 16
var/const/LEGS = 24
var/const/FOOT_LEFT = 32
var/const/FOOT_RIGHT = 64
var/const/FEET = 96
var/const/ARM_LEFT = 128
var/const/ARM_RIGHT = 256
var/const/ARMS = 384
var/const/HAND_LEFT = 512
var/const/HAND_RIGHT = 1024
var/const/HANDS = 1536
var/const/FULL_BODY = 2047

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
var/const/THERMAL_PROTECTION_HEAD = 0.3
var/const/THERMAL_PROTECTION_UPPER_TORSO = 0.15
var/const/THERMAL_PROTECTION_LOWER_TORSO = 0.15
var/const/THERMAL_PROTECTION_LEG_LEFT = 0.075
var/const/THERMAL_PROTECTION_LEG_RIGHT = 0.075
var/const/THERMAL_PROTECTION_FOOT_LEFT = 0.025
var/const/THERMAL_PROTECTION_FOOT_RIGHT = 0.025
var/const/THERMAL_PROTECTION_ARM_LEFT = 0.075
var/const/THERMAL_PROTECTION_ARM_RIGHT = 0.075
var/const/THERMAL_PROTECTION_HAND_LEFT = 0.025
var/const/THERMAL_PROTECTION_HAND_RIGHT = 0.025

// String identifiers for associative list lookup

// mob/var/list/mutations

var/const/STRUCDNASIZE = 27
var/const/UNIDNASIZE = 13

	// Generic mutations:
var/const/TK = 1
var/const/COLD_RESISTANCE = 2
var/const/XRAY = 3
var/const/HULK = 4
var/const/CLUMSY = 5
var/const/FAT = 6
var/const/HUSK = 7
var/const/NOCLONE = 8
var/const/LASER = 9 	// harm intent - click anywhere to shoot lasers from eyes
var/const/HEAL = 10 	// healing people with hands

	//2spooky
var/const/SKELETON = 29
var/const/PLANT = 30

// Other Mutations:
var/const/mNobreath = 100 	// no need to breathe
var/const/mRemote = 101 	// remote viewing
var/const/mRegen = 102 	// health regen
var/const/mRun = 103 	// no slowdown
var/const/mRemotetalk = 104 	// remote talking
var/const/mMorph = 105 	// changing appearance
var/const/mBlend = 106 	// nothing (seriously nothing)
var/const/mHallucination = 107 	// hallucinations
var/const/mFingerprints = 108 	// no fingerprints
var/const/mShock = 109 	// insulated hands
var/const/mSmallsize = 110 	// table climbing

//disabilities
var/const/NEARSIGHTED = 1
var/const/EPILEPSY = 2
var/const/COUGHING = 4
var/const/TOURETTES = 8
var/const/NERVOUS = 16

//sdisabilities
var/const/BOTH_EYES_BLIND = 1
var/const/MUTE = 2
var/const/DEAF = 4

//mob/var/stat things
var/const/CONSCIOUS = 0
var/const/UNCONSCIOUS = 1
var/const/DEAD = 2

// channel numbers for power
var/const/EQUIP = 1
var/const/LIGHT = 2
var/const/ENVIRON = 3
var/const/TOTAL = 4	//for total power used only

// bitflags for machine stat variable
var/const/BROKEN = 1
var/const/NOPOWER = 2
var/const/POWEROFF = 4		// tbd
var/const/MAINT = 8			// under maintaince
var/const/EMPED = 16		// temporary broken by EMP pulse

//bitflags for door switches.
var/const/OPEN = 1
var/const/IDSCAN = 2
var/const/BOLTS = 4
var/const/SHOCK = 8
var/const/SAFE = 16

var/const/ENGINE_EJECT_Z = 3

//metal, glass, rod stacks
var/const/MAX_STACK_AMOUNT_METAL = 50
var/const/MAX_STACK_AMOUNT_GLASS = 50
var/const/MAX_STACK_AMOUNT_RODS = 60

var/const/GAS_O2 = (1 << 0)
var/const/GAS_N2 = (1 << 1)
var/const/GAS_PL = (1 << 2)
var/const/GAS_CO2 = (1 << 3)
var/const/GAS_N2O = (1 << 4)

//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
//(Exceptions: extended, sandbox and nuke) -Errorage
//Was list("3" = 30, "4" = 70)
var/list/accessable_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60)

var/list/global_mutations = list() // list of hidden mutation things

//I hate adding defines like this but I'd much rather deal with bitflags than lists and string searches
var/const/BRUTELOSS = 1
var/const/FIRELOSS =  2
var/const/TOXLOSS = 4
var/const/OXYLOSS = 8

//Bitflags defining which status effects could be or are inflicted on a mob
var/const/CANSTUN = 1
var/const/CANWEAKEN = 2
var/const/CANPARALYSE = 4
var/const/CANPUSH = 8
var/const/GODMODE = 4096
var/const/FAKEDEATH = 8192	//Replaces stuff like changeling.changeling_fakedeath
var/const/DISFIGURED = 16384	//I'll probably move this elsewhere if I ever get wround to writing a bitflag mob-damage system
var/const/XENO_HOST = 32768	//Tracks whether we're gonna be a baby alien's mummy.

var/static/list/scarySounds = list('sound/weapons/thudswoosh.ogg','sound/weapons/Taser.ogg','sound/weapons/armbomb.ogg','sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg','sound/voice/hiss5.ogg','sound/voice/hiss6.ogg','sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg','sound/items/Welder.ogg','sound/items/Welder2.ogg','sound/machines/airlock.ogg','sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')

//Security levels
var/const/SEC_LEVEL_GREEN = 0
var/const/SEC_LEVEL_BLUE = 1
var/const/SEC_LEVEL_RED = 2
var/const/SEC_LEVEL_DELTA = 3

var/const/TRANSITIONEDGE = 7 //Distance from edge to move to another z-level

var/list/liftable_structures = list(\
	/obj/machinery/autolathe, \
	/obj/machinery/constructable_frame, \
	/obj/machinery/hydroponics, \
	/obj/machinery/computer, \
	/obj/machinery/optable, \
	/obj/structure/dispenser, \
	/obj/machinery/gibber, \
	/obj/machinery/microwave, \
	/obj/machinery/vending, \
	/obj/machinery/seed_extractor, \
	/obj/machinery/space_heater, \
	/obj/machinery/recharge_station, \
	/obj/machinery/flasher, \
	/obj/structure/stool, \
	/obj/structure/closet, \
	/obj/machinery/photocopier, \
	/obj/structure/filingcabinet, \
	/obj/structure/reagent_dispensers, \
	/obj/machinery/portable_atmospherics/canister)

//A set of constants used to determine which type of mute an admin wishes to apply:
//Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO etc = (MUTE_IC << 1)
//Therefore there needs to be a gap between the flags for the automute flags
var/const/MUTE_IC = 1
var/const/MUTE_OOC = 2
var/const/MUTE_PRAY = 4
var/const/MUTE_ADMINHELP = 8
var/const/MUTE_DEADCHAT = 16
var/const/MUTE_ALL = 31

//Number of identical messages required to get the spam-prevention automute thing to trigger warnings and automutes
var/const/SPAM_TRIGGER_WARNING = 5
var/const/SPAM_TRIGGER_AUTOMUTE = 10

var/const/SEE_INVISIBLE_MINIMUM = 5

var/const/SEE_INVISIBLE_OBSERVER_NOLIGHTING = 15

var/const/INVISIBILITY_LIGHTING = 20

var/const/SEE_INVISIBLE_LIVING = 25

var/const/SEE_INVISIBLE_LEVEL_ONE = 35	//Used by some stuff in code. It's really poorly organized.
var/const/INVISIBILITY_LEVEL_ONE = 35	//Used by some stuff in code. It's really poorly organized.

var/const/SEE_INVISIBLE_LEVEL_TWO = 45	//Used by some other stuff in code. It's really poorly organized.
var/const/INVISIBILITY_LEVEL_TWO = 45	//Used by some other stuff in code. It's really poorly organized.

var/const/INVISIBILITY_OBSERVER = 60
var/const/SEE_INVISIBLE_OBSERVER = 60

var/const/INVISIBILITY_MAXIMUM = 100

//Object specific defines
var/const/CANDLE_LUM = 3 //For how bright candles are


//Some mob defines below
var/const/AI_CAMERA_LUMINOSITY = 6

var/const/BORGMESON = 1
var/const/BORGTHERM = 2
var/const/BORGXRAY = 4

//some arbitrary defines to be used by self-pruning global lists. (see master_controller)
var/const/PROCESS_KILL = 26	//Used to trigger removal from a processing list

// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.
var/list/TAGGERLOCATIONS = list(
	"Disposals", "Clown Office", "Internal Affairs", "Psych. Office", "Chaplain's Office",
	"Library", "Hydroponics", "Kitchen", "Bar", "Custodial Closet",
	"CE's Office", "Engineering Breakroom", "Atmo. Office", "Warden's Office", "Security",
	"HoS's Office", "Detective's Office", "HoP's Office", "Captain's Office", "Medical Breakroom",
	"CMO's Office", "Genetics", "Research Breakroom", "RD's Office", "Robotics",
	"Quartermaster's Office")

var/const/HOSTILE_STANCE_IDLE = 1
var/const/HOSTILE_STANCE_ALERT = 2
var/const/HOSTILE_STANCE_ATTACK = 3
var/const/HOSTILE_STANCE_ATTACKING = 4
var/const/HOSTILE_STANCE_TIRED = 5

var/const/ROUNDSTART_LOGOUT_REPORT_TIME = 6000 //Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

//Damage things

var/const/CUT = "cut"
var/const/BRUISE = "bruise"
var/const/BRUTE = "brute"
var/const/BURN = "fire"
var/const/TOX = "tox"
var/const/OXY = "oxy"
var/const/CLONE = "clone"
var/const/HALLOSS = "halloss"

var/const/STUN = "stun"
var/const/WEAKEN = "weaken"
var/const/PARALYZE = "paralize"
var/const/IRRADIATE = "irradiate"
var/const/STUTTER = "stutter"
var/const/SLUR = "slur"
var/const/EYE_BLUR = "eye_blur"
var/const/DROWSY = "drowsy"
var/const/AGONY = "agony" // Added in PAIN!

///////////////////ORGAN DEFINES///////////////////

var/const/ORGAN_CUT_AWAY = 1
var/const/ORGAN_GAUZED = 2
var/const/ORGAN_ATTACHABLE = 4
var/const/ORGAN_BLEEDING = 8
var/const/ORGAN_BROKEN = 32
var/const/ORGAN_DESTROYED = 64
var/const/ORGAN_ROBOT = 128
var/const/ORGAN_SPLINTED = 256
var/const/SALVED = 512
var/const/ORGAN_DEAD = 1024
var/const/ORGAN_MUTATED = 2048

//Please don't edit these values without speaking to Errorage first	~Carn
//Admin Permissions
var/const/R_BUILDMODE = 1
var/const/R_ADMIN = 2
var/const/R_BAN = 4
var/const/R_FUN = 8
var/const/R_SERVER = 16
var/const/R_DEBUG = 32
var/const/R_POSSESS = 64
var/const/R_PERMISSIONS = 128
var/const/R_STEALTH = 256
var/const/R_REJUVINATE = 512
var/const/R_VAREDIT = 1024
var/const/R_SOUNDS = 2048
var/const/R_SPAWN = 4096
var/const/R_MOD = 8192

var/const/R_MAXPERMISSION = 8192 //This holds the maximum value for a permission. It is used in iteration, so keep it updated.

var/const/R_HOST = 65535

//Preference toggles
var/const/SOUND_ADMINHELP = 1
var/const/SOUND_MIDI = 2
var/const/SOUND_AMBIENCE = 4
var/const/SOUND_LOBBY = 8
var/const/CHAT_OOC = 16
var/const/CHAT_DEAD = 32
var/const/CHAT_GHOSTEARS = 64
var/const/CHAT_GHOSTSIGHT = 128
var/const/CHAT_PRAYER = 256
var/const/CHAT_RADIO = 512
var/const/CHAT_ATTACKLOGS = 1024
var/const/CHAT_DEBUGLOGS = 2048
var/const/CHAT_LOOC = 4096


var/const/TOGGLES_DEFAULT = (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_ATTACKLOGS|CHAT_LOOC)

var/const/BE_TRAITOR = 1
var/const/BE_OPERATIVE = 2
var/const/BE_CHANGELING = 4
var/const/BE_WIZARD = 8
var/const/BE_MALF = 16
var/const/BE_REV = 32
var/const/BE_ALIEN = 64
var/const/BE_PAI = 128
var/const/BE_CULTIST = 256
var/const/BE_MONKEY = 512
var/const/BE_NINJA = 1024
var/const/BE_RAIDER = 2048
var/const/BE_PLANT = 4096

var/list/be_special_flags = list(
	"Traitor" = BE_TRAITOR,
	"Operative" = BE_OPERATIVE,
	"Changeling" = BE_CHANGELING,
	"Wizard" = BE_WIZARD,
	"Malf AI" = BE_MALF,
	"Revolutionary" = BE_REV,
	"Xenomorph" = BE_ALIEN,
	"pAI" = BE_PAI,
	"Cultist" = BE_CULTIST,
	"Monkey" = BE_MONKEY,
	"Ninja" = BE_NINJA,
	"Raider" = BE_RAIDER,
	"Diona" = BE_PLANT
	)

var/const/AGE_MIN = 17			//youngest a character can be
var/const/AGE_MAX = 85			//oldest a character can be

//Languages!
var/const/LANGUAGE_HUMAN = 1
var/const/LANGUAGE_ALIEN = 2
var/const/LANGUAGE_DOG = 4
var/const/LANGUAGE_CAT = 8
var/const/LANGUAGE_BINARY = 16
var/const/LANGUAGE_OTHER = 32768

var/const/LANGUAGE_UNIVERSAL = 65535

var/const/LEFT = 1
var/const/RIGHT = 2

// for secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list of humans.
var/const/HEALTH_HUD = 1 // dead, alive, sick, health status
var/const/STATUS_HUD = 2 // a simple line rounding the mob's number health
var/const/ID_HUD = 3 // the job asigned to your ID
var/const/WANTED_HUD = 4 // wanted, released, parroled, security status
var/const/IMPLOYAL_HUD = 5 // loyality implant
var/const/IMPCHEM_HUD = 6 // chemical implant
var/const/IMPTRACK_HUD = 7 // tracking implant

//Pulse levels, very simplified
var/const/PULSE_NONE = 0	//so !M.pulse checks would be possible
var/const/PULSE_SLOW = 1	//<60 bpm
var/const/PULSE_NORM = 2	//60-90 bpm
var/const/PULSE_FAST = 3	//90-120 bpm
var/const/PULSE_2FAST = 4	//>120 bpm
var/const/PULSE_THREADY = 5	//occurs during hypovolemic shock
//feel free to add shit to lists below
var/list/tachycardics = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine")	//increase heart rate
var/list/bradycardics = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")					//decrease heart rate

//proc/get_pulse methods
var/const/GETPULSE_HAND = 0	//less accurate (hand)
var/const/GETPULSE_TOOL = 1	//more accurate (med scanner, sleeper, etc)

var/list/RESTRICTED_CAMERA_NETWORKS = list( //Those networks can only be accessed by preexisting terminals. AIs and new terminals can't use them.
	"thunder",
	"ERT",
	"NUKE"
	)

//Species flags.
var/const/NO_EAT = 1
var/const/NO_BREATHE = 2
var/const/NO_SLEEP = 4
var/const/NO_SHOCK = 8
var/const/NO_SCAN = 16
var/const/NON_GENDERED = 32
var/const/REQUIRE_LIGHT = 64
var/const/WHITELISTED = 128
var/const/HAS_SKIN_TONE = 256
var/const/HAS_LIPS = 512
var/const/HAS_UNDERWEAR = 1024
var/const/HAS_TAIL = 2048
var/const/IS_PLANT = 4096

//Language flags.
var/const/WHITELISTED_LANG = 1  // Language is available if the speaker is whitelisted.
var/const/RESTRICTED_LANG = 2   // Language can only be accquired by spawning or an admin.
