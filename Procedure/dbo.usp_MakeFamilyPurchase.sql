/*
Создать процедуру dbo.usp_MakeFamilyPurchase:
	- Входной параметр (@FamilySurName varchar(255)) одно из значений атрибута SurName таблицы dbo.Family
	- Процедура при вызове обновляет данные в таблицы dbo.Family в поле BudgetValue по логике
	  dbo.Family.BudgetValue - sum(dbo.Basket.Value), где dbo.Basket.Value покупки для переданной в процедуру семьи
	- При передаче несуществующего dbo.Family.SurName пользователю выдается ошибка, что такой семьи нет

*/
-- Создадим процедуру, которая рассчитает и обновит бюджет семьи
create procedure dbo.usp_MakeFamilyPurchase(
in FamilySurName varchar(100)
)
begin	
	-- Задаем переменные в которые будем помещать значения
	declare family_id int;
	declare	total_basket_value decimal(18, 2);
    
   	-- Находим ID семьи по фамилии
    select ID 
    into family_id
    from dbo.Family
    where SurName = FamilySurName;
    
    -- Проверяем, существует ли такая семья
    if family_id is null then
       signal sqlstate '45000' 
       set message_text = 'Такой семьи нет';
    else
        -- Общая стоимость покупок для семьи
        select sum(Value)
        into total_basket_value
        from dbo.Basket
        where ID_Family = family_id;
        
        -- Обновляем бюджет семьи
        update dbo.Family
        set BudgetValue = BudgetValue - total_basket_value
        where ID = family_id;

    end if;
end
