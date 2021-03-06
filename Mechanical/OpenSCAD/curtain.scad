$fn=100;

use <servo.scad>

bead_r = 2.5;

module wheel()
{
	s_thick = 1.5;
	s_gap = 1;
	
	radius = 25;
	
	module slice(cut=false)
	{
		grooves = 22;
		bead_d = 21.5;
	
		te = (6.28*radius/grooves-0.5)/2; re = radius-bead_d;
	
		difference()
		{
			circle(r=radius);
			for(i=[0:grooves-1]) rotate(a=i*360/grooves) translate([0,bead_d,0])
			{
				circle(r=bead_r);
				polygon(points=[[bead_r,0],[-bead_r,0],[-te,re],[te,re]]);
			}
			difference(){ circle(r=radius); circle(r=radius-0.25); }
			if(cut){ difference(){ circle(r=radius); circle(r=bead_d); } }
		}
	}
	
	translate([0,0,s_thick])
	{
		translate([0,0,bead_r-s_gap]) linear_extrude(s_gap) slice(true);
		linear_extrude(bead_r-s_gap) slice();
	}
	cylinder(r=radius,h=s_thick);
}

module wheel_assembly(spokes=12,bore=6)
{
	holes = [10,16];
	difference()
	{
		wheel();
		cylinder(r=bore,h=10,center=true);
		for(i=[0:spokes-1]) rotate(a=i*360/spokes) for(j=holes) translate([0,j,0]) cylinder(r=1,h=10,center=true);
	}
}

module limit_trigger()
{
	bead_d = 6.5;
	difference()
	{
		translate([0,0,1.9]) cube([25,6,3.8],center=true);
		translate([0,0,3.1]) cube([25,1,1.5],center=true);
		for(i=[-2,-1,0,1,2]) translate([bead_d*i,0,1.35]) cylinder(r=bead_r,h=bead_r);
	}
}

module rail_mount()
{
	length = 70;
	mount = [length,29.5,17];
	module rail_clasp()
	{
		rail_d = 14; // distance between rails
		
		rail = [length+1,2.5,12];
		
		difference()
		{
			cube(mount,center=true);
			for(i=rail_d/2*[-1,1])
			{
				translate([0,i,(mount[2]-rail[2])/2+0.01]) cube(rail,center=true);
				for(j=[-1,1]) translate([j*((length-rail[2])/2+1),i,0])
					rotate([0,90,0]) cube(rail,center=true);
			}
			translate([0,0,6.5]) cube([length+1,rail_d,6],center=true);
		}
	}
	
	translate([0,mount[1]/2,0]) cube([length,2,mount[2]],center=true);
	
	difference()
	{
		rail_clasp();
		for(i=[-3,-1,1,3]) translate([i*10,0,0]) cylinder(r=2.5,h=30,center=true);
	}
	
	difference()
	{
		translate([0,18,6.5]) cube([length,6,30],center=true);
		for(i=[-3,-1,1,3]) for(j=[-1,0,1])
			translate([i*8,13.5,14]) rotate([90,0,0])
			{
				cylinder(r=3.5,h=10,$fn=6,center=true);
				cylinder(r=1.5,h=20,center=true);
			}
	}
}

limit_trigger();

//for(i=[-1,1]) translate([0,5*i,26]) rotate([90*i,0,0]) wheel_assembly();
//translate([0,-30,8.5]) rail_mount();