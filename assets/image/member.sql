# 회원가입(USER_SIGNUP_001)
insert into member (userid,username,email,
nickname,password,birth_date,gender) 
values("woo975",'최원익',"dyd975@naver.com",
"버스탈게요","qwer1234",'1997-11-11','male');

# 회원정보 수정(USER-UPDATE-01)
update member set gender="female" where id=2;

# 회원정보 수정 접근 보안 보안을 위한 비밀번호 확인 로직(USER-UPDATE-02)
select * from member where userid="woo975" and password="qwer1234";

# 비밀번호 변경(USER-UPDATE-03)
update member set password="1111" where id=2;

# 정보 수정 보안(USER-UPDATE-04)
select * from member where userid="woo975" and password="1111";

# email인증으로 아이디 찾기(USER-READ-01)
select userid from member where email="dyd975@naver.com";

# 비밀번호 재설정(USER-UPDATE-05)
update member set password="1111" where email="dyd975@naver.com"; -- id pk 값이나 userid 값으로 바꾸는 것이 더 나은지 확인해보기?

# 회원 탈퇴(USER-DELETE-01)
UPDATE member
SET is_deleted = TRUE, username="탈퇴한 사용자", 
    deleted_at = NOW()
WHERE id = 100005;

# 일반 로그인(USER-LOGIN-01)
select * from member where userid='woo975' and password='1111';

# 판매 게시글 관리(USER-POST-01)
select * from product 
left join member on member.id=product.member_id
where member.id=3;

# 거래내역 관리(USER-PAYMENT-01)
select orders.order_status, orders.created_at,orders.id,
orders.amount, book.title 
from orders
left join member on member.id= orders.member_id
left join product on product.id = orders.id
left join book on book.id = product.book_id
where member.id=2;