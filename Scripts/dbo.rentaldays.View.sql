USE [GISData]
GO
/****** Object:  View [dbo].[rentaldays]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create view [dbo].[rentaldays] as
select contract_number,
       days=datediff(dayofyear,min(checked_out),max(actual_check_in))
       from vehicle_on_contract
       group by contract_number

GO
