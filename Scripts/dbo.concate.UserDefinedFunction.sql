USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[concate]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[concate] (@fileno varchar(18))
returns nvarchar(1000)
as
begin
declare @concat nvarchar(1000)
select @concat=coalesce(@concat,'')+remark+'\' from svbvm007.cars.dbo.BillingRemarks where File_No =@fileno
select @concat = substring(@concat,1,len(@concat)-1)
return (@concat)
end
GO
