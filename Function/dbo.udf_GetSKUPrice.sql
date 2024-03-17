/*
Создать функцию dbo.udf_GetSKUPrice:
	- Входной параметр @ID_SKU
	- Рассчитывает стоимость передаваемого продукта из таблицы dbo.Basket по формуле
	  сумма Value по переданному SKU / сумма Quantity по переданному SKU
	- На выходе значение типа decimal(18, 2)
*/
create function dbo.udf_GetSKUPrice(
   ID_SKU int
)
returns decimal(18, 2)

begin
	declare sku_price DECIMAL(18, 2);

    select sum(Value / Quantity) as price
    into sku_price
    from dbo.Basket
    where ID_SKU = ID_SKU;
    
    return sku_price;
end
