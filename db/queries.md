# SQL queries for the API and the worker

`%s` placeholders are for psycopg2 (Python). Always pass values as parameters, never build SQL with f-strings.

Submission status: `pending` -> `running` -> `passed` | `failed` | `error` | `timeout`

## API

### List problems
```sql
SELECT id, title, description FROM problems ORDER BY id;
```

### Get one problem
```sql
SELECT id, title, description, time_limit_ms, memory_limit_mb
FROM problems WHERE id = %s;
```

### Create a submission
```sql
INSERT INTO submissions (problem_id, code) VALUES (%s, %s) RETURNING id;
```

### Get the status of a submission
```sql
SELECT id, problem_id, status, created_at, finished_at
FROM submissions WHERE id = %s;
```

### Get the results of a submission
```sql
SELECT test_case_id, passed, actual_output, execution_time_ms, error_message
FROM results WHERE submission_id = %s ORDER BY test_case_id;
```

### Submission history
```sql
SELECT s.id, p.title, s.status, s.created_at
FROM submissions s JOIN problems p ON p.id = s.problem_id
ORDER BY s.created_at DESC LIMIT 50;
```

## Worker

### Claim the next pending submission
Safe with several workers: two workers never get the same submission.
```sql
UPDATE submissions SET status = 'running'
WHERE id = (
  SELECT id FROM submissions WHERE status = 'pending'
  ORDER BY id LIMIT 1
  FOR UPDATE SKIP LOCKED
)
RETURNING id, problem_id, code;
```
If it returns no row, there is nothing to do: wait a second and retry.

### Get the test cases of a problem
```sql
SELECT id, input, expected_output FROM test_cases
WHERE problem_id = %s ORDER BY id;
```

### Save the result of one test case
```sql
INSERT INTO results
  (submission_id, test_case_id, actual_output, passed, execution_time_ms, error_message)
VALUES (%s, %s, %s, %s, %s, %s);
```

### Finish a submission
```sql
UPDATE submissions SET status = %s, finished_at = NOW() WHERE id = %s;
```
Suggested final status: `passed` if all test cases pass, `failed` if an output is wrong, `error` on a runtime error, `timeout` if the time limit is exceeded.
Compare outputs after `.strip()`, because `print()` adds a newline.