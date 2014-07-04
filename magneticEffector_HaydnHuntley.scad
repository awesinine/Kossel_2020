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

$fn = 360/4;

include <configuration_HaydnHuntley.scad>;

// All measurements in mm.
insideBaseRadius        = 43.0 / 2;
ledRadius				= insideBaseRadius + 3.0;
releauxRadius			= 120.0 / 2;
centerBaseHeight        = 3.0;
baseHeight              = 8.0;
mountHeight             = 6.3;  // The height of the mount.
mountHeightExt				= 4.0;  // The height of the next part of the mount.
minMountHoleRadius      = (12.15+0.5) / 2;
maxMountHoleRadius      = (16.15+0.2) / 2;
maxMountHoleLooseRadius = (maxMountHoleRadius + 0.5);
maxMountHoleOffset      = (minMountHoleRadius + maxMountHoleRadius) / 2;
ringHoleCount           = 12;
edgeRadius              = baseHeight/2;
sides                   = 3;
sideOffset			    = insideBaseRadius;
sideLength              = ballJointSeparation + 3 * edgeRadius;
secureScrewOffset       = 15.0;


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
		cylinder(r=insideBaseRadius,
				 h=baseHeight+smidge);

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
		for (i = [0:2])
			for (j = [-20, 20])
				rotate([0, 0, 30+i*120+j])
				{
					translate([ledRadius, -0.05*mmPerInch, -smidge/2])
					cylinder(r=1.0, h=baseHeight+smidge, $fn=16);
					translate([ledRadius, 0.05*mmPerInch, -smidge/2])
					cylinder(r=1.0, h=baseHeight+smidge, $fn=16);
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
		}
	
		// Oblong hole for the mount.
		hull()
		{
			translate([0, 0, -smidge/2])
			cylinder(r=minMountHoleRadius, h=mountHeight+smidge);

			translate([0, maxMountHoleOffset, -smidge/2])
			cylinder(r=minMountHoleRadius, h=mountHeight+smidge);
		}

		// Oblong hole for the top of the groove mount.
		translate([0, 0, mountHeight])
#		hull()
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
		rotate([0, 0, 60])
		translate([0, secureScrewOffset, -smidge/2])
		cylinder(r=m3LooseRadius, 10, $fn=16);

		rotate([0, 0, -60])
		translate([0, secureScrewOffset, -smidge/2])
		cylinder(r=m3LooseRadius, 10, $fn=16);
	}	
}


module mountKey(extra=0)
{
	h = mountHeight - centerBaseHeight + extra;
	r = 4.0;

	difference()
	{
		union()
		{
			hull()
			{
				rotate([0, 0, 60])
				translate([0, secureScrewOffset, 0])
				cylinder(r=r, h);

				rotate([0, 0, -60])
				translate([0, secureScrewOffset, 0])
				cylinder(r=r, h);
			}

			cylinder(r=maxMountHoleRadius+3,
					 h=h+mountHeightExt);
			translate([0, 0, h])
			cylinder(r=maxMountHoleRadius, h=mountHeightExt);
		}

		translate([-secureScrewOffset, -3*r, -smidge/2])
		cube([2*secureScrewOffset, 4*r, h+mountHeightExt+smidge]);

		// Hole for the mount.
		translate([0, 0, -smidge/2])
		cylinder(r=minMountHoleRadius, h=h+smidge);

		translate([0, 0, h])
		cylinder(r=maxMountHoleRadius, h=mountHeightExt+smidge);

		// Two holes for securing the mount key.
		rotate([0, 0, 60])
		translate([0, secureScrewOffset, -smidge/2])
		cylinder(r=m3LooseRadius, h+smidge, $fn=16);

		rotate([0, 0, -60])
		translate([0, secureScrewOffset, -smidge/2])
		cylinder(r=m3LooseRadius, h+smidge, $fn=16);
	}
}


union()
{
	effectorOutside();

	difference()
	{
		effectorInside();

		translate([0, 0, centerBaseHeight])
		mountKey(smidge);
	}
	
	%translate([0, 0, centerBaseHeight])
	mountKey();

	translate([0, 28, 0])
	mountKey();
}