/*
Создать представление dbo.vw_SKUPrice:
	- Возвращает все атрибуты продуктов из таблицы dbo.SKU 
      и расчетный атрибут со стоимостью одного продукта (используя функцию dbo.udf_GetSKUPrice)
*/
create view dbo.vw_SKUPrice
as
select 
	ID
	,Code
	,Name
	,udf_GetSKUPrice(ID) as price
from dbo.SKU
