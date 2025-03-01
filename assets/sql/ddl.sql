-- 회원정보 테이블
CREATE TABLE member (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID 기본키
    userid VARCHAR(20) NOT NULL UNIQUE,   -- 회원ID
    username VARCHAR(50) NOT NULL,        -- 사용자명(본명)
    email VARCHAR(100) NOT NULL UNIQUE,   -- 이메일
    password VARCHAR(255) NOT NULL,       -- 비밀번호
    nickname VARCHAR(50) UNIQUE,          -- 닉네임
    birth_date DATE NOT NULL,             -- 생년월일
    gender ENUM('male', 'female', 'other'), -- 성별
    is_admin BOOLEAN DEFAULT FALSE,       -- 관리자 계정 여부
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 가입일자
    is_deleted BOOLEAN,                   -- 탈퇴여부
    deleted_at DATETIME DEFAULT NULL,     -- 탈퇴일자
    agree BOOLEAN DEFAULT FALSE          -- 약관동의
    score INT DEFAULT 0                  -- 신뢰도
);

-- 카테고리 테이블 (계층형 구조)
# 서적을 분류하는 카테고리 테이블
# - 계층 구조로 관리한다
---------------------------------------------------------
CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES category(id) ON DELETE SET NULL
);

-- 책 정보 테이블
CREATE TABLE book (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 책 고유 ID
    isbn VARCHAR(13) UNIQUE NOT NULL,       -- ISBN 번호
    title VARCHAR(255) NOT NULL,            -- 책 제목
    author VARCHAR(255) NOT NULL,           -- 저자
    publisher VARCHAR(255),                 -- 출판사
    publication_date DATE                  -- 출판일
);

-- 판매 게시글 테이블
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- 판매 ID pk
    member_id INT NOT NULL,                    -- 판매자 ID
    book_id INT NOT NULL,                      -- 책 정보 참조 (book)
    category_id INT,                        -- 카테고리 참조
    price DECIMAL(10, 2) NOT NULL,             -- 가격
    book_condition ENUM ('상', '중', '하'),    -- 상태
    trade_method VARCHAR(100),               -- 거래 선호 방식
    payment_location VARCHAR(255),             -- 거래 장소 (직거래를 선호할 때만 기록 null값 가능)
    description TEXT,                          -- 상품 설명
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 등록일시
    product_status ENUM('Deleted','For Sale', 'Reserved', 'Sold Out') DEFAULT 'For Sale', -- 판매상태
    # product_status ENUM('삭제 상품', '판매중', '거래 예약중', '거래 완료') DEFAULT '판매중', -- 판매상태
    book_image VARCHAR(255),                   -- 책 이미지 URL
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (member_id) REFERENCES member(id),
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE
);

-- 찜하기 테이블
CREATE TABLE wish (
		idx INT AUTO_INCREMENT PRIMARY KEY,       -- 찜 ID pk
		product_idx INT NOT NULL UNIQUE,
		member_idx INT NOT NULL UNIQUE,
		canceled BOOLEAN NOT NULL DEFAULT FALSE,
		FOREIGN KEY (member_idx) REFERENCES member(idx),
		FOREIGN KEY (product_idx) REFERENCES product(idx)
); -- 취소하면 boolean 값 변경

-- 리뷰 테이블
CREATE TABLE review (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- 리뷰 ID
    member_id INT,                          -- 작성자 ID
    product_id INT,                         -- 리뷰 대상 상품 ID
    review_text TEXT,                       -- 리뷰 내용
    rating INT CHECK (rating BETWEEN 1 AND 5), -- 평점
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 작성일시
    FOREIGN KEY (member_id) REFERENCES member(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- 채팅방 테이블
CREATE TABLE chatting_room (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 채팅방 ID
    identifier VARCHAR(100) NOT NULL,   -- 고유 식별자
    last_chat TEXT,                     -- 마지막 메시지
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- 생성일시
);

-- 채팅 메시지 테이블
CREATE TABLE chatting (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 메시지 ID
    room_id INT,                        -- 채팅방 ID
    send_user_id INT,                   -- 보낸 사용자 ID
    message TEXT,                       -- 메시지 내용
    is_read BOOLEAN DEFAULT FALSE,      -- 읽음 여부
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    FOREIGN KEY (room_id) REFERENCES chatting_room(id),
    FOREIGN KEY (send_user_id) REFERENCES member(id)
);

-- 채팅 참여자 테이블
CREATE TABLE participant (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 참여자 ID
    room_id INT,                       -- 채팅방 ID
    user_id INT,                       -- 사용자 ID
    FOREIGN KEY (room_id) REFERENCES chatting_room(id),
    FOREIGN KEY (user_id) REFERENCES member(id)
);

-- 주문 테이블
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,        -- 주문 ID
    member_id INT,                            -- 구매자 ID
    product_id INT,                           -- 상품 ID
    amount INT NOT NULL,                      -- 가격
    order_status ENUM('거래중', '거래완료', '거래취소') DEFAULT '거래중' NOT NULL, -- 주문 상태
    street_address VARCHAR(255),        -- 주문자 도로명 주소
    detail_address VARCHAR(255),        -- 주문자 상세 주소
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 주문일시
    FOREIGN KEY (member_id) REFERENCES member(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- 결제 내역 테이블
-- 직거래 (현금 직접결제)
CREATE TABLE payment (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 결제 ID
    product_id INT,                     -- 상품 ID
    order_id INT,                       -- 주문 ID
	amount INT NOT NULL,                -- 가격
	payment_type ENUM('Kakao', 'Toss', 'Direct') NOT NULL,    -- 결제수단
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 결제일시
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 알림 테이블
CREATE TABLE notification (
    id INT AUTO_INCREMENT PRIMARY KEY,             -- 알림 ID
    member_id INT,                                 -- 사용자 ID
    message TEXT,                                  -- 알림 내용
    is_read BOOLEAN DEFAULT FALSE,                 -- 읽음 여부
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    FOREIGN KEY (member_id) REFERENCES member(id)
);

-- 신고 테이블
CREATE TABLE report (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 신고 ID
    member_id INT,                      -- 신고자 ID
    product_id INT,                     -- 신고 대상 상품 ID
    report_reason TEXT,                 -- 신고 사유
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- 신고일시
    FOREIGN KEY (member_id) REFERENCES member(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);
