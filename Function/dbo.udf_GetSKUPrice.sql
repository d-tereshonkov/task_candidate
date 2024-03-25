-- Создать функцию dbo.udf_GetSKUPrice
create function dbo.udf_GetSKUPrice(
   -- Входной параметр @ID_SKU
   IdSku int
)
-- На выходе значение типа decimal(18, 2)	
returns decimal(18, 2)

begin
    declare SkuPrice DECIMAL(18, 2);

    /*
    Рассчитаем стоимость передаваемого продукта из таблицы dbo.Basket по формуле
    сумма Value по переданному SKU / сумма Quantity по переданному SKU
    */
    select sum(Value / Quantity) as price
    into SKUPrice
    from dbo.Basket
    where ID_SKU = IdSku;
    
    return SKUPrice;
end
