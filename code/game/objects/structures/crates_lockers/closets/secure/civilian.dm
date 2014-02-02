/obj/structure/closet/secure_closet/bartender
	name = "bartender's locker"
	req_access = list(access_bar)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/head/hairflower(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/suit/wcoat(src)
		new /obj/item/clothing/under/dress/dress_saloon(src)
		new /obj/item/clothing/under/rank/bartender(src)
		new /obj/item/clothing/under/sl_suit(src)
		new /obj/item/device/radio/headset(src)
		new /obj/item/weapon/storage/backpack(src)

		new /obj/item/clothing/suit/armor/vest(src)

/obj/structure/closet/secure_closet/chef
	name = "chef's closet"
	req_access = list(access_kitchen)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/head/chefhat(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/suit/chef(src)
		new /obj/item/clothing/under/rank/chef(src)
		new /obj/item/device/radio/headset(src)
		new /obj/item/weapon/storage/backpack(src)

/obj/structure/closet/secure_closet/hydro
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"

	New()
		..()
		sleep(2)
		switch(rand(1,2))
			if(1)
				new /obj/item/clothing/suit/apron(src)
			if(2)
				new /obj/item/clothing/suit/apron/overalls(src)

		new /obj/item/clothing/gloves/botanic_leather(src)
		new /obj/item/clothing/head/greenbandana(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/under/rank/hydroponics(src)
		new /obj/item/device/radio/headset(src)
		new /obj/item/weapon/storage/backpack(src)

		new /obj/item/weapon/storage/bag/plants(src)
		new /obj/item/device/analyzer/plant_analyzer(src)
		new /obj/item/weapon/minihoe(src)
		new /obj/item/weapon/hatchet(src)
		new /obj/item/weapon/bee_net(src)

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/soft(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/under/rank/cargo(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/weapon/storage/backpack(src)

		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/weapon/cartridge/quartermaster(src)

/obj/structure/closet/secure_closet/cargo_tech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

	New()
		..()
		sleep(2)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/soft(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/under/rank/cargotech(src)
		new /obj/item/device/radio/headset/headset_cargo(src)
		new /obj/item/weapon/storage/backpack(src)

		new /obj/item/weapon/cartridge/quartermaster(src)

/obj/structure/closet/secure_closet/mining
	name = "shaft miner's locker"
	req_access = list(access_mining)
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"

	New()
		..()
		sleep(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_eng(src)

		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/under/rank/miner(src)
		new /obj/item/device/radio/headset/headset_cargo(src)

		new /obj/item/weapon/storage/bag/ore(src)
		new /obj/item/device/flashlight/lantern(src)
		new /obj/item/clothing/glasses/meson(src)

/obj/structure/closet/secure_closet/clown
	name = "clown's locker"
	req_access = list(access_clown)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/mask/gas/voice/clown_hat(src)
		new /obj/item/clothing/shoes/clown_shoes(src)
		new /obj/item/clothing/under/rank/clown(src)
		new /obj/item/device/radio/headset/(src)
		new /obj/item/weapon/storage/backpack/clown(src)

		new /obj/item/toy/crayon/rainbow(src)
		new /obj/item/toy/waterflower(src)
		new /obj/item/weapon/bikehorn(src)
		new /obj/item/weapon/cartridge/clown(src)
		new /obj/item/weapon/storage/fancy/crayons(src)

/obj/structure/closet/secure_closet/janitor
	name = "janitor's locker"
	req_access = list(access_janitor)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/head/soft/purple(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/under/rank/janitor(src)
		new /obj/item/device/radio/headset/(src)
		new /obj/item/weapon/storage/backpack(src)

		new /obj/item/weapon/cartridge/janitor(src)
		new /obj/item/clothing/shoes/galoshes(src)

/obj/structure/closet/secure_closet/librarian
	name = "librarian's locker"
	req_access = list(access_library)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/under/suit_jacket/red(src)
		new /obj/item/clothing/under/suit_jacket/really_black(src)
		new /obj/item/clothing/under/suit_jacket/female(src)
		new /obj/item/device/radio/headset/(src)
		new /obj/item/weapon/storage/backpack(src)

/obj/structure/closet/secure_closet/lawyer
	name = "interal affairs agent's locker"
	req_access = list(access_lawyer)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/suit/storage/lawyer/bluejacket(src)
		new /obj/item/clothing/suit/storage/lawyer/purpjacket(src)
		new /obj/item/clothing/under/lawyer/female(src)
		new /obj/item/clothing/under/lawyer/black(src)
		new /obj/item/clothing/under/lawyer/bluesuit(src)
		new /obj/item/clothing/under/lawyer/purpsuit(src)
		new /obj/item/clothing/under/lawyer/red(src)
		new /obj/item/device/radio/headset/(src)
		new /obj/item/weapon/storage/backpack(src)

		new /obj/item/weapon/cartridge/lawyer(src)

/obj/structure/closet/secure_closet/chaplain
	name = "chaplain's locker"
	req_access = list(access_lawyer)

	New()
		..()
		sleep(2)
		new /obj/item/clothing/head/chaplain_hood(src)
		new /obj/item/clothing/head/nun_hood(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/suit/chaplain_hoodie(src)
		new /obj/item/clothing/suit/holidaypriest(src)
		new /obj/item/clothing/suit/nun(src)
		new /obj/item/clothing/under/rank/chaplain(src)
		new /obj/item/clothing/under/wedding/bride_white(src)
		new /obj/item/device/radio/headset/(src)
		new /obj/item/weapon/storage/backpack(src)
		new /obj/item/weapon/storage/backpack/cultpack (src)

		new /obj/item/weapon/storage/fancy/candle_box(src)
		new /obj/item/weapon/storage/fancy/candle_box(src)