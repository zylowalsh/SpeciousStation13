//Food
/datum/job/bartender
	title = "Bartender"
	titleFlag = T_BARTENDER
	countsAsPlayedInDept = T_CIVILIAN
	flag = BARTENDER
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_BAR)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/bartender(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/bar(H), slot_belt)

		if(H.backbag == 1)
			var/obj/item/weapon/storage/box/survival/Barpack = new /obj/item/weapon/storage/box/survival(H)
			H.equip_to_slot_or_del(Barpack, slot_r_hand)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
		return 1

/datum/job/chef
	title = "Chef"
	titleFlag = T_CHEF
	countsAsPlayedInDept = T_CIVILIAN
	flag = CHEF
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_KITCHEN)
	alt_titles = list("Cook")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/pda/chef(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/hydro
	title = "Botanist"
	titleFlag = T_BOTANIST
	countsAsPlayedInDept = T_CIVILIAN
	flag = BOTANIST
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MORGUE) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
	alt_titles = list("Hydroponicist")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/analyzer/plant_analyzer(H), slot_s_store)
		H.equip_to_slot_or_del(new /obj/item/device/pda/botanist(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

//Cargo
/datum/job/qm
	title = "Quartermaster"
	titleFlag = T_QUARTERMASTER
	countsAsPlayedInDept = T_CIVILIAN
	minimumTimesAsCivilian = 1
	flag = QUARTERMASTER
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_MAINTENANCE, ACCESS_MAIL_SORTING, ACCESS_CARGO, ACCESS_QM,
			ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MAINTENANCE, ACCESS_MAIL_SORTING, ACCESS_CARGO, ACCESS_QM,
			ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SHUTTLE)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargo(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/quartermaster(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/cargo_tech
	title = "Cargo Technician"
	titleFlag = T_CARGO_TECH
	countsAsPlayedInDept = T_CIVILIAN
	flag = CARGOTECH
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_MAINTENANCE, ACCESS_MAIL_SORTING, ACCESS_CARGO, ACCESS_MINING,
			ACCESS_MINING_STATION, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MAINTENANCE, ACCESS_CARGO, ACCESS_MAIL_SORTING)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/cargo(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/mining
	title = "Shaft Miner"
	titleFlag = T_MINER
	countsAsPlayedInDept = T_CIVILIAN
	flag = MINER
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_MAINTENANCE, ACCESS_MAIL_SORTING, ACCESS_CARGO, ACCESS_MINING,
		ACCESS_MINING_STATION, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MAIL_SORTING, ACCESS_EXTERNAL_AIRLOCKS,
		ACCESS_SHUTTLE)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo (H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/shaftminer(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_in_backpack)
		return 1

/datum/job/clown
	title = "Clown"
	titleFlag = T_CLOWN
	countsAsPlayedInDept = T_CIVILIAN
	minimumTimesAsCivilian = 1
	flag = CLOWN
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/clown
	access = list(ACCESS_CLOWN, ACCESS_MAINTENANCE)
	minimal_access = list(ACCESS_CLOWN)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/clown(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/clown(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/voice/clown_hat(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/toy/crayon/rainbow(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/crayons(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/toy/waterflower(H), slot_in_backpack)
		H.mutations.Add(CLUMSY)
		return 1

//Griff //BS12 EDIT
/*
/datum/job/mime
	title = "Mime"
	flag = MIME
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(access_mime, access_theatre, ACCESS_MAINTENANCE)
	minimal_access = list(access_mime, access_theatre)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		if(H.backbag == 2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(H.backbag == 3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/mime(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/mime(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mime(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/suspenders(H), slot_wear_suit)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/toy/crayon/mime(H), slot_l_store)
			H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/toy/crayon/mime(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(H), slot_in_backpack)
		H.verbs += /client/proc/mimespeak
		H.verbs += /client/proc/mimewall
		H.mind.special_verbs += /client/proc/mimespeak
		H.mind.special_verbs += /client/proc/mimewall
		H.miming = 1
		return 1
*/

/datum/job/janitor
	title = "Janitor"
	titleFlag = T_JANITOR
	countsAsPlayedInDept = T_CIVILIAN
	flag = JANITOR
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_JANITOR, ACCESS_MAINTENANCE)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINTENANCE)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/janitor(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/key(H), slot_l_store)
		return 1

/datum/job/librarian
	title = "Librarian"
	titleFlag = T_LIBRARIAN
	countsAsPlayedInDept = T_CIVILIAN
	flag = LIBRARIAN
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_LIBRARY, ACCESS_MAINTENANCE)
	minimal_access = list(ACCESS_LIBRARY)
	alt_titles = list("Journalist")

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/red(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/librarian(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/lawyer
	title = "Internal Affairs Agent"
	titleFlag = T_IAA
	countsAsPlayedInDept = T_SECURITY
	minimumTimesAsCivilian = 1
	minimumTimesAsSecurity = 2
	flag = LAWYER
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the captain"
	selection_color = "#dddddd"
	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS, ACCESS_MAINTENANCE, ACCESS_ENGINE, ACCESS_MEDICAL,
						ACCESS_RESEARCH, ACCESS_HEADS, ACCESS_MINING, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/internalaffairs(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/internalaffairs(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(H), slot_glasses)
		H.equip_to_slot_or_del(new /obj/item/device/pda/lawyer(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_l_hand)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		return 1


