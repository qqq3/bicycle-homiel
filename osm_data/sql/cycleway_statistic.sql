UPDATE bicycle_cycleway
SET length = st_length(st_transform(geom, 4326)::geography)
WHERE length is NULL;

CREATE OR REPLACE VIEW cycleway_length_view AS
    SELECT round((sum(length)::numeric), 2) as length
    FROM bicycle_cycleway;

CREATE OR REPLACE VIEW cycleway_by_district_view AS
    SELECT round(SUM(cw.length)::numeric, 2) as cycleway_length, hdb.name_be as district_name
    FROM  bicycle_cycleway cw
    LEFT JOIN homiel_district_boundary hdb ON ST_Intersects(cw.geom, hdb.geom)
    GROUP BY district_name
    ORDER BY cycleway_length DESC;

CREATE OR REPLACE VIEW cycleway_surface_view AS
    SELECT surface,
           round((100.0 * COUNT(surface)) / (SELECT count(surface) from bicycle_cycleway where surface is not null), 2) as percentage
    FROM bicycle_cycleway
    WHERE surface is NOT NULL
    group by surface
    ORDER BY percentage DESC;

CREATE OR REPLACE VIEW cycleway_smoothness_view AS
    SELECT smoothness,
           round((100.0 * count(smoothness)) / (SELECT count(smoothness) from bicycle_cycleway where smoothness is not NULL), 2) as percentage
    FROM bicycle_cycleway
    WHERE smoothness is NOT NULL
    GROUP BY smoothness
    ORDER BY percentage DESC;

COPY (
    SELECT row_to_json(cycleway_length_view)
    FROM cycleway_length_view
    ) TO '/usr/local/pgsql/files/json_export/cycleway_length.json';

COPY (
    SELECT json_agg(row_to_json(cycleway_by_district_view))
    FROM cycleway_by_district_view
    ) TO '/usr/local/pgsql/files/json_export/cycleway_by_district.json';

COPY (
    SELECT json_agg(row_to_json(cycleway_surface_view))
    FROM cycleway_surface_view
    ) TO '/usr/local/pgsql/files/json_export/cycleway_surface.json';

COPY (
    SELECT json_agg(row_to_json(cycleway_smoothness_view))
    FROM cycleway_smoothness_view
    ) TO '/usr/local/pgsql/files/json_export/cycleway_smoothness.json';
