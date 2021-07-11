USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSupd_bgt_armaster_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_bgt_armaster_base] 
 @c1 binary(8),@c2 varchar(12),@c3 varchar(12),@c4 smallint,@c5 smallint,@c6 smallint,@pkc1 varchar(12),@pkc2 varchar(12),@pkc3 smallint
,@bitmap binary(1)
as
if substring(@bitmap,1,1) & 2 = 2 or substring(@bitmap,1,1) & 4 = 4 or substring(@bitmap,1,1) & 8 = 8
begin
update "bgt_armaster_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"customer_code" = case substring(@bitmap,1,1) & 2 when 2 then @c2 else "customer_code" end
,"ship_to_code" = case substring(@bitmap,1,1) & 4 when 4 then @c3 else "ship_to_code" end
,"address_type" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "address_type" end
,"po_num_reqd_flag" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "po_num_reqd_flag" end
,"claim_num_reqd_flag" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "claim_num_reqd_flag" end
where "customer_code" = @pkc1 and "ship_to_code" = @pkc2 and "address_type" = @pkc3
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
else
begin
update "bgt_armaster_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"po_num_reqd_flag" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "po_num_reqd_flag" end
,"claim_num_reqd_flag" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "claim_num_reqd_flag" end
where "customer_code" = @pkc1 and "ship_to_code" = @pkc2 and "address_type" = @pkc3
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
GO
