CREATE OR REPLACE VIEW parking_count_view AS
    SELECT COUNT(*)
    FROM bicycle_parking;

CREATE OR REPLACE VIEW parking_by_district_view AS
    SELECT COUNT(*) as count, hdb.name_be as district_name
    FROM bicycle_parking bp
    LEFT JOIN homiel_district_boundary hdb ON ST_INTERSECTS(bp.geom, hdb.geom)
    GROUP BY hdb.name_be
    ORDER BY count DESC;

CREATE OR REPLACE VIEW parking_by_type_view AS
    SELECT COUNT(*) as count, type
    FROM bicycle_parking
    GROUP BY type
    ORDER BY count DESC;

COPY (
    SELECT row_to_json(parking_count_view)
    FROM parking_count_view
    ) TO '/usr/local/pgsql/files/json_export/parking_count.json';

COPY (
    SELECT json_agg(row_to_json(parking_by_district_view))
    FROM parking_by_district_view
    ) TO '/usr/local/pgsql/files/json_export/parking_by_district.json';

COPY (
    SELECT json_agg(row_to_json(parking_by_type_view))
    FROM parking_by_type_view
    ) TO '/usr/local/pgsql/files/json_export/parking_by_type.json';

