base_length=40;
base_width=27.25;
base_height=6.5;
corner_rad=4;
arm_distance=42;
sphere_offset_y=5.75; //offset from bolt holes to center of sphere
ball_radius=4.7625;
belt_clamp_height = 6.2;

$fn=24;


module 20mm_frame(){
	translate([0,0,0]) difference(){
	hull(){ //square base with rounder bottom corners

			translate([-base_width/2,-base_length/2+corner_rad,0]){
				cube([base_width,base_length-corner_rad,base_height]);}
			translate([-(base_width/2-corner_rad),-(base_length/2-corner_rad),0]){
				cylinder(h=base_height,r=4, $fn=100);}
			translate([(base_width/2-corner_rad),-(base_length/2-corner_rad),0]){
				cylinder(h=base_height,r=4, $fn=100);}

		}
	}
}

module belt_holder(){
	union(){
		translate([-3.3,-0.5,base_height-0.1]) cube([7,8,7.1]);//top
		translate([-2,-9.6,base_height-0.1]) cube([8.6,7.5,7.1]);//middle
		translate([-3.3,-19.2,base_height-0.1]) cube([7,7.9,7.1]);//bottom

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
   translate([3.20, (5 + corner_radius + 10/2 + 1.5), 0])  cube([5, 10, belt_clamp_height], center=true);
   // bottom cube
   translate([3.20, -(5 + corner_radius + 10/2 + 1.5), 0]) cube([5, 10, belt_clamp_height], center=true);
	// solid side
	translate([3.20 + solid_side_width + belt_gap, 0, 0]) cube([solid_side_width, base_length, belt_clamp_height], center=true);	
}

module ball_holders(){
	difference(){

		union(){
			hull(){ //right
					translate([arm_distance/2,(base_length/2-corner_rad)-4,0]){ //cylinder..
						cylinder(h=base_height,r=6, $fn=100);} 
					translate([base_width/2,(base_length-(base_length/1.5))/2,base_height/2]){ //wing
						cube([0.1,base_length/1.5,base_height],center=true);}
					translate([arm_distance/2,(base_length/2-corner_rad)-4,base_height]){ //boss
						rotate([35,0,0]) cylinder(h=2,r=6.5, $fn=100);}
			}
			hull(){ //left
					translate([-arm_distance/2,(base_length/2-corner_rad)-4,0]){ //cylinder..
						cylinder(h=base_height,r=6, $fn=100);}
					translate([-base_width/2,(base_length-(base_length/1.5))/2,base_height/2]){ //wing
						cube([0.1,base_length/1.5,base_height],center=true);}
					translate([-arm_distance/2,(base_length/2-corner_rad)-4,base_height]){ //boss
						rotate([35,0,0]) cylinder(h=2,r=6.5, $fn=100);}
			}

			translate([0,0,base_height+belt_clamp_height/2-0.1]) belt_clamp();
		}
		
		hull(){ //right rod clearance
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,-12]) cylinder(h=40,r1=4,r2=4, $fn=100);
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,12]) cylinder(h=40,r1=4,r2=4, $fn=100);
		}
		hull(){ //left rod clearance
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,12]) cylinder(h=40,r1=4,r2=4, $fn=100);
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,-12]) cylinder(h=40,r1=4,r2=4, $fn=100);
		}

		//sphere pockets
		translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) sphere(ball_radius, $fn=100);
		translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) sphere(ball_radius, $fn=100);		

	}
}

module carriage(){
	difference() {
		union(){
			20mm_frame(); 
			ball_holders();
		}

		//right rod clearance
		hull(){ 
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,-12]) cylinder(h=40,r1=4,r2=4, $fn=100);
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,12]) cylinder(h=40,r1=4,r2=4, $fn=100);
		}

		//left rod clearance
		hull(){ 
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,12]) cylinder(h=40,r1=4,r2=4, $fn=100);
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,-12]) cylinder(h=40,r1=4,r2=4, $fn=100);
		}

		// screw holes
		translate([0,-4,0]) for(a=[0:90:359]){  // rail carriage bolt holes
			rotate([0,0,a]) translate([10,10,-5]) cylinder(h=20,r=1.5,$fn=18);
		}

	}
}
//scale(25.4) import("MagnetCarriage.stl");

//translate([arm_distance/2, (base_length/2-corner_rad)-4, 8]) sphere(ball_radius);
//translate([-arm_distance/2, (base_length/2-corner_rad)-4, 8]) sphere(ball_radius);

carriage();

