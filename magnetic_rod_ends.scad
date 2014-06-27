magnet_dia = 9.5;
magnet_length = 9.5;
rod_dia = 5.8;
rod_connector_length = 15.0;
wall_thickness = 1.2;
gap = 3.0;

$fn=100;

difference(){

	union(){
		cylinder(h=magnet_length + rod_connector_length + gap, r1 = rod_dia/2.0 + 1.0, r2=magnet_dia/2.0 + wall_thickness);
		translate([0,0,magnet_length + rod_connector_length + gap]) cylinder(h=2.5,r1=magnet_dia/2.0+wall_thickness,r2=4.0);
	}

	translate([0,0,rod_connector_length + 1.5]) cylinder(h=magnet_length + gap,r=magnet_dia/2.0);
	translate([0,0,-0.1]) cylinder(h=rod_connector_length + 2, r=rod_dia/2.0);
	translate([0,0,magnet_length + rod_connector_length + gap + 5.9]) sphere(9.5/2);
%	translate([0,0,magnet_length + rod_connector_length + gap + 5.9]) sphere(9.5/2);
}
//difference(){
//translate([0,0,-0.1]) cylinder(h=23.2,r=3);
//	translate([0,0,27.9]) sphere(9.5/2);
//}
