All mappers need to follow these rules, if you want your edits to be commited.

- Do not map unless you can read the code and be able to do simple code changes(like changing an object's
	initial vars). Several machines require you to set their vars correctly! While looking at existing examples may
	help, it will not substitute actually knowing what the machine does like how it sets its vars in its various
	states.  
- It is also expected that you fully understand the power and atmos systems.  You cannot do any sizeable edits
	without messing with these systems.
- Always test your edits! You will make mistakes, a lot of stupid mistakes.  Mapping is tedious at best and you will
	forget stuff.
- Only put one APC per area. It causes logic errors you won't see unless the power goes out.
- The cycling airlocks that use vents (like the external airlocks) cannot be in an area with an air alarm.  The air 
	alarm will mess with vents and the cycling airlock controller will get confused because it is poorly coded and
	tracks the states of the doors and vents without checking if the doors' or vents' states have changed.
- Try to keep an area connected in one blob except for rare cases like the external airlocks area.  If you have to 
	separate an area, it would be best to just make a new area.  An exception may be if the separated bit is too small
	to fit an APC, air alarm, the vents and scrubber and whatever else needs to be in the room.
- Do not use unsimulated turf unless you know what you are doing. Also don't connect it with simulated turf.  It will
	cause weird bugs like the air getting vented out of simulated areas.
- Do not set the any of the atmo related vars on the turf.  It is a pain to find and fix, if yourself or someone else
	uses your basic floor variant without any indication that you have made it airless. If you have to set the atmo 
	vars, it is best if you create a child class of the turf you want and change the vars with that.
- Note: There are legacy turfs on the map that may still have the atmos related vars set on them without having a
	separate class name.  Mainly, they are the turfs like the ones in the atmo's air storage tanks but may exist in
	other places.
- When using plating, make sure it isn't airless.  It is common to copy the plating around the solars and use it in
	a maintenance tunnel edit.  Do not do that!
- When deciding what area belongs with a wall ask this question "If a security guard came across that wall broken, 
	what would be their first area would they think has been breached?"
- Trash pipes and power cables go through maintence and the disto and waste pipes go through the main halls.  
	Exceptions are common.
- Wires should not be looped.
- Use the debug admin tools when testing or write your own esp. with stuff that has a lot of objects.  Trust me, it
	helps your sanity.
- When designing new rooms, make sure you design your atmos system correctly.  Do not leave isolated bits that do not
	have vents or scrubbers.  
- If you put firedoors down, just put them on the border of the /area and under airlocks if possible.  Also, you
	can put them alone in the middle of large areas (like hallways) to prevent the whole area from de-pressurizing.
	You may place them under space bordering windows but personally, I'd avoid that if possible. By placing 
	firedoors in the middle of large areas, it will create pockets of air(or lack of) that the air alarms cannot 
	detect. Understand that the air alarms are stupid. They cannot detect if an area is open to space or if an 
	neighbouring area is venting it (ex. an assistant opening a maintenance tunnel that has been breached). In 
	addition, note that if there are multiple air alarms in one area, they may conflict. They can order all the 
	firedoors in an area open when their pocket of air is normal although other pockets may be de-pressurized. 
	Because of these reasons, you should only put firedoors on the border of an /area. This may be fixed or worked
	around in the future but at the moment this is how they work.

	
