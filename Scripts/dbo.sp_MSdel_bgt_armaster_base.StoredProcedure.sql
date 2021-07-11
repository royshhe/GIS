USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSdel_bgt_armaster_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSdel_bgt_armaster_base] @pkc1 varchar(12),@pkc2 varchar(12),@pkc3 smallint
as
delete "bgt_armaster_base"
where "customer_code" = @pkc1 and "ship_to_code" = @pkc2 and "address_type" = @pkc3
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
GO
