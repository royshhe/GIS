USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLookupTableDataByCategory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLookupTableDataByCategory] --'Reservation Standard Comment'
@Category varchar(30)
AS
Set Rowcount 2000

if @Category='Reservation Standard Comment' 
	begin
		Select 'Reservation Standard Comment' as Category ,Reservation_Comment_ID as Code, Reservation_Comment as Value, '' as Alias,
				'True' as Editable, 'True'	 as Deletable		
		--select *					
		From
			Reservation_Standard_Comment
		Order By Reservation_Comment_ID
	end
else
	begin
		Select Category,Code, Value, Alias,
				(case when Editable=1 
						then 'True'
						else 'False'
				end)	 as Editable,	
				case when editable=1 and category like 'Charge Type %'
						then 'False'
					 when editable=1 and category not like 'Charge Type %'
						then 'True'
					 else 'False'	
				end as Deletable		
		--select *					
		From
			Lookup_Table
		Where
			Category=@Category
		Order By right(REPLICATE('0', 25)+rtrim(ltrim(Code)),5),Value
	end	
Return 1
GO
