USE [GISData]
GO
/****** Object:  Table [dbo].[aractcus_base]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aractcus_base](
	[timestamp] [binary](8) NOT NULL,
	[customer_code] [varchar](12) NOT NULL,
	[date_last_inv] [int] NOT NULL,
	[date_last_cm] [int] NOT NULL,
	[date_last_adj] [int] NOT NULL,
	[date_last_wr_off] [int] NOT NULL,
	[date_last_pyt] [int] NOT NULL,
	[date_last_nsf] [int] NOT NULL,
	[date_last_fin_chg] [int] NOT NULL,
	[date_last_late_chg] [int] NOT NULL,
	[date_last_comm] [int] NOT NULL,
	[amt_last_inv] [float] NOT NULL,
	[amt_last_cm] [float] NOT NULL,
	[amt_last_adj] [float] NOT NULL,
	[amt_last_wr_off] [float] NOT NULL,
	[amt_last_pyt] [float] NOT NULL,
	[amt_last_nsf] [float] NOT NULL,
	[amt_last_fin_chg] [float] NOT NULL,
	[amt_last_late_chg] [float] NOT NULL,
	[amt_last_comm] [float] NOT NULL,
	[amt_age_bracket1] [float] NOT NULL,
	[amt_age_bracket2] [float] NOT NULL,
	[amt_age_bracket3] [float] NOT NULL,
	[amt_age_bracket4] [float] NOT NULL,
	[amt_age_bracket5] [float] NOT NULL,
	[amt_age_bracket6] [float] NOT NULL,
	[amt_on_order] [float] NOT NULL,
	[amt_inv_unposted] [float] NOT NULL,
	[last_inv_doc] [varchar](16) NOT NULL,
	[last_cm_doc] [varchar](16) NOT NULL,
	[last_adj_doc] [varchar](16) NOT NULL,
	[last_wr_off_doc] [varchar](16) NOT NULL,
	[last_pyt_doc] [varchar](16) NOT NULL,
	[last_nsf_doc] [varchar](16) NOT NULL,
	[last_fin_chg_doc] [varchar](16) NOT NULL,
	[last_late_chg_doc] [varchar](16) NOT NULL,
	[high_amt_ar] [float] NOT NULL,
	[high_amt_inv] [float] NOT NULL,
	[high_date_ar] [int] NOT NULL,
	[high_date_inv] [int] NOT NULL,
	[num_inv] [int] NOT NULL,
	[num_inv_paid] [int] NOT NULL,
	[num_overdue_pyt] [int] NOT NULL,
	[avg_days_pay] [int] NOT NULL,
	[avg_days_overdue] [int] NOT NULL,
	[last_trx_time] [int] NOT NULL,
	[amt_balance] [float] NOT NULL,
	[amt_on_acct] [float] NOT NULL,
	[amt_age_b1_oper] [float] NOT NULL,
	[amt_age_b2_oper] [float] NOT NULL,
	[amt_age_b3_oper] [float] NOT NULL,
	[amt_age_b4_oper] [float] NOT NULL,
	[amt_age_b5_oper] [float] NOT NULL,
	[amt_age_b6_oper] [float] NOT NULL,
	[amt_on_order_oper] [float] NOT NULL,
	[amt_inv_unp_oper] [float] NOT NULL,
	[high_amt_ar_oper] [float] NOT NULL,
	[high_amt_inv_oper] [float] NOT NULL,
	[amt_balance_oper] [float] NOT NULL,
	[amt_on_acct_oper] [float] NOT NULL,
	[last_inv_cur] [varchar](8) NOT NULL,
	[last_cm_cur] [varchar](8) NOT NULL,
	[last_adj_cur] [varchar](8) NOT NULL,
	[last_wr_off_cur] [varchar](8) NOT NULL,
	[last_pyt_cur] [varchar](8) NOT NULL,
	[last_nsf_cur] [varchar](8) NOT NULL,
	[last_fin_chg_cur] [varchar](8) NOT NULL,
	[last_late_chg_cur] [varchar](8) NOT NULL,
	[last_age_upd_date] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PK_aractcus]    Script Date: 2021-07-10 1:50:44 PM ******/
CREATE UNIQUE CLUSTERED INDEX [PK_aractcus] ON [dbo].[aractcus_base]
(
	[customer_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
