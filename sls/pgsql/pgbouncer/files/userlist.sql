SELECT '"'||rolname||'"', '"'||COALESCE(rolpassword, '')||'"' FROM pg_authid WHERE rolcanlogin = true;
