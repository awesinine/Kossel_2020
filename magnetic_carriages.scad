base_length=40;
base_width=27.25;
base_height=6.5;
corner_rad=4;
arm_distance=42;
sphere_offset_y=5.75; //offset from bolt holes to center of sphere
ball_radius=4.7625;
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
		translate([0,-4,0]) for(a=[0:90:359]){  // rail carriage bolt holes
			rotate([0,0,a]) translate([10,10,-5]) cylinder(h=20,r=1.5,$fn=18);
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
		}
		
		hull(){ //right rod clearance
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,-12]) cylinder(h=20,r1=4,r2=4, $fn=100);
			translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,12]) cylinder(h=20,r1=4,r2=4, $fn=100);
		}
		hull(){ //left rod clearance
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,12]) cylinder(h=20,r1=4,r2=4, $fn=100);
			translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) rotate([90,0,-12]) cylinder(h=20,r1=4,r2=4, $fn=100);
		}

		//sphere pockets
		translate([arm_distance/2, (base_length/2-corner_rad)-5, 9]) sphere(ball_radius, $fn=100);
		translate([-arm_distance/2, (base_length/2-corner_rad)-5, 9]) sphere(ball_radius, $fn=100);		

	}
}

module base(){
	translate([0,0,0]) union(){
		20mm_frame(); 
		belt_holder();
		ball_holders();
	}
}
//scale(25.4) import("MagnetCarriage.stl");

//translate([arm_distance/2, (base_length/2-corner_rad)-4, 8]) sphere(ball_radius);
//translate([-arm_distance/2, (base_length/2-corner_rad)-4, 8]) sphere(ball_radius);

base();

