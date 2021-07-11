USE [GISData]
GO
/****** Object:  Table [dbo].[bgt_armaster_base]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bgt_armaster_base](
	[timestamp] [binary](8) NOT NULL,
	[customer_code] [varchar](12) NOT NULL,
	[ship_to_code] [varchar](12) NOT NULL,
	[address_type] [smallint] NOT NULL,
	[po_num_reqd_flag] [smallint] NOT NULL,
	[claim_num_reqd_flag] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PK_bgt_armaster]    Script Date: 2021-07-10 1:50:44 PM ******/
CREATE UNIQUE CLUSTERED INDEX [PK_bgt_armaster] ON [dbo].[bgt_armaster_base]
(
	[customer_code] ASC,
	[ship_to_code] ASC,
	[address_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
