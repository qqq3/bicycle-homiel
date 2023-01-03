#!/usr/bin/zsh

osmium getid -r -t -v belarus-latest.osm.pbf r163244 --overwrite -o homiel_boundary.osm --progress
osmium extract -p homiel_boundary.osm belarus-latest.osm.pbf --overwrite -o homiel-latest.pbf --progress