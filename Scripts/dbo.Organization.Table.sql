USE [GISData]
GO
/****** Object:  Table [dbo].[Organization]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization](
	[Organization_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organization] [varchar](50) NOT NULL,
	[BCD_Number] [char](10) NULL,
	[Address_1] [varchar](50) NOT NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](25) NOT NULL,
	[Province] [varchar](25) NULL,
	[Country] [varchar](25) NOT NULL,
	[Postal_Code] [varchar](10) NULL,
	[Phone_Number] [varchar](31) NOT NULL,
	[Fax_Number] [varchar](31) NULL,
	[Contact_Name] [varchar](25) NULL,
	[Contact_Position] [varchar](25) NULL,
	[Contact_Phone_Number] [varchar](31) NULL,
	[Contact_Fax_Number] [varchar](31) NULL,
	[Contact_Email_Address] [varchar](50) NULL,
	[Commission_Payable] [char](1) NOT NULL,
	[Org_Type] [varchar](25) NULL,
	[Remarks] [varchar](255) NULL,
	[Inactive] [bit] NOT NULL,
	[Update_Ctrl] [timestamp] NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[Maestro_Commission_Paid] [bit] NOT NULL,
	[Maestro_Freq_Flyer_Honoured] [bit] NOT NULL,
	[Tour_Rate_Account] [bit] NULL,
	[Maestro_Rate_Override] [bit] NULL,
	[AR_Customer_Code] [varchar](20) NULL,
	[Marketing_Source] [varchar](30) NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED 
(
	[Organization_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Organization_B_O_O_O]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Organization_B_O_O_O] ON [dbo].[Organization]
(
	[BCD_Number] ASC,
	[Organization] ASC,
	[Organization_ID] ASC,
	[Org_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Organization] ADD  CONSTRAINT [DF_Organization_Tour_Rate_Account]  DEFAULT (0) FOR [Tour_Rate_Account]
GO
