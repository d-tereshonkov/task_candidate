/*
Создать таблицу dbo.SKU (ID identity, Code, Name):
	- Ограничение на уникальность поля Code
	- Поле Code вычисляемое: "s" + ID
*/
create table dbo.SKU (
     -- При создании объекта, запятые ставятся в конце строк
     ID int not null auto_increment,
     Code varchar(100),
     Name varchar(100),
     constraint PK_SKU primary key (ID)
);
alter table dbo.SKU add constraint UK_SKU_Code unique (Code);

/*
Ввиду того, что в mysql нельзя использовать вычислительные поля при создании таблицы, 
то воспользуемся тирггером
*/
create trigger dbo.tr_Code_insert before insert on SKU
for each row
begin
    set new.Code = concat('s', new.ID);
end;

-- Добавим строки в таблицу
insert into dbo.SKU (ID, Code, Name)
values 
  (6, 'Ivanov', 'Ivanov Ivan Ivanovich')
  ,(7, 'Petrov', 'Petrov Petr Petrovich')
  ,(8, 'Sidorov', 'Sidorov Sidr Sidorovich')
  ,(9, 'Semenov', 'Semenov Semen Semenovich')
  ,(10, 'Petrov', 'Petrov Petr Petrovich');
  
-- Создать таблицу dbo.Family (ID identity, SurName, BudgetValue):
create table dbo.Family (
	ID int not null auto_increment,
	SurName varchar(100),
	BudgetValue decimal(12, 2),
	constraint PK_Family primary key (ID)
);

-- Добавим строки
insert into dbo.family (ID, SurName, BudgetValue)
values
  (6, 'Ivanov', 1000)
  ,(7, 'Petrov', 12000)
  ,(8, 'Sidorov', 5000)
  ,(9, 'Semenov', 8000)
  ,(10, 'Petrov', 7500);
 
 /*
Создать таблицу dbo.Basket (ID identity, ID_SKU (внешний ключ на таблицу dbo.SKU), 
							ID_Family (Внешний ключ на таблицу dbo.Family) Quantity, 
                            Value, PurchaseDate, DiscountValue):
	- Ограничение, что поле Quantity и Value не могут быть меньше 0
	- Добавить значение по умолчанию для поля PurchaseDate: дата добавления записи (текущая дата)
*/
create table dbo.Basket (
	ID int not null auto_increment,
	ID_SKU int,
	ID_Family int,
	Quantity int CHECK (Quantity >= 0), 
	Value decimal(18, 2) check (Value >= 0), 
	PurchaseDate timestamp default current_timestamp,
	DiscountValue decimal(18, 2),
	constraint PK_Basket primary key (ID)
);
alter table dbo.Basket add constraint FK_Basket_ID_SKU_SKU foreign key (ID_SKU) references dbo.SKU(ID);
alter table dbo.Basket add constraint FK_Basket_ID_Family_SKU foreign key (ID_Family) references dbo.Family(ID);

-- Добавим строки
insert into dbo.basket (ID, ID_SKU, ID_Family, Quantity, Value, DiscountValue)
values
  (6, 6, 6, 3, 100, 10)
  ,(7, 7, 7, 0, 200, 10)
  ,(8, 8, 8, 1, 300, 25)
  ,(9, 9, 9, 2, 400, 25)
  ,(10, 10, 10, 1, 100, 10);
