/datum/job/rd
	title = "Research Director"
	titleFlag = T_RD
	countsAsPlayedInDept = T_COMMAND
	minimumTimesAsResearch = 3
	flag = RD
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOXIN, ACCESS_GENETICS, ACCESS_MORGUE, ACCESS_TECH_STORAGE,
		    ACCESS_TOXIN_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS, ACCESS_CHANGE_IDS,ACCESS_RESEARCH,
		    ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH,
		    ACCESS_XENOARCH,ACCESS_EXTERNAL_AIRLOCKS, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_RD, ACCESS_HEADS, ACCESS_TOXIN, ACCESS_GENETICS, ACCESS_MORGUE, ACCESS_TECH_STORAGE,
            ACCESS_TOXIN_STORAGE, ACCESS_TELEPORTER, ACCESS_SEC_DOORS, ACCESS_CHANGE_IDS, ACCESS_RESEARCH,
            ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_AI_UPLOAD, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH,
            ACCESS_XENOARCH, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_player_age = 1

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/rd(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/research_director(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/rd(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/scientist
	title = "Scientist"
	titleFlag = T_SCIENTIST
	countsAsPlayedInDept = T_RESEARCH
	flag = SCIENTIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the research director"
	selection_color = "#ffeeff"
	access = list(ACCESS_ROBOTICS, ACCESS_TOXIN, ACCESS_TOXIN_STORAGE, ACCESS_TECH_STORAGE, ACCESS_MORGUE,
			ACCESS_RESEARCH, ACCESS_XENOARCH, ACCESS_XENOBIOLOGY, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_AI_UPLOAD,
			ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_TOXIN, ACCESS_TOXIN_STORAGE, ACCESS_RESEARCH, ACCESS_XENOARCH,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SHUTTLE)
	alt_titles = list("Xenoarcheologist", "Anomalist", "Plasma Researcher")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/toxins(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/science(H), slot_wear_suit)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/xenobiologist
	title = "Xenobiologist"
	titleFlag = T_XENOBIOLOGIST
	countsAsPlayedInDept = T_RESEARCH
	flag = XENOBIOLOGIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#ffeeff"
	access = list(ACCESS_ROBOTICS, ACCESS_TOXIN, ACCESS_TOXIN_STORAGE, ACCESS_TECH_STORAGE, ACCESS_MORGUE,
			ACCESS_RESEARCH, ACCESS_XENOARCH, ACCESS_XENOBIOLOGY, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_AI_UPLOAD,
			ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_RESEARCH, ACCESS_XENOBIOLOGY)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/toxins(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), slot_wear_suit)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1


/datum/job/roboticist
	title = "Roboticist"
	titleFlag = T_ROBOTICIST
	countsAsPlayedInDept = T_RESEARCH
	flag = ROBOTICIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#ffeeff"
	access = list(ACCESS_ROBOTICS, ACCESS_TOXIN, ACCESS_TOXIN_STORAGE, ACCESS_TECH_STORAGE, ACCESS_MORGUE,
			ACCESS_RESEARCH, ACCESS_XENOARCH, ACCESS_XENOBIOLOGY, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_AI_UPLOAD,
			ACCESS_SHUTTLE) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(ACCESS_ROBOTICS, ACCESS_TECH_STORAGE, ACCESS_AI_UPLOAD, ACCESS_MORGUE, ACCESS_RESEARCH) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_ears)
		if(H.backbag == 2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(H.backbag == 3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/roboticist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/roboticist(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat(H), slot_wear_suit)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1