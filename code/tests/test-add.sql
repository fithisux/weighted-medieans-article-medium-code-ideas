BEGIN;
  SELECT plan(5);

  truncate my_experiment;
  insert into my_experiment(price) values (30);
  insert into my_experiment(price) values (10);
  insert into my_experiment(price) values (20);
  insert into my_experiment(price) values (10);
  insert into my_experiment(price) values (30);
  insert into my_experiment(price) values (15);

  SELECT ok(peso_median() = 17.5, 'my median test1');
  SELECT ok(peso_occurences_median() = 17.5, 'my median test2');
  SELECT ok(nearest_rank(0.5) = 15.0, 'my median test3');

  truncate MY_PARTITIONED_EXPERIMENT;
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (30, 5, 1);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (10, 20, 1);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (20, 10, 1);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (10, 20, 1);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (30, 5, 1);

  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (300, 10, 2);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (100, 200, 2);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (200, 100, 2);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (100, 200, 2);
  insert into MY_PARTITIONED_EXPERIMENT(price, units, region) values (300, 50, 2);

  CREATE OR REPLACE FUNCTION region_price(threshold real, region int) RETURNS real
  AS $$
  DECLARE my_result real;
  begin
      select theprice into my_result
      from my_partitioned_weighted_nearest_rank(threshold)
      where theregion=region;

  return my_result;
  end;
  $$
  STABLE
  LANGUAGE plpgsql;

  SELECT ok(region_price(0.7, 1) = 20.0);
  SELECT ok(region_price(0.7, 2) = 100.0);

  --SELECT columns_are('my_experiment', ARRAY[ 'price']);

ROLLBACK;
