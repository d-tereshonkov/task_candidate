/* 
Создать триггер dbo.TR_Basket_insert_update:
	- Если в таблицу dbo.Basket за раз добавляются 2 и более записей одного ID_SKU, 
      то значение в поле DiscountValue, для этого ID_SKU рассчитывается по формуле Value * 5%, 
      иначе DiscountValue = 0
*/
-- Создадим триггер, который сработает после вставки данных и пройдет итерацией по каждой строке
create trigger dbo.TR_Basket_insert_update before insert on dbo.Basket 
for each row
begin
    declare sku_count int;
    declare sku_value decimal(18, 2);
    
    -- Найдем кол-во добавленных записей одного ID_SKU
    select count(*) 
    into sku_count
    from dbo.Basket
    -- Условие сравнения идентификаторов старых, с вновь добавленными
    where ID_SKU = new.ID_SKU; 
    
    -- Возьмем значение для расчета скидки
    select Value into sku_value
    from dbo.Basket
    where ID_SKU = new.ID_SKU
    limit 1;
    
    -- Определим какая скидка будет
    if sku_count >= 2 then
        set new.DiscountValue = sku_value * 0.05;
    else
        set new.DiscountValue = 0;
    end if;
end
