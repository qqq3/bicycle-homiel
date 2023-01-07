CREATE OR REPLACE VIEW shop_count_view AS
    SELECT COUNT(*)
    FROM bicycle_shop;

CREATE OR REPLACE VIEW shop_by_district_view AS
    SELECT COUNT(*) as count, hdb.name_be as district_name
    FROM bicycle_shop bs
    LEFT JOIN homiel_district_boundary hdb ON ST_INTERSECTS(bs.geom, hdb.geom)
    GROUP BY hdb.name_be
    ORDER BY count DESC;

COPY (
    SELECT row_to_json(shop_count_view)
    FROM shop_count_view
    ) TO '/usr/local/pgsql/files/json_export/shop_count.json';

COPY (
    SELECT json_agg(row_to_json(shop_by_district_view))
    FROM shop_by_district_view
    ) TO '/usr/local/pgsql/files/json_export/shop_by_district.json';