
var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/CHIEF				=(1<<5)
var/const/ENGINEER			=(1<<6)
var/const/ATMOSTECH			=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)

var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/GENETICIST		=(1<<5)
var/const/VIROLOGIST		=(1<<6)
var/const/PSYCHIATRIST		=(1<<7)
var/const/ROBOTICIST		=(1<<8)
var/const/XENOBIOLOGIST		=(1<<9)

var/const/CIVILIAN			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/CLOWN				=(1<<11)
var/const/MIME				=(1<<12)
var/const/ASSISTANT			=(1<<13)

//Constants that are used for var/titleFlag.  Each one needs to be unique from other jobs. They are also locations in the list
//	numOfJobsPlayed.  It is in the modules/client/preferences.dm file.
var/const/T_CAPTAIN			= 1
var/const/T_IAA				= 2

var/const/T_HOS				= 3
var/const/T_WARDEN			= 4
var/const/T_DETECTIVE		= 5
var/const/T_OFFICER			= 6

var/const/T_CHIEF_ENG		= 7
var/const/T_ENGINEER		= 8
var/const/T_ATMOS_TECH		= 9

var/const/T_AI				= 10
var/const/T_CYBORG			= 11

var/const/T_RD				= 12
var/const/T_SCIENTIST		= 13
var/const/T_ROBOTICIST		= 14
var/const/T_XENOBIOLOGIST	= 15

var/const/T_CMO				= 16
var/const/T_EMT				= 17
var/const/T_DOCTOR			= 18
var/const/T_GENETICIST		= 19
var/const/T_PSYCHIATRIST	= 20

var/const/T_HOP				= 21
var/const/T_BARTENDER		= 22
var/const/T_BOTANIST		= 23
var/const/T_CHEF			= 24
var/const/T_JANITOR			= 25
var/const/T_LIBRARIAN		= 26
var/const/T_CHAPLAIN		= 27
var/const/T_CLOWN			= 28
var/const/T_ASSISTANT		= 29

var/const/T_QUARTERMASTER	= 30
var/const/T_CARGO_TECH		= 31
var/const/T_MINER			= 32

//Constants that are used by var/countsAsPlayedInDept
var/const/T_CIVILIAN		= 1
var/const/T_ENGINEERING		= 2
var/const/T_SECURITY		= 4
var/const/T_MEDICAL			= 8
var/const/T_RESEARCH		= 16
var/const/T_COMMAND			= 32
var/const/T_SILICON			= 64

var/list/assistant_occupations = list(
)

var/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"
)

var/list/engineering_positions = list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician",
)

var/list/medical_positions = list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",
	"Psychiatrist",
	"Emergency Medical Technician"
)

var/list/science_positions = list(
	"Research Director",
	"Scientist",
	"Geneticist",	//Part of both medical and science
	"Roboticist",
	"Xenobiologist"
)

var/list/civilian_positions = list(
	"Head of Personnel",
	"Bartender",
	"Botanist",
	"Chef",
	"Janitor",
	"Librarian",
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Assistant"
)

var/list/security_positions = list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer"
)

var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)

/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(!J)	continue
		if(J.title == job)
			titles = J.alt_titles

	return titles

