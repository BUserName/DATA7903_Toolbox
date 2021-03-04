CREATE OR REPLACE FUNCTION locf_state(double precision, double precision)
RETURNS double precision
LANGUAGE SQL
AS $f$
  SELECT COALESCE($2,$1)
$f$;

CREATE AGGREGATE locf(double precision) (
  SFUNC = locf_state,
  STYPE = double precision
);
