USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSdel_aractcus_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSdel_aractcus_base] @pkc1 varchar(12)
as
delete "aractcus_base"
where "customer_code" = @pkc1
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
GO
