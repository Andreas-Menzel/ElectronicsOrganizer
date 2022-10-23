///////////////////// YOU CAN CHANGE THE FOLLOWING VALUES //////////////////////

// 1u (1 unit) is the base size. Each part can be created with a size of
// a x b x h. The following variables define the size of the outer dimensions.

// size for 1u (in x & y)
u_size = 60;
// height for 1u (in z)
u_height = 40;
// minimum main-wall thickness
u_wall_thickness = 1;
// bottom thickness
u_bottom_thickness = 1.5;


// The following variables define the dimensions of the connector bar at the
// bottom of a box.

// height
u_connector_height = 7;
// width
u_connector_width = 3.5;
// wall thickness
u_connector_wall_thickness = 1.5;

// clearance
u_connector_clearance = 0.1;

// additional height of connector bar
u_connector_ridge_height = 2.5;



////////////////////// DO NOT CHANGE THE FOLLOWING VALUES //////////////////////

connector_angle = atan(u_connector_width / u_connector_height);

tmp_a = tan(connector_angle) * u_connector_wall_thickness;
tmp_h = cos(connector_angle) * u_connector_wall_thickness;
tmp_b = cos(connector_angle) * tmp_h;
connector_bar_plane_width = tmp_a + tmp_b;