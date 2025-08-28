-- Initialize database extensions if needed
-- This file runs when the PostgreSQL container starts for the first time

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create a health check function
CREATE OR REPLACE FUNCTION health_check()
RETURNS text AS $$
BEGIN
    RETURN 'Database is healthy';
END;
$$ LANGUAGE plpgsql;