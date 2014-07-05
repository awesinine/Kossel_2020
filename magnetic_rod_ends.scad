magnet_dia = 9.5;
magnet_length = 9.5;
rod_dia = 5.8;
rod_connector_length = 15.0;
wall_thickness = 2.0;
gap = 3.0;

$fn=100;

difference(){

	// main body
	hull(){
		sphere(rod_dia/2.0 + wall_thickness, center=true);
		translate([0,0,magnet_length + rod_connector_length + gap + rod_dia]) sphere(magnet_dia/2 + 1.0);
	}

	// cut off the top
	translate([0,0,magnet_length + rod_connector_length + gap + rod_dia]) 
		cylinder(h = magnet_dia, r=magnet_dia/2 + 2.0);

	// cut out for the magnet
	translate([0,0,rod_connector_length + 1.5]) cylinder(h=magnet_length + gap,r=magnet_dia/2.0);

	// cut out for the rod
	translate([0,0,-5.1]) cylinder(h=rod_connector_length + 7, r=rod_dia/2.0);

	// cut out for the ball
	translate([0,0,magnet_length + rod_connector_length + gap + rod_dia - 0.5]) sphere(9.5/2);
%	translate([0,0,magnet_length + rod_connector_length + gap + rod_dia - 0.5]) sphere(9.5/2);
}