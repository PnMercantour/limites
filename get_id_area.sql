CREATE OR REPLACE FUNCTION limites.get_id_area(
        mytype character varying,
        myname character varying
    ) RETURNS integer LANGUAGE plpgsql IMMUTABLE AS $function$ --id_area pour un type et un nom donnés
DECLARE result integer;
DECLARE the_id_type integer;
BEGIN
select into the_id_type id
from limites.area_type
where type = mytype;
SELECT INTO result id
from limites.area
where id_type = the_id_type
    and name = myname;
return result;
END;
$function$;