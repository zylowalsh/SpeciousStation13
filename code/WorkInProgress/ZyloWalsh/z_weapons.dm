/obj/item/ammo_magazine/a762_bk48
	name = "magazine (7.62mm)"
	icon = 'icons/obj/ammo/a762_bk48.dmi'
	icon_state = "full"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/a762"
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/a762_bk48/empty
	name = "magazine (7.62mm)"
	icon = 'icons/obj/ammo/a762_bk48.dmi'
	icon_state = "empty"
	ammo_type = "/obj/item/ammo_casing/a762"
	max_ammo = 0

/obj/item/weapon/gun/projectile/automatic/bk48
	name = "\improper BK-48"
	desc = "This weapon embodies the great Motherland."
	icon = 'icons/obj/guns/bk48.dmi'
	item_state = "loaded"
	icon_state = "c20r"
	w_class = 3.0
	max_shells = 30
	caliber = "a762"
	origin_tech = "combat=5;materials=2;syndicate=6"
	ammo_type = "/obj/item/ammo_casing/a762"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = 2


	New()
		..()
		empty_mag = new /obj/item/ammo_magazine/a12mm/empty(src)
		update_icon()
		return


	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
		..()
		if(!loaded.len && empty_mag)
			empty_mag.loc = get_turf(src.loc)
			empty_mag = null
			update_icon()
		return


	update_icon()
		..()
		if(empty_mag)
			icon_state = "loaded"
		else
			icon_state = "empty"
		return