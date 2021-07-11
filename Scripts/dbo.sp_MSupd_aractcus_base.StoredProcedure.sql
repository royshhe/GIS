USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSupd_aractcus_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_aractcus_base] 
 @c1 binary(8),@c2 varchar(12),@c3 int,@c4 int,@c5 int,@c6 int,@c7 int,@c8 int,@c9 int,@c10 int,@c11 int,@c12 float,@c13 float,@c14 float,@c15 float,@c16 float,@c17 float,@c18 float,@c19 float,@c20 float,@c21 float,@c22 float,@c23 float,@c24 float,@c25 float,@c26 float,@c27 float,@c28 float,@c29 varchar(16),@c30 varchar(16),@c31 varchar(16),@c32 varchar(16),@c33 varchar(16),@c34 varchar(16),@c35 varchar(16),@c36 varchar(16),@c37 float,@c38 float,@c39 int,@c40 int,@c41 int,@c42 int,@c43 int,@c44 int,@c45 int,@c46 int,@c47 float,@c48 float,@c49 float,@c50 float,@c51 float,@c52 float,@c53 float,@c54 float,@c55 float,@c56 float,@c57 float,@c58 float,@c59 float,@c60 float,@c61 varchar(8),@c62 varchar(8),@c63 varchar(8),@c64 varchar(8),@c65 varchar(8),@c66 varchar(8),@c67 varchar(8),@c68 varchar(8),@c69 int,@pkc1 varchar(12)
,@bitmap binary(9)
as
if substring(@bitmap,1,1) & 2 = 2
begin
update "aractcus_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"customer_code" = case substring(@bitmap,1,1) & 2 when 2 then @c2 else "customer_code" end
,"date_last_inv" = case substring(@bitmap,1,1) & 4 when 4 then @c3 else "date_last_inv" end
,"date_last_cm" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "date_last_cm" end
,"date_last_adj" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "date_last_adj" end
,"date_last_wr_off" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "date_last_wr_off" end
,"date_last_pyt" = case substring(@bitmap,1,1) & 64 when 64 then @c7 else "date_last_pyt" end
,"date_last_nsf" = case substring(@bitmap,1,1) & 128 when 128 then @c8 else "date_last_nsf" end
,"date_last_fin_chg" = case substring(@bitmap,2,1) & 1 when 1 then @c9 else "date_last_fin_chg" end
,"date_last_late_chg" = case substring(@bitmap,2,1) & 2 when 2 then @c10 else "date_last_late_chg" end
,"date_last_comm" = case substring(@bitmap,2,1) & 4 when 4 then @c11 else "date_last_comm" end
,"amt_last_inv" = case substring(@bitmap,2,1) & 8 when 8 then @c12 else "amt_last_inv" end
,"amt_last_cm" = case substring(@bitmap,2,1) & 16 when 16 then @c13 else "amt_last_cm" end
,"amt_last_adj" = case substring(@bitmap,2,1) & 32 when 32 then @c14 else "amt_last_adj" end
,"amt_last_wr_off" = case substring(@bitmap,2,1) & 64 when 64 then @c15 else "amt_last_wr_off" end
,"amt_last_pyt" = case substring(@bitmap,2,1) & 128 when 128 then @c16 else "amt_last_pyt" end
,"amt_last_nsf" = case substring(@bitmap,3,1) & 1 when 1 then @c17 else "amt_last_nsf" end
,"amt_last_fin_chg" = case substring(@bitmap,3,1) & 2 when 2 then @c18 else "amt_last_fin_chg" end
,"amt_last_late_chg" = case substring(@bitmap,3,1) & 4 when 4 then @c19 else "amt_last_late_chg" end
,"amt_last_comm" = case substring(@bitmap,3,1) & 8 when 8 then @c20 else "amt_last_comm" end
,"amt_age_bracket1" = case substring(@bitmap,3,1) & 16 when 16 then @c21 else "amt_age_bracket1" end
,"amt_age_bracket2" = case substring(@bitmap,3,1) & 32 when 32 then @c22 else "amt_age_bracket2" end
,"amt_age_bracket3" = case substring(@bitmap,3,1) & 64 when 64 then @c23 else "amt_age_bracket3" end
,"amt_age_bracket4" = case substring(@bitmap,3,1) & 128 when 128 then @c24 else "amt_age_bracket4" end
,"amt_age_bracket5" = case substring(@bitmap,4,1) & 1 when 1 then @c25 else "amt_age_bracket5" end
,"amt_age_bracket6" = case substring(@bitmap,4,1) & 2 when 2 then @c26 else "amt_age_bracket6" end
,"amt_on_order" = case substring(@bitmap,4,1) & 4 when 4 then @c27 else "amt_on_order" end
,"amt_inv_unposted" = case substring(@bitmap,4,1) & 8 when 8 then @c28 else "amt_inv_unposted" end
,"last_inv_doc" = case substring(@bitmap,4,1) & 16 when 16 then @c29 else "last_inv_doc" end
,"last_cm_doc" = case substring(@bitmap,4,1) & 32 when 32 then @c30 else "last_cm_doc" end
,"last_adj_doc" = case substring(@bitmap,4,1) & 64 when 64 then @c31 else "last_adj_doc" end
,"last_wr_off_doc" = case substring(@bitmap,4,1) & 128 when 128 then @c32 else "last_wr_off_doc" end
,"last_pyt_doc" = case substring(@bitmap,5,1) & 1 when 1 then @c33 else "last_pyt_doc" end
,"last_nsf_doc" = case substring(@bitmap,5,1) & 2 when 2 then @c34 else "last_nsf_doc" end
,"last_fin_chg_doc" = case substring(@bitmap,5,1) & 4 when 4 then @c35 else "last_fin_chg_doc" end
,"last_late_chg_doc" = case substring(@bitmap,5,1) & 8 when 8 then @c36 else "last_late_chg_doc" end
,"high_amt_ar" = case substring(@bitmap,5,1) & 16 when 16 then @c37 else "high_amt_ar" end
,"high_amt_inv" = case substring(@bitmap,5,1) & 32 when 32 then @c38 else "high_amt_inv" end
,"high_date_ar" = case substring(@bitmap,5,1) & 64 when 64 then @c39 else "high_date_ar" end
,"high_date_inv" = case substring(@bitmap,5,1) & 128 when 128 then @c40 else "high_date_inv" end
,"num_inv" = case substring(@bitmap,6,1) & 1 when 1 then @c41 else "num_inv" end
,"num_inv_paid" = case substring(@bitmap,6,1) & 2 when 2 then @c42 else "num_inv_paid" end
,"num_overdue_pyt" = case substring(@bitmap,6,1) & 4 when 4 then @c43 else "num_overdue_pyt" end
,"avg_days_pay" = case substring(@bitmap,6,1) & 8 when 8 then @c44 else "avg_days_pay" end
,"avg_days_overdue" = case substring(@bitmap,6,1) & 16 when 16 then @c45 else "avg_days_overdue" end
,"last_trx_time" = case substring(@bitmap,6,1) & 32 when 32 then @c46 else "last_trx_time" end
,"amt_balance" = case substring(@bitmap,6,1) & 64 when 64 then @c47 else "amt_balance" end
,"amt_on_acct" = case substring(@bitmap,6,1) & 128 when 128 then @c48 else "amt_on_acct" end
,"amt_age_b1_oper" = case substring(@bitmap,7,1) & 1 when 1 then @c49 else "amt_age_b1_oper" end
,"amt_age_b2_oper" = case substring(@bitmap,7,1) & 2 when 2 then @c50 else "amt_age_b2_oper" end
,"amt_age_b3_oper" = case substring(@bitmap,7,1) & 4 when 4 then @c51 else "amt_age_b3_oper" end
,"amt_age_b4_oper" = case substring(@bitmap,7,1) & 8 when 8 then @c52 else "amt_age_b4_oper" end
,"amt_age_b5_oper" = case substring(@bitmap,7,1) & 16 when 16 then @c53 else "amt_age_b5_oper" end
,"amt_age_b6_oper" = case substring(@bitmap,7,1) & 32 when 32 then @c54 else "amt_age_b6_oper" end
,"amt_on_order_oper" = case substring(@bitmap,7,1) & 64 when 64 then @c55 else "amt_on_order_oper" end
,"amt_inv_unp_oper" = case substring(@bitmap,7,1) & 128 when 128 then @c56 else "amt_inv_unp_oper" end
,"high_amt_ar_oper" = case substring(@bitmap,8,1) & 1 when 1 then @c57 else "high_amt_ar_oper" end
,"high_amt_inv_oper" = case substring(@bitmap,8,1) & 2 when 2 then @c58 else "high_amt_inv_oper" end
,"amt_balance_oper" = case substring(@bitmap,8,1) & 4 when 4 then @c59 else "amt_balance_oper" end
,"amt_on_acct_oper" = case substring(@bitmap,8,1) & 8 when 8 then @c60 else "amt_on_acct_oper" end
,"last_inv_cur" = case substring(@bitmap,8,1) & 16 when 16 then @c61 else "last_inv_cur" end
,"last_cm_cur" = case substring(@bitmap,8,1) & 32 when 32 then @c62 else "last_cm_cur" end
,"last_adj_cur" = case substring(@bitmap,8,1) & 64 when 64 then @c63 else "last_adj_cur" end
,"last_wr_off_cur" = case substring(@bitmap,8,1) & 128 when 128 then @c64 else "last_wr_off_cur" end
,"last_pyt_cur" = case substring(@bitmap,9,1) & 1 when 1 then @c65 else "last_pyt_cur" end
,"last_nsf_cur" = case substring(@bitmap,9,1) & 2 when 2 then @c66 else "last_nsf_cur" end
,"last_fin_chg_cur" = case substring(@bitmap,9,1) & 4 when 4 then @c67 else "last_fin_chg_cur" end
,"last_late_chg_cur" = case substring(@bitmap,9,1) & 8 when 8 then @c68 else "last_late_chg_cur" end
,"last_age_upd_date" = case substring(@bitmap,9,1) & 16 when 16 then @c69 else "last_age_upd_date" end
where "customer_code" = @pkc1
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
else
begin
update "aractcus_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"date_last_inv" = case substring(@bitmap,1,1) & 4 when 4 then @c3 else "date_last_inv" end
,"date_last_cm" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "date_last_cm" end
,"date_last_adj" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "date_last_adj" end
,"date_last_wr_off" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "date_last_wr_off" end
,"date_last_pyt" = case substring(@bitmap,1,1) & 64 when 64 then @c7 else "date_last_pyt" end
,"date_last_nsf" = case substring(@bitmap,1,1) & 128 when 128 then @c8 else "date_last_nsf" end
,"date_last_fin_chg" = case substring(@bitmap,2,1) & 1 when 1 then @c9 else "date_last_fin_chg" end
,"date_last_late_chg" = case substring(@bitmap,2,1) & 2 when 2 then @c10 else "date_last_late_chg" end
,"date_last_comm" = case substring(@bitmap,2,1) & 4 when 4 then @c11 else "date_last_comm" end
,"amt_last_inv" = case substring(@bitmap,2,1) & 8 when 8 then @c12 else "amt_last_inv" end
,"amt_last_cm" = case substring(@bitmap,2,1) & 16 when 16 then @c13 else "amt_last_cm" end
,"amt_last_adj" = case substring(@bitmap,2,1) & 32 when 32 then @c14 else "amt_last_adj" end
,"amt_last_wr_off" = case substring(@bitmap,2,1) & 64 when 64 then @c15 else "amt_last_wr_off" end
,"amt_last_pyt" = case substring(@bitmap,2,1) & 128 when 128 then @c16 else "amt_last_pyt" end
,"amt_last_nsf" = case substring(@bitmap,3,1) & 1 when 1 then @c17 else "amt_last_nsf" end
,"amt_last_fin_chg" = case substring(@bitmap,3,1) & 2 when 2 then @c18 else "amt_last_fin_chg" end
,"amt_last_late_chg" = case substring(@bitmap,3,1) & 4 when 4 then @c19 else "amt_last_late_chg" end
,"amt_last_comm" = case substring(@bitmap,3,1) & 8 when 8 then @c20 else "amt_last_comm" end
,"amt_age_bracket1" = case substring(@bitmap,3,1) & 16 when 16 then @c21 else "amt_age_bracket1" end
,"amt_age_bracket2" = case substring(@bitmap,3,1) & 32 when 32 then @c22 else "amt_age_bracket2" end
,"amt_age_bracket3" = case substring(@bitmap,3,1) & 64 when 64 then @c23 else "amt_age_bracket3" end
,"amt_age_bracket4" = case substring(@bitmap,3,1) & 128 when 128 then @c24 else "amt_age_bracket4" end
,"amt_age_bracket5" = case substring(@bitmap,4,1) & 1 when 1 then @c25 else "amt_age_bracket5" end
,"amt_age_bracket6" = case substring(@bitmap,4,1) & 2 when 2 then @c26 else "amt_age_bracket6" end
,"amt_on_order" = case substring(@bitmap,4,1) & 4 when 4 then @c27 else "amt_on_order" end
,"amt_inv_unposted" = case substring(@bitmap,4,1) & 8 when 8 then @c28 else "amt_inv_unposted" end
,"last_inv_doc" = case substring(@bitmap,4,1) & 16 when 16 then @c29 else "last_inv_doc" end
,"last_cm_doc" = case substring(@bitmap,4,1) & 32 when 32 then @c30 else "last_cm_doc" end
,"last_adj_doc" = case substring(@bitmap,4,1) & 64 when 64 then @c31 else "last_adj_doc" end
,"last_wr_off_doc" = case substring(@bitmap,4,1) & 128 when 128 then @c32 else "last_wr_off_doc" end
,"last_pyt_doc" = case substring(@bitmap,5,1) & 1 when 1 then @c33 else "last_pyt_doc" end
,"last_nsf_doc" = case substring(@bitmap,5,1) & 2 when 2 then @c34 else "last_nsf_doc" end
,"last_fin_chg_doc" = case substring(@bitmap,5,1) & 4 when 4 then @c35 else "last_fin_chg_doc" end
,"last_late_chg_doc" = case substring(@bitmap,5,1) & 8 when 8 then @c36 else "last_late_chg_doc" end
,"high_amt_ar" = case substring(@bitmap,5,1) & 16 when 16 then @c37 else "high_amt_ar" end
,"high_amt_inv" = case substring(@bitmap,5,1) & 32 when 32 then @c38 else "high_amt_inv" end
,"high_date_ar" = case substring(@bitmap,5,1) & 64 when 64 then @c39 else "high_date_ar" end
,"high_date_inv" = case substring(@bitmap,5,1) & 128 when 128 then @c40 else "high_date_inv" end
,"num_inv" = case substring(@bitmap,6,1) & 1 when 1 then @c41 else "num_inv" end
,"num_inv_paid" = case substring(@bitmap,6,1) & 2 when 2 then @c42 else "num_inv_paid" end
,"num_overdue_pyt" = case substring(@bitmap,6,1) & 4 when 4 then @c43 else "num_overdue_pyt" end
,"avg_days_pay" = case substring(@bitmap,6,1) & 8 when 8 then @c44 else "avg_days_pay" end
,"avg_days_overdue" = case substring(@bitmap,6,1) & 16 when 16 then @c45 else "avg_days_overdue" end
,"last_trx_time" = case substring(@bitmap,6,1) & 32 when 32 then @c46 else "last_trx_time" end
,"amt_balance" = case substring(@bitmap,6,1) & 64 when 64 then @c47 else "amt_balance" end
,"amt_on_acct" = case substring(@bitmap,6,1) & 128 when 128 then @c48 else "amt_on_acct" end
,"amt_age_b1_oper" = case substring(@bitmap,7,1) & 1 when 1 then @c49 else "amt_age_b1_oper" end
,"amt_age_b2_oper" = case substring(@bitmap,7,1) & 2 when 2 then @c50 else "amt_age_b2_oper" end
,"amt_age_b3_oper" = case substring(@bitmap,7,1) & 4 when 4 then @c51 else "amt_age_b3_oper" end
,"amt_age_b4_oper" = case substring(@bitmap,7,1) & 8 when 8 then @c52 else "amt_age_b4_oper" end
,"amt_age_b5_oper" = case substring(@bitmap,7,1) & 16 when 16 then @c53 else "amt_age_b5_oper" end
,"amt_age_b6_oper" = case substring(@bitmap,7,1) & 32 when 32 then @c54 else "amt_age_b6_oper" end
,"amt_on_order_oper" = case substring(@bitmap,7,1) & 64 when 64 then @c55 else "amt_on_order_oper" end
,"amt_inv_unp_oper" = case substring(@bitmap,7,1) & 128 when 128 then @c56 else "amt_inv_unp_oper" end
,"high_amt_ar_oper" = case substring(@bitmap,8,1) & 1 when 1 then @c57 else "high_amt_ar_oper" end
,"high_amt_inv_oper" = case substring(@bitmap,8,1) & 2 when 2 then @c58 else "high_amt_inv_oper" end
,"amt_balance_oper" = case substring(@bitmap,8,1) & 4 when 4 then @c59 else "amt_balance_oper" end
,"amt_on_acct_oper" = case substring(@bitmap,8,1) & 8 when 8 then @c60 else "amt_on_acct_oper" end
,"last_inv_cur" = case substring(@bitmap,8,1) & 16 when 16 then @c61 else "last_inv_cur" end
,"last_cm_cur" = case substring(@bitmap,8,1) & 32 when 32 then @c62 else "last_cm_cur" end
,"last_adj_cur" = case substring(@bitmap,8,1) & 64 when 64 then @c63 else "last_adj_cur" end
,"last_wr_off_cur" = case substring(@bitmap,8,1) & 128 when 128 then @c64 else "last_wr_off_cur" end
,"last_pyt_cur" = case substring(@bitmap,9,1) & 1 when 1 then @c65 else "last_pyt_cur" end
,"last_nsf_cur" = case substring(@bitmap,9,1) & 2 when 2 then @c66 else "last_nsf_cur" end
,"last_fin_chg_cur" = case substring(@bitmap,9,1) & 4 when 4 then @c67 else "last_fin_chg_cur" end
,"last_late_chg_cur" = case substring(@bitmap,9,1) & 8 when 8 then @c68 else "last_late_chg_cur" end
,"last_age_upd_date" = case substring(@bitmap,9,1) & 16 when 16 then @c69 else "last_age_upd_date" end
where "customer_code" = @pkc1
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
GO
