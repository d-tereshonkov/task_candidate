-- Создадим триггер, который сработает после вставки данных и пройдет итерацией по каждой строке
create trigger dbo.tr_Basket_insert_update before insert on dbo.Basket 
for each row
begin
    declare SkuCount int;
    declare SkuValue decimal(18, 2);
    
    -- Найдем кол-во добавленных записей одного ID_SKU
    select count(*) 
    into SkuCount
    from dbo.Basket
    -- Условие сравнения идентификаторов старых, с вновь добавленными
    where ID_SKU = new.ID_SKU; 
    
    -- Возьмем значение для расчета скидки
    select Value into SkuValue
    from dbo.Basket
    where ID_SKU = new.ID_SKU
    limit 1;
    
    /* Определим какая скидка будет
       Если в таблицу dbo.Basket за раз добавляются 2 и более записей одного ID_SKU, 
       то значение в поле DiscountValue, для этого ID_SKU рассчитывается по формуле Value * 5%, 
       иначе DiscountValue = 0
    */
    if SkuCount >= 2 then
        set new.DiscountValue = SkuValue * 0.05;
    else
        set new.DiscountValue = 0;
    end if;
end
