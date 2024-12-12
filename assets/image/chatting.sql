#1. 채팅 기능 (CHAT_001)
-- 채팅 메시지 생성 및 저장
INSERT INTO chatting (room_id, send_user_id, message, is_read, created_at) 
VALUES (1, 101, '안녕하세요, 첫 메시지입니다.',FALSE, NOW());

-- 특정 채팅방의 메시지를 최신 순으로 불러오기 (스크롤 구현 지원)
SELECT id, send_user_id, message, created_at, is_read
FROM chatting
WHERE room_id = 8
ORDER BY created_at DESC
LIMIT 20 OFFSET 0; -- OFFSET을 통해 스크롤 페이지 처리

#2. 읽음 확인 기능 (CHAT_002)
-- 채팅 메시지 읽음 확인 업데이트
UPDATE chatting
SET is_read = TRUE
WHERE room_id = 8 AND id = 755; -- 특정 메시지 ID

# 채팅 메시지 읽음 조회
-- room_id = 1 인 채팅방에서 메시지 읽음 여부 확인
SELECT id, message, is_read
FROM chatting
WHERE room_id = 2;

#3.알림기능 (CHAT_003)
-- 새 메시지가 도착했을 때 알림 생성
INSERT INTO notification (member_id, message, is_read, created_at)
VALUES (102, '101님이 새 메시지를 보냈습니다.', FALSE, NOW());

-- 알림 조회
SELECT *
FROM notification
WHERE member_id = 35170 AND is_read = FALSE;

-- 알림 읽음 처리
UPDATE notification
SET is_read = TRUE
WHERE member_id = 102 AND id = 1; -- 특정 알림 ID

#4. 신고 기능 (CHAT_004)
-- 메시지 신고 등록
INSERT INTO report (member_id, product_id, report_reason, created_at)
VALUES (103, 201, '욕설', NOW());

-- 신고 조회
SELECT r.id AS report_id, r.report_reason, r.created_at, m.nickname AS reporter
FROM report r
INNER JOIN member m 
ON r.member_id = m.id
WHERE r.product_id = 8727;

#5. 삭제 기능 (CHAT_005)
-- 단일 메시지 삭제
DELETE FROM chatting
WHERE id = 123;

-- 채팅방 메시지 삭제
DELETE FROM chatting
WHERE room_id = ?;

-- 조건부 삭제
DELETE FROM chatting
WHERE send_user_id = 101;

#6. 채팅방 생성 (ROOM_001)
-- 채팅방 생성
INSERT INTO chatting_room (identifier, last_chat, created_at)
SELECT 
    b.title AS identifier,   
    NULL AS last_chat,       
    NOW() AS created_at      
FROM product p
JOIN book b ON p.book_id = b.id
WHERE p.id = 101; 

-- 채팅방 조회 (개선전)
SELECT 
    cr.id AS chat_room_id,       -- 채팅방 ID
    cr.identifier AS book_title, -- 책 제목
    b.id AS book_id,             -- 책 ID
    p.id AS product_id,          -- 판매 게시글 ID
    p.member_id AS seller_id,    -- 판매자 ID
    cr.last_chat,                -- 마지막 메시지
    cr.created_at                -- 생성일시
FROM chatting_room cr
JOIN product p ON cr.identifier = (
    SELECT b.title               -- 책 제목과 identifier 매칭
    FROM book b 
    WHERE b.id = p.book_id
)
JOIN book b ON b.id = p.book_id  -- 책 ID를 추가로 가져오기 위해 조인
LIMIT 0, 1000;

-- 채팅방 조회(개선후)
SELECT 
    cr.id AS chat_room_id,       -- 채팅방 ID
    b.title AS book_title,       -- 책 제목
    b.id AS book_id,             -- 책 ID
    p.id AS product_id,          -- 판매 게시글 ID
    p.member_id AS seller_id,    -- 판매자 ID
    cr.last_chat,                -- 마지막 메시지
    cr.created_at                -- 생성일시
FROM chatting_room cr
JOIN book b ON cr.identifier = b.title  -- identifier와 title 매칭
JOIN product p ON b.id = p.book_id  -- 책 ID를 가져오기 위한 조인
LIMIT 1000; -- LIMIT 범위 적용

#7. 채팅방 종료 (ROOM_002)
-- 채팅방 삭제
DELETE FROM chatting_room
WHERE id = 1;
-- 특정 사용자 나가기
DELETE FROM participant
WHERE room_id = 1 AND user_id = 101;

#8. 참여자 관리
-- 특정 사용자 강퇴
DELETE FROM participant
WHERE room_id = 1 AND user_id = 101;

-- 강퇴된 사용자를 추적하려면 별도의 테이블에 기록
INSERT INTO banned_users (room_id, user_id, banned_at)
VALUES (1, 104, NOW());