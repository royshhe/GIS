USE [GISData]
GO
/****** Object:  View [dbo].[Local_Rental_Location_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  VIEW [dbo].[Local_Rental_Location_vw]
AS
Select * From Location

WHERE (Owning_Company_ID in (select  code from lookup_table where category='BudgetBC Company')) AND delete_Flag <> 1 And    Rental_location = 1
GO
