/*
Создадим процедуру, которая рассчитает и обновит бюджет семьи
Процедура при вызове обновляет данные в таблицы dbo.Family в поле BudgetValue по логике
dbo.Family.BudgetValue - sum(dbo.Basket.Value), где dbo.Basket.Value покупки для переданной в процедуру семьи
*/
create procedure dbo.usp_MakeFamilyPurchase(
-- Входной параметр (@FamilySurName varchar(255)) одно из значений атрибута SurName таблицы dbo.Family
in FamilySurName varchar(100)
)
begin	
    -- Задаем переменные в которые будем помещать значения
    declare FamilyId int;
    declare TotalBasketValue decimal(18, 2);
    
    -- Находим ID семьи по фамилии
    select ID 
    into FamilyId
    from dbo.Family
    where SurName = FamilySurName;
    
    /* 
    Проверяем, существует ли такая семья
    При передаче несуществующего dbo.Family.SurName пользователю выдается ошибка, что такой семьи нет
    */
    if FamilyId is null then
        signal sqlstate '45000' 
        set message_text = 'Такой семьи нет';
    else
        -- Общая стоимость покупок для семьи
        select sum(Value)
        into TotalBasketValue
        from dbo.Basket
        where ID_Family = FamilyId;
        
        -- Обновляем бюджет семьи
        update dbo.Family
        set BudgetValue = BudgetValue - TotalBasketValue
        where ID = FamilyId;
    end if;
end
