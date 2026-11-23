-- Seed data: starter problems and their test cases

INSERT INTO problems (title, description) VALUES
  ('Sum of two numbers', 'Read two integers on one line and print their sum.'),
  ('Even or odd', 'Read an integer and print even or odd.'),
  ('Reverse a string', 'Read a string and print it reversed.');

INSERT INTO test_cases (problem_id, input, expected_output) VALUES
  (1, '2 3', '5'),
  (1, '10 -4', '6'),
  (2, '4', 'even'),
  (2, '7', 'odd'),
  (3, 'hello', 'olleh'),
  (3, 'abc', 'cba');