#!/usr/bin/zsh

osmium getid -r -t -v belarus-latest.osm.pbf r163244 --overwrite -o homiel_boundary.osm.pbf --progress
osmium extract -p homiel_boundary.osm.pbf belarus-latest.osm.pbf --overwrite -o homiel-latest.osm.pbf --progress