## Database (Student 2: Chayma)

### Overview
PostgreSQL 16 stores the problems, their test cases, the submitted code and the results of each execution.

### ER diagram
```mermaid
erDiagram
  problems ||--o{ test_cases : has
  problems ||--o{ submissions : receives
  submissions ||--o{ results : produces
  test_cases ||--o{ results : checked_by
  problems {
    int id PK
    varchar title
    text description
    int time_limit_ms
    int memory_limit_mb
  }
  test_cases {
    int id PK
    int problem_id FK
    text input
    text expected_output
  }
  submissions {
    int id PK
    int problem_id FK
    text code
    varchar status
    timestamp created_at
    timestamp finished_at
  }
  results {
    int id PK
    int submission_id FK
    int test_case_id FK
    text actual_output
    boolean passed
    int execution_time_ms
    text error_message
  }
```

### Tables
| Table | Purpose |
|---|---|
| problems | Exercises users can solve |
| test_cases | Input and expected output for each problem |
| submissions | Submitted code and its global status |
| results | Outcome of each test case for each submission |

Submission status: `pending` -> `running` -> `passed`, `failed`, `error` or `timeout`.

### Start the database locally
```bash
cp .env.example .env
docker compose -f docker-compose.db.yml up -d
```
The scripts in `db/init/` run automatically the first time and create the tables and seed data.

### Persistence
Data is stored in the Docker volume `pgdata` and survives `docker compose down`. To reset the database completely: `docker compose -f docker-compose.db.yml down -v`.# code-evaluation-platform