print('osm2pgsql version there < === ' .. osm2pgsql.version)

local prefix = 'bicycle_'
local tables = {}

tables.bicycle_parkings = osm2pgsql.define_node_table(prefix .. 'parking', {
	{column = 'id', sql_type = 'serial', create_only = true},
	{column = 'type', type = 'text'},
	{column = 'capacity', type ='int2'},
	{column = 'covered', type = 'text'},
	{column = 'fee', type = 'text'},
	{column = 'access', type = 'text'},
	{column = 'timestamp', type = 'text'},
	{column = 'geom', type = 'point'}
})

tables.bicycle_repair_stations = osm2pgsql.define_node_table(prefix .. 'repair_station', {
	{column = 'id', sql_type = 'serial', create_only = true},
	{column = 'opening_hours', type = 'text'},
	{column = 'brand', type = 'text'},
	{column = 'operator', type = 'text'},
	{column = 'fee', type = 'text'},
	{column = 'covered', type = 'text'},
	{column = 'pump', type = 'text'},
	{column = 'tools', type = 'text'},
	{column = 'stand', type = 'text'},
	{column = 'timestamp', type = 'text'},
	{column = 'geom', type = 'point'}
})

tables.bicycle_shops = osm2pgsql.define_node_table(prefix .. 'shop', {
	{column = 'id', sql_type = 'serial', create_only = true},
	{column = 'name_be', type = 'text'},
	{column = 'name_int', type = 'text'},
	{column = 'addr_street', type = 'text'},
	{column = 'addr_housenumber', type = 'text'},
	{column = 'opening_hours', type = 'text'},
	{column = 'website', type = 'text'},
	{column = 'retail', type = 'text'},
	{column = 'repair', type = 'text'},
	{column = 'rental', type = 'text'},
	{column = 'timestamp', type = 'text'},
	{column = 'geom', type = 'point'}
})

tables.bicycle_cycleways = osm2pgsql.define_way_table(prefix .. 'cycleway', {
	{column = 'id', sql_type = 'serial', create_only = true},
	{column = 'type', type = 'text'},
	{column = 'segregated', type = 'text'},
	{column = 'surface', type = 'text'},
	{column = 'smoothness', type = 'text'},
	{column = 'length', type = 'real', create_only = true},
	{column = 'timestamp', type = 'text'},
	{column = 'geom', type = 'multilinestring'}
})

tables.districts_boundaries = osm2pgsql.define_relation_table('homiel_district_boundary', {
	{column = 'id', sql_type = 'serial', create_only = true},
	{column = 'name_be', type = 'text'},
	{column = 'name_int', type = 'text'},
	{column = 'geom', type = 'multipolygon'}
})

for name, dtable in pairs(tables) do
	print("\ntable '" .. name .. "':")
	print(" name = '" .. dtable:name() .. "'")
end

function osm2pgsql.process_node(object)
	if object.tags.amenity == 'bicycle_parking' then
		tables.bicycle_parkings:insert({
			type = object.tags.bicycle_parking,
			capacity = object.tags.capacity,
			covered = object.tags.covered,
			fee = object.tags.fee,
			access = object.tags.access,
			timestamp = object.timestamp,
			geom = object:as_point()
		})
	end

	if object.tags.amenity == 'bicycle_repair_station' then
		tables.bicycle_repair_stations:insert({
			opening_hours = object.tags.opening_hours,
			brand = object.tags.brand,
			operator = object.tags.operator,
			fee = object.tags.fee,
			covered = object.tags.covered,
			pump = object.tags['service:bicycle:pump'],
			tools = object.tags['service:bicycle:tools'],
			stand = object.tags['service:bicycle:stand'],
			timestamp = object.timestamp,
			geom = object:as_point()
		})
	end

	if object.tags.shop == 'bicycle' then 
		tables.bicycle_shops:insert({
			name_be = object.tags['name:be'],
			name_int = object.tags.int_name,
			addr_street = object.tags['addr:street'],
			addr_housenumber = object.tags['addr:housenumber'],
			opening_hours = object.tags.opening_hours,
			website = object.tags['contact:website'],
			retail = object.tags['service:bicycle:retail'],
			repair = object.tags['service:bicycle:repair'],
			rental = object.tags['service:bicycle:rental'],
			timestamp = object.timestamp,
			geom = object:as_point()
		})
	end
end

function osm2pgsql.process_way(object)
	if object.tags.highway == 'cycleway' then 
		tables.bicycle_cycleways:insert({
			type = object:grab_tag('highway'),
			segregated = object.tags.segregated,
			surface = object.tags.surface,
			smoothness = object.tags.smoothness,
			timestamp = object.timestamp,
			geom = object:as_multilinestring()
		})
	end

	if object.tags.highway == 'footway' and object.tags.bicycle == 'designated' and object.tags.segregated == 'no' then
		tables.bicycle_cycleways:insert({
			type = object:grab_tag('highway'),
			segregated = object.tags.segregated,
			surface = object.tags.surface,
			smoothness = object.tags.smoothness,
			timestamp = object.timestamp,
			geom = object:as_multilinestring()
		})
	end

	if object.tags.highway == 'footway' and object.tags.bicycle == 'designated' then
		tables.bicycle_cycleways:insert({
			type = object:grab_tag('highway'),
			segregated = object.tags.segregated,
			surface = object.tags['cycleway:surface'],
			smoothness = object.tags.smoothness,
			timestamp = object.timestamp,
			geom = object:as_multilinestring()
		})
	end
end

function osm2pgsql.process_relation(object)
	if object.tags.type == 'boundary' and object.tags.admin_level == '9' then
		tables.districts_boundaries:insert({
			tags = object.tags,
			name_be = object.tags['name:be'],
			name_int = object.tags.int_name,
			timestamp = object.timestamp,
			geom = object:as_multipolygon()
		})
	end
end