# Logistics Database Normalization

PostgreSQL coursework for the **Databases and SQL** course at the National
University of Science and Technology MISIS. The task starts with a logistics
company's flat CSV containing orders, staff, clients and cargo, then explores
splitting it into related tables toward third normal form (3NF).

This repository preserves the submitted database snapshot and the original SQL
working notes. It is a completed academic exercise, with a reproducible snapshot
restore and a separate raw-data import; it is not an application or a complete
CSV-to-3NF migration pipeline.

## Repository contents

| Path | Contents |
| --- | --- |
| [assignment.txt](assignment.txt) | Original assignment and field definitions, in Russian |
| [data/sample_2.csv](data/sample_2.csv) | Source CSV: 200,000 rows and 19 columns, about 63 MiB |
| [dump/dump-postgres-202312061740.file](dump/dump-postgres-202312061740.file) | PostgreSQL custom-format snapshot, about 67 MiB, created with PostgreSQL 16.0 on 2023-12-06 |
| [scripts/script.sql](scripts/script.sql) | Historical normalization working notes |
| [scripts/import_sample.psql](scripts/import_sample.psql) | Transactional import into a separate all-text staging schema |
| [scripts/inspect.sql](scripts/inspect.sql) | Read-only table counts, constraints and missing-link checks |
| [docs/schema.md](docs/schema.md) | Snapshot tables, foreign-key diagram and design limitations |

## Restore the submitted database

Use PostgreSQL 16 or newer and matching or newer client tools (`createdb`,
`pg_restore`, `psql`). The commands below use your standard PostgreSQL connection
settings and create a dedicated database named `logistics_course`.

From the repository root:

```sh
createdb logistics_course
pg_restore --dbname=logistics_course \
  --no-owner --no-privileges --clean --if-exists \
  --single-transaction --exit-on-error \
  dump/dump-postgres-202312061740.file
psql --dbname=logistics_course --set=ON_ERROR_STOP=1 --file=scripts/inspect.sql
```

`--clean` replaces the snapshot's objects in the target database; keep this
workflow in the newly created coursework database. `--no-owner` and
`--no-privileges` avoid depending on the original `postgres` owner and grants.
The `.file` extension belongs to a custom-format archive: use `pg_restore`,
not `psql --file`, to read it.

To inspect the archive without restoring it:

```sh
pg_restore --list dump/dump-postgres-202312061740.file
pg_restore --schema-only --no-owner --no-privileges \
  --file=schema.sql dump/dump-postgres-202312061740.file
```

## Import the source CSV separately

For data exploration, the following script loads the source into
`raw_import.sample` without changing the restored snapshot. Run it from the
repository root so the client-side CSV path resolves correctly:

```sh
psql --dbname=logistics_course --file=scripts/import_sample.psql
```

The import creates its schema once and stops on any error; a failed transaction
leaves no partial import. Running it again fails rather than appending duplicate
rows. All columns are text to retain source values such as leading zeros in PINs,
phone numbers and the original `staf_name` spelling. Unquoted empty CSV fields become
SQL `NULL`. Typed conversion and normalization are separate analysis steps.

## Data model and scope

The snapshot includes four entity tables (`info_staff`, `info_orders`, `info_cli`,
`info_cargo`), five association/detail tables, and two retained staging tables.
See the [schema guide](docs/schema.md) for the actual foreign keys and queries.

The original `scripts/script.sql` is a record of interactive work, **not a
one-command rebuild**: it lacks a CSV import, has missing statement terminators,
and references `info_orders` before creating it. Its imputation queries also use
heuristics such as matching addresses, names and countries; these are not
validated business keys. Use the dump to inspect the submitted result rather
than executing the notebook as a migration.

The assignment aimed at 3NF; the snapshot does not establish that every functional
dependency is modeled correctly. Nullable links, absent association-table keys,
integer PINs and floating-point prices are retained in the historical result.
They are documented so the exercise can be assessed and extended accurately.
