COPY (SELECT jsonb_build_object(
                     'type', 'FeatureCollection',
                     'features', jsonb_agg(features.feature)
                 )
      FROM (SELECT jsonb_build_object(
                           'type', 'Feature',
                           'id', id,
                           'geometry', ST_AsGeoJSON(st_transform(geom, 4326)::geography)::json,
                           'properties', to_jsonb(properties_data) - 'id' - 'geom' - 'timestamp'
                       ) AS feature
            FROM (SELECT * FROM bicycle_cycleway) AS properties_data) AS features
) TO '/usr/local/pgsql/files/data/bicycle_cycleway.geojson';

COPY (SELECT jsonb_build_object(
                     'type', 'FeatureCollection',
                     'features', jsonb_agg(features.feature)
                 )
      FROM (SELECT jsonb_build_object(
                           'type', 'Feature',
                           'id', id,
                           'geometry', ST_AsGeoJSON(st_transform(geom, 4326)::geography)::json,
                           'properties', to_jsonb(properties_data) - 'id' - 'geom' - 'timestamp'
                       ) AS feature
            FROM (SELECT * FROM bicycle_shop) AS properties_data) AS features
) TO '/usr/local/pgsql/files/data/bicycle_shop.geojson';

COPY (SELECT jsonb_build_object(
                     'type', 'FeatureCollection',
                     'features', jsonb_agg(features.feature)
                 )
      FROM (SELECT jsonb_build_object(
                           'type', 'Feature',
                           'id', id,
                           'geometry', ST_AsGeoJSON(st_transform(geom, 4326)::geography)::json,
                           'properties', to_jsonb(properties_data) - 'id' - 'geom' - 'timestamp'
                       ) AS feature
            FROM (SELECT * FROM bicycle_parking) AS properties_data) AS features
) TO '/usr/local/pgsql/files/data/bicycle_parking.geojson';

COPY (SELECT jsonb_build_object(
                     'type', 'FeatureCollection',
                     'features', jsonb_agg(features.feature)
                 )
      FROM (SELECT jsonb_build_object(
                           'type', 'Feature',
                           'id', id,
                           'geometry', ST_AsGeoJSON(st_transform(geom, 4326)::geography)::json,
                           'properties', to_jsonb(properties_data) - 'id' - 'geom' - 'timestamp'
                       ) AS feature
            FROM (SELECT * FROM bicycle_repair_station) AS properties_data) AS features
) TO '/usr/local/pgsql/files/data/bicycle_repair_station.geojson';

COPY (SELECT jsonb_build_object(
                     'type', 'FeatureCollection',
                     'features', jsonb_agg(features.feature)
                 )
      FROM (SELECT jsonb_build_object(
                           'type', 'Feature',
                           'id', id,
                           'geometry', ST_AsGeoJSON(st_transform(geom, 4326)::geography)::json,
                           'properties', to_jsonb(properties_data) - 'id' - 'geom' - 'timestamp'
                       ) AS feature
            FROM (SELECT * FROM homiel_district_boundary) AS properties_data) AS features
) TO '/usr/local/pgsql/files/data/homiel_districts.geojson';