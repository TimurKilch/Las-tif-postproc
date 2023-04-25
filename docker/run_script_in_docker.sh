#!/bin/bash

# Input LAZ folder
input_folder_laz=/media/takilchukov/Disk_D/USA/LAS

output_folder_las=/media/takilchukov/Disk_D/USA/las_images

# Output DEM folder
output_folder_DEM=/media/takilchukov/Disk_D/USA/DEM_images

# Loop through all LAS files in input folder
for laz_file in $input_folder_laz/*.laz; do
  # Get the filename without the path and file extension
  filename=$(basename "$laz_file" .laz)
  
  cd $output_folder_DEM
  mkdir $filename
  
  echo processing $filename
  # Convert LAS to DEM using the LASTools Docker image (TIMUR NE MOJET ILYA POMOJET)
  docker run -it -v $input_folder_laz:/input_folder_laz -v $output_folder_las:/output_folder_las -v $output_folder_DEM:/output_folder_DEM las2dem:v1 bash -c "laszip64 -i /input_folder_laz/$filename.laz -o /output_folder_las/$filename.las && las2dem64 -keep_class 2 -step 0.5 -i /output_folder_las/$filename.las -o /output_folder_DEM/$filename.tif 2>/dev/null"
  
  cd $output_folder_DEM
  mv $filename.tif "$filename/"
  mv $filename.kml "$filename/"
  cd "$filename/"
  rm $filename.kml
  cd $output_folder_las
  rm -r *
  cd $output_folder_DEM
  rm -r *.tfw
done
