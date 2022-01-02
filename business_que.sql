use tradedata;

/* find the name of the agents who are from new york*/
select *
from agents
where office_location like '%MA';

/* calculate the amount of perishable and nonperishable goods*/
select good_type,count(*) as amount
from goods
group by good_type;

/* retrive the purchase details, count total amount without tax, agent and good names from the database*/
select 
	p.purchase_id,
    g.good_name,
    p.quantity_in_tons,
    g.price_in$_perTons*p.quantity_in_tons AS Total_Price,
    p.buy_date,
    d.dis_name,
    a.agent_name
from purchase_good p
join agents a
	ON p.agent_id=a.certification_no
join goods g
	ON p.good_code=g.good_code
join distributer d
	ON p.dis_id=d.Id;
    
    
    /*Retrieve the 10 distributers name and thier agents name who purchased goods with a tax higher than 5*/
Select 
	d.dis_name,
    a.agent_name,
    g.good_name,
    p.tax_perTons AS Tax
from purchase_good p
join distributer d 
	ON p.dis_id=d.Id
join agents a
	ON p.agent_id=a.certification_no
join goods g
	ON p.good_code=g.good_code
Where p.tax_perTons >5 
Order by p.tax_perTons desc
Limit 10;

/* company want to give reminder those manufacturer whose contract with their agent will be end with in 15 months. 
So, they wants to view all the details of manufacurer and their agents as well as contract details.*/

create view reminder AS
select a.agent_name,m.man_name,
		c.start_date,
        c.end_date,ceiling(datediff(c.end_date, curdate())/30) as duration_in_months,
        c.commition_in_per
from contract c
join agents a ON a.certification_no=c.certification_no
join manufacturer m ON m.Id=c.man_id
where datediff(c.end_date, curdate()) < 460 ;
	
    
/* company wants to send notice to those agents who take more than 25% commition from their manufacturer.*/
create view notice as
select * from agents
where certification_no In (
						select distinct certification_no 
                        from contract
                        where commition_in_per>25);
                        
 
 /* Management wants to chech the stock of goods and status. make a proceddure for this quetion.*/
 DELIMITER $$

CREATE PROCEDURE GetGoodStock(
)
BEGIN
    create temporary table stocks
    select quantity_in_tons as quantity, IF(quantity_in_tons<50,'Out of stock','Stock Available') AS Stock 
	from goods;
    SELECT * FROM stocks;    
END$$

DELIMITER ;

CALL GetGoodStock()

 
