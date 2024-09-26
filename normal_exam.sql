create database wwii_missions;

create database normal_mission_db;


CREATE TABLE mission (
                         mission_id INTEGER PRIMARY KEY,                 -- Mission ID, auto-incremented primary key
                         mission_date DATE,                             -- Mission Date, a date field
                         theater_of_operations VARCHAR(100),            -- Theater of Operations, assuming text data
                         country VARCHAR(100),                          -- Country, assuming text data
                         air_force VARCHAR(100),                        -- Air Force, assuming text data
                         unit_id VARCHAR(100),                          -- Unit ID, assuming text data
                         aircraft_series VARCHAR(100),                  -- Aircraft Series, assuming text data
                         callsign VARCHAR(100),                         -- Callsign, assuming text data
                         mission_type VARCHAR(100),                     -- Mission Type, assuming text data
                         takeoff_base VARCHAR(255),                     -- Takeoff Base, assuming larger text data
                         takeoff_location VARCHAR(255),                 -- Takeoff Location, assuming larger text data
                         takeoff_latitude VARCHAR(15),               -- Takeoff Latitude, assuming GPS latitude
                         takeoff_longitude NUMERIC(10, 6),              -- Takeoff Longitude, assuming GPS longitude
                         target_id VARCHAR(100),                        -- Target ID, assuming text or unique identifier
                         target_country VARCHAR(100),                   -- Target Country, assuming text data
                         target_city VARCHAR(100),                      -- Target City, assuming text data
                         target_type VARCHAR(100),                      -- Target Type, assuming text data
                         target_industry VARCHAR(255),                  -- Target Industry, assuming text data
                         target_priority VARCHAR(5),                       -- Target Priority, assuming numerical data
                         target_latitude NUMERIC(10, 6),                -- Target Latitude, assuming GPS latitude
                         target_longitude NUMERIC(10, 6),               -- Target Longitude, assuming GPS longitude
                         altitude_hundreds_of_feet NUMERIC(7, 2),             -- Altitude in hundreds of feet, assuming numerical data
                         airborne_aircraft NUMERIC(4, 1),                     -- Airborne Aircraft, assuming numerical data
                         attacking_aircraft INTEGER,                    -- Attacking Aircraft, assuming numerical data
                         bombing_aircraft INTEGER,                      -- Bombing Aircraft, assuming numerical data
                         aircraft_returned INTEGER,                     -- Aircraft Returned, assuming numerical data
                         aircraft_failed INTEGER,                       -- Aircraft Failed, assuming numerical data
                         aircraft_damaged INTEGER,                      -- Aircraft Damaged, assuming numerical data
                         aircraft_lost INTEGER,                         -- Aircraft Lost, assuming numerical data
                         high_explosives VARCHAR(255),                  -- High Explosives, assuming text
                         high_explosives_type VARCHAR(255),             -- High Explosives Type, assuming text data
                         high_explosives_weight_pounds VARCHAR(25),  -- High Explosives Weight in Pounds, assuming decimal data
                         high_explosives_weight_tons NUMERIC(10, 2),    -- High Explosives Weight in Tons, assuming decimal data
                         incendiary_devices VARCHAR(255),               -- Incendiary Devices, assuming text data
                         incendiary_devices_type VARCHAR(255),          -- Incendiary Devices Type, assuming text data
                         incendiary_devices_weight_pounds NUMERIC(10, 2), -- Incendiary Devices Weight in Pounds, assuming decimal data
                         incendiary_devices_weight_tons NUMERIC(10, 2),   -- Incendiary Devices Weight in Tons, assuming decimal data
                         fragmentation_devices VARCHAR(255),            -- Fragmentation Devices, assuming text data
                         fragmentation_devices_type VARCHAR(255),       -- Fragmentation Devices Type, assuming text data
                         fragmentation_devices_weight_pounds NUMERIC(10, 2), -- Fragmentation Devices Weight in Pounds, assuming decimal data
                         fragmentation_devices_weight_tons NUMERIC(10, 2),   -- Fragmentation Devices Weight in Tons, assuming decimal data
                         total_weight_pounds NUMERIC(10, 2),            -- Total Weight in Pounds, assuming decimal data
                         total_weight_tons NUMERIC(10, 2),              -- Total Weight in Tons, assuming decimal data
                         time_over_target VARCHAR(8),                         -- Time Over Target, assuming time data
                         bomb_damage_assessment VARCHAR(255),           -- Bomb Damage Assessment, assuming text data
                         source_id VARCHAR(100)                         -- Source ID, assuming text or unique identifier
);


SELECT *
FROM mission
LIMIT 10;

drop table mission;

CREATE TABLE target
(
    target_id        SERIAL PRIMARY KEY, -- Target ID, assuming text or unique identifier
    target_country   VARCHAR(100),       -- Target Country, assuming text data
    target_city      VARCHAR(100),       -- Target City, assuming text data
    target_type      VARCHAR(100),       -- Target Type, assuming text data
    target_industry  VARCHAR(255),       -- Target Industry, assuming text data
    target_priority  VARCHAR(5),         -- Target Priority, assuming numerical data
    target_latitude  NUMERIC(10, 6),     -- Target Latitude, assuming GPS latitude
    target_longitude NUMERIC(10, 6)
);



CREATE TABLE target_details (
                                target_id INT,
                                target_priority INT,
                                location_id INT REFERENCES target_location(location_id),
                                type_id INT REFERENCES target_types(type_id),
                                industry_id INT REFERENCES industries(industry_id)
);

CREATE TABLE countries (
                           country_id SERIAL PRIMARY KEY,
                           country_name VARCHAR(255) UNIQUE
);

CREATE TABLE target_location (
                                 location_id SERIAL PRIMARY KEY,
                                 target_latitude NUMERIC(10, 6),
                                 target_longitude NUMERIC(10, 6),
                                 city_id INT REFERENCES cities(city_id)
);

CREATE TABLE cities (
                        city_id SERIAL PRIMARY KEY,
                        city_name VARCHAR(255),
                        country_id INT REFERENCES countries(country_id)
);

CREATE TABLE target_types (
                              type_id SERIAL PRIMARY KEY,
                              type_name VARCHAR(255) UNIQUE
);

CREATE TABLE industries (
                            industry_id SERIAL PRIMARY KEY,
                            industry_name VARCHAR(255)
);


CREATE INDEX idx_mission_date_year ON mission (date_part('year', mission_date));
CREATE INDEX idx_country ON mission (target_country);
CREATE INDEX idx_city ON mission (target_city);

select target_city, air_force, count(mission_id)
from mission
where date_part('year', mission_date) = 1943
group by target_city, air_force;








