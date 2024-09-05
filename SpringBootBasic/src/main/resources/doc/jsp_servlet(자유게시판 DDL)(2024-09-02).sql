DROP TABLE FREE_BOARD;
CREATE TABLE FREE_BOARD(
  FREE_BOARD_ID NUMBER NOT NULL,
  MEMBER_NO NUMBER NOT NULL,
  FREE_BOARD_TITLE VARCHAR2(765) NOT NULL,
  FREE_BOARD_CONTENT VARCHAR2(4000) NOT NULL,
  CREATE_DATE DATE NOT NULL,
  UPDATE_DATE DATE NOT NULL
);

COMMENT ON TABLE FREE_BOARD IS '자유게시판';

COMMENT ON COLUMN FREE_BOARD.FREE_BOARD_ID IS '자유게시판 번호';
COMMENT ON COLUMN FREE_BOARD.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN FREE_BOARD.FREE_BOARD_TITLE IS '자유게시판 주제';
COMMENT ON COLUMN FREE_BOARD.FREE_BOARD_CONTENT IS '자유게시판 본문';
COMMENT ON COLUMN FREE_BOARD.CREATE_DATE IS '자유게시판 생성날짜';
COMMENT ON COLUMN FREE_BOARD.UPDATE_DATE IS '자유게시판 수정날짜';

ALTER TABLE FREE_BOARD 
ADD CONSTRAINT FREE_BOARD_ID_PK 
PRIMARY KEY(FREE_BOARD_ID);

ALTER TABLE FREE_BOARD 
ADD CONSTRAINT FREE_BOARD_MEMBER_NO_FK
FOREIGN KEY(MEMBER_NO) REFERENCES MEMBER(MEMBER_NO);

DROP SEQUENCE FREE_BOARD_ID_SEQ;
CREATE SEQUENCE FREE_BOARD_ID_SEQ
INCREMENT BY 1
START WITH 1;

-- FREE_BOARD 확인
SELECT *
FROM FREE_BOARD;

desc free_board;

-- NO 확인
SELECT *
FROM MEMBER;

INSERT INTO FREE_BOARD(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE)
VALUES (FREE_BOARD_ID_SEQ.NEXTVAL, 3, '암온더 넥스트 레벨', '광야를 걸어가~', SYSDATE, SYSDATE);
INSERT INTO FREE_BOARD(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE)
VALUES (FREE_BOARD_ID_SEQ.NEXTVAL, 3, 'LIKE THAT', '찰리푸스~', SYSDATE, SYSDATE);
INSERT INTO FREE_BOARD(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE)
VALUES (FREE_BOARD_ID_SEQ.NEXTVAL, 6, 'batter up', '어텐션!', SYSDATE, SYSDATE);
INSERT INTO FREE_BOARD(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE)
VALUES (FREE_BOARD_ID_SEQ.NEXTVAL, 6, '어텐션', '유갓미룩킹폴어텐션~', SYSDATE, SYSDATE);
INSERT INTO FREE_BOARD(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE)
VALUES (FREE_BOARD_ID_SEQ.NEXTVAL, 6, '스파쏘닉', '스파스파스파쏘닉스파쏘닉', SYSDATE, SYSDATE);

COMMIT;

DESC FREE_BOARD;

-- 게시글 생성일 정렬(내림차순)
SELECT FREE_BOARD_ID
    , MEMBER_NO
    , FREE_BOARD_TITLE
    , FREE_BOARD_CONTENT
    , CREATE_DATE
    , UPDATE_DATE
FROM FREE_BOARD
WHERE ROWNUM <= 3
ORDER BY FREE_BOARD_ID DESC;

-- 에스터리스크 사용
SELECT * 
FROM (SELECT FREE_BOARD_ID
    , MEMBER_NO
    , FREE_BOARD_TITLE
    , FREE_BOARD_CONTENT
    , CREATE_DATE
    , UPDATE_DATE
FROM FREE_BOARD
ORDER BY FREE_BOARD_ID DESC)
WHERE ROWNUM <= 3;

SELECT ROWNUM AS RN, FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE
    , FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE
FROM (SELECT FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE
    , FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE
FROM FREE_BOARD
ORDER BY FREE_BOARD_ID DESC)
WHERE ROWNUM <= 3;

SELECT *
FROM (SELECT ROWNUM AS RN, FREE_BOARD_ID
    , MEMBER_NO
    , FREE_BOARD_TITLE
    , FREE_BOARD_CONTENT
    , CREATE_DATE
    , UPDATE_DATE
FROM FREE_BOARD
ORDER BY FREE_BOARD_ID DESC)
WHERE ROWNUM <= 3;

SELECT *
FROM (SELECT ROWNUM AS RN, FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE
      FROM (SELECT FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE
            FROM FREE_BOARD
            ORDER BY FREE_BOARD_ID DESC)
    )
WHERE RN BETWEEN 1 AND 3;

SELECT RNUM, FREE_BOARD.FREE_BOARD_ID, FREE_BOARD.MEMBER_NO
    , FREE_BOARD.MEMBER_NAME, FREE_BOARD.FREE_BOARD_TITLE, FREE_BOARD.FREE_BOARD_CONTENT
    , FREE_BOARD.CREATE_DATE, FREE_BOARD.UPDATE_DATE
FROM (  SELECT  ROWNUM RNUM, FB.FREE_BOARD_ID, FB.MEMBER_NO, FB.MEMBER_NAME, 
            FB.FREE_BOARD_TITLE, FB.FREE_BOARD_CONTENT, FB.CREATE_DATE, FB.UPDATE_DATE
        FROM (  SELECT  OFB.FREE_BOARD_ID, M.MEMBER_NO, M.MEMBER_NAME, 
                    OFB.FREE_BOARD_TITLE, OFB.FREE_BOARD_CONTENT, OFB.CREATE_DATE, OFB.UPDATE_DATE
                FROM MEMBER M, FREE_BOARD OFB
                WHERE M.MEMBER_NO = OFB.MEMBER_NO
                ORDER BY OFB.FREE_BOARD_ID DESC) FB
) FREE_BOARD
WHERE RNUM >= 1 AND RNUM <= 6;

SELECT COUNT(FREE_BOARD_ID)
FROM FREE_BOARD;

SELECT *
FROM FREE_BOARD;

SELECT RNUM, FREE_BOARD.FREE_BOARD_ID, FREE_BOARD.MEMBER_NO
				, FREE_BOARD.MEMBER_NAME, FREE_BOARD.FREE_BOARD_TITLE,
				FREE_BOARD.FREE_BOARD_CONTENT
				, FREE_BOARD.CREATE_DATE, FREE_BOARD.UPDATE_DATE
			FROM ( SELECT ROWNUM RNUM, FB.FREE_BOARD_ID, FB.MEMBER_NO, FB.MEMBER_NAME,
						FB.FREE_BOARD_TITLE, FB.FREE_BOARD_CONTENT, FB.CREATE_DATE,
						FB.UPDATE_DATE
						FROM ( SELECT OFB.FREE_BOARD_ID, M.MEMBER_NO, M.MEMBER_NAME,
									OFB.FREE_BOARD_TITLE, OFB.FREE_BOARD_CONTENT, OFB.CREATE_DATE,
									OFB.UPDATE_DATE
									FROM MEMBER M, FREE_BOARD OFB
									WHERE M.MEMBER_NO = OFB.MEMBER_NO
									ORDER BY OFB.FREE_BOARD_ID DESC) FB
			) FREE_BOARD
			WHERE RNUM >= 1 AND RNUM <= 600;

INSERT INTO free_board
VALUE(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT
    , CREATE_DATE, UPDATE_DATE)
VALUES(FREE_BOARD_ID_SEQ.NEXTVAL, 6, 
    '제목:TEST 자료' || FREE_BOARD_ID_SEQ.CURRVAL,
    '내용:TEST 자료' || FREE_BOARD_ID_SEQ.CURRVAL, 
     SYSDATE + FREE_BOARD_ID_SEQ.CURRVAL, SYSDATE + FREE_BOARD_ID_SEQ.CURRVAL);


COMMIT;

SELECT *
FROM FREE_BOARD;

SELECT *
FROM MEMBER;

-- PL/SQL 언어
-- 프로시저 생성
CREATE OR REPLACE PROCEDURE INSERT_FREE_BOARD_RECORDS AS
BEGIN
    FOR i IN 1..53 LOOP
        INSERT INTO free_board
        VALUE(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT
            , CREATE_DATE, UPDATE_DATE)
        VALUES(FREE_BOARD_ID_SEQ.NEXTVAL, 6, 
            '제목:TEST 자료' || FREE_BOARD_ID_SEQ.CURRVAL,
            '내용:TEST 자료' || FREE_BOARD_ID_SEQ.CURRVAL, 
             SYSDATE + FREE_BOARD_ID_SEQ.CURRVAL, 
             SYSDATE + FREE_BOARD_ID_SEQ.CURRVAL
        );
        END LOOP;
END;
/

-- 프로시저 실행
BEGIN
    INSERT_FREE_BOARD_RECORDS; -- 프로시저 명
    COMMIT;
END; -- end
/ -- 실행


-- FREE_BOARD
DESC FREE_BOARD;

SELECT *
FROM MEMBER;

-- 자유게시판 insert
INSERT INTO FREE_BOARD
VALUE(FREE_BOARD_ID, MEMBER_NO, FREE_BOARD_TITLE, FREE_BOARD_CONTENT, CREATE_DATE, UPDATE_DATE)
VALUES(FREE_BOARD_ID_SEQ.NEXTVAL, 2, '여름이었다.', '계절이 지나가는 하늘에는 여름으로 가득 차 있습니다.', SYSDATE, SYSDATE);

COMMIT;

SELECT *
FROM FREE_BOARD;

DESC MEMBER;

-- 자유게시판 detail
SELECT F.FREE_BOARD_ID, F.MEMBER_NO, M.EMAIL, M.MEMBER_NAME, F.FREE_BOARD_TITLE, F.FREE_BOARD_CONTENT, F.CREATE_DATE
FROM FREE_BOARD F INNER JOIN MEMBER M
ON F.MEMBER_NO = M.MEMBER_NO
WHERE FREE_BOARD_ID = 5;

SELECT F.FREE_BOARD_ID, F.MEMBER_NO, M.EMAIL, M.MEMBER_NAME, F.FREE_BOARD_TITLE, F.FREE_BOARD_CONTENT, F.CREATE_DATE
FROM FREE_BOARD F INNER JOIN MEMBER M
ON F.MEMBER_NO = M.MEMBER_NO
WHERE FREE_BOARD_ID = #{}