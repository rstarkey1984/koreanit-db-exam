# 데이터베이스 설계 및 SQL 문제해결 시나리오 평가

## 과목
데이터베이스 설계 / SQL

## 평가 유형
실습 기반 문제해결 시나리오 평가

## 평가 목적
본 평가는 데이터베이스의 단순 SQL 문법 암기가 아닌,
실제 운영 환경에서 발생할 수 있는 문제 상황을 분석하고
SQL을 활용하여 이를 해결할 수 있는 능력을 종합적으로 평가하는 것을 목적으로 한다.

## 평가 개요

> 본 평가는 사전 환경 구성부터 문제 해결까지 포함된 실습 중심 평가로 3시간으로 구성한다.

- 운영 중인 게시판 서비스의 데이터베이스를 가정한다.

- 수험자는 제공된 스키마 및 더미데이터를 기반으로 문제 상황을 해결한다.

- 데이터베이스 생성 및 권한 부여는 서버 터미널(MySQL CLI) 환경에서 수행하며, 이후 실제 데이터 작업과 문제 해결은 MySQL Workbench를 사용한다.

- 모든 문제는 실제 실무 환경에서 발생 가능한 시나리오를 기반으로 한다.

---
# 채점 기준
> 본 평가는 SQL 문법 암기가 아닌  
> 운영 환경에서의 문제 분석 능력과 해결 과정을 평가한다.    
> 정답 여부뿐 아니라 접근 방식·근거·검증 SQL을 함께 채점한다.

※ 본 평가는 일부 문항에 대해
제출물 내용과 무관하게 감독관이 직접 데이터베이스 상태를 확인하여 채점한다.

- 제약조건(UNIQUE, FK)
- 인덱스 존재 여부
- 컬럼 추가 및 데이터 반영 여부

실제 DB에 반영되지 않은 경우,
서술 내용과 관계없이 해당 문항은 감점 또는 0점 처리될 수 있다.

## 총점: 100점

- 사전 환경 구성: 20점  
( 수험자가 사전 환경 구성을 완료하지 못한 경우, 감독관이 개입하여 최소 실행 환경을 제공한다. )

- 문제 1 (FK 삭제 문제): 20점

- 문제 2 (성능 문제): 20점

- 문제 3 (데이터 품질): 20점

- 문제 4 (비정규화): 20점


## 제출물 규칙

- 제출물은 MD 파일 형식으로 [`본인이름.md`](/html/이름.md) 로 제출

## 시험 환경

- OS: `WSL Ubuntu 24`

- DBMS: `MySQL 8.0.44`

- DB 서버 접속 방식

  - 데이터베이스(스키마) 설정: 터미널(`MySQL 클라이언트`)

  - 실습 및 문제 해결: `MySQL Workbench`

- 클라이언트 도구: MySQL Workbench (로컬 PC)

---

# 0. 사전 환경 구성

### 0-1. `sudo` 를 사용해 `root` 계정으로 MySQL 클라이언트를 실행하여 서버에 접속한다

```bash
sudo mysql
```


### 0-2. MySQL 프롬프트에서 시험용 데이터베이스 생성

```sql
CREATE DATABASE examdb;
```


### 0-3. 시험 전용 계정 생성 및 권한 부여

```sql
CREATE USER 'examuser'@'localhost' IDENTIFIED BY 'Ex@m9Q2#L!!';
```

```sql
GRANT ALL PRIVILEGES ON examdb.* TO 'examuser'@'localhost';
```

### 0-4. MySQL Workbench 에서 DB 접속설정

- Hostname: `localhost`

- Port: `3308`

- Username: `examuser`

- Password: `Ex@m9Q2#L!!`

- Default Schema: `examdb`


## 0-5. 아래 내용에 있는 SQL 실행
### [데이터베이스 초기화 및 시드 데이터 생성 (DB Initialization & Seeding)](html/seed_data.sql)


---

# 문제해결 시나리오

## 공통 규칙

- 모든 문제 해결은 `examdb` 데이터베이스(스키마) 에서 수행

- 각 문항은 “원인 분석 → 해결 방법 → 검증” 흐름을 갖추어야 함

--- 
# 문제 1. 운영 장애: 특정 사용자 삭제가 안 된다
## 상황

운영팀이 `users` 테이블에 `id` 가 `10` 인 사용자를 탈퇴 처리하려고 DELETE 했는데 실패한다.
(외래키로 인해 삭제가 막히는 상황)

## 요구사항

1. DELETE 쿼리문을 작성해서 실행해보고 실패하는 정확한 원인(테이블/제약조건/연관 데이터) 을 로그로 확인

2. 운영 정책을 가정하여 아래 중 하나로 해결(선택)

    - A안: 사용자 삭제 시 해당 사용자의 게시글/댓글도 함께 삭제되는 정책(= FK 옵션 On Delete 옵션 검토)

    - B안: 사용자 삭제 시 그 사용자의 게시글은 유지하되, 작성자 표시를 “탈퇴회원”으로 바꾸는 정책(= FK 옵션 On Delete 옵션 검토 및 게시글 조회시 posts.user_id null 처리 전략 필요)


3. 해결 후 DELETE FROM users WHERE id=10; 이 정상 동작함을 검증 SQL로 증명

## 평가 포인트

- FK 구조 이해 / 운영 정책 선택 / 검증 쿼리

--- 
# 문제 2. 성능 장애: “일정기간 동안의 게시글 수 집계” 가 너무 느리다
## 상황

운영 대시보드에서 아래 성격의 통계 쿼리가 느려서 타임아웃이 난다.

- 2025년 12월 한달동안 작성된 총 게시글 수 집계

## 요구사항

1. 쿼리 작성

2. `EXPLAIN` 구문을 통해 요구사항 1번에서 작성한 쿼리 실행이 왜 느린지 확인

3. 인덱스/쿼리 개선으로 성능 개선(개선 전/후 비교 제시)

    - 인덱스 추가가 필요하다면 근거 포함
    - 불필요한 풀스캔이 줄어드는지 확인

## 평가 포인트

- 쿼리작성 / EXPLAIN 해석 / 인덱스 설계 근거

--- 

# 문제 3. 데이터 품질: 이메일 중복 데이터 정리 + 제약조건 강화
## 상황

초기 서비스 운영시에는 사용자 이메일을 중복 허용했었다.

하지만 정책이 바뀜에 따라 사용자 이메일은 중복을 허용하지 않기로 했다.

## 요구사항

1. 이메일 중복 탐지 SQL 작성

2. 정리 정책을 택해 정리(예: 중복 중 가장 먼저 가입자만 남기고 나머지는 email을 NULL 처리, 또는 규칙 기반으로 변경)

3. 정리 후 `email` 컬럼에 `UNIQUE` 제약 추가

## 평가 포인트

- 중복탐지 SQL / 중복데이터 정리과정 / email 컬럼에 UNIQUE 제약 추가

---

# 문제 4. 비정규화 도입: posts.comments_cnt 캐시 컬럼 설계
## 상황

현재 게시글 목록에서 “댓글 수”를 함께 보여주고 있다.

게시글 오래된 순으로 조회하는 쿼리:
```sql
SELECT p2.*, count(c.id) AS comments_cnt from 
(SELECT p.id, p.title, u.nickname, p.created_at FROM posts AS p
INNER JOIN users AS u ON p.user_id = u.id
ORDER BY p.created_at ASC limit 20) AS p2
LEFT JOIN comments AS c
ON p2.id = c.post_id GROUP BY p2.id
```

매 요청마다 `comments` 테이블을 `LEFT JOIN` / `COUNT(*)`로 계산하고 있어서 목록 조회가 느려졌다.

## 요구사항

1. posts 테이블에 댓글 수 컬럼(`comments_cnt`) 추가

2. 댓글(comments 테이블) INSERT 시 posts.comments_cnt 증가 SQL 작성

3. 댓글(comments 테이블) DELETE 시 posts.comments_cnt 감소 SQL 작성

4. 기존 데이터에 대해 댓글 수를 일괄 채우는 초기 마이그레이션 SQL 실행 후 게시글 오래된 순으로 조회하는 쿼리를 comments 테이블 조인 없이 댓글 수 포함해서 조회 ( 컬럼: `id`, `title`, `nickname`, `created_at`, `comments_cnt` )

## 기존 데이터에 대해 댓글 수를 일괄 채우는 초기 마이그레이션 SQL 실행:

```sql
UPDATE posts p
LEFT JOIN (
  SELECT post_id, COUNT(*) AS cnt
  FROM comments
  GROUP BY post_id
) c ON c.post_id = p.id
SET p.comments_cnt = COALESCE(c.cnt, 0)
WHERE p.id >= 1;
```

## 평가 포인트

- DDL 쿼리 / comments_cnt 증감 로직 쿼리 정확성

- 기존쿼리(join comments)와 변경된쿼리(comments 테이블 join없이) 실행 후 comments_cnt 동일한지 확인

