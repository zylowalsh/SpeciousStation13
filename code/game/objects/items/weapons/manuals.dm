/*********************MANUALS (BOOKS)***********************/

/obj/item/weapon/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified

/obj/item/weapon/book/manual/basicLeadership
	name = "Basic Leadership"
	icon_state = "book4"
	author = "NT Training Division"
	title = "Basic Leadership"
	dat = {"
		This guide is intended mainly for new department heads that do not have much experience
		leading.  It may also be an useful reminder to experienced officers.  Let us be first tell
		you that you an important person.  You serve all crew-mates on your station esp. the ones
		directly under you.  Your success at serving your fellow crew-mates will determine the success
		of any mission given to you.  If you fail, your crew-mates may ignore you, they may fall
		asleep in the halls or they may even die.  The following tips will help you serve your crew-mates:<BR>
		<BR>
		1. Do Not Die - The first tip sounds easy but is an important one.  You cannot serve your crew-mates
		if you are dead.  Understand that making decisions that keep yourself alive does not mean you are a coward.<BR>
		2. Trust In Your Crew-mates - You should trust your crew-mates until they give you evidence not to trust
		them.  Keep in mind that you may serve several shifts together and they may become your boss.  Don't
		destroy your relationship with them.<BR>
		3. Know How To Give Orders - Keep your orders short, simple and directed to a specific person
		or group.  This is to avoid confusion.<BR>
		4. Understand What Your Department Does - In order to work as one station you need to know how
		your department fits into the bigger picture.  You should know what each job under you does.
		In addition, you should know job of the crew-mates above you.<BR>
		"}

/obj/item/weapon/book/manual/whenTheBossDies
	name = "When The Boss Dies"
	icon_state = "book5"
	author = "NT Training Division"
	title = "When The Boss Dies"
	dat = {"Losing a department head or the captain can and will be very jarring.  It is important
		that everyone understands who is next in line.  Generally, it follows rank.  If there is a
		tie, canidates should be evaluated based on prior job experience, if they were tardy for the
		current shift, williness to step up, and if they have be promoted before in the shift.  If a
		job requires prior experience, that job is considered a higher rank.  When a department head
		is the casualty, someone from the department should take command.  When the captain is the
		casualty, normally the head of personnel takes over but it may be any head.  The acting
		captain should look for a replacement for their previous job.
		"}

/obj/item/weapon/book/manual/abandoningTheStation
	name = "Abandoning The Station"
	icon_state = "book3"
	author = "NT Training Division"
	title = "Abandoning The Station"
	dat = {"It can be difficult determining when to abandon the station.  In most cases, station
		should be abandoned when there is no hope of the station returning to normal operations.
		This is usually happens when there are signigicant damage to the station, lost of leadership
		or massive casualties amoung the crew.
		"}

/obj/item/weapon/book/manual/templete
	name = "test"
	icon_state = "book3"
	author = "test"
	title = "test"
	dat = {"test test test"}

/obj/item/weapon/book/manual/medicalManualOne
	name = "A Guide to General Practitioning"
	icon_state = "medbook"
	author = "Aaron Perkins"
	title = "A Guide to General Practitioning"
	dat = {"<html><BIG> A Guide to General Practitioning. By: Aaron Perkins </BIG>
		<BIG> Table of Contents </BIG>
		<BR>
		<BR>

		1. Welcome to Medbay
		2. Civilians in Medbay
		3. So you just got your Doctorate
		4. General Practitioning
		5. Advanced Tips and Tricks
		<BR>
		<BR>
		<BR>
		<BR>

		<B><BIG> 1. Welcome to Medbay </B></BIG>
		<BR>

		<P> So, you have just walked into Medbay. Welcome to the place where wounds are healed and the dead can be revived. In this place you have at your disposal the ability to cure or cause almost any ailment the human body can withstand and more. You are likely here for one of three reasons. One, you work here; Two, you or someone you know has been injured or is sick; or Three, you want to blow the place up. This guide will help you through the finer details of doing those first two things. <P>
		<BR>

		<B><BIG> 2. Civilians in Medbay </B></BIG>
		<BR>

		<P> So if you don’t work here, and you’re in Medbay, you or someone close to you has been afflicted with some form of ailment. Be it bullets or space gibs, someone inside those doors is able to help you. <P>
		<P>At the bottom of the chain of command are Emergency Medical Technicians, or <ACRONYM>EMT</ACRONYM>s. They will likely be the first responders if you have injured coming into medbay. They usually carry first aid kits on them, and may have access to other medicines that they have been supplied from the higher ranking medical staff.<P>
		<P> Medical Doctors make up the bulk of the staff in Medbay. They may have a menagerie of different titles, but those usually just denote a specialty, and any of them should be able to help you with most anything you need.</P>
		<P> Psychologists are to the mind what Medical Doctors are to the body. Their purpose is to help you with whatever ails your mind. Feel free to speak to them about anything that bothers you.</P>
		<P> Geneticists are mostly there for research purposes, but they have one important purpose in Medbay. With naught but a scrap of flesh they can revive the dead. How they do this is a long and complicated process, and there is little that can stop it.</P>
		<P> The most powerful man in all of Medbay is the leader of the entire medical staff, the Chief Medical Officer. The <ACRONYM>CMO</ACRONYM> has access to all of Medbay, and is able to perform any of the jobs in Medbay if required. He can usually be found in his office, though he is often seen inside Medbay proper instructing the other staff.</P>
		<BR>

		<B><BIG> 3. So you just got your Doctorate </B></BIG>
		<P> If you are fresh out of University and are just stepping into a Medbay for the first time, there is a lot for you to take in all at once. Luckily, you almost always have a good amount of time before the place gets hectic. The <ACRONYM>EMT</ACRONYM>s will act as your first responders, and will start bring you the sick and injured eventually. Once you get ahold of a patient your first responsibility will be to figure out what exactly the issue is. </P>
		<P>A preliminary examination usually involves asking the patient what the issue is, however be warned <B> YOU ARE THE MEDICAL PROFESSIONAL </B> people can explain away almost anything, do not take what they say as gospel. You have a myriad of diagnostic tools on hand in Medbay. Your first response should be the medical scanner in your PDA. When you scan someone with a either a medical scanner or your PDA you will get a list of numbers that will look something like 0-0-0-0.The first number represents Suffocation damage, then Toxins, then Burns, Brute damage. High numbers are bad, 0’s are good. Normal body temperatures vary, but are usually around 37º C (98º F). Drastically different temperatures can be symptoms of diseases, which is Virology’s problem. </P>
		<P> After that if you cannot tell exactly tell what the issue is, or you think there may be more to the story, you should toss the patient into the body scanner. The body scanner is the large green sleeper with the red screen. This will give a <B> MUCH </B> more detailed synopsis of what is going on with the patient. Everything you need to know about the person to treat them is on that screen. Treatments are as varied as injuries, you need to know a good variety of fixes to common problems if you expect to be good at this position.</P>
		<BR>

		<B><BIG> 4. General Practitioning  </B></BIG>
		<BR>

		<P>Almost any injury can be solved with either the right pharmaceuticals or the right surgery, but those are a matter unto themselves, and require their own guides. The key to being a good Medical Doctor is knowing exactly what treatment is best for the given situation. Surgeries are end all brute force fixes for 90% of injuries, however they are also risky and difficult to do if one is not well trained. Meds on the other hand don’t heal things instantly, some take long times to work, some are more subtle, some heal without stopping the symptoms the patient is actually feeling, and to top that all off meds can’t fix everything. Regardless of that however, medicines are far less invasive and should be your go to way of solving things.</P>
		<P>If a patient is too far gone and would die on the operating table, and has injuries that meds can’t fix, then what you need is the cryopods . Cryopods, and to a lesser extent sleeper pods, are for people that require healing or meds while seriously injured. <B> If someone is about to die, do not immediately attempt surgery. Allow them time in the cryo pod to heal first. I have seen too many people die from the brute damage suffered on the operating table putting them over the edge.</B> </P>
		<BR>

		<B><BIG> 5. Advanced Tips and Tricks  </B></BIG>
		<BR>

		<P> Almost anything you find in the OR, or half of medbay really, can be substituted by things you find around the station. These are definitely lesser, and riskier, alternatives; only to be used in dire situations. Knowing these tricks can save someones life.</P>
		<BR>

		<P> Keep a syringe full of Cryoaxedone on you at all times. A wrenched showerhead can actually bring a persons body temperature low enough that it will begin working, making a ghetto cryotube out of any bathroom.</P>
		<BR>

		<P> A shard of glass can be used as a ghetto scalpel in emergencies, and a welding tool can be used as a cautery.</P>
		</html>"}

/obj/item/weapon/book/manual/medicalManualTwo
	name = "A Guide to Cutting People Open"
	icon_state = "medbook"
	author = "Aaron Perkins"
	title = "A Guide to Cutting People Open"
	dat = {"<html><BIG> A Guide to Cutting People Open.</BIG><BR>
		<BIG> Table of Contents </BIG>
		<BR>
		<BR>

		Preface<BR>
		1. Welcome to the OR<BR>
		2. Is surgery the correct choice<BR>
		3. Preparing <S>the Bodybag</S> the Operating room<BR>
		4. The finer points of human internal anatomy<BR>
		<BR>
		<BR>
		<BR>
		<BR>

		<B><BIG> Preface </B></BIG>
		<BR>

		<P> This is a guide to surgery intended for the eyes of advanced medical professionals. Please do not attempt to follow this guide out of order, or in any capacity other than intended by the author. The author of this guide cannot be held legally responsible for any damages or loss of life that may occur by use or misuse of the information contained within.</P>
		<BR>

		<B><BIG> 1. Welcome to the OR </B></BIG>
		<BR>

		<P> Welcome to the Operating Room. On the table you see before you nearly any problem of the human body can be solved by a man with skill, determination, knowhow, and balls of steel. To your left you will see a table of sterilized tools, each of these tools has their own unique purpose, and must be chosen carefully and handled adeptly, lest there be a corpse lying on the table. Medicines have side effects and any errors can be fixed by a quick dose of anti-toxin. Surgery is not so simple, it is a dangerous and precise art; but those who master it will be able to save even the most near death of poor unfortunate souls.</P>
		<P> In the center of the room you will see the operating table itself, the vital tracking computer, and an additional body scanner. This scanner is no different from the one outside, do not be afraid to direct a patient into the OR if the scanner outside is in use. On the right there is a table with your standard Sterile masks and gloves, a sink for keeping things clean and keeping blood off your hands and tools, a wardrobe useful for stowing a patient's items whilst on the table, a freezer good for keeping any surgically removed organic bits from stinking up the place, and the Anesthetic locker.</P>
		<BR>

		<B><BIG> 2. Is surgery the correct choice </B></BIG>
		<BR>

		<P> Surgery is dangerous. It is not to be used on the mortally wounded, and not to be performed by the feint of heart. In many cases medicines can be used before surgery is required; and even when surgery will ultimately be needed, sometimes it is best to administer a slew of chemicals to prep the area before the patient hits the table. What chemicals may be needed will be covered in my chemistry guide.</P>
		<P> Before you commit to completing a surgery, just make sure that the patient has a good chance of living through the procedure, and you know exactly what needs to be done on the table. Know what all the instruments are called, what they all do, and what they look like. If you can recite the tools needed for a given surgery from memory in the correct order, you should be fine in the OR itself. Should you royally fuck up however, all is not lost. Pick up a copy of my Guide to Cloning from your local bookstore or library to learn how to revive the person you just murdered through ineptitude.</P>
		<BR>

		<B><BIG> 3. Preparing the Operating room </B></BIG>
		<BR>

		<P> Before beginning surgery you should know that even if everything goes perfect while the patient is on the table, you can still get them killed by an infection if you screw up the prep. Before any of that though, make sure you have some advanced trauma kits on hand, no surgery necessitates the use of one always but there are some circumstances where one is required to make a surgery successful.
		Make sure you wash your hands before putting anyone on the table.
		The only clothes that need to be removed from the patient are the back and mask items.
		Once you have the patient set on the operating table, open the anesthetic closet and get an anesthetic tank and a medical mask.
		With the tank in one hand and the mask in the other, apply the tank to the back and the mask to the mask. ((Drag and drop the patient onto yourself and click on the corresponding items.))
		Make sure you open the valve on the tank to actually apply the anesthetic. ((Click the “Set internals” button that should pop up when everything is set up right))
		Wash your hands one more time and get yourself ready to get the job done. ((MAKE SURE YOU ARE SET TO THE HELP INTENT!))</P>
		<BR>

		<B><BIG> 4. The finer points of human internal anatomy </B></BIG>

		<P> In this chapter I will break down each and every surgery you are likely to need while you are on the station and when you may need them.</P>
		<BR>

		<FONT Color = #1EFFBB></FONT>

		<B> <U><FONT Color = Red>Bone Repair Surgery</FONT> </B></U><BR>
		<BR>

		<P>When to use this surgery is obvious, this should fix nearly any form of break or fracture that occurs. However if the affected area has taken too much brute damage completion of this surgery will be pointless, as the bone will either break again instantly, or grow back in the wrong position. Make sure the affected region has less than <B>15 brute damage</B> on it before starting surgery. Different bones have different limits, but 15 is the safest bet you can make. Use Bicaridine or advanced trauma kits as needed to get the brute damage below this threshold.</P><BR>
		<BR>
		0. Do everything mentioned in the previous chapter.<BR>
		1. Make sure you know exactly where the break is.<BR>
		2. Make an incision using a <FONT Color = #1EFFBB> Scalpel </FONT> over the affected area.<BR>
		3. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding in the area.<BR>
		4. Use the <FONT Color = #1EFFBB>Retractors</FONT> to peel back the skin so you can see the injured bone.<BR>
		5. Apply <FONT Color = #1EFFBB>Bone Gel</FONT> to the broken bone to make it malleable enough to heal.<BR>
		6. Use the <FONT Color = #1EFFBB>Bone Setter</FONT> to get the bone into it’s normal, healthy, position.<BR>
		7. Finalize the bones position by melding it together with another application of <FONT Color = #1EFFBB>Bone Gel.</FONT> <BR>
		8. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Facial Reconstruction</FONT> </B></U><BR>
		<BR>

		<P> This surgery is for when someone’s face is pummeled so hard you can’t even tell who they are by voice. Pretty straightforward procedure as far as the actual surgery goes.. </P><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Open the patient's <FONT Color = #1EFFBB>Mouth</FONT>, as most of this surgery is done in the throat surprisingly enough.<BR>
		2. Gain access to the patient’s voice box with the <FONT Color = #1EFFBB>Scalpel</FONT>. <BR>
		3. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding in the area.<BR>
		4. Use the <FONT Color = #1EFFBB>Retractors</FONT> to peel back the skin so you can see the vocal cords.<BR>
		5. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to reshape the vocal cords.<BR>
		6. Use the <FONT Color = #1EFFBB>Retractors</FONT> to close up the voice box.<BR>
		7. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Internal Bleeding</FONT> </B></U><BR>
		<BR>

		<P> Again, fairly straight forward. If someone is bleeding internally do this to stop it.</P><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Make sure you know exactly where the bleed is.<BR>
		2. Make an incision using a <FONT Color = #1EFFBB> Scalpel </FONT> over the affected area.<BR>
		3. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding from the initial incision.<BR>
		4. Use the <FONT Color = #1EFFBB>Retractors</FONT> to peel back the skin so you can see the injured veins.<BR>
		5. Use the <FONT Color = #1EFFBB>Fix O’ Vein</FONT> to stop the actual internal bleed.
		6. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Appendectomy</FONT> </B></U><BR>
		<BR>

		<P> If your scanner tells you someone has major issues with their Appendix, you should probably do this so it doesn’t burst and kill them.</P>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Get ready to slice open someone's <FONT Color = #1EFFBB>Groin</FONT> .<BR>
		2. Make an incision using a <FONT Color = #1EFFBB> Scalpel </FONT> over the affected area.<BR>
		3. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding from the initial incision.<BR>
		4. Use the <FONT Color = #1EFFBB>Retractors</FONT> to peel back the skin so you can see the injured veins.<BR>
		5. Free the injured appendix from it’s oppressive shitlords body using a <FONT Color = #1EFFBB> Scalpel </FONT>.<BR>
		6. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to liberate the newly detached Appendix.<BR>
		7. Toss the Appendix into a Biohazard Bag and dispose of it in the incinerator.<BR>
		8. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Robotic Limb Attachment Surgery</FONT> </B></U><BR>
		<BR>

		<P> This surgery is for when a scumbag tears someones arm off and you need to give them a sick ass augmented one. Make sure you have the artificial limb from robotics before starting this surgery. Medbay does not keep them in stock, so you do need to get one made before you chop a guy’s stump of an arm open.</P><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Make sure you know exactly where the new parts are needed.<BR>
		2. Make an incision using a <FONT Color = #1EFFBB> Scalpel </FONT> over the affected area.<BR>
		3. Use the <FONT Color = #1EFFBB>Retractors</FONT> to set the area up for the new implant.<BR>
		4. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision and finalize the target area for the implant.<BR>
		5. Plug in the new robotic arm. <BR>
		<B>6. Beat the patient to death with the anesthetic tank if the first thing they say when they wake up is “I didn’t ask for this.</B><BR>
		7. Bill them for it afterwards.<BR>
		<BR>

		<B> <U><FONT Color = Red>Internal Organ Surgery</FONT> </B></U><BR>
		<BR>

		<P> This is the most common surgery you will ever do, you will do it at least once a shift. Be prepared to have this surgery down to muscle memory after three or four shifts. This is used for ruptured lungs, chemically mutilated livers and everything inbetween.</P><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Be ready to open someone’s <FONT Color = #1EFFBB>Chest</FONT>.<BR>
		2. Gain access to the patient’s chest cavity with the <FONT Color = #1EFFBB>Scalpel</FONT>. <BR>
		3. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding in the area.<BR>
		4. Use the <FONT Color = #1EFFBB>Retractors</FONT> to peel back the skin so you can see the rib cage.<BR>
		5. Use the <FONT Color = #1EFFBB>Bone Saw</FONT> on the patient’s sternum to gain access to the actual injured organ. <BR>
		6. Move the <FONT Color = #1EFFBB>Retractors</FONT> in a little deeper and separate the  rib cage.<BR>
		7. Cleanly slice over the injured area of the affected organs with the <FONT Color = #1EFFBB>Scalpel</FONT>. It will sew the incision shut as you go, healing the organ. <BR>
		8. SLOWLY close the rib cage with the <FONT Color = #1EFFBB>Retractors</FONT>.<BR>
		9. Fuse the sternum back together with the <FONT Color = #1EFFBB>Bone Gel.</FONT> <BR>
		10. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Alien Embryo Removal</FONT> </B></U><BR>
		<BR>

		<P> If someone has been attacked by a Xeno and possibly infected with alien eggs, this is how you get the little bastards out.</P><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Be ready to open someone’s <FONT Color = #1EFFBB>Chest</FONT>.<BR>
		2. Gain access to the patient’s chest cavity with the <FONT Color = #1EFFBB>Scalpel</FONT>. <BR>
		3. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding in the area.<BR>
		4. Use the <FONT Color = #1EFFBB>Retractors</FONT> to peel back the skin so you can see the rib cage.<BR>
		5. Use the <FONT Color = #1EFFBB>Bone Saw</FONT> on the patient’s sternum to gain access to the actual injured organ. <BR>
		6. Move the <FONT Color = #1EFFBB>Retractors</FONT> in a little deeper and separate the  rib cage.<BR>
		7. Use the <FONT Color = #1EFFBB>Hemostat</FONT> to remove the eggs. <BR>
		8. SLOWLY close the rib cage with the <FONT Color = #1EFFBB>Retractors</FONT>.<BR>
		9. Fuse the sternum back together with the <FONT Color = #1EFFBB>Bone Gel.</FONT> <BR>
		10. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Eye Repair Surgery</FONT> </B></U><BR>
		<BR>

		<P> If someone has had their eyes stabbed out, this is the surgery required to fix them. Note that this surgery <B>DOES NOT</B> fix genetically defective eyes, and that requires medicines covered in my Comprehensive Book of All Chemicals Ever.</P><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Be ready to open someone’s <FONT Color = #1EFFBB>Eyes</FONT>.<BR>
		2. Gain access to the patient’s eye sockets with the <FONT Color = #1EFFBB>Scalpel</FONT>. <BR>
		3. Use the <FONT Color = #1EFFBB>Retractors</FONT> lift up the actual eyeballs.<BR>
		4. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to stop the bleeding in the area.<BR>
		5. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		<BR>

		<B> <U><FONT Color = Red>Brain Removal/Damage Surgeries</FONT> </B></U><BR>
		<BR>

		<P> If someone’s brain is damaged, or someone needs to be put into a robotic body. These are the surgeries needed. They are incredibly similar, so I put them into one block.</><BR>
		<BR>

		0. Do everything mentioned in the previous chapter.<BR>
		1. Be ready to open someone’s <FONT Color = #1EFFBB>Head</FONT>.<BR>
		2. Gain access to the patient’s skull with the <FONT Color = #1EFFBB>Scalpel</FONT>. <BR>
		3. Use the <FONT Color = #1EFFBB>Bone Saw</FONT> on the patient’s skullto gain access to the insides of the cranium. <BR>

		<P> Repeat steps 2 and 3 again to remove the brain, then hand the organ off to the nearest roboticist. If there are no roboticists nearby, put the brain into the freezer <B>IMMEDIATELY</B>. If you are replacing someone’s brain, simply insert the removed brain into it’s new home.</P>
		<BR>
		<P> If you are trying to repair physical damage, proceed onward to step 4.</P><BR>

		4. Use a <FONT Color = #1EFFBB>Hemostat</FONT> to remove the bone chips that will inevitably be lodged in the brain.
		5. Use the <FONT Color = #1EFFBB>Fix O’ Vein</FONT> to repair the Subdural Hematoma.
		6. Back your hands away from the area and use the <FONT Color #1EFFBB>Cautery</FONT> to seal the initial incision.<BR>
		</html>"}

/obj/item/weapon/book/manual/engineering_construction
	name = "Station Repairs and Construction"
	icon_state ="bookEngineering"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Station Repairs and Construction"
	/*dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://wiki.nanotrasen.com/index.php?title=Guide_to_construction&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}*/

/obj/item/weapon/book/manual/engineering_particle_accelerator
	name = "Particle Accelerator User's Guide"
	icon_state ="bookParticleAccelerator"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Particle Accelerator User's Guide"
//big pile of shit below.

	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h3>Experienced user's guide</h3>

				<h4>Setting up</h4>

				<ol>
					<li><b>Wrench</b> all pieces to the floor</li>
					<li>Add <b>wires</b> to all the pieces</li>
					<li>Close all the panels with your <b>screwdriver</b></li>
				</ol>

				<h4>Use</h4>

				<ol>
					<li>Open the control panel</li>
					<li>Set the speed to 2</li>
					<li>Start firing at the singularity generator</li>
					<li><font color='red'><b>When the singularity reaches a large enough size so it starts moving on it's own set the speed down to 0, but don't shut it off</b></font></li>
					<li>Remember to wear a radiation suit when working with this machine... we did tell you that at the start, right?</li>
				</ol>

				</body>
				</html>"}*/


/obj/item/weapon/book/manual/engineering_hacking
	name = "Hacking"
	icon_state ="bookHacking"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Hacking"
//big pile of shit below.

	/*dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://wiki.nanotrasen.com/index.php?title=Hacking&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}*/

/obj/item/weapon/book/manual/engineering_singularity_safety
	name = "Singularity Safety in Special Circumstances"
	icon_state ="bookEngineeringSingularitySafety"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Singularity Safety in Special Circumstances"
//big pile of shit below.

	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h3>Singularity Safety in Special Circumstances</h3>

				<h4>Power outage</h4>

				A power problem has made the entire station loose power? Could be station-wide wiring problems or syndicate power sinks. In any case follow these steps:
				<p>
				<b>Step one:</b> <b><font color='red'>PANIC!</font></b><br>
				<b>Step two:</b> Get your ass over to engineering! <b>QUICKLY!!!</b><br>
				<b>Step three:</b> Get to the <b>Area Power Controller</b> which controls the power to the emitters.<br>
				<b>Step four:</b> Swipe it with your <b>ID card</b> - if it doesn't unlock, continue with step 15.<br>
				<b>Step five:</b> Open the console and disengage the cover lock.<br>
				<b>Step six:</b> Pry open the APC with a <b>Crowbar.</b><br>
				<b>Step seven:</b> Take out the empty <b>power cell.</b><br>
				<b>Step eight:</b> Put in the new, <b>full power cell</b> - if you don't have one, continue with step 15.<br>
				<b>Step nine:</b> Quickly put on a <b>Radiation suit.</b><br>
				<b>Step ten:</b> Check if the <b>singularity field generators</b> withstood the down-time - if they didn't, continue with step 15.<br>
				<b>Step eleven:</b> Since disaster was averted you now have to ensure it doesn't repeat. If it was a powersink which caused it and if the engineering apc is wired to the same powernet, which the powersink is on, you have to remove the piece of wire which links the apc to the powernet. If it wasn't a powersink which caused it, then skip to step 14.<br>
				<b>Step twelve:</b> Grab your crowbar and pry away the tile closest to the APC.<br>
				<b>Step thirteen:</b> Use the wirecutters to cut the wire which is conecting the grid to the terminal. <br>
				<b>Step fourteen:</b> Go to the bar and tell the guys how you saved them all. Stop reading this guide here.<br>
				<b>Step fifteen:</b> <b>GET THE FUCK OUT OF THERE!!!</b><br>
				</p>

				<h4>Shields get damaged</h4>

				Step one: <b>GET THE FUCK OUT OF THERE!!! FORGET THE WOMEN AND CHILDREN, SAVE YOURSELF!!!</b><br>
				</body>
				</html>
				"}*/

/obj/item/weapon/book/manual/hydroponics_pod_people
	name = "The Human Harvest - From seed to market"
	icon_state ="bookHydroponicsPodPeople"
	author = "Farmer John"
	title = "The Human Harvest - From seed to market"
	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h3>Growing Humans</h3>

				Why would you want to grow humans? Well I'm expecting most readers to be in the slave trade, but a few might actually
				want to revive fallen comrades. Growing pod people is easy, but prone to disaster.
				<p>
				<ol>
				<li>Find a dead person who is in need of cloning. </li>
				<li>Take a blood sample with a syringe. </li>
				<li>Inject a seed pack with the blood sample. </li>
				<li>Plant the seeds. </li>
				<li>Tend to the plants water and nutrition levels until it is time to harvest the cloned human.</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
				</html>
				"}*/

/obj/item/weapon/book/manual/medical_cloning
	name = "Cloning techniques of the 26th century"
	icon_state ="bookCloning"
	author = "Medical Journal, volume 3"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Cloning techniques of the 26th century"
//big pile of shit below.

	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<H3>How to Clone People</H3>
				So there’s 50 dead people lying on the floor, chairs are spinning like no tomorrow and you haven’t the foggiest idea of what to do? Not to worry! This guide is intended to teach you how to clone people and how to do it right, in a simple step-by-step process! If at any point of the guide you have a mental meltdown, genetics probably isn’t for you and you should get a job-change as soon as possible before you’re sued for malpractice.

				<ol>
					<li><a href='#1'>Acquire body</a></li>
					<li><a href='#2'>Strip body</a></li>
					<li><a href='#3'>Put body in cloning machine</a></li>
					<li><a href='#4'>Scan body</a></li>
					<li><a href='#5'>Clone body</a></li>
					<li><a href='#6'>Get clean Structurel Enzymes for the body</a></li>
					<li><a href='#7'>Put body in morgue</a></li>
					<li><a href='#8'>Await cloned body</a></li>
					<li><a href='#9'>Use the clean SW injector</a></li>
					<li><a href='#10'>Give person clothes back</a></li>
					<li><a href='#11'>Send person on their way</a></li>
				</ol>

				<a name='1'><H4>Step 1: Acquire body</H4>
				This is pretty much vital for the process because without a body, you cannot clone it. Usually, bodies will be brought to you, so you do not need to worry so much about this step. If you already have a body, great! Move on to the next step.

				<a name='2'><H4>Step 2: Strip body</H4>
				The cloning machine does not like abiotic items. What this means is you can’t clone anyone if they’re wearing clothes, so take all of it off. If it’s just one person, it’s courteous to put their possessions in the closet. If you have about seven people awaiting cloning, just leave the piles where they are, but don’t mix them around and for God’s sake don’t let people in to steal them.

				<a name='3'><H4>Step 3: Put body in cloning machine</H4>
				Grab the body and then put it inside the DNA modifier. If you cannot do this, then you messed up at Step 2. Go back and check you took EVERYTHING off - a commonly missed item is their headset.

				<a name='4'><H4>Step 4: Scan body</H4>
				Go onto the computer and scan the body by pressing ‘Scan - <Subject Name Here>’. If you’re successful, they will be added to the records (note that this can be done at any time, even with living people, so that they can be cloned without a body in the event that they are lying dead on port solars and didn‘t turn on their suit sensors)! If not, and it says “Error: Mental interface failure.”, then they have left their bodily confines and are one with the spirits. If this happens, just shout at them to get back in their body, click ‘Refresh‘ and try scanning them again. If there’s no success, threaten them with gibbing. Still no success? Skip over to Step 7 and don‘t continue after it, as you have an unresponsive body and it cannot be cloned. If you got “Error: Unable to locate valid genetic data.“, you are trying to clone a monkey - start over.

				<a name='5'><H4>Step 5: Clone body</H4>
				Now that the body has a record, click ’View Records’, click the subject’s name, and then click ‘Clone’ to start the cloning process. Congratulations! You’re halfway there. Remember not to ‘Eject’ the cloning pod as this will kill the developing clone and you’ll have to start the process again.

				<a name='6'><H4>Step 6: Get clean SEs for body</H4>
				Cloning is a finicky and unreliable process. Whilst it will most certainly bring someone back from the dead, they can have any number of nasty disabilities given to them during the cloning process! For this reason, you need to prepare a clean, defect-free Structural Enzyme (SE) injection for when they’re done. If you’re a competent Geneticist, you will already have one ready on your working computer. If, for any reason, you do not, then eject the body from the DNA modifier (NOT THE CLONING POD) and take it next door to the Genetics research room. Put the body in one of those DNA modifiers and then go onto the console. Go into View/Edit/Transfer Buffer, find an open slot and click “SE“ to save it. Then click ‘Injector’ to get the SEs in syringe form. Put this in your pocket or something for when the body is done.

				<a name='7'><H4>Step 7: Put body in morgue</H4>
				Now that the cloning process has been initiated and you have some clean Structural Enzymes, you no longer need the body! Drag it to the morgue and tell the Chef over the radio that they have some fresh meat waiting for them in there. To put a body in a morgue bed, simply open the tray, grab the body, put it on the open tray, then close the tray again. Use one of the nearby pens to label the bed “CHEF MEAT” in order to avoid confusion.

				<a name='8'><H4>Step 8: Await cloned body</H4>
				Now go back to the lab and wait for your patient to be cloned. It won’t be long now, I promise.

				<a name='9'><H4>Step 9: Use the clean SE injector on person</H4>
				Has your body been cloned yet? Great! As soon as the guy pops out, grab your injector and jab it in them. Once you’ve injected them, they now have clean Structural Enzymes and their defects, if any, will disappear in a short while.

				<a name='10'><H4>Step 10: Give person clothes back</H4>
				Obviously the person will be naked after they have been cloned. Provided you weren’t an irresponsible little shit, you should have protected their possessions from thieves and should be able to give them back to the patient. No matter how cruel you are, it’s simply against protocol to force your patients to walk outside naked.

				<a name='11'><H4>Step 11: Send person on their way</H4>
				Give the patient one last check-over - make sure they don’t still have any defects and that they have all their possessions. Ask them how they died, if they know, so that you can report any foul play over the radio. Once you’re done, your patient is ready to go back to work! Chances are they do not have Medbay access, so you should let them out of Genetics and the Medbay main entrance.

				<p>If you’ve gotten this far, congratulations! You have mastered the art of cloning. Now, the real problem is how to resurrect yourself after that traitor had his way with you for cloning his target.



				</body>
				</html>
				"}*/


/obj/item/weapon/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state ="book"
	author = "Weyland-Yutani Corp"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "APLU \"Ripley\" Construction and Operation Manual"
//big pile of shit below.

	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<center>
				<b style='font-size: 12px;'>Weyland-Yutani - Building Better Worlds</b>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul>
				<li><b>Class:</b> Autonomous Power Loader</li>
				<li><b>Scope:</b> Logistics and Construction</li>
				<li><b>Weight:</b> 820kg (without operator and with empty cargo compartment)</li>
				<li><b>Height:</b> 2.5m</li>
				<li><b>Width:</b> 1.8m</li>
				<li><b>Top speed:</b> 5km/hour</li>
				<li><b>Operation in vacuum/hostile environment:</b> Possible</b>
				<li><b>Airtank Volume:</b> 500liters</li>
				<li><b>Devices:</b>
					<ul>
					<li>Hydraulic Clamp</li>
					<li>High-speed Drill</li>
					</ul>
				</li>
				<li><b>Propulsion Device:</b> Powercell-powered electro-hydraulic system.</li>
				<li><b>Powercell capacity:</b> Varies.</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
				<li>Connect all exosuit parts to the chassis frame</li>
				<li>Connect all hydraulic fittings and tighten them up with a wrench</li>
				<li>Adjust the servohydraulics with a screwdriver</li>
				<li>Wire the chassis. (Cable is not included.)</li>
				<li>Use the wirecutters to remove the excess cable if needed.</li>
				<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
				<li>Secure the mainboard with a screwdriver.</li>
				<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
				<li>Secure the peripherals control module with a screwdriver</li>
				<li>Install the internal armor plating (Not included due to Nanotrasen regulations. Can be made using 5 metal sheets.)</li>
				<li>Secure the internal armor plating with a wrench</li>
				<li>Weld the internal armor plating to the chassis</li>
				<li>Install the external reinforced armor plating (Not included due to Nanotrasen regulations. Can be made using 5 reinforced metal sheets.)</li>
				<li>Secure the external reinforced armor plating with a wrench</li>
				<li>Weld the external reinforced armor plating to the chassis</li>
				<li></li>
				<li>Additional Information:</li>
				<li>The firefighting variation is made in a similar fashion.</li>
				<li>A firesuit must be connected to the Firefighter chassis for heat shielding.</li>
				<li>Internal armor is plasteel for additional strength.</li>
				<li>External armor must be installed in 2 parts, totaling 10 sheets.</li>
				<li>Completed mech is more resiliant against fire, and is a bit more durable overall</li>
				<li>Nanotrasen is determined to the safety of its <s>investments</s> employees.</li>
				</ol>
				</body>
				</html>

				<h2>Operation</h2>
				Coming soon...
			"}*/


/obj/item/weapon/book/manual/research_and_development
	name = "Research and Development 101"
	icon_state = "rdbook"
	author = "Dr. L. Ight"
	title = "Research and Development 101"
	/*dat = {"
	<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Science For Dummies</h1>
				So you want to further SCIENCE? Good man/woman/thing! However, SCIENCE is a complicated process even though it's quite easy. For the most part, it's a three step process:
				<ol>
					<li> 1) Deconstruct items in the Destructive Analyzer to advance technology or improve the design.</li>
					<li> 2) Build unlocked designs in the Protolathe and Circuit Imprinter</li>
					<li> 3) Repeat!</li>
				</ol>

				Those are the basic steps to furthing science. What do you do science with, however? Well, you have four major tools: R&D Console, the Destructive Analyzer, the Protolathe, and the Circuit Imprinter.

				<h2>The R&D Console</h2>
				The R&D console is the cornerstone of any research lab. It is the central system from which the Destructive Analyzer, Protolathe, and Circuit Imprinter (your R&D systems) are controled. More on those systems in their own sections. On its own, the R&D console acts as a database for all your technological gains and new devices you discover. So long as the R&D console remains intact, you'll retain all that SCIENCE you've discovered. Protect it though, because if it gets damaged, you'll lose your data! In addition to this important purpose, the R&D console has a disk menu that lets you transfer data from the database onto disk or from the disk into the database. It also has a settings menu that lets you re-sync with nearby R&D devices (if they've become disconnected), lock the console from the unworthy, upload the data to all other R&D consoles in the network (all R&D consoles are networked by default), connect/disconnect from the network, and purge all data from the database.
				<b>NOTE:</b> The technology list screen, circuit imprinter, and protolathe menus are accessible by non-scientists. This is intended to allow 'public' systems for the plebians to utilize some new devices.

				<h2>Destructive Analyzer</h2>
				This is the source of all technology. Whenever you put a handheld object in it, it analyzes it and determines what sort of technological advancements you can discover from it. If the technology of the object is equal or higher then your current knowledge, you can destroy the object to further those sciences. Some devices (notably, some devices made from the protolathe and circuit imprinter) aren't 100% reliable when you first discover them. If these devices break down, you can put them into the Destructive Analyzer and improve their reliability rather then futher science. If their reliability is high enough ,it'll also advance their related technologies.

				<h2>Circuit Imprinter</h2>
				This machine, along with the Protolathe, is used to actually produce new devices. The Circuit Imprinter takes glass and various chemicals (depends on the design) to produce new circuit boards to build new machines or computers. It can even be used to print AI modules.

				<h2>Protolathe</h2>
				This machine is an advanced form of the Autolathe that produce non-circuit designs. Unlike the Autolathe, it can use processed metal, glass, solid plasma, silver, gold, and diamonds along with a variety of chemicals to produce devices. The downside is that, again, not all devices you make are 100% reliable when you first discover them.

				<h1>Reliability and You</h1>
				As it has been stated, many devices when they're first discovered do not have a 100% reliablity when you first discover them. Instead, the reliablity of the device is dependent upon a base reliability value, whatever improvements to the design you've discovered through the Destructive Analyzer, and any advancements you've made with the device's source technologies. To be able to improve the reliability of a device, you have to use the device until it breaks beyond repair. Once that happens, you can analyze it in a Destructive Analyzer. Once the device reachs a certain minimum reliability, you'll gain tech advancements from it.

				<h1>Building a Better Machine</h1>
				Many machines produces from circuit boards and inserted into a machine frame require a variety of parts to construct. These are parts like capacitors, batteries, matter bins, and so forth. As your knowledge of science improves, more advanced versions are unlocked. If you use these parts when constructing something, its attributes may be improved. For example, if you use an advanced matter bin when constructing an autolathe (rather then a regular one), it'll hold more materials. Experiment around with stock parts of various qualities to see how they affect the end results! Be warned, however: Tier 3 and higher stock parts don't have 100% reliability and their low reliability may affect the reliability of the end machine.
				</body>
				</html>
			"}*/


/obj/item/weapon/book/manual/robotics_cyborgs
	name = "Cyborgs for Dummies"
	icon_state = "borgbook"
	author = "XISC"
	title = "Cyborgs for Dummies"
	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
        h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Cyborgs for Dummies</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Equipment">Cyborg Related Equipment</a></li>
					<li><a href="#Modules">Cyborg Modules</a></li>
					<li><a href="#Construction">Cyborg Construction</a></li>
					<li><a href="#Maintenance">Cyborg Maintenance</a></li>
					<li><a href="#Repairs">Cyborg Repairs</a></li>
					<li><a href="#Emergency">In Case of Emergency</a></li>
				</ol>


				<h2><a name="Equipment">Cyborg Related Equipment</h2>

				<h3>Exosuit Fabricator</h3>
				The Exosuit Fabricator is the most important piece of equipment related to cyborgs. It allows the construction of the core cyborg parts. Without these machines, cyborgs can not be built. It seems that they may also benefit from advanced research techniques.

				<h3>Cyborg Recharging Station</h3>
				This useful piece of equipment will suck power out of the power systems to charge a cyborg's power cell back up to full charge.

				<h3>Robotics Control Console</h3>
				This useful piece of equipment can be used to immobolize or destroy a cyborg. A word of warning: Cyborgs are expensive pieces of equipment, do not destroy them without good reason, or Nanotrasen may see to it that it never happens again.


				<h2><a name="Modules">Cyborg Modules</h2>
				When a cyborg is created it picks out of an array of modules to designate its purpose. There are 6 different cyborg modules.

				<h3>Standard Cyborg</h3>
				The standard cyborg module is a multi-purpose cyborg. It is equipped with various modules, allowing it to do basic tasks.<br>A Standard Cyborg comes with:
				<ul>
				  <li>Crowbar</li>
				  <li>Stun Baton</li>
				  <li>Health Analyzer</li>
				  <li>Fire Extinguisher</li>
				</ul>

				<h3>Engineering Cyborg</h3>
				The Engineering cyborg module comes equipped with various engineering-related tools to help with engineering-related tasks.<br>An Engineering Cyborg comes with:
				<ul>
				  <li>A basic set of engineering tools</li>
				  <li>Metal Synthesizer</li>
				  <li>Reinforced Glass Synthesizer</li>
				  <li>An RCD</li>
				  <li>Wire Synthesizer</li>
				  <li>Fire Extinguisher</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Mining Cyborg</h3>
				The Mining Cyborg module comes equipped with the latest in mining equipment. They are efficient at mining due to no need for oxygen, but their power cells limit their time in the mines.<br>A Mining Cyborg comes with:
				<ul>
				  <li>Jackhammer</li>
				  <li>Shovel</li>
				  <li>Mining Satchel</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Security Cyborg</h3>
				The Security Cyborg module is equipped with effective security measures used to apprehend and arrest criminals without harming them a bit.<br>A Security Cyborg comes with:
				<ul>
				  <li>Stun Baton</li>
				  <li>Handcuffs</li>
				  <li>Taser</li>
				</ul>

				<h3>Janitor Cyborg</h3>
				The Janitor Cyborg module is equipped with various cleaning-facilitating devices.<br>A Janitor Cyborg comes with:
				<ul>
				  <li>Mop</li>
				  <li>Hand Bucket</li>
				  <li>Cleaning Spray Synthesizer and Spray Nozzle</li>
				</ul>

				<h3>Service Cyborg</h3>
				The service cyborg module comes ready to serve your human needs. It includes various entertainment and refreshment devices. Occasionally some service cyborgs may have been referred to as "Bros"<br>A Service Cyborg comes with:
				<ul>
				  <li>Shaker</li>
				  <li>Industrail Dropper</li>
				  <li>Platter</li>
				  <li>Beer Synthesizer</li>
				  <li>Zippo Lighter</li>
				  <li>Rapid-Service-Fabricator (Produces various entertainment and refreshment objects)</li>
				  <li>Pen</li>
				</ul>

				<h2><a name="Construction">Cyborg Construction</h2>
				Cyborg construction is a rather easy process, requiring a decent amount of metal and a few other supplies.<br>The required materials to make a cyborg are:
				<ul>
				  <li>Metal</li>
				  <li>Two Flashes</li>
				  <li>One Power Cell (Preferrably rated to 15000w)</li>
				  <li>Some electrical wires</li>
				  <li>One Human Brain</li>
				  <li>One Man-Machine Interface</li>
				</ul>
				Once you have acquired the materials, you can start on construction of your cyborg.<br>To construct a cyborg, follow the steps below:
				<ol>
				  <li>Start the Exosuit Fabricators constructing all of the cyborg parts</li>
				  <li>While the parts are being constructed, take your human brain, and place it inside the Man-Machine Interface</li>
				  <li>Once you have a Robot Head, place your two flashes inside the eye sockets</li>
				  <li>Once you have your Robot Chest, wire the Robot chest, then insert the power cell</li>
				  <li>Attach all of the Robot parts to the Robot frame</li>
				  <li>Insert the Man-Machine Interface (With the Brain inside) Into the Robot Body</li>
				  <li>Congratulations! You have a new cyborg!</li>
				</ol>

				<h2><a name="Maintenance">Cyborg Maintenance</h2>
				Occasionally Cyborgs may require maintenance of a couple types, this could include replacing a power cell with a charged one, or possibly maintaining the cyborg's internal wiring.

				<h3>Replacing a Power Cell</h3>
				Replacing a Power cell is a common type of maintenance for cyborgs. It usually involves replacing the cell with a fully charged one, or upgrading the cell with a larger capacity cell.<br>The steps to replace a cell are follows:
				<ol>
				  <li>Unlock the Cyborg's Interface by swiping your ID on it</li>
				  <li>Open the Cyborg's outer panel using a crowbar</li>
				  <li>Remove the old power cell</li>
				  <li>Insert the new power cell</li>
				  <li>Close the Cyborg's outer panel using a crowbar</li>
				  <li>Lock the Cyborg's Interface by swiping your ID on it, this will prevent non-qualified personnel from attempting to remove the power cell</li>
				</ol>

				<h3>Exposing the Internal Wiring</h3>
				Exposing the internal wiring of a cyborg is fairly easy to do, and is mainly used for cyborg repairs.<br>You can easily expose the internal wiring by following the steps below:
				<ol>
				  <li>Follow Steps 1 - 3 of "Replacing a Cyborg's Power Cell"</li>
				  <li>Open the cyborg's internal wiring panel by using a screwdriver to unsecure the panel</li>
			  </ol>
			  To re-seal the cyborg's internal wiring:
			  <ol>
			    <li>Use a screwdriver to secure the cyborg's internal panel</li>
			    <li>Follow steps 4 - 6 of "Replacing a Cyborg's Power Cell" to close up the cyborg</li>
			  </ol>

			  <h2><a name="Repairs">Cyborg Repairs</h2>
			  Occasionally a Cyborg may become damaged. This could be in the form of impact damage from a heavy or fast-travelling object, or it could be heat damage from high temperatures, or even lasers or Electromagnetic Pulses (EMPs).

			  <h3>Dents</h3>
			  If a cyborg becomes damaged due to impact from heavy or fast-moving objects, it will become dented. Sure, a dent may not seem like much, but it can compromise the structural integrity of the cyborg, possibly causing a critical failure.
			  Dents in a cyborg's frame are rather easy to repair, all you need is to apply a welding tool to the dented area, and the high-tech cyborg frame will repair the dent under the heat of the welder.

        <h3>Excessive Heat Damage</h3>
        If a cyborg becomes damaged due to excessive heat, it is likely that the internal wires will have been damaged. You must replace those wires to ensure that the cyborg remains functioning properly.<br>To replace the internal wiring follow the steps below:
        <ol>
          <li>Unlock the Cyborg's Interface by swiping your ID</li>
          <li>Open the Cyborg's External Panel using a crowbar</li>
          <li>Remove the Cyborg's Power Cell</li>
          <li>Using a screwdriver, expose the internal wiring or the Cyborg</li>
          <li>Replace the damaged wires inside the cyborg</li>
          <li>Secure the internal wiring cover using a screwdriver</li>
          <li>Insert the Cyborg's Power Cell</li>
          <li>Close the Cyborg's External Panel using a crowbar</li>
          <li>Lock the Cyborg's Interface by swiping your ID</li>
        </ol>
        These repair tasks may seem difficult, but are essential to keep your cyborgs running at peak efficiency.

        <h2><a name="Emergency">In Case of Emergency</h2>
        In case of emergency, there are a few steps you can take.

        <h3>"Rogue" Cyborgs</h3>
        If the cyborgs seem to become "rogue", they may have non-standard laws. In this case, use extreme caution.
        To repair the situation, follow these steps:
        <ol>
          <li>Locate the nearest robotics console</li>
          <li>Determine which cyborgs are "Rogue"</li>
          <li>Press the lockdown button to immobolize the cyborg</li>
          <li>Locate the cyborg</li>
          <li>Expose the cyborg's internal wiring</li>
          <li>Check to make sure the LawSync and AI Sync lights are lit</li>
          <li>If they are not lit, pulse the LawSync wire using a multitool to enable the cyborg's Law Sync</li>
          <li>Proceed to a cyborg upload console. Nanotrasen usually places these in the same location as AI uplaod consoles.</li>
          <li>Use a "Reset" upload moduleto reset the cyborg's laws</li>
          <li>Proceed to a Robotics Control console</li>
          <li>Remove the lockdown on the cyborg</li>
        </ol>

        <h3>As a last resort</h3>
        If all else fails in a case of cyborg-related emergency. There may be only one option. Using a Robotics Control console, you may have to remotely detonate the cyborg.
        <h3>WARNING:</h3> Do not detonate a borg without an explicit reason for doing so. Cyborgs are expensive pieces of Nanotrasen equipment, and you may be punished for detonating them without reason.

        </body>
		</html>
		"}*/

/obj/item/weapon/book/manual/security_space_law
	name = "Space Law"
	desc = "A set of Nanotrasen guidelines for keeping law and order on their space stations."
	icon_state = "bookSpaceLaw"
	author = "Nanotrasen"
	title = "Space Law"
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://baystation12.net/wiki/index.php?title=Space_law&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>		</body>

		</html>

		"}

/obj/item/weapon/book/manual/engineering_guide
	name = "Engineering Textbook"
	icon_state ="bookEngineering2"
	author = "Engineering Encyclopedia"
	title = "Engineering Textbook"
	/*dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://wiki.nanotrasen.com/index.php?title=Guide_to_engineering&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>		</body>

		</html>

		"}*/


/obj/item/weapon/book/manual/chef_recipes
	name = "Chef Recipes"
	icon_state = "cooked_book"
	author = "Lord Frenrir Cageth"
	title = "Chef Recipes"
	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Food for Dummies</h1>
				Here is a guide on basic food recipes and also how to not poison your customers accidentally.

				<h2>Burger:<h2>
				Put 1 meat and 1 flour into the microwave and turn it on. Then wait.

				<h2>Bread:<h2>
				Put 3 flour into the microwave and then wait.

				<h2>Waffles:<h2>
				Add 2 flour and 2 egg to the microwave and then wait.

				<h2>Popcorn:<h2>
				Add 1 corn to the microwave and wait.

				<h2>Meat Steak:<h2>
				Put 1 meat, 1 unit of salt and 1 unit of pepper into the microwave and wait.

				<h2>Meat Pie:<h2>
				Put 1 meat and 2 flour into the microwave and wait.

				<h2>Boiled Spagetti:<h2>
				Put 1 spagetti and 5 units of water into the microwave and wait.

				<h2>Donuts:<h2>
				Add 1 egg and 1 flour to the microwave and wait.

				<h2>Fries:<h2>
				Add one potato to the processor and wait.


				</body>
				</html>
			"}*/

/obj/item/weapon/book/manual/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Sir John Rose"
	title = "Barman Recipes"
	/*dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Drinks for dummies</h1>
				Heres a guide for some basic drinks.

				<h2>Manly Dorf:</h2>
				Mix ale and beer into a glass.

				<h2>Grog:</h2>
				Mix rum and water into a glass.

				<h2>Black Russian:</h2>
				Mix vodka and kahlua into a glass.

				<h2>Irish Cream:</h2>
				Mix cream and whiskey into a glass.

				<h2>Screwdriver:</h2>
				Mix vodka and orange juice into a glass.

				<h2>Cafe Latte:</h2>
				Mix milk and coffee into a glass.

				<h2>Mead:</h2>
				Mix Enzyme, water and sugar into a glass.

				<h2>Gin Tonic:</h2>
				Mix gin and tonic into a glass.

				<h2>Classic Martini:</h2>
				Mix vermouth and gin into a glass.


				</body>
				</html>
			"}*/


/obj/item/weapon/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state ="bookDetective"
	author = "Nanotrasen"
	title = "The Film Noir: Proper Procedures for Investigations"
	/*dat = {"<html>
			<head>
			<style>
			h1 {font-size: 18px; margin: 15px 0px 5px;}
			h2 {font-size: 15px; margin: 15px 0px 5px;}
			li {margin: 2px 0px 2px 15px;}
			ul {list-style: none; margin: 5px; padding: 0px;}
			ol {margin: 5px; padding: 0px 15px;}
			</style>
			</head>
			<body>
			<h3>Detective Work</h3>

			Between your bouts of self-narration, and drinking whiskey on the rocks, you might get a case or two to solve.<br>
			To have the best chance to solve your case, follow these directions:
			<p>
			<ol>
			<li>Go to the crime scene. </li>
			<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog.) </li>
			<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
			<li>Return to your office. </li>
			<li>Using your forensic scanning computer, scan your Scanner to upload all of your evidence into the database.</li>
			<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
			<li>If you have 80% or more of the print (The print is displayed) go to step 10, otherwise continue to step 8.</li>
			<li>Look for clues from the suit fibres you found on your perp, and go about looking for more evidence with this new information, scanning as you go. </li>
			<li>Try to get a fingerprint card of your perp, as if used in the computer, the prints will be completed on their dossier.</li>
			<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
			<li>Since you now have both your dossier and the name of the person, print both out as evidence, and get security to nab your baddie.</li>
			<li>Give yourself a pat on the back and a bottle of the ships finest vodka, you did it!. </li>
			</ol>
			<p>
			It really is that easy! Good luck!

			</body>
			</html>"}*/

/obj/item/weapon/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	icon_state ="bookNuclear"
	author = "Syndicate"
	title = "Fission Mailed: Nuclear Sabotage 101"
	/*dat = {"<html>
			Nuclear Explosives 101:<br>
			Hello and thank you for choosing the Syndicate for your nuclear information needs.<br>
			Today's crash course will deal with the operation of a Fusion Class Nanotrasen made Nuclear Device.<br>
			First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.<br>
			Pressing any button on the compacted bomb will cause it to extend and bolt itself into place.<br>
			If this is done to unbolt it one must completely log in which at this time may not be possible.<br>
			To make the nuclear device functional:<br>
			<li>Place the nuclear device in the designated detonation zone.</li>
			<li>Extend and anchor the nuclear device from its interface.</li>
			<li>Insert the nuclear authorisation disk into slot.</li>
			<li>Type numeric authorisation code into the keypad. This should have been provided. Note: If you make a mistake press R to reset the device.
			<li>Press the E button to log onto the device.</li>
			You now have activated the device. To deactivate the buttons at anytime for example when you've already prepped the bomb for detonation	remove the auth disk OR press the R on the keypad.<br>
			Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option.<br>
			Note: Nanotrasen is a pain in the neck.<br>
			Toggle off the SAFETY.<br>
			Note: You wouldn't believe how many Syndicate Operatives with doctorates have forgotten this step.<br>
			So use the - - and + + to set a det time between 5 seconds and 10 minutes.<br>
			Then press the timer toggle button to start the countdown.<br>
			Now remove the auth. disk so that the buttons deactivate.<br>
			Note: THE BOMB IS STILL SET AND WILL DETONATE<br>
			Now before you remove the disk if you need to move the bomb you can:<br>
			Toggle off the anchor, move it, and re-anchor.<br><br>
			Good luck. Remember the order:<br>
			<b>Disk, Code, Safety, Timer, Disk, RUN!</b><br>
			Intelligence Analysts believe that normal Nanotrasen procedure is for the Captain to secure the nuclear authorisation disk.<br>
			Good luck!
			</html>"}*/