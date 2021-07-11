USE [GISData]
GO
/****** Object:  Table [dbo].[bgt_armaster_base_add]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bgt_armaster_base_add](
	[timestamp] [timestamp] NOT NULL,
	[customer_code] [varchar](12) NOT NULL,
	[ship_to_code] [varchar](12) NOT NULL,
	[address_type] [smallint] NOT NULL,
	[po_num_reqd_flag] [smallint] NOT NULL,
	[claim_num_reqd_flag] [smallint] NOT NULL
) ON [PRIMARY]
GO
