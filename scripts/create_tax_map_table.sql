DROP TABLE opa_2014_2015;
DROP TABLE opa_unique;
DROP TABLE parcels_unique;
DROP TABLE parcels_map;

-- Create one table with both tax years
SELECT old.*, 
  new."Market_Value" as "Market_Value_15",
  new."Taxable_Land" as "Taxable_Land_15",
  new."Taxable_Building" as "Taxable_Building_15",
  new."Exempt_Land" as "Exempt_Land_15",
  new."Exempt_Building" as "Exempt_Building_15",
  new."Homestead_Exemption" as "Homestead_Exemption_15"
INTO opa_2014_2015
FROM opa_2014 old JOIN opa_2015 new
ON old."Account_Number" = new."Account_Number";

-- Create table with tax records for unique addresses
SELECT * INTO opa_unique
FROM opa_2014_2015
WHERE "Address" IN (
  SELECT "Address"
  FROM opa_2014_2015
  GROUP BY "Address"
  HAVING count("Address") = 1
);

-- Create a table of parcels with unique addresses, which we'll use to join to the table of assessments
SELECT address, geom
INTO parcels_unique
FROM parcels
WHERE address IS NOT NULL AND address IN (
  SELECT address
  FROM parcels
  GROUP BY address
  HAVING COUNT(address) = 1
);

-- Join unqiue parcels table to unique combined tax records table
SELECT p.geom, t.*
INTO parcels_map
FROM parcels_unique p
INNER JOIN opa_unique t
ON p.address = t."Address";

-- Add columns for taxable and exempt values
ALTER TABLE parcels_map ADD COLUMN tax_value_2014 bigint;
ALTER TABLE parcels_map ADD COLUMN tax_value_2015 bigint;
ALTER TABLE parcels_map ADD COLUMN exempt_value_2014 bigint;
ALTER TABLE parcels_map ADD COLUMN exempt_value_2015 bigint;

-- Calculate taxable value
UPDATE parcels_map
SET tax_value_2014 = "Taxable_Land" + "Taxable_Building"
WHERE "Homestead_Exemption" = 'NO*';

UPDATE parcels_map
SET tax_value_2014 = "Taxable_Land" + "Taxable_Building" - 30000
WHERE "Homestead_Exemption" = 'YES*';

UPDATE parcels_map
SET tax_value_2014 = 0
WHERE tax_value_2014 < 0;

UPDATE parcels_map
SET exempt_value_2014 = "Exempt_Land" + "Exempt_Building"

UPDATE parcels_map
SET tax_value_2015 = "Taxable_Land_15" + "Taxable_Building_15"
WHERE "Homestead_Exemption_15" = 'NO*';

UPDATE parcels_map
SET tax_value_2015 = "Taxable_Land_15" + "Taxable_Building_15" - 30000
WHERE "Homestead_Exemption_15" = 'YES*';

UPDATE parcels_map
SET tax_value_2015 = 0
WHERE tax_value_2015 < 0;

UPDATE parcels_map
SET exempt_value_2015 = "Exempt_Land_15" + "Exempt_Building_15"

-- Add column for tax value
ALTER TABLE parcels_map ADD COLUMN tax_2014 bigint;
ALTER TABLE parcels_map ADD COLUMN tax_2015 bigint;

-- Calculate new taxes
UPDATE parcels_map
SET tax_2014 = tax_value_2014 * 0.0134;

UPDATE parcels_map
SET tax_2015 = tax_value_2015 * 0.0134;

--Add column for percent change in taxes
ALTER TABLE parcels_map ADD COLUMN tax_change NUMERIC(10, 3);

-- Calculate percent change
UPDATE parcels_map
SET tax_change = ((CAST(tax_2015 as NUMERIC) - CAST(tax_2014 as NUMERIC)) / CAST(tax_2014 as NUMERIC))
WHERE tax_2014 <> 0;

-- Fix up some of the tax change calculations--the decrease in taxes can't be less than -100%
UPDATE parcels_map
SET tax_change = -1
WHERE tax_change < -1 AND tax_2015 = 0 AND "Market_Value_15" <> -1;

-- Create unique id column for TileMill Starts as a serial to autopopulate,
-- then switch it to an int for TileMill compatability
ALTER TABLE parcels_map ADD COLUMN parcelid serial;
ALTER TABLE parcels_map ADD PRIMARY KEY (parcelid);
ALTER TABLE parcels_map ALTER COLUMN parcelid TYPE INTEGER;

-- Currently the parcel layer geometry is in 2272,
-- but we want it in 4326 to work better in TileMill with the MapBox OpenStreetMap layers
SELECT AddGeometryColumn ('public','parcels_map','geom_4326',4326,'MULTIPOLYGON', 2);
UPDATE parcels_map SET geom_4326 = ST_Transform(ST_SetSRID(geom, 2272), 4326);
