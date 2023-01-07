CREATE OR REPLACE VIEW data_datetime_view AS
    SELECT MAX(to_timestamp(timestamp::numeric)) as data_datetime
    FROM (
        SELECT timestamp FROM bicycle_parking
                        UNION ALL
                        SELECT timestamp FROM bicycle_shop
                                        UNION ALL
                                        SELECT timestamp FROM bicycle_repair_station
                                                         UNION ALL
                                                        SELECT timestamp FROM bicycle_cycleway
                                                                         ) as search_last_date;

COPY (
    SELECT row_to_json(data_datetime_view)
    FROM data_datetime_view
    ) TO '/usr/local/pgsql/files/json_export/data_datetime.json';