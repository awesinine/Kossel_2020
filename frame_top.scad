include <configuration.scad>;

use <vertex.scad>;

$fn = 280;


fin_w=5.2;
fin_d=4;  // 5x4 for the vertical extrusion fins
fins=1;   // Yes use fins

top_frame_height = 2.5*extrusion;
motor_z_offset = 1.5; // use 1.5 for 40mm height

module frame_top() {
  difference() {
  	vertex(top_frame_height, idler_offset=3, idler_space=12.5, fin_w=fin_w, fin_d=fin_d, fins=fins, fn=200);

    // KOSSEL logotype.
    translate([23, -11, 0]) rotate([90, -90, 30])
      scale([0.11, 0.11, 1]) import("logotype.stl");
    // Motor cable paths.
    for (mirror = [-1, 1]) scale([mirror, 1, 1]) {
      translate([-35, 45, 0]) rotate([0, 0, -30])
         cube([4, 15, 15], center=true);
      translate([-6-3, 0, -35]) cylinder(r=3.5, h=40);
      translate([-11, 0, 0])  cube([15, 5.2, 15], center=true);
    }

    // M3 bolt to support idler bearings.
    translate([0, 65, 0]) rotate([90, 0, 0]) cylinder(r=m3_radius, h=55);
    
    // Vertical belt tensioner.
    translate([0, 13, 18]) rotate([12, 0, 0]) union() {
      cylinder(r=m3_wide_radius, h=30, center=true);
      translate([0, -4.25, 8]) rotate([-12,0,0])cube([5.6, 6, 8], center=true);
      translate([0, 0, 2.5]) scale([1, 1, -1]) rotate([0, 0, 0])   cylinder(r1=m3_nut_radius+0.2, r2=m3_nut_radius+0.3, h=15, $fn=6);
    }
   //sink innner belt pulley screw
   translate([0,49-thickness,(extrusion/2)/2-5])rotate([90,0,0])cylinder(h=5, r=3, center=true);


  }
}

translate([0, 0, top_frame_height/2]) frame_top();
