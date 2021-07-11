USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSupd_glchart_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_glchart_base] 
 @c1 binary(8),@c2 varchar(32),@c3 varchar(40),@c4 smallint,@c5 smallint,@c6 varchar(32),@c7 varchar(32),@c8 varchar(32),@c9 varchar(32),@c10 smallint,@c11 smallint,@c12 int,@c13 int,@c14 smallint,@c15 varchar(8),@c16 smallint,@c17 varchar(8),@c18 varchar(8),@pkc1 varchar(32)
,@bitmap binary(3)
as
if substring(@bitmap,1,1) & 2 = 2
begin
update "glchart_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"account_code" = case substring(@bitmap,1,1) & 2 when 2 then @c2 else "account_code" end
,"account_description" = case substring(@bitmap,1,1) & 4 when 4 then @c3 else "account_description" end
,"account_type" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "account_type" end
,"new_flag" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "new_flag" end
,"seg1_code" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "seg1_code" end
,"seg2_code" = case substring(@bitmap,1,1) & 64 when 64 then @c7 else "seg2_code" end
,"seg3_code" = case substring(@bitmap,1,1) & 128 when 128 then @c8 else "seg3_code" end
,"seg4_code" = case substring(@bitmap,2,1) & 1 when 1 then @c9 else "seg4_code" end
,"consol_detail_flag" = case substring(@bitmap,2,1) & 2 when 2 then @c10 else "consol_detail_flag" end
,"consol_type" = case substring(@bitmap,2,1) & 4 when 4 then @c11 else "consol_type" end
,"active_date" = case substring(@bitmap,2,1) & 8 when 8 then @c12 else "active_date" end
,"inactive_date" = case substring(@bitmap,2,1) & 16 when 16 then @c13 else "inactive_date" end
,"inactive_flag" = case substring(@bitmap,2,1) & 32 when 32 then @c14 else "inactive_flag" end
,"currency_code" = case substring(@bitmap,2,1) & 64 when 64 then @c15 else "currency_code" end
,"revaluate_flag" = case substring(@bitmap,2,1) & 128 when 128 then @c16 else "revaluate_flag" end
,"rate_type_home" = case substring(@bitmap,3,1) & 1 when 1 then @c17 else "rate_type_home" end
,"rate_type_oper" = case substring(@bitmap,3,1) & 2 when 2 then @c18 else "rate_type_oper" end
where "account_code" = @pkc1
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
else
begin
update "glchart_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"account_description" = case substring(@bitmap,1,1) & 4 when 4 then @c3 else "account_description" end
,"account_type" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "account_type" end
,"new_flag" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "new_flag" end
,"seg1_code" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "seg1_code" end
,"seg2_code" = case substring(@bitmap,1,1) & 64 when 64 then @c7 else "seg2_code" end
,"seg3_code" = case substring(@bitmap,1,1) & 128 when 128 then @c8 else "seg3_code" end
,"seg4_code" = case substring(@bitmap,2,1) & 1 when 1 then @c9 else "seg4_code" end
,"consol_detail_flag" = case substring(@bitmap,2,1) & 2 when 2 then @c10 else "consol_detail_flag" end
,"consol_type" = case substring(@bitmap,2,1) & 4 when 4 then @c11 else "consol_type" end
,"active_date" = case substring(@bitmap,2,1) & 8 when 8 then @c12 else "active_date" end
,"inactive_date" = case substring(@bitmap,2,1) & 16 when 16 then @c13 else "inactive_date" end
,"inactive_flag" = case substring(@bitmap,2,1) & 32 when 32 then @c14 else "inactive_flag" end
,"currency_code" = case substring(@bitmap,2,1) & 64 when 64 then @c15 else "currency_code" end
,"revaluate_flag" = case substring(@bitmap,2,1) & 128 when 128 then @c16 else "revaluate_flag" end
,"rate_type_home" = case substring(@bitmap,3,1) & 1 when 1 then @c17 else "rate_type_home" end
,"rate_type_oper" = case substring(@bitmap,3,1) & 2 when 2 then @c18 else "rate_type_oper" end
where "account_code" = @pkc1
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
GO
