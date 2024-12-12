# 내 거래 정보 확인(pay_002)
select orders.amount, book.title, book.id as book_id, product.member_id, orders.created_at from orders
left join product on product.id=orders.id
left join book on book.id=product.id
where orders.id=1;

select orders.amount, book.title, book.id as book_id, product.member_id, orders.created_at from orders
left join product on product.id=orders.id
left join book on book.id=product.id
where orders.member_id=19;

# 결제(pay_003)
insert into payment 
(product_id,order_id,quantity,street_address,detail_address,amount) 
values(50593,1,2,'street 656','Detail 55',6075);

# 거래완료(pay_004)
update product set product_status='Sold Out' where product.id=1;