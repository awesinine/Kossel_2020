eFlatHeight = 2;
eTaperHeight = 6;
eRadius = 35;
eTaperDistance = 10;

difference(){
	rotate([0,0,-15]) difference(){
	
		union(){
			cylinder(h=eFlatHeight,r=eRadius);
			translate([0,0,eFlatHeight]) cylinder(h=eTaperHeight,r1=eRadius,r2=eRadius-eTaperDistance);
		}
		union(){ //J-head sized hole
			cylinder(h=20,r=4.45);
			translate([0,0,-0.1]) cylinder(h=2.8,r=7.99);
		}
		for (a = [-15:60:359]) rotate([0, 0, a]) { //mounting holes
		     translate([0, 12.5, 0]) cylinder(r=1.5, h=20, center=true, $fn=12);
		}
		for (b = [0:120:359]) rotate([0,0,b]) { //first set of spherical holes
			translate([0, 30, 1+eFlatHeight+eTaperHeight/2]) sphere(9.5/2);
		}
		for (b = [90:120:359]) rotate([0,0,b]) { //second set of spherical holes
			translate([0, 30, 1+eFlatHeight+eTaperHeight/2]) sphere(9.5/2);
		}
	}

	for (a=[30:120:359]) rotate([0,0,a]) {
		difference(){
			union(){
				translate([0,32,0]) cube([46,15,20],center=true);
				hull(){
					translate([0,28,-1]) cylinder(h=20,r=12);
					translate([0,55,-1]) cylinder(h=20,r=34);
				}
			}	
			translate([21,19,0]) cylinder(h=20,r=8);
			translate([-21,19,0]) cylinder(h=20,r=8);
		}
	}

}

