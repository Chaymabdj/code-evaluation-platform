-- Problems: the exercises users can solve
CREATE TABLE problems (
  id SERIAL PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  time_limit_ms INT NOT NULL DEFAULT 2000,
  memory_limit_mb INT NOT NULL DEFAULT 128
);

-- Test cases: input and expected output for each problem
CREATE TABLE test_cases (
  id SERIAL PRIMARY KEY,
  problem_id INT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  input TEXT NOT NULL,
  expected_output TEXT NOT NULL
);

-- Submissions: code sent by users and its global status
CREATE TABLE submissions (
  id SERIAL PRIMARY KEY,
  problem_id INT NOT NULL REFERENCES problems(id),
  code TEXT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'running', 'passed', 'failed', 'error', 'timeout')),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  finished_at TIMESTAMP
);

-- Results: outcome of each test case for each submission
CREATE TABLE results (
  id SERIAL PRIMARY KEY,
  submission_id INT NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
  test_case_id INT NOT NULL REFERENCES test_cases(id),
  actual_output TEXT,
  passed BOOLEAN NOT NULL,
  execution_time_ms INT,
  error_message TEXT
);

-- Indexes: make frequent searches faster
CREATE INDEX idx_submissions_status ON submissions(status);
CREATE INDEX idx_results_submission ON results(submission_id);