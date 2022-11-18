include <dimensions.scad>

// Connector bar at the bottom of a box. This part helps with stacking of boxes.
module connector_bar() {
    connector_offset = u_wall_thickness + u_connector_clearance;
    
    additional_offset = tan(connector_angle) * (u_connector_height - u_bottom_thickness);
    middle_offset = connector_offset + connector_bar_plane_width + additional_offset;
    
    points = [
        // bottom
        [u_connector_width + connector_offset, u_connector_width + connector_offset, 0],
        [u_size - u_connector_width - connector_offset, u_connector_width + connector_offset, 0],
        [u_size - u_connector_width - connector_offset, u_size - u_connector_width - connector_offset, 0],
        [u_connector_width + connector_offset, u_size - u_connector_width - connector_offset, 0],

        // top - outer
        [connector_offset, connector_offset, u_connector_height],
        [u_size - connector_offset, connector_offset, u_connector_height],
        [u_size - connector_offset, u_size - connector_offset, u_connector_height],
        [connector_offset, u_size - connector_offset, u_connector_height],

        // top - inner
        [connector_offset + connector_bar_plane_width, connector_offset + connector_bar_plane_width, u_connector_height],
        [u_size - connector_offset - connector_bar_plane_width, connector_offset + connector_bar_plane_width, u_connector_height],
        [u_size - connector_offset - connector_bar_plane_width, u_size - connector_offset - connector_bar_plane_width, u_connector_height],
        [connector_offset + connector_bar_plane_width, u_size - connector_offset - connector_bar_plane_width, u_connector_height],

        // middle
        [middle_offset, middle_offset, u_bottom_thickness],
        [u_size - middle_offset, middle_offset, u_bottom_thickness],
        [u_size - middle_offset, u_size - middle_offset, u_bottom_thickness],
        [middle_offset, u_size - middle_offset, u_bottom_thickness],
    ];
    faces = [
        [1, 2, 3, 0], // bottom bottom
        [15, 14, 13, 12], // bottom top
        [8, 9, 5, 4], // top front
        [10, 11, 7, 6], // top back
        [11, 8, 4, 7], // top left
        [9, 10, 6, 5], // top right
        [4, 5, 1, 0], // front outer
        [6, 7, 3, 2], // back outer
        [7, 4, 0, 3], // left outer
        [5, 6, 2, 1], // right outer
        [12, 13, 9, 8], // front inner
        [14, 15, 11, 10], // back inner
        [15, 12, 8, 11], // left inner
        [13, 14, 10, 9] // right inner
    ];
    polyhedron(points, faces);
}


// Creates the connector bars for size a x b.
module nxn_connector_bar(a, b) {
    for(i = [0 : 1 : a - 1]) {
        for(j = [0 : 1 : b - 1]) {
            translate([i*u_size, j*u_size, 0])
                connector_bar();
        }
    }
}


// Additional part on top of the connector bar. This part makes sure that the
// bottom of larger parts is properly connected and strong.
module connector_bar_ridge() {
    connector_offset = u_wall_thickness + u_connector_clearance;
    
    tmp_a = u_connector_ridge_height / tan(90 - connector_angle);
    tmp_top_width = connector_offset + connector_bar_plane_width - tmp_a;
    
    bottom_offset = connector_offset + connector_bar_plane_width;
    
    top_offset = tmp_top_width > u_connector_wall_thickness ? tmp_top_width : u_connector_wall_thickness;
    
    points = [
        // bottom outer
        [0, 0, 0],
        [u_size, 0, 0],
        [u_size, u_size, 0],
        [0, u_size, 0],
    
        // bottom inner
        [bottom_offset, bottom_offset, 0],
        [u_size - bottom_offset, bottom_offset, 0],
        [u_size - bottom_offset, u_size - bottom_offset, 0],
        [bottom_offset, u_size - bottom_offset, 0],
    
        // top outer
        [0, 0, u_connector_ridge_height],
        [u_size, 0, u_connector_ridge_height],
        [u_size, u_size, u_connector_ridge_height],
        [0, u_size, u_connector_ridge_height],
    
        // top inner
        [top_offset, top_offset, u_connector_ridge_height],
        [u_size - top_offset, top_offset, u_connector_ridge_height],
        [u_size - top_offset, u_size - top_offset, u_connector_ridge_height],
        [top_offset, u_size - top_offset, u_connector_ridge_height],
    ];
    faces = [
        [0, 1, 5, 4], // bottom front
        [2, 3, 7, 6], // bottom back
        [3, 0, 4, 7], // bottom left
        [1, 2, 6, 5], // bottom right
        
        [9, 8, 12, 13], // top front
        [11, 10, 14, 15], // top back
        [8, 11, 15, 12], // top left
        [9, 13, 14, 10], // top right
        
        [0, 8, 9, 1], // front outer
        [2, 10, 11, 3], // back outer
        [0, 3, 11, 8], // left outer
        [1, 9, 10, 2], // right outer
        
        [4, 5, 13, 12], // front inner
        [6, 7, 15, 14], // back inner
        [12, 15, 7, 4], // left inner
        [14, 13, 5, 6], // right inner
    ];
    polyhedron(points, faces);
}


// Creates a connector bar ridge for size a x b.
module nxn_connector_bar_ridge(a, b) {
    for(i = [0 : 1 : a - 1]) {
        for(j = [0 : 1 : b - 1]) {
            translate([i*u_size, j*u_size, 0])
                connector_bar_ridge();
        }
    }
}


// Main wall of a box of size a x b x h.
module nxn_outer_wall(a, b, h) {
    size_a = a * u_size;
    size_b = b * u_size;
    
    connector_offset = u_wall_thickness + u_connector_clearance;
    height = h*u_height - u_connector_height - u_connector_ridge_height - u_connector_height;
    
    tmp_a = u_connector_ridge_height / tan(90 - connector_angle);
    tmp_top_width = connector_offset + connector_bar_plane_width - tmp_a;
    
    top_offset = tmp_top_width > u_connector_wall_thickness ? tmp_top_width : u_connector_wall_thickness;
    
    points = [
        // bottom outer
        [0, 0, 0],
        [size_a, 0, 0],
        [size_a, size_b, 0],
        [0, size_b, 0],
    
        // bottom inner - TODO
        [top_offset, top_offset, 0],
        [size_a - top_offset, top_offset, 0],
        [size_a - top_offset, size_b - top_offset, 0],
        [top_offset, size_b - top_offset, 0],
    
        // top outer
        [0, 0, height],
        [size_a, 0, height],
        [size_a, size_b, height],
        [0, size_b, height],
    
        // top inner
        [u_wall_thickness + u_connector_width, u_wall_thickness + u_connector_width, height],
        [size_a - u_wall_thickness - u_connector_width, u_wall_thickness + u_connector_width, height],
        [size_a - u_wall_thickness - u_connector_width, size_b - u_wall_thickness - u_connector_width, height],
        [u_wall_thickness + u_connector_width, size_b - u_wall_thickness - u_connector_width, height],
    ];
    faces = [
        [1, 5, 4, 0], // bottom front
        [7, 6, 2, 3], // bottom back
        [4, 7, 3, 0], // bottom left
        [6, 5, 1, 2], // bottom right
        
        [8, 9, 1, 0], // front outer
        [10, 11, 3, 2], // back outer
        [11, 8, 0, 3], // left outer
        [9, 10, 2, 1], // front outer
        
        [4, 5, 13, 12], // front inner
        [15, 14, 6, 7], // back inner
        [12, 15, 7, 4], // left inner
        [14, 13, 5, 6], // right inner
        
        [12, 13, 9, 8], // top front
        [14, 15, 11, 10], // top back
        [15, 12, 8, 11], // top left
        [13, 14, 10, 9], // top right
    ];
    polyhedron(points, faces);
}


// The connector slot allows another box to be stacked on the current box of
// size a x b.
module nxn_connector_slot(a, b) {
    size_a = a * u_size;
    size_b = b * u_size;
    
    // outer ring
    {
        linear_extrude(u_connector_height) {
            difference() {
                square([size_a, size_b]);
                translate([u_wall_thickness, u_wall_thickness])
                    square([size_a - 2*u_wall_thickness, size_b - 2*u_wall_thickness]);
            }
        }
    }
    // connector slot
    {
        points = [
        // bottom - outer
        [u_wall_thickness, u_wall_thickness, 0],
        [size_a - u_wall_thickness, u_wall_thickness, 0],
        [size_a - u_wall_thickness, size_b - u_wall_thickness, 0],
        [u_wall_thickness, size_b - u_wall_thickness, 0],
        
        // bottom - inner
        [u_wall_thickness + u_connector_width, u_wall_thickness + u_connector_width, 0],
        [size_a - u_wall_thickness - u_connector_width, u_wall_thickness + u_connector_width, 0],
        [size_a - u_wall_thickness - u_connector_width, size_b - u_wall_thickness - u_connector_width, 0],
        [u_wall_thickness + u_connector_width, size_b - u_wall_thickness - u_connector_width, 0],

        // top - outer
        [u_wall_thickness, u_wall_thickness, u_connector_height],
        [size_a - u_wall_thickness, u_wall_thickness, u_connector_height],
        [size_a - u_wall_thickness, size_b - u_wall_thickness, u_connector_height],
        [u_wall_thickness, size_b - u_wall_thickness, u_connector_height],
    ];
    faces = [
        [4, 5, 9, 8], // front inner
        [6, 7, 11, 10], // back inner
        [7, 4, 8, 11], // left inner
        [5, 6, 10, 9], // right inner
        
        [1, 0, 8, 9], // front outer
        [10, 11, 3, 2], // back outer
        [0, 3, 11, 8], // left outer
        [2, 1, 9, 10], // right outer
        
        [0, 1, 5, 4], // bottom front
        [2, 3, 7, 6], // bottom back
        [0, 4, 7, 3], // bottom left
        [1, 2, 6, 5], // bottom right
    ];
        polyhedron(points, faces);
    }
}


// This module creates a part for labeling. It also makes pulling the box out
// of a case easier.
module label() {
    translate([0, u_wall_thickness, 0]) {
        points = [
            // bottom
            [-(label_width_bottom - label_width) / 2, 0, 0],
            [(label_width_bottom - label_width) / 2 + label_width, 0, 0],

            // top
            [-(label_width_back - label_width) / 2, 0, label_height],
            [(label_width_back - label_width) / 2 + label_width, 0, label_height],
            [label_width, label_depth + u_connector_width, label_height],
            [0, label_depth + u_connector_width, label_height],
        ];
        faces = [
            [2, 3, 1, 0], // front
            [4, 5, 0, 1], // back
            [0, 5, 2], // left
            [1, 3, 4], // right
  
            [3, 2, 5, 4], // top
        ];
        polyhedron(points, faces);
    }
}


// This module creates a box of size a x b x h.
module nxn_unit(a, b, h) {
    size_a = a * u_size;
    size_b = b * u_size;
    height = h * u_height;

    nxn_connector_bar(a, b);

    translate([0, 0, u_connector_height])
        nxn_connector_bar_ridge(a, b);

    translate([0, 0, u_connector_height + u_connector_ridge_height])
        nxn_outer_wall(a, b, h);

    translate([0, 0, h*u_height - u_connector_height])
        nxn_connector_slot(a, b);
    
    translate([(size_a / 2) - (label_width / 2), 0, height - u_connector_height - label_height])
        label();
}


// This module creates the base connector slot mesh.
module nxn_connector_slot_mesh(a, b, chamfer_l, chamfer_t, chamfer_r, chamfer_b) {
    this_height = u_connector_height / 2;
    this_width = u_connector_width;
    module chamfer(length) {
        // TODO: Calculate so that the minimum wall thickness is considered
        translate([0, 0, this_height])
                rotate([0, 90, 0])
                linear_extrude(length) {
            polygon(points = [[0, 0], [this_height, 0], [this_height, this_width]]);
        }
    }
    
    difference() {
        // mesh
        for(i = [0 : 1 : a - 1]) {
            for(j = [0 : 1 : b - 1]) {
                translate([i*u_size, j*u_size, 0])
                    nxn_connector_slot(1, 1);
            }
        }

        // chamfer(s)
        union() {
            if(chamfer_l) {
                chamfer(a * u_size);
            }
            if(chamfer_t) {
                translate([0, b * u_size, 0])
                    rotate([0, 0, 270])
                    chamfer(b * u_size);
            }
            if(chamfer_r) {
                translate([a * u_size, b * u_size, 0])
                    rotate([0, 0, 180])
                    chamfer(a * u_size);
            }
            if(chamfer_t) {
                translate([a * u_size, 0, 0])
                    rotate([0, 0, 90])
                    chamfer(b * u_size);
            }
        }
    }
}





// For debugging: This cuts a box + mesh in half.
if(false) {
    difference() {
        union() {
            nxn_unit(1, 1, 1);
            translate([0, 0, -2])
                nxn_connector_slot_mesh(2, 1);
        }
        translate([0, u_size / 2, -2])
            cube([2*u_size, u_size / 2, 2*u_height + 2]);
    }
}


// For visualisation
if(false) {
    translate([0, 0, 0]) nxn_unit(2, 2, 1);
    translate([3*u_size, 0, 0]) nxn_unit(3, 2, 1);

    translate([0, 5*u_size, 0]) nxn_unit(1, 1, 1);
    translate([2*u_size, 5*u_size, 0]) nxn_unit(2, 1, 1);

    translate([5*u_size, 3*u_size, 0]) nxn_unit(1, 3, 1);
    translate([0, 3*u_size, 0]) nxn_unit(4, 1, 1);

    translate([0, -3*u_size, 0]) nxn_unit(3, 2, 2);
    translate([4*u_size, -3*u_size, 0]) nxn_unit(2, 2, 2);

    translate([-4*u_size, 0, 0]) nxn_connector_slot_mesh(3, 3);
    translate([-4*u_size, 4*u_size, 0]) nxn_connector_slot_mesh(3, 2);

    translate([-4*u_size, -3*u_size, 0]) nxn_unit(3, 2, 3);
}


// For export via command line
object = "mesh";
size_a = 2; // box & mesh
size_b = 3; // box & mesh
height = 1; // box
chamfer_l = true; // mesh
chamfer_t = true; // mesh
chamfer_r = true; // mesh
chamfer_b = true; // mesh

if(object == "box") {
    assert(size_a > 0, "size_a must be greater than 0!");
    assert(size_b > 0, "size_b must be greater than 0!");
    assert(height > 0, "height must be greater than 0!");

    nxn_unit(size_a, size_b, height);
}

if(object == "mesh") {
    assert(size_a > 0, "size_a must be greater than 0!");
    assert(size_b > 0, "size_b must be greater than 0!");

    nxn_connector_slot_mesh(size_a, size_b, chamfer_l, chamfer_t, chamfer_r, chamfer_b);
}