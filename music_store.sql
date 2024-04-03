--Who is senior most employee based on job title
select top 1 * 
from employee
order by levels  desc

-- Which countries has most Invoices
select billing_country, count(*) as invoice_per_country 
from invoice
group by billing_country
order by invoice_per_country desc

--Which city made most money
select top 1 billing_city, sum(total) as total_invoice
from invoice
group by billing_city
order by total_invoice desc

 --Which customer spent most money
select c.customer_id, c.first_name, c.last_name, sum(i.total) as total_invoice
from customer c
join invoice i
on c.customer_id=i.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_invoice desc

 --List of Rock music listeners ordered alphabetically by email
 select distinct c.last_name, c.first_name, c.email
 from customer c
 join invoice i
 on c.customer_id=i.customer_id
 join invoice_line il
 on i.invoice_id=il.invoice_id
 where track_id in(
	select track_id 
	from track t
	join genre g
	on t.genre_id=g.genre_id
	where g.name like 'Rock'
	)
 order by email 

 -- Top ten Rock artists
 select top 10 a.name, count(a.artist_id) as track_count
 from artist a 
 join album al
 on a.artist_id=al.artist_id
 join track t
 on al.album_id=t.album_id
 where track_id in(
	select track_id
	from track t
	join genre g
	on t.genre_id=g.genre_id
	where g.name like 'Rock'
	)
group by a.name
order by track_count desc

--Checking the tracks that has song length more than the average song length
 select * 
 from track
 where milliseconds>(select avg(milliseconds) from track)
 order by milliseconds desc

 --Who is best selling artist
 select top 1 ar.name, sum(il.unit_price*il.quantity) as total
 from invoice_line il
 join track t
 on il.track_id=t.track_id
 join album al
 on t.album_id=al.album_id
 join artist ar
 on al.artist_id=ar.artist_id
 group by ar.name
 order by total desc
 
 --How much money each each customer has spent on particular artist
 select c.first_name, c.last_name, a.name, sum(il.unit_price*il.quantity) as total
 from customer c
 join invoice i
 on c.customer_id=i.invoice_id
 join invoice_line il
 on i.invoice_id=il.invoice_id
 join track t
 on il.track_id=t.track_id
 join album al
 on t.album_id=al.album_id
 join artist ar
 on al.artist_id=ar.artist_id
 group by c.first_name, c.last_name, a.name
 order by total desc

 --Best selling genre 
 select top 1 g.name,sum(il.unit_price*il.quantity) as total
 from invoice_line il
 join track t
 on il.track_id=t.track_id
 join genre g
 on t.genre_id=g.genre_id
 group by g.name
 order by total desc

 --Best selling genre by each country
 with cte as(
 select i.billing_country,g.name, sum(il.unit_price*il.quantity) as total,
 row_number() over(partition by i.billing_country order by i.billing_country, sum(il.unit_price*il.quantity) desc) as rn
 from invoice i
 join invoice_line il
 on i.invoice_id=il.invoice_id
 join track t
 on il.track_id=t.track_id
 join genre g
 on t.genre_id=g.genre_id
 group by i.billing_country, g.name
 ) 
 select * 
 from cte 
 where rn=1

 --Customers who has spent most money by each country
 with cte as(
select c.first_name,c.last_name, i.billing_country,sum(il.unit_price*il.quantity) as total,
rank() over(partition by i.billing_country order by sum(il.unit_price*il.quantity) desc) as rnk
 from customer c
 join invoice i
 on c.customer_id=i.customer_id
 join invoice_line il
 on i.invoice_id=il.invoice_id
 group by c.first_name,c.last_name,i.billing_country
 )
 select * 
 from cte
 where rnk=1
