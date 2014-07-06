ball_dia = 9.5;
magnet_dia = 9.5 + 0.5;
magnet_length = 9.5;
rod_dia = 5.8;
rod_connector_length = 15.0;
wall_thickness = 1.2;
gap = 1.0;		// Accounts for the extra gap created by the ball cutout

$fn=100;

module rodEnd()
{
difference(){

	// main body
	hull(){
		sphere((rod_dia+wall_thickness)/2.0, center=true);
		translate([0,0,rod_connector_length]) 
			cylinder(h=magnet_length+gap+ball_dia/2-1.5, r=(magnet_dia+wall_thickness)/2);
	}

	// cut off the top
	translate([0,0,magnet_length + rod_connector_length + gap + rod_dia]) 
		cylinder(h = magnet_dia, r=magnet_dia/2 + 2.0);

	// cut out for the magnet
	translate([0,0,rod_connector_length]) cylinder(h=magnet_length + gap,r=magnet_dia/2.0);

	// cut out for the rod
	translate([0,0,-6.1]) cylinder(h=rod_connector_length + 8, r=rod_dia/2.0 + 0.1);
	// add slope
	translate([0,0,rod_connector_length]) sphere(magnet_dia/2);

	// cut out for the ball
	translate([0,0,rod_connector_length + magnet_length + gap + ball_dia/2 - 1.0]) 
		sphere(ball_dia/2);
}

	// Show the ball
	%translate([0,0,magnet_length + rod_connector_length + gap + rod_dia - 1.0]) sphere(ball_dia/2);

	// Show the magnet
%	translate([0,12,rod_connector_length]) cylinder(h=magnet_length,r=magnet_dia/2.0);
}

rotate([180,0,0]) rodEnd();

	