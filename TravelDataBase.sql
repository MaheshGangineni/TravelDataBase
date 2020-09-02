create database dbTravel;
use dbTravel;

create table tblTravelAgent
(
Id varchar(100) not null,
Agent_Name varchar(100),
Phone_Number varchar(100),
Date_Of_Registration date,
User_Rating int
);


alter table tblTravelAgent add constraint AgentId_PK primary key(Id);

create table tblCustomer
(
Id int not null,
tblCustomer_Name varchar(100),
Email_Id varchar(100),
Phone_Number varchar(100),
Date_Of_Birth date,
tblCustomer_Address varchar(100)
);

alter table tblCustomer add constraint tblCustomerId_PK primary key(Id);


create table tblBookingDetails
(
Booking_Id varchar(100) not null,
tblCustomer_Id int not null,
Agent_Id varchar(100),
From_Station varchar(100),
To_Station varchar(100),
Journey_Date date,
Ticket_Cost float
);

alter table tblBookingDetails add constraint BookingId_PK primary key(Booking_Id);


alter table tblBookingDetails add
constraint AgentId_FK foreign key(Agent_Id) references tblTravelAgent(Id) 
on delete cascade on update cascade;

alter table tblBookingDetails add
constraint tblCustomerId_FK foreign key(tblCustomer_Id) references tblCustomer(Id) 
on delete cascade on update cascade;


insert into tblTravelAgent values
('A1001','GO IBIBO','033-6450001','2015-03-10',7),
('A1002','IRCTC','033-6450015','2017-08-20',4),
('A1003  ','Decaan Travels','033-6450018','2015-09-15',5);

insert into tblCustomer values
(5001,'samuel gomes','sam@gmail.com','9600197788','1990-05-10','12E-Kolkata-700001'),
(5002,'peter disuza','peter@yahoo.in','9600197789','1996-02-22','New Town-Kolkata-700032'),
(5003,'adhiraj pandey','adhiraj@gmail.com','9600197788','1992-05-18','Lal Path-Delhi-110002'),
(5004,'sneha agarwal','sneha@gmail.com',null,'1996-03-19','APC College-Kolkata-700022'),
(5005,'chinmoy dey','chinmoy@yahoo.in','9600197788','1990-09-25','Gandhi Nagar-Delhi-110005');


insert into tblBookingDetails values
(' TR7001',5001,'A1002','kolkata','delhi','2018-01-13',5000),
('AR7002',5002,'A1002','pune','bangalore','2018-01-13',8000),
('TR7003',5001,'A1001','delhi','kolkata','2018-01-25',5000),
(' AR7004',5003,null,'kolkata','bhubaneswar','2018-02-05',1200),
('TR7005',5001,'A1001','kolkata','bhubaneswar','2018-02-10',1200),
('TR7006',5005,'A1003','pune','mumbai','2018-02-15',1800),
('AR7007',5002,null,'delhi','chennai','2018-02-17',9000);


--uspInsertAgentRecordProc

create procedure uspInsertAgentRecordProc (@id varchar(100),@name varchar(100),@phone varchar(100),@registrationDate date,@rating int)
as
begin
insert into tblTravelAgent values(@id,@name,@phone,@registrationDate,@rating)
end;

exec uspInsertAgentRecordProc 12453,'Mahesh',7674865209,'2020-09-02',5;

--select * from tblTravelAgent;

--uspUpdatetblCustomerRecordProc

create procedure uspUpdatetblCustomerRecordProc (@email varchar(100),@phone varchar(100),@id int)
as
begin
if exists(select * from  tblCustomer where Id=@id)
update tblCustomer set Email_Id=@email,Phone_Number=@phone where Id=@id
end;

exec uspUpdatetblCustomerRecordProc 'sam143@gmail.com',7894561237,5001;

--select * from tblCustomer;




--uspDeleteBookingDetailsProc

create procedure uspDeleteBookingDetailsProc(@bookingId varchar(100))
as
begin 
if exists(select * from tblBookingDetails where Booking_Id=@bookingId)
delete from tblBookingDetails where Booking_Id=@bookingId
end;

exec uspDeleteBookingDetailsProc 'AR7007';

--select * from tblBookingDetails;



--uspBookedSelfTicketProc

create procedure uspBookedSelfTicketProc
as
begin 
select c.Id,c.tblCustomer_Name,c.tblCustomer_Address,c.Date_Of_Birth,c.Email_Id,coalesce(c.Phone_Number,'Phone not found') as Phone_Number from tblCustomer c inner join tblBookingDetails b
on c.Id=b.tblCustomer_Id
where b.Agent_Id is NULL and DateName(month,b.Journey_Date)='February'
order by c.tblCustomer_Name asc,year(c.Date_Of_Birth) desc
end;

exec uspBookedSelfTicketProc;



--fnDisplayTravelFunc


create function fnDisplayTravelFunc(@from varchar(100),@destination varchar(100))
returns table
as
return(select b.Agent_Id,a.Agent_Name,c.tblCustomer_Name,c.Email_Id,b.Booking_Id,b.Ticket_Cost 
from tblCustomer c inner join tblBookingDetails b
on c.Id=b.tblCustomer_Id
inner join tblTravelAgent a
on b.Agent_Id=a.Id
where b.From_Station=@from and
b.To_Station=@destination);

select * from fnDisplayTravelFunc('kolkata','delhi');
