-- Read-only inspection of the restored coursework snapshot.
BEGIN TRANSACTION READ ONLY;

SELECT 'info_cargo' AS table_name, count(*) AS row_count FROM public.info_cargo
UNION ALL SELECT 'info_cli', count(*) FROM public.info_cli
UNION ALL SELECT 'info_orders', count(*) FROM public.info_orders
UNION ALL SELECT 'info_staff', count(*) FROM public.info_staff
UNION ALL SELECT 'orders_cargo', count(*) FROM public.orders_cargo
UNION ALL SELECT 'orders_cli', count(*) FROM public.orders_cli
UNION ALL SELECT 'orders_list', count(*) FROM public.orders_list
UNION ALL SELECT 'secret_key', count(*) FROM public.secret_key
UNION ALL SELECT 'staff_orders', count(*) FROM public.staff_orders
UNION ALL SELECT 'sample', count(*) FROM public.sample
UNION ALL SELECT 'sample_02', count(*) FROM public.sample_02
ORDER BY table_name;

SELECT conrelid::regclass AS table_name, conname AS constraint_name,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace AND contype IN ('p', 'f')
ORDER BY conrelid::regclass::text, conname;

-- Foreign keys allow NULLs in this snapshot; report absent links explicitly.
SELECT 'staff_orders.order_id' AS relationship, count(*) AS missing_links
FROM public.staff_orders WHERE order_id IS NULL
UNION ALL SELECT 'staff_orders.staff_id', count(*)
FROM public.staff_orders WHERE staff_id IS NULL
UNION ALL SELECT 'orders_cargo.order_id', count(*)
FROM public.orders_cargo WHERE order_id IS NULL
UNION ALL SELECT 'orders_cargo.c_id', count(*)
FROM public.orders_cargo WHERE c_id IS NULL
UNION ALL SELECT 'orders_cli.order_id', count(*)
FROM public.orders_cli WHERE order_id IS NULL
UNION ALL SELECT 'orders_cli.cli_id', count(*)
FROM public.orders_cli WHERE cli_id IS NULL
UNION ALL SELECT 'orders_list.order_id', count(*)
FROM public.orders_list WHERE order_id IS NULL
UNION ALL SELECT 'secret_key.cli_id', count(*)
FROM public.secret_key WHERE cli_id IS NULL
ORDER BY relationship;

COMMIT;
