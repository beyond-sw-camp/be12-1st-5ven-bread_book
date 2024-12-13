# 내 거래 정보 확인(pay_002)
select orders.amount, book.title, book.id as book_id, product.member_id, 
orders.created_at, order_status, payment.payment_type from orders
left join product on product.id=orders.id
left join book on book.id=product.id
left join payment on product.id=payment.id
where orders.member_id=19;

# 결제(pay_003)
insert into orders (member_id,product_id,amount,order_status,steert_address,detail_address)
value (53849,50593,6075,'거래중','street 656','Detail 55');
insert into payment (product_id,order_id,payment_type ,amount)
value (50593,1,'kakao',6075);


# 거래완료(pay_004)
update product set product_status='Sold Out' where product.id=50593;
update orders set order_status='거래 완료' where orders.id=1;