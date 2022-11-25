#!/bin/bash

# Export mesh parts
mkdir -p "./stl files/mesh/normal"
mkdir -p "./stl files/mesh/chamfer 1"
mkdir -p "./stl files/mesh/chamfer 2"
mkdir -p "./stl files/mesh/chamfer 4"
for (( size_a=1; size_a<=4; size_a++ ))
do
    for (( size_b=$size_a; size_b<=4; size_b++ ))
    do
        echo "Exporting normal mesh with size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/normal/mesh_${size_a}x${size_b}.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b};"
        echo "Done!"

        # 1 chamfer
        echo "Exporting mesh with chamfer l and size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 1/mesh_${size_a}x${size_b}_chamfer_l.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_l=true;"
        echo "Done!"

        if (( $size_a != $size_b ))
        then
            echo "Exporting mesh with chamfer t and size ${size_a}x${size_b}..."
            openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 1/mesh_${size_a}x${size_b}_chamfer_t.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_t=true;"
            echo "Done!"
        fi

        # 2 chamfer
        echo "Exporting mesh with chamfer l+t and size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 2/mesh_${size_a}x${size_b}_chamfer_l+t.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_l=true; chamfer_t=true;"
        echo "Done!"

        echo "Exporting mesh with chamfer l+r and size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 2/mesh_${size_a}x${size_b}_chamfer_l+r.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_l=true; chamfer_r=true;"
        echo "Done!"

        if (( $size_a != $size_b ))
        then
            echo "Exporting mesh with chamfer b+l and size ${size_a}x${size_b}..."
            openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 2/mesh_${size_a}x${size_b}_chamfer_b+l.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_b=true; chamfer_l=true;"
            echo "Done!"

            echo "Exporting mesh with chamfer t+b and size ${size_a}x${size_b}..."
            openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 2/mesh_${size_a}x${size_b}_chamfer_t+b.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_t=true; chamfer_b=true;"
            echo "Done!"
        fi

        # 3 chamfer
        echo "Exporting mesh with chamfer l+t+r and size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 4/mesh_${size_a}x${size_b}_chamfer_l+t+r.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_l=true; chamfer_t=true; chamfer_r=true;"
        echo "Done!"

        echo "Exporting mesh with chamfer b+l+t and size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 4/mesh_${size_a}x${size_b}_chamfer_b+l+t.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_b=true; chamfer_l=true; chamfer_t=true;"
        echo "Done!"

        # 4 chamfer
        echo "Exporting mesh with chamfer l+t+r+b and size ${size_a}x${size_b}..."
        openscad "./code/modules.scad" -o "./stl files/mesh/chamfer 4/mesh_${size_a}x${size_b}_chamfer_l+t+r+b.stl" -D "object=\"mesh\"; size_a=${size_a}; size_b=${size_b}; chamfer_l=true; chamfer_t=true; chamfer_r=true; chamfer_b=true;"
        echo "Done!"
    done
done


# Export box parts
for (( size_a=1; size_a<=4; size_a++ ))
do
    for (( size_b=1; size_b<=4; size_b++ ))
    do
        for (( height=1; height<=3; height++ ))
        do
            mkdir -p "./stl files/box/height ${height}"
            echo "Exporting box with size ${size_a}x${size_b}x${height}..."
            openscad "./code/modules.scad" -o "./stl files/box/height ${height}/box_${size_a}x${size_b}x${height}.stl" -D "object=\"box\"; size_a=${size_a}; size_b=${size_b}; height=${height};"
            echo "Done!"
        done
    done
done