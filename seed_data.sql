SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    view_count INT UNSIGNED NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_posts_user_id (user_id),
    CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    comment VARCHAR(500) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_comments_post_id (post_id),
    CONSTRAINT fk_comments_post FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- =========================
-- seed data
-- =========================
SET SESSION cte_max_recursion_depth = 1000000;

-- ===== users (200)
INSERT INTO users (username, email, password, nickname)
SELECT
  CONCAT('user', n),
  CASE
    WHEN n IN (3, 7, 15, 42) THEN 'same@test.com'
    ELSE CONCAT('user', n, '@test.com')
  END,
  '$2a$10$abcdefghijklmnopqrstuvwxyz1234567890abcdef', -- 더미 bcrypt 해시
  CONCAT('user_', n)
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 200
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== posts (100000)
INSERT INTO posts (user_id, title, content, view_count, created_at)
SELECT
  FLOOR(1 + RAND() * 100),
  CONCAT('게시글 제목 ', n),
  CONCAT('게시글 내용 ', n),
  FLOOR(RAND() * 10000),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;

-- ===== comments (100000)
INSERT INTO comments (post_id, user_id, comment, created_at)
SELECT
  FLOOR(1 + RAND() * 10000),
  FLOOR(1 + RAND() * 100),
  CONCAT('댓글 내용 ', n),
  NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM (
  WITH RECURSIVE seq(n) AS (
    SELECT 1 UNION ALL SELECT n+1 FROM seq WHERE n < 100000
  ) SELECT n FROM seq
) t;