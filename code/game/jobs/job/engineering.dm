/datum/job/chief_engineer
	title = "Chief Engineer"
	titleFlag = T_CHIEF_ENG
	countsAsPlayedInDept = T_COMMAND
	minimumTimesAsEngineering = 3
	flag = CHIEF
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffeeaa"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINTENANCE,
			            ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_CHANGE_IDS,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINTENANCE,
			            ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EVA,
			            ACCESS_HEADS, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS, ACCESS_CHANGE_IDS,
			            ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_SHUTTLE)
	minimal_player_age = 1


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/ce(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_engineer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/ce(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yellow(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/white(H), slot_head)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
		return 1

/datum/job/engineer
	title = "Station Engineer"
	titleFlag = T_ENGINEER
	countsAsPlayedInDept = T_ENGINEERING
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINTENANCE,
			ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_TCOMSAT, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINTENANCE,
			ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_TCOMSAT, ACCESS_SHUTTLE)
	alt_titles = list("Maintenance Technician","Engine Technician","Electrician")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yellow(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/device/pda/engineering(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
		return 1

/datum/job/atmos
	title = "Atmospheric Technician"
	titleFlag = T_ATMOS_TECH
	countsAsPlayedInDept = T_ENGINEERING
	minimumTimesAsEngineering = 1
	flag = ATMOSTECH
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	access = list(ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINTENANCE,
			ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS, ACCESS_TCOMSAT, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE, ACCESS_MAINTENANCE, ACCESS_CONSTRUCTION, ACCESS_SHUTTLE)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/atmospheric_technician(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yellow(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/atmos(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
		return 1