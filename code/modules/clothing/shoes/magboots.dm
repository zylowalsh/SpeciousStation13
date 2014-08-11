/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	var/magpulse = 0
//	flags = NO_SLIP //disabled by default


	verb/toggle()
		set name = "Toggle Magboots"
		set category = "Object"
		set src in usr
		if(usr.stat)
			return
		if(src.magpulse)
			src.flags &= ~NO_SLIP
			src.slowdown = SHOES_SLOWDOWN
			src.magpulse = 0
			icon_state = "magboots0"
			usr << "You disable the mag-pulse traction system."
		else
			src.flags |= NO_SLIP
			src.slowdown = 2
			src.magpulse = 1
			icon_state = "magboots1"
			usr << "You enable the mag-pulse traction system."
		usr.update_inv_shoes()	//so our mob-overlays update


	examine()
		set src in view()
		..()
		var/state = "disabled"
		if(src.flags&NO_SLIP)
			state = "enabled"
		usr << "Its mag-pulse traction system appears to be [state]."