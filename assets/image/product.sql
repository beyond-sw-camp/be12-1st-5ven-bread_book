# 도서 정보 입력 PRODUCT 001
-- 도서명으로 도서 검색
-- 네이버 책 검색 API에서 XML이나 JSON 파일로 응답 요청이 오면 프론트엔드에서 채워 넣는다.

-- 도서가 BOOK 테이블에 등록되어있는지 확인한다.
SELECT *
FROM book
WHERE isbn = '9791162241622';

-- 도서가 BOOK 테이블에 등록되지 않았다면, 새로운 레코드(=행)를 추가한다.
INSERT INTO book (isbn, title, author, publisher, publication_date)
VALUES ('9791162241622', '이것이 MariaDB다', '우재남', '한빛미디어', '2019-04-01');

-- 입력한 책의 id로, 판매중인 상품들의 최저가와 상품 상태를 함께 검색
SELECT price, book_condition
FROM product
WHERE book_id = 1 AND product_status = 'For Sale'
ORDER BY price ASC
LIMIT 3;


-- ----------------------------------
# 판매 정보 입력 - PRODUCT 002
# 판매 게시글 등록 - PRODUCT 003
-- 판매할 도서의 카테고리를 직접 지정하기 위해 카테고리 조회
-- 1수준 카테고리 조회
SELECT * FROM category
WHERE parent_id is null;
-- 2수준 - 지정된 1수준 카테고리의 하위 카테고리 조회
SELECT * FROM category
WHERE parent_id = 1;
-- 3수준 - 지정된 2수준 카테고리의 하위 카테고리 조회
SELECT * FROM category
WHERE parent_id = 22;

-- 판매 게시글 등록 SQL
INSERT INTO product (
    member_id,
    book_id,
    category_id,
    price,
    book_condition,
    trade_method,
    payment_location,
    description,
    product_status,
    book_image
) VALUES (
    1,           -- 판매자 ID
    1,             -- 도서 ID
    260,         -- 카테고리 ID
    10000,               -- 판매 가격
    '상',      -- 도서 상태 ('상', '중', '하')
    '택배',     -- 거래 방식 ('택배', '직거래', '문고리 거래' 등등...)
    '37.566588, 126.978169',    -- 거래 희망 장소 (직거래 시 입력)
    '판매 도서 설명입니다.',         -- 상품 설명
    'For Sale',           -- 기본 판매 상태 ('판매중')
    'https://image.yes24.com/goods/71736690/XL'           -- 도서 사진 URL
);
-- -------------------------------------
# 판매 게시글 수정 기능 PRODUCT_04
UPDATE product
SET price = '5000',
    book_condition = '중',
    trade_method = '택배 및 직거래 가능',
    payment_location = '37.566588, 126.978169',
    description = '가격 인하합니다.',
    book_image = 'https://image.yes24.com/goods/71736690/XL'
WHERE id = '1';
-- -------------------------

# 판매 상태 변경
UPDATE poduct
SET product_status = "Deleted"
WHERE id = '3';

UPDATE poduct
SET product_status = "Reserved"
WHERE id = '3';

UPDATE poduct
SET product_status = "Sold Out"
WHERE id = '3';

-- -------------------------------
# 판매 게시글 조회 (=검색) - 판매자 정보 PRODUCT_05
-- 선택한 판매자의 닉네임과 점수(등급으로 계산될 점수!)르 가져온다.
SELECT nickname, score FROM member
WHERE id = 1;

-- 선택한 판매자의 판매목록을 보여준다.
SELECT p.id, book.title, p.book_condition, p.price, p.product_status
FROM product AS p
LEFT JOIN member ON p.member_id = member.id
INNER JOIN book on p.book_id = book.id
WHERE member.id = 1 AND product_status NOT LIKE 'Deleted';
-- ---------------------------------
# 판매 게시글 조회 (=검색) - 도서 검색 PRODUCT_06
SELECT book.title, book.author, book.publisher, book.publication_date, product.book_condition, product.price, product.product_status
FROM product
LEFT JOIN book ON product.book_id = book.id
WHERE product.product_status not like 'Deleted';

SELECT book.title, book.author, book.publisher, book.publication_date, product.book_condition, product.price, product.product_status
FROM product
LEFT JOIN book ON product.book_id = book.id
WHERE product.product_status like 'For Sale';