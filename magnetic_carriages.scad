include <configuration.scad>;

base_length=45;
base_width=27.25;
base_height=6.5;
corner_rad=4;
arm_distance=48;
sphere_offset_y=5.75; //offset from bolt holes to center of sphere
ball_radius=4.7625;
belt_clamp_height = 6.2;


mmPerInch			= 25.4;

separation = 40;

horn_thickness = 13;
horn_x = 8;

belt_width = 5;
belt_x = 5.6;
belt_z = 7;

ballJointSeparation = arm_distance;
ballRadius			= (3/8 * mmPerInch)/2;
ballBaseRadius		= 10.0 / 2;
wingWidth			= 12.0;
wingHeight			= 12.0;

$fn=100;


module 20mm_frame(){
	translate([0,0,0]) union(){
		hull(){ //square base with rounder bottom corners
				translate([-base_width/2,-base_length/2+corner_rad,0]){
					cube([base_width,base_length-corner_rad,base_height]);}
				translate([-(base_width/2-corner_rad),-(base_length/2-corner_rad),0]){
					cylinder(h=base_height,r=4, $fn=100);}
				translate([(base_width/2-corner_rad),-(base_length/2-corner_rad),0])
					cylinder(h=base_height,r=4, $fn=100);
			}
	}
}

module belt_clamp(){

	corner_radius = 3.5;
	belt_gap = 2.4;
	solid_side_width = 5.35;

	for (y = [[5, -1], [-5, 1]]) {
     	translate([2.20, y[0], 0]) hull() {
         translate([ corner_radius-1,  -y[1] * corner_radius + y[1], 0]) cube([2, 2, belt_clamp_height], center=true);
      	cylinder(h=belt_clamp_height, r=corner_radius,  center=true);
   	}
   }

   // top cube
   translate([3.20, (5 + corner_radius + 12.5/2 + 1.5), 0])  cube([5, 12.5, belt_clamp_height], center=true);
   // bottom cube
   translate([3.20, -(5 + corner_radius + 12.5/2 + 1.5), 0]) cube([5, 12.5, belt_clamp_height], center=true);
	// solid side
	translate([3.20 + solid_side_width + belt_gap, 0, 0]) cube([solid_side_width, base_length, belt_clamp_height], center=true);	
}


module stud_wings(spacing, height)
{
	filletRadius = 6;
	heightOffset = -3;
	difference () {
		union () {
			// Add wings to hold the ball screws.
			translate([0, -wingHeight/2, base_height/2])
			roundedBox([spacing+wingWidth, wingHeight, height],
					   filletRadius, true);
			
			// Add two pillars in the wings, angled at 30 degrees, for the
			// ball studs.
			translate([0, .63, 0])
			union()
			{
				for (x = [-1, 1]) {
					hull()
					{
						translate([x*spacing/2, 0, heightOffset])
						rotate([30, 0, 0])
						translate([0, 0, 11])
						cylinder(r=ballBaseRadius, h=5.7);
		
						translate([x*(spacing)/2,
								   -wingHeight/2-0.63,
								   height/2])
						roundedBox([wingWidth, wingHeight, height], filletRadius,
								true);
					}
				}					
			}
		}
		// Two holes in the wings, angled at 30 degrees, for the ball studs,
		// and with nut traps.
		translate([0, 0.6, heightOffset]) 
		for (x = [-1, 1]) {
				translate([x*spacing/2, 0, 0])
				rotate([30, 0, 0])
				m3x10((14)/cos(30));
		}
	}
}

module roundedBox(size, radius, sidesonly)
{
	rot = [ [0,0,0], [90,0,90], [90,90,0] ];
   	if (sidesonly)
	{
   		cube(size - [2*radius,0,0], true);
      	cube(size - [0,2*radius,0], true);
      	for (x = [radius-size[0]/2, -radius+size[0]/2],
      		  y = [radius-size[1]/2, -radius+size[1]/2])
		{
      		translate([x,y,0])
				cylinder(r=radius, h=size[2], center=true);
      }
   }
	else
	{
   		cube([size[0], size[1]-radius*2, size[2]-radius*2], 
			  center=true);
      cube([size[0]-radius*2, size[1], size[2]-radius*2],
			  center=true);
      cube([size[0]-radius*2, size[1]-radius*2, size[2]],
			  center=true);

      for (axis = [0:2])
		{
      		for (x = [radius-size[axis]/2, -radius+size[axis]/2],
              y = [radius-size[(axis+1)%3]/2, 
						-radius+size[(axis+1)%3]/2])
			{
         		rotate(rot[axis]) 
					translate([x,y,0]) 
                	cylinder(h=size[(axis+2)%3]-2*radius, 
								   r=radius, center=true);
			}
		}
   		for (x = [radius-size[0]/2, -radius+size[0]/2],
           y = [radius-size[1]/2, -radius+size[1]/2],
           z = [radius-size[2]/2, -radius+size[2]/2])
		{
      		translate([x,y,z]) sphere(radius);
      }
	}
}


module m3x10(h)
{
	translate([0, 0, -m3_wide_radius])
	{
		cylinder(r=m3_wide_radius, h=h+2*m3_wide_radius);
		translate([0, 0, -2])
		cylinder(r1=m3_nut_radius+0.5,
				 r2=m3_nut_radius,
				 h=h+2*m3_wide_radius-5, $fn=6);
	}
}

module carriage(){
	difference() {
		union(){
			20mm_frame(); 
			// Belt clamps
			translate([0,0,base_height-0.1])
			intersection() {
			 	translate([0,0,belt_clamp_height/2]) belt_clamp();
				20mm_frame();
			}
      	// Magnetic attachment 'wings'
      	translate([0, 24, 0])
			  stud_wings(ballJointSeparation, base_height);
			// Wing support
			difference() {
				
			}
		}

		//right rod clearance
		hull(){ 
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 14]) rotate([90,0,-12]) cylinder(h=40,r1=4,r2=4, $fn=100);
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 14]) rotate([90,0,12]) cylinder(h=40,r1=4,r2=4, $fn=100);
		}

		//left rod clearance
		hull(){ 
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 14]) rotate([90,0,12]) cylinder(h=40,r1=4,r2=4, $fn=100);
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 14]) rotate([90,0,-12]) cylinder(h=40,r1=4,r2=4, $fn=100);
		}

		// screw holes
		translate([0,0,0]) for(a=[0:90:359]){  // rail carriage bolt holes
			rotate([0,0,a]) translate([10,10,-5]) cylinder(h=20,r=1.55,$fn=18);
		}

	}
}
//scale(25.4) import("MagnetCarriage.stl");

//translate([arm_distance/2, (base_length/2-corner_rad)-4, 8]) sphere(ball_radius);
//translate([-arm_distance/2, (base_length/2-corner_rad)-4, 8]) sphere(ball_radius);

carriage();
//stud_wings(ballJointSeparation, base_height);
