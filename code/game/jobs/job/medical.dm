/datum/job/cmo
	title = "Chief Medical Officer"
	titleFlag = T_CMO
	countsAsPlayedInDept = T_COMMAND
	minimumTimesAsMedical = 3
	flag = CMO
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_HEADS, ACCESS_CHANGE_IDS,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_HEADS, ACCESS_CHANGE_IDS,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_player_age = 1

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/cmo(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_medical_officer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/cmo(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/cmo(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/doctor
	title = "Medical Doctor"
	titleFlag = T_DOCTOR
	countsAsPlayedInDept = T_MEDICAL
	minimumTimesAsMedical = 1
	flag = DOCTOR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY,
			ACCESS_GENETICS, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_VIROLOGY, ACCESS_CHEMISTRY)
	alt_titles = list("Surgeon", "Nurse", "Virologist", "Pharmacist")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/doctor(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/doctor(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/emt
	title = "Emergency Medical Technician"
	titleFlag = T_EMT
	countsAsPlayedInDept = T_MEDICAL
	flag = CHEMIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_EVA, ACCESS_SHUTTLE)

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/emt(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/emt(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/fr_jacket(H), slot_wear_suit)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/datum/job/geneticist
	title = "Geneticist"
	titleFlag = T_GENETICIST
	countsAsPlayedInDept = T_MEDICAL
	minimumTimesAsMedical = 1
	flag = GENETICIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer and research director"
	selection_color = "#ffeef0"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY,
			ACCESS_GENETICS, ACCESS_RESEARCH, ACCESS_PSYCHIATRIST, ACCESS_EVA, ACCESS_SHUTTLE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_RESEARCH)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_medsci(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/geneticist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/geneticist(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/genetics(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1

/*/datum/job/virologist
	title = "Virologist"
	flag = VIROLOGIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_VIROLOGY)
	alt_titles = list("Pathologist","Microbiologist")

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/viro(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/labcoat/virologist(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1*/

/datum/job/psychiatrist
	title = "Psychiatrist"
	titleFlag = T_PSYCHIATRIST
	countsAsPlayedInDept = T_MEDICAL
	flag = PSYCHIATRIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PSYCHIATRIST)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_PSYCHIATRIST)
	alt_titles = list("Psychologist")

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_ears)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/psychiatrist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1
