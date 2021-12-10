rect_width = 10.0;
rect_height_offset = 2.0;
rect_wall_thickness = 6.0;
outlet_spacing = 2.0;
outlet_outer_diam = 5.0;
outlet_inner_diam = 4.0;
outlet_length = 9.0;
outlet_count = 4;
draw_barb = true;
barb_length_mul = 0.3;
barb_max_mul = 1.1;
barb_min_mul = 0.7;
show_inside = false;


module main(){
    //Draw rect
    difference()
    {
        union()
        {
            drawRect();
            drawCylinders(outlet_outer_diam, 0);
            
        }
        scale(v=[1+barb_length_mul,1,1]){
            drawCylinders(outlet_inner_diam, 0.1);
        }
        cube([r_width-rect_wall_thickness, r_length, r_height-rect_wall_thickness+(show_inside ? 100 : 0)], center=true);
    }
    
    
    //Remove rect internal to make hollow. 
}

r_width = rect_width;
r_height = outlet_outer_diam + 2*rect_height_offset;
r_length = (outlet_outer_diam * outlet_count) + (outlet_spacing * (outlet_count+1));

module drawRect(){
    cube([r_width, r_length+rect_wall_thickness, r_height], center=true);
}

barb_length = outlet_length * barb_length_mul;

module drawCylinders(diam, h_offset){
    for (i = [0:outlet_count-1]){
        //place cylinder on box.     
        x_mov = (outlet_length + (0.5*rect_width))*0.5;
        y_mov =  (r_length * -0.5) + (outlet_outer_diam*0.5)+ outlet_spacing + (i * (outlet_spacing + outlet_outer_diam));
        translate([x_mov, y_mov, 0])
        rotate([0, 90, 0])
        //Draw cylinder
        union(){
            cylinder(h=outlet_length+(0.5*rect_width)+h_offset, d=diam, center=true, $fn=100);
            //Draw barb optional
            
            if (draw_barb && h_offset == 0){ //hack with h_offset.
                rotate([-180, 0, 0])
                translate([0, 0, -outlet_length + 0.5*barb_length])
                cylinder(h=barb_length, d1= diam * barb_min_mul, d2= diam*barb_max_mul, center=true, $fn=100);
            }
        }
    }
}


main();