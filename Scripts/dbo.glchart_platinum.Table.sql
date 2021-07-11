USE [GISData]
GO
/****** Object:  Table [dbo].[glchart_platinum]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glchart_platinum](
	[timestamp] [binary](8) NULL,
	[account_code] [varchar](32) NOT NULL,
	[account_description] [varchar](40) NOT NULL,
	[account_type] [smallint] NOT NULL,
	[new_flag] [smallint] NOT NULL,
	[seg1_code] [varchar](32) NOT NULL,
	[seg2_code] [varchar](32) NOT NULL,
	[seg3_code] [varchar](32) NOT NULL,
	[seg4_code] [varchar](32) NOT NULL,
	[consol_detail_flag] [smallint] NOT NULL,
	[consol_type] [smallint] NOT NULL,
	[active_date] [int] NOT NULL,
	[inactive_date] [int] NOT NULL,
	[inactive_flag] [smallint] NOT NULL,
	[currency_code] [varchar](8) NOT NULL,
	[revaluate_flag] [smallint] NOT NULL,
	[rate_type_home] [varchar](8) NULL,
	[rate_type_oper] [varchar](8) NULL,
 CONSTRAINT [PK_glchart_platinum] PRIMARY KEY CLUSTERED 
(
	[account_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
