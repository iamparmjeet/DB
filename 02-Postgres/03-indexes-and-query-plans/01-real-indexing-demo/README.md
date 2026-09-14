# Real indexing demo

## Goal

Reproduce the source video's lesson with your own PostgreSQL instance: establish a baseline, add a selective index, inspect both plans, and measure the read/write trade-off.

## Source

- Neeraj Kulkarni, [Database indexing explained on a real database](https://www.youtube.com/watch?v=eGzmUyOyzHs)

## Environment

- PostgreSQL 18.6 in Docker Compose; database: `indexing_lab`.
- 20,000,000 initial rows in `orders`.
- Run `docker compose up -d` before using the commands below.

## Artefacts

- `compose.yaml` — repeatable PostgreSQL environment.
- `seed.sql` — recreates and seeds `orders`; run `ANALYZE orders;` after loading it when planner statistics need refreshing.
- `bench_email.sql` — random existing-email lookup workload.
- `bench_insert.sql` — random-email insert workload.

## Reproduced read-side results — 2026-09-14

| Workload | Before email index | After `idx_orders_email` |
| --- | ---: | ---: |
| `EXPLAIN ANALYZE` execution | 248.304 ms, parallel sequential scan | 0.054 ms first run; 0.040–0.041 ms warm, index scan |
| `pgbench` average latency | 2088.870 ms | 0.079 ms |
| `pgbench` TPS | 4.787 | 127,287.738 |

The command used 10 clients, 2 threads, 30 seconds, custom script, and `-n` to skip pgbench's built-in-table vacuum:

```bash
docker compose exec -T postgres pgbench \
  -U postgres -d indexing_lab \
  -f /tmp/bench_email.sql \
  -c 10 -j 2 -T 30 -n
```

The status experiment also created `idx_orders_status`, but PostgreSQL chose a sequential scan for `WHERE status = 'pending'`: it returned 4,999,412 rows (about 25% of the table) in 941.521 ms. That is expected for a broad predicate.

## Write experiment: current limitation

One insert run with both secondary indexes reported 762.469 TPS; one run after dropping them reported 11.478 TPS. Do not interpret this reversal as an index benefit. It is a single-run, environment-sensitive measurement and needs repeated alternating trials with medians.

## Next measurement

Run `bench_insert.sql` three times per configuration: primary key only, email index only, and email plus status index. Record every TPS value and compare medians.

## Success criteria

- Demonstrate a selective predicate whose plan changes after a matching index.
- Demonstrate a broad predicate for which a sequential scan remains reasonable.
- Record local results; do not compare them directly with another machine's numbers.
- Treat write-cost evidence as complete only after repeated comparable runs.
