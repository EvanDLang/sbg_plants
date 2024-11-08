-- Deploy sbgplants:database_init to pg

BEGIN;

CREATE SCHEMA IF NOT EXISTS sbgplants;
ALTER DATABASE sbgplants SET search_path = sbgplants;

CREATE EXTENSION postgis SCHEMA  sbgplants;

CREATE GROUP sbgplants_admins;

-- grant access to the sbgplants schema
GRANT USAGE, CREATE ON SCHEMA sbgplants to sbgplants_admins;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sbgplants TO sbgplants_admins;

-- grant access to the sqitch schema
GRANT USAGE, CREATE ON SCHEMA sqitch TO sbgplants_admins;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sqitch TO sbgplants_admins;

COMMIT;
