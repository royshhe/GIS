USE [GISData]
GO
/****** Object:  Table [dbo].[Toll_Reporting]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Toll_Reporting](
	[Toll_Report_ID] [int] IDENTITY(1,1) NOT NULL,
	[Confirmation_Number] [varchar](20) NULL,
	[Contract_number] [int] NULL,
	[Renter_Last_Name] [varchar](50) NULL,
	[Licence_Plate_Number] [varchar](20) NULL,
	[Crossing_Date] [smalldatetime] NOT NULL,
	[Number_Of_Crossing] [smallint] NULL,
	[Issuer] [varchar](10) NULL,
	[Reporting_Time] [datetime] NULL,
	[Processed] [bit] NULL,
	[Business_Transaction_ID] [int] NULL,
 CONSTRAINT [PK_Toll_Reporting_1] PRIMARY KEY CLUSTERED 
(
	[Toll_Report_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Toll_Reporting] ADD  CONSTRAINT [DF_Toll_Reporting_Issuer]  DEFAULT ('T3') FOR [Issuer]
GO
ALTER TABLE [dbo].[Toll_Reporting] ADD  CONSTRAINT [DF_Toll_Reporting_Processed]  DEFAULT (0) FOR [Processed]
GO
