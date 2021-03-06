/obj/structure/closet/secure_closet/chief_engineer
	name = "chief engineer's locker"
	req_access = list(ACCESS_CE)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"

	New()
		..()
		sleep(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)

		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/clothing/head/hardhat/white(src)
		new /obj/item/clothing/shoes/yellow(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/under/rank/chief_engineer(src)
		new /obj/item/device/radio/headset/heads/ce(src)

		new /obj/item/weapon/cartridge/ce(src)
		new /obj/item/weapon/storage/belt/utility/full(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/flash(src)

/obj/structure/closet/secure_closet/engineer
	name = "station engineer's locker"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

	New()
		..()
		sleep(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)

		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/clothing/head/hardhat(src)
		new /obj/item/clothing/shoes/yellow(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/under/rank/engineer(src)
		new /obj/item/device/radio/headset/headset_eng(src)

		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/weapon/cartridge/engineering(src)
		new /obj/item/weapon/storage/belt/utility/full(src)


/obj/structure/closet/secure_closet/atmos
	name = "atmospheric technician's locker"
	req_access = list(ACCESS_ENGINE_EQUIP)

	New()
		..()
		sleep(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)

		new /obj/item/clothing/shoes/yellow(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/under/rank/atmospheric_technician(src)
		new /obj/item/device/radio/headset/headset_eng(src)

		new /obj/item/weapon/cartridge/atmos(src)
		new /obj/item/weapon/storage/belt/utility/atmostech(src)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "Electrical Supplies"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/multitool(src)

/obj/structure/closet/secure_closet/engineering_welding
	name = "Welding Supplies"
	req_access = list(ACCESS_ENGINE_EQUIP)
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)

