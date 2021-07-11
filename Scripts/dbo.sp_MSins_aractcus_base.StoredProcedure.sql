USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSins_aractcus_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_aractcus_base] @c1 binary(8),@c2 varchar(12),@c3 int,@c4 int,@c5 int,@c6 int,@c7 int,@c8 int,@c9 int,@c10 int,@c11 int,@c12 float,@c13 float,@c14 float,@c15 float,@c16 float,@c17 float,@c18 float,@c19 float,@c20 float,@c21 float,@c22 float,@c23 float,@c24 float,@c25 float,@c26 float,@c27 float,@c28 float,@c29 varchar(16),@c30 varchar(16),@c31 varchar(16),@c32 varchar(16),@c33 varchar(16),@c34 varchar(16),@c35 varchar(16),@c36 varchar(16),@c37 float,@c38 float,@c39 int,@c40 int,@c41 int,@c42 int,@c43 int,@c44 int,@c45 int,@c46 int,@c47 float,@c48 float,@c49 float,@c50 float,@c51 float,@c52 float,@c53 float,@c54 float,@c55 float,@c56 float,@c57 float,@c58 float,@c59 float,@c60 float,@c61 varchar(8),@c62 varchar(8),@c63 varchar(8),@c64 varchar(8),@c65 varchar(8),@c66 varchar(8),@c67 varchar(8),@c68 varchar(8),@c69 int

AS
BEGIN


insert into "aractcus_base"( 
"timestamp", "customer_code", "date_last_inv", "date_last_cm", "date_last_adj", "date_last_wr_off", "date_last_pyt", "date_last_nsf", "date_last_fin_chg", "date_last_late_chg", "date_last_comm", "amt_last_inv", "amt_last_cm", "amt_last_adj", "amt_last_wr_off", "amt_last_pyt", "amt_last_nsf", "amt_last_fin_chg", "amt_last_late_chg", "amt_last_comm", "amt_age_bracket1", "amt_age_bracket2", "amt_age_bracket3", "amt_age_bracket4", "amt_age_bracket5", "amt_age_bracket6", "amt_on_order", "amt_inv_unposted", "last_inv_doc", "last_cm_doc", "last_adj_doc", "last_wr_off_doc", "last_pyt_doc", "last_nsf_doc", "last_fin_chg_doc", "last_late_chg_doc", "high_amt_ar", "high_amt_inv", "high_date_ar", "high_date_inv", "num_inv", "num_inv_paid", "num_overdue_pyt", "avg_days_pay", "avg_days_overdue", "last_trx_time", "amt_balance", "amt_on_acct", "amt_age_b1_oper", "amt_age_b2_oper", "amt_age_b3_oper", "amt_age_b4_oper", "amt_age_b5_oper", "amt_age_b6_oper", "amt_on_order_oper", "amt_inv_unp_oper", "high_amt_ar_oper", "high_amt_inv_oper", "amt_balance_oper", "amt_on_acct_oper", "last_inv_cur", "last_cm_cur", "last_adj_cur", "last_wr_off_cur", "last_pyt_cur", "last_nsf_cur", "last_fin_chg_cur", "last_late_chg_cur", "last_age_upd_date"
 )

values ( 
@c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9, @c10, @c11, @c12, @c13, @c14, @c15, @c16, @c17, @c18, @c19, @c20, @c21, @c22, @c23, @c24, @c25, @c26, @c27, @c28, @c29, @c30, @c31, @c32, @c33, @c34, @c35, @c36, @c37, @c38, @c39, @c40, @c41, @c42, @c43, @c44, @c45, @c46, @c47, @c48, @c49, @c50, @c51, @c52, @c53, @c54, @c55, @c56, @c57, @c58, @c59, @c60, @c61, @c62, @c63, @c64, @c65, @c66, @c67, @c68, @c69
 )


END
GO
