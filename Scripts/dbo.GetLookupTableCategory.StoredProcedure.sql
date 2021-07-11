USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLookupTableCategory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetLookupTableCategory]
AS
select * from (
	select top 1 '[Select]' as category,convert(bit,0) as Editable --from lookup_table
	union
	select distinct Category , 
			case when Category like 'Charge Type%' 
					then convert(bit,0)
					else convert(bit,1)
				end as 	Editable 
		--Editable 
	from lookup_table
	where editable=1
	union
	select  'Reservation Standard Comment',convert(bit,1) as Editable ) aa
	order by Category
GO
