# Real indexing demo

## Goal

Reproduce the source video's lesson with your own PostgreSQL instance: establish a baseline, add a selective index, inspect both plans, and measure the read/write trade-off.

## Source

- Neeraj Kulkarni, [Database indexing explained on a real database](https://www.youtube.com/watch?v=eGzmUyOyzHs)

## To add

- `schema.sql`
- `seed.sql`
- `queries.sql`
- `benchmark/`
- before/after `EXPLAIN (ANALYZE, BUFFERS)` output and environment details

## Success criteria

- Demonstrate a selective predicate whose plan changes after a matching index.
- Demonstrate a broad predicate for which a sequential scan remains reasonable.
- Record local results; do not compare them directly with another machine's numbers.
