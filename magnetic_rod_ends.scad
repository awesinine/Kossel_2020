$fn=50;

difference(){

	union(){
		cylinder(h=21.5,r=4.5);
		translate([0,0,21.5]) cylinder(h=2.5,r1=4.5,r2=3);
	}

	translate([0,0,-0.1]) cylinder(h=23.2,r=3.125);
	translate([0,0,-0.1]) cylinder(h=25,r=2);
	translate([0,0,27.9]) sphere(9.5/2);
}
//difference(){
//translate([0,0,-0.1]) cylinder(h=23.2,r=3);
//	translate([0,0,27.9]) sphere(9.5/2);
//}
