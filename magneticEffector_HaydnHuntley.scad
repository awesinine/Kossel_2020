// Magnetic effector for KosselPlus printer.
//
// This work is licensed under a Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
// Visit: http://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

// Holds one hot end using a groove mount.
// Note: assumes a layer height of 0.2mm.

// TODO:
// change the mount key so that it is easier to print?
// try right side up, but remove the bottom again?
// change the mount key to use 0,0 as the reference point.
// put the screws in straight.

$fn = 360/4;

include <configuration.scad>;

// All measurements in mm.
insideBaseRadius        = 43.0 / 2;
ledRadius				= insideBaseRadius + 3.0;
releauxRadius			= 120.0 / 2;
centerBaseHeight        = 3.0;
baseHeight              = 8.0;
mountHeight             = 5.5;  // The height of the mount.
mountHeightExt			= 4.0;  // The height of the next part of the mount.
minMountHoleRadius      = (12.15+0.5) / 2;
maxMountHoleRadius      = (16.15+0.2) / 2;
maxMountHoleLooseRadius = (maxMountHoleRadius + 0.5);
maxMountHoleOffset      = (minMountHoleRadius + maxMountHoleRadius) / 2;
ringHoleCount           = 12;
edgeRadius              = baseHeight/2;
sides                   = 3;
sideOffset			    = insideBaseRadius;
sideLength              = ballJointSeparation + 3 * edgeRadius;
secureScrewX			= 15.0;
secureScrewY			= 4.0;
secureScrewZ			= (mountHeight+mountHeightExt-2)/2+centerBaseHeight;
keyX					= (2 * insideBaseRadius) - 6;
keyY					= 3.0;


module releauxPiece(angle, size, base, height)
{
	rotate([0, 0, angle * 120])
	translate([0, size/2, 0])
	{
		translate([0, 0, base])
		cylinder(r1=size, r2=0, h=size-base);
		
		cylinder(r=size, h=base);
	}
}


module m3x8BallStud()
{
	len = 8.0;

	// The screw shaft.
	translate([0, 0, -0.6*m3LockNutHeight])
	cylinder(r=m3LooseRadius, h=len+3, $fn=16);
	
	// The nylock nut trap.
	translate([0, 0, -1.4])
	cylinder(r1=m3LockNutRadius,
			 r2=m3LockNutRadius-0.1,
			 h=2+m3LockNutHeight, $fn=6);
}


module m3x8Base()
{
	translate([0, 0, 4])
	cylinder(r=10/2, h=4.3);
}


module effectorOutside()
{
	difference()
	{
		union()
		{
			rotate([0, 0, 60])
			intersection()
			{
				// This creates a Reuleaux triangle.
				releauxPiece(0, releauxRadius, 2, releauxRadius);
				releauxPiece(1, releauxRadius, 2, releauxRadius);
				releauxPiece(2, releauxRadius, 2, releauxRadius);
				cylinder(r=2*releauxRadius, h=baseHeight);					
			}

			// Add a base for each M3x8 ball stud to sit on.
			for (i = [0:sides])
				assign(angle = i * 360/sides)
				{
					rotate([0, 0, angle])
					{
						translate([ballJointSeparation/2, 0, 0])
						translate([0, sideOffset-3, 0])
						rotate([-30, 0, 0])
						m3x8Base();

						translate([-ballJointSeparation/2, 0, 0])
						translate([0, sideOffset-3, 0])
						rotate([-30, 0, 0])
						m3x8Base();
					}
				}
		}

		// Center hole.
		translate([0, 0, -smidge/2])
		cylinder(r=insideBaseRadius, h=baseHeight+smidge);

		// M3 holes for attaching ball studs.
		for (i = [0:sides])
			assign(angle = i * 360/sides)
			{
				rotate([0, 0, angle])
				{
					translate([ballJointSeparation/2, 0, 0])
					translate([0, sideOffset-3, 0])
					rotate([-30, 0, 0])
					m3x8BallStud();

					translate([-ballJointSeparation/2, 0, 0])
					translate([0, sideOffset-3, 0])
					rotate([-30, 0, 0])
					m3x8BallStud();
				}
			}

		// COMMENT THIS OUT TO DISPLAY ON LINUX!
		// Holes for attaching the LED lights.
		for (i = [1, 2])
		{
			for (j = [-20, 20])
				for (dir = [-1, 1])
				{
					rotate([0, 0, 30+i*120+j+dir*2.92])
					{
						translate([ledRadius, 0, -1])
						cylinder(r=1.0, h=baseHeight+2, $fn=16);
					}
				}
			// Common hole between LED leads.
			rotate([0, 0, 30+i*120])
			translate([ledRadius-1, 0, -smidge/2])
			cylinder(r=1.0, h=baseHeight+smidge, $fn=16);
			
			// Gutter between LED leads and common hole.
			hull()
			{
				rotate([0, 0, 30+i*120-20+2.92])
				translate([ledRadius, 0, baseHeight-1+smidge/2])
				cylinder(r=1.0, h=1.0, $fn=16);
				
				rotate([0, 0, 30+i*120+20-2.92])
				translate([ledRadius, 0, baseHeight-1+smidge/2])
				cylinder(r=1.0, h=1.0, $fn=16);
			}
/*
			// Common hole outside leads.
			rotate([0, 0, 60+30+i*120])
			translate([ledRadius-2, 0, -smidge/2])
			#cylinder(r=1.0, h=baseHeight+smidge, $fn=16);
*/			
			// Pairs of holes outside leads.
			for (dir = [-1, 1])
			{
				rotate([0, 0, 30+i*120+dir*20+dir*3*2.92])
				translate([ledRadius-1, 0, -smidge/2])
				cylinder(r=1.0, h=baseHeight+smidge, $fn=16);
			}

			// Top gutters between LED leads and outside holes.
			for (dir = [-1, 1])
				hull()
				{
					rotate([0, 0, 30+i*120+dir*20+dir*2.92])
					translate([ledRadius, 0, baseHeight-1+smidge/2])
					cylinder(r=1.0, h=1.0, $fn=16);
					
					rotate([0, 0, 30+i*120+dir*20+dir*3*2.92])
					translate([ledRadius-1, 0, baseHeight-1+smidge/2])
					cylinder(r=1.0, h=1.0, $fn=16);
				}

			// Bottom gutters between holes outside leads.
			bottomGutter(1);
		}
	}
}


module effectorInside()
{
	difference()
	{
		union()
		{
			// Center area.
			cylinder(r=insideBaseRadius, h=centerBaseHeight);

			// Raised area to hold the hot end's mount.
			difference()
			{
				cylinder(r=maxMountHoleRadius+3, h=mountHeight+mountHeightExt);
				cylinder(r=minMountHoleRadius,   h=mountHeight+mountHeightExt);
				translate([0, 0, mountHeight])
				cylinder(r=maxMountHoleRadius, h=mountHeightExt+smidge);
			}

			// Wings for securing screws.
			translate([-keyX/2, 2.5-smidge-keyY/2, 0])
			cube([keyX, keyY, mountHeight+mountHeightExt]);
		}
	
		// Oblong hole for the mount.
		hull()
		{
			translate([0, 0, -smidge/2])
			cylinder(r=minMountHoleRadius, h=mountHeight+smidge);

			translate([0, maxMountHoleOffset+8, -smidge/2])
			cylinder(r=minMountHoleRadius, h=mountHeight+smidge);
		}

		// Oblong hole for the top of the groove mount.
		translate([0, 0, mountHeight])
		hull()
		{
			translate([0, 0, -smidge/2])
			cylinder(r=maxMountHoleRadius, h=mountHeight+smidge);

			translate([0, maxMountHoleOffset, -smidge/2])
			cylinder(r=maxMountHoleRadius, h=mountHeight+smidge);
		}

		// Hole for inserting the mount.
		translate([0, 2+maxMountHoleOffset, -smidge/2])
		cylinder(r=maxMountHoleLooseRadius, h=mountHeight+smidge);

		// Two holes for securing the mount key.
		translate([secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);

		translate([-secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);

		// Finish the bottom gutters between holes' outside leads.
		bottomGutter(1);
	}	
}

module bottomGutter(i)
{
	hull()
	{
		rotate([0, 0, 30+i*120+20+3*2.92])
		translate([ledRadius-1, 0, -smidge/2])
		cylinder(r=1.0, h=1, $fn=16);
				
		rotate([0, 0, 30+(i+1)*120-20-3*2.92])
		translate([ledRadius-1, 0, -smidge/2])
		cylinder(r=1.0, h=1, $fn=16);
	}
}


module mountKey(extra=0)
{
	h = mountHeight + mountHeightExt - centerBaseHeight + extra;
	
	difference()
	{
		union()
		{
			// The wings on the side of the mount key for securing it.
			translate([-keyX/2, keyY, centerBaseHeight])
			cube([keyX, keyY, h+extra]);

			// The cylindrical body.
			translate([0, 0, centerBaseHeight])
			cylinder(r=maxMountHoleRadius+3, h=h);
		}

		// The box which clips off the flat edge against the mount.
		translate([-keyX/2,
		           keyY-2*maxMountHoleRadius,
		           centerBaseHeight-smidge/2])
		cube([keyX, 2*maxMountHoleRadius, h+smidge]);

		// Hole for the mount.
		translate([0, 0, -smidge/2])
		cylinder(r=minMountHoleRadius, h=mountHeight+smidge);

		// Hole for the top of the groove mount.			
		translate([0, 0, mountHeight-smidge/2])
		cylinder(r=maxMountHoleRadius, h=mountHeight+smidge);

		// Two holes for securing the mount key.
		translate([secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);

		translate([-secureScrewX, secureScrewY, secureScrewZ])
		rotate([-90, 0, 0])
		cylinder(r=m3LooseRadius, 10+smidge, center=true, $fn=16);
	}
}


union()
{
	effectorOutside();

	difference()
	{
		effectorInside();

		// The box which clips off the flat edge against the mount key.
		// The extra smidge in the -Y direction helps hold it tight.
		translate([-keyX/2,
		           keyY-smidge,
		           centerBaseHeight])
		cube([keyX,
		      maxMountHoleRadius,
		      mountHeight + mountHeightExt - centerBaseHeight+smidge]);
	}
	
	%mountKey();

	translate([0, 28, -centerBaseHeight])
	mountKey();
}
