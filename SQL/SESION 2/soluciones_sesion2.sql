--1. Obtener la lista de precios de los libros que están disponibles en la tienda. Columnas a mostrar
--en la consulta: ISBN, book_title, year, sale_price.
SELECT isbn,title,year,sale_price
FROM book;

/*2.Obtenerla lista de pedidos y los clientes que los han solicitado. Columnas a mostrar en la
consulta: order_Id, order_date, customer_Id, customer_name.*/
select order_Id, order_date, customer.customer_Id, name
from orderr join customer on orderr.customer_id=customer.customer_id;

/*3. Obtener la lista de clientes cuyo nombre contenga ‘Jo’ y los libros que ha comprado. Columnas
a mostrar en la consulta: customer_Id, customer_name, book_title.*/
select customer.customer_Id, customer.name, book.title
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where customer.name like 'Jo%'
;

/*4. Obtener los clientes que han comprado al menos un libro con un precio mayor a 10€. Columnas
a mostrar en la consulta: customer_Id, customer_name.*/
select distinct customer.customer_Id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where book.sale_price>10
order by customer.customer_id  
;

/*5. Obtener los clientes y las fechas de los pedidos que todavía no han sido entregados. Columnas a
mostrar en la consulta: customer_Id, customer_name, order_Id, order_date.*/
select customer.customer_Id, customer.name, orderr.order_id, orderr.order_date
from orderr join customer on orderr.customer_id=customer.customer_id  
where orderr.shipping_date  is NULL
order by customer.customer_id  
;

/*6. Obtener los clientes que no han realizado ningún pedido. Columnas a mostrar en la consulta:
customer_Id, customer_name.*/
select distinct customer.customer_id, customer.name
from customer
minus
select distinct customer.customer_id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id;

/*7. Obtener los clientes que solamente han comprado libros de menos de 20€. Columnas a mostrar
en la consulta: customer_Id, customer_name.*/
select distinct customer.customer_Id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where book.sale_price<20
MINUS
select distinct customer.customer_Id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where book.sale_price>=20
;
/*8. Obtener los libros que cuestan más de 30€ o que han vendido más de 5 copias en un mismo
pedido. Columnas a mostrar en la consulta: ISBN, book_title, sale_price.*/
SELECT book.isbn,title,year,sale_price
FROM book
where book.sale_price>30
union
SELECT book.isbn,title,year,sale_price
FROM book join book_order on book.isbn=book_order.isbn 
where book_order.quantity>5
;

/*9. Obtener los clientes que han realizado más de un pedido en la misma fecha. Columnas a mostrar
en la consulta: customer_Id, customer_name, order_date.*/
select DISTINCT C.customer_Id, name, order_date
from orderr R join customer C on R.customer_id=C.customer_id
WHERE c.customer_id IN (select customer.customer_id
from orderr join customer on orderr.customer_id=customer.customer_id
group by customer.customer_id, orderr.order_date
having count(*)>1)
;

/*10. Obtener los clientes que han comprado los libros ‘Dracula’ o ‘1984’. Columnas a mostrar en la
consulta: customer_Id, customer_name.*/
select distinct customer.customer_Id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where book.title='Dracula' or book.title='1984';

/*11. Obtener los clientes que han comprado tanto el libro ‘Pride and Prejudice’ y ‘The Little Prince’.
Columnas a mostrar en la consulta: customer_Id, customer_name.*/
select distinct customer.customer_Id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where book.title='Pride and Prejudice' 
INTERSECT
select distinct customer.customer_Id, customer.name
from orderr join customer on orderr.customer_id=customer.customer_id  
            join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
where book.title='The Little Prince';
/*12. Obtener los clientes y los libros que han proporcionado un beneficio de al menos 50€ en un
mismo pedido (es decir, la compra de un libro en particular, en un mismo pedido, ha
proporcionado un beneficio de al menos 50€, por lo que habrá que tener en cuenta el número de
copias de ese libro que se han solicitado en el pedido). El beneficio se calcula como la diferencia
entre el precio de venta al público (sale_price) y el precio de adquisición por parte del editor
(purchase_price). Columnas a mostrar en la consulta: customer_Id, book_title, profit.*/
select orderr.order_id,customer_Id, title, (sale_price-purchase_price)*quantity as profit
from orderr join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn;
select sum((sale_price-purchase_price)*quantity )as profit
from orderr join book_order on orderr.order_id=book_order.order_id 
            join book on book_order.isbn=book.isbn
order by orderr.order_id;            


