USE [GISData]
GO
/****** Object:  Table [dbo].[armaster_base]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[armaster_base](
	[timestamp] [binary](8) NULL,
	[customer_code] [varchar](12) NOT NULL,
	[ship_to_code] [varchar](12) NOT NULL,
	[address_name] [varchar](60) NULL,
	[short_name] [varchar](10) NULL,
	[addr1] [varchar](40) NULL,
	[addr2] [varchar](40) NULL,
	[addr3] [varchar](40) NULL,
	[addr4] [varchar](40) NULL,
	[addr5] [varchar](40) NULL,
	[addr6] [varchar](40) NULL,
	[addr_sort1] [varchar](40) NULL,
	[addr_sort2] [varchar](40) NULL,
	[addr_sort3] [varchar](40) NULL,
	[address_type] [smallint] NOT NULL,
	[status_type] [smallint] NULL,
	[attention_name] [varchar](40) NULL,
	[attention_phone] [varchar](30) NULL,
	[contact_name] [varchar](40) NULL,
	[contact_phone] [varchar](30) NULL,
	[tlx_twx] [varchar](30) NULL,
	[phone_1] [varchar](30) NULL,
	[phone_2] [varchar](30) NULL,
	[tax_code] [varchar](8) NULL,
	[terms_code] [varchar](8) NULL,
	[fob_code] [varchar](8) NULL,
	[freight_code] [varchar](8) NULL,
	[posting_code] [varchar](8) NULL,
	[location_code] [varchar](8) NULL,
	[alt_location_code] [varchar](8) NULL,
	[dest_zone_code] [varchar](8) NULL,
	[territory_code] [varchar](8) NULL,
	[salesperson_code] [varchar](8) NULL,
	[fin_chg_code] [varchar](8) NULL,
	[price_code] [varchar](8) NULL,
	[payment_code] [varchar](8) NULL,
	[vendor_code] [varchar](12) NULL,
	[affiliated_cust_code] [varchar](8) NULL,
	[print_stmt_flag] [smallint] NULL,
	[stmt_cycle_code] [varchar](8) NULL,
	[inv_comment_code] [varchar](8) NULL,
	[stmt_comment_code] [varchar](8) NULL,
	[dunn_message_code] [varchar](8) NULL,
	[note] [varchar](255) NULL,
	[trade_disc_percent] [float] NULL,
	[invoice_copies] [smallint] NULL,
	[iv_substitution] [smallint] NULL,
	[ship_to_history] [smallint] NULL,
	[check_credit_limit] [smallint] NULL,
	[credit_limit] [float] NULL,
	[check_aging_limit] [smallint] NULL,
	[aging_limit_bracket] [smallint] NULL,
	[bal_fwd_flag] [smallint] NULL,
	[ship_complete_flag] [smallint] NULL,
	[resale_num] [varchar](30) NULL,
	[db_num] [varchar](20) NULL,
	[db_date] [int] NULL,
	[db_credit_rating] [varchar](20) NULL,
	[late_chg_type] [smallint] NULL,
	[valid_payer_flag] [smallint] NULL,
	[valid_soldto_flag] [smallint] NULL,
	[valid_shipto_flag] [smallint] NULL,
	[payer_soldto_rel_code] [char](8) NULL,
	[across_na_flag] [smallint] NULL,
	[date_opened] [int] NULL,
	[added_by_user_name] [varchar](30) NULL,
	[added_by_date] [datetime] NULL,
	[modified_by_user_name] [varchar](30) NULL,
	[modified_by_date] [datetime] NULL,
	[rate_type_home] [varchar](8) NULL,
	[rate_type_oper] [varchar](8) NULL,
	[limit_by_home] [smallint] NULL,
	[nat_cur_code] [varchar](8) NULL,
	[one_cur_cust] [smallint] NULL,
	[city] [varchar](40) NULL,
	[state] [varchar](40) NULL,
	[postal_code] [varchar](15) NULL,
	[country] [varchar](40) NULL,
	[remit_code] [varchar](10) NULL,
	[forwarder_code] [varchar](10) NULL,
	[freight_to_code] [varchar](10) NULL,
	[route_code] [varchar](10) NULL,
	[route_no] [int] NULL,
	[url] [varchar](50) NULL,
	[special_instr] [varchar](255) NULL,
	[guid] [varchar](32) NULL,
	[price_level] [char](1) NULL,
	[ship_via_code] [varchar](8) NULL,
	[po_num_reqd_flag] [smallint] NULL,
	[claim_num_reqd_flag] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PK_armaster]    Script Date: 2021-07-10 1:50:44 PM ******/
CREATE UNIQUE CLUSTERED INDEX [PK_armaster] ON [dbo].[armaster_base]
(
	[customer_code] ASC,
	[ship_to_code] ASC,
	[address_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_armaster_base_5_536597200__K2_K4]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_armaster_base_5_536597200__K2_K4] ON [dbo].[armaster_base]
(
	[customer_code] ASC,
	[address_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
