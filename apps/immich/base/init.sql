DO
$do$
BEGIN
   -- Check if the role 'photos' already exists in the database.
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles  -- pg_roles is a view that includes users
      WHERE  rolname = 'photos') THEN

      -- If the user does not exist, create it with a password.
      -- The LOGIN option is default for CREATE USER but is included here for clarity.
      CREATE USER photos WITH LOGIN PASSWORD '123456';

      -- You can uncomment the line below to grant database creation rights.
      -- ALTER USER photos CREATEDB;

      -- Print a notice to the console confirming user creation.
      RAISE NOTICE 'User "photos" created.';
   ELSE
      -- If the user already exists, print a notice and do nothing.
      RAISE NOTICE 'User "photos" already exists. Skipping creation.';
   END IF;
END
$do$;

SELECT 'CREATE DATABASE photos'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'photos')\gexec

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE photos TO photos;

-- Connect to the photos database
\c photos

-- Grant all privileges on the schema to the user
GRANT ALL PRIVILEGES ON SCHEMA public TO photos;

-- Grant all privileges on all tables to the user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO photos;

-- Grant all privileges on all sequences to the user
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO photos;

-- Make photos the owner of the public schema
ALTER SCHEMA public OWNER TO photos; 