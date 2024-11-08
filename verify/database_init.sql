-- Verify sbgplants:database_init on pg


SELECT 1 FROM information_schema.schemata WHERE schema_name = 'sbgplants';

SELECT * FROM pg_extension WHERE extname = 'postgis';

SELECT 1 FROM pg_roles WHERE rolname = 'sbgplants_admins';

-- Verify if sbgplants_admins has USAGE and CREATE on sbgplants schema
SELECT 
    has_schema_privilege('sbgplants_admins', 'sbgplants', 'USAGE') AS has_usage,
    has_schema_privilege('sbgplants_admins', 'sbgplants', 'CREATE') AS has_create;

-- Verify if sbgplants_admins has USAGE and CREATE on sqitch schema
SELECT 
    has_schema_privilege('sbgplants_admins', 'sqitch', 'USAGE') AS has_usage,
    has_schema_privilege('sbgplants_admins', 'sqitch', 'CREATE') AS has_create;

-- Verify if sbgplants_admins has SELECT, INSERT, UPDATE, DELETE privileges on all tables in the sbgplants schema
SELECT 
    table_name, 
    has_table_privilege('sbgplants_admins', table_name, 'SELECT') AS has_select,
    has_table_privilege('sbgplants_admins', table_name, 'INSERT') AS has_insert,
    has_table_privilege('sbgplants_admins', table_name, 'UPDATE') AS has_update,
    has_table_privilege('sbgplants_admins', table_name, 'DELETE') AS has_delete
FROM 
    information_schema.tables
WHERE 
    table_schema = 'sbgplants';

