var/checked_for_inactives = 0
var/inactive_keys = "None<br>"

/client/proc/check_customitem_activity()
	set category = "Admin"
	set name = "Check activity of players with custom items"

	var/dat = "<b>Inactive players with custom items</b><br>"
	dat += "<br>"
	dat += "The list below contains players with custom items that have not logged\
	 in for the past two months, or have not logged in since this system was implemented.\
	 This system requires the feedback SQL database to be properly setup and linked.<br>"
	dat += "<br>"
	dat += "Populating this list is done automatically, but must be manually triggered on a per\
	 round basis. Populating the list may cause a lag spike, so use it sparingly.<br>"
	dat += "<hr>"
	if(checked_for_inactives)
		dat += inactive_keys
		dat += "<hr>"
		dat += "This system was implemented on March 1 2013, and the database a few days before that. Root server access is required to add or disable access to specific custom items.<br>"
	else
		dat += "<a href='?src=\ref[src];_src_=holder;populate_inactive_customitems=1'>Populate list (requires an active database connection)</a><br>"

	usr << browse(dat, "window=inactive_customitems;size=600x480")

