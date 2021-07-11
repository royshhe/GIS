USE [GISData]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Customer_ID] [int] IDENTITY(1000,1) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](25) NULL,
	[Province] [varchar](25) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Country] [varchar](25) NULL,
	[Phone_Number] [varchar](31) NULL,
	[Email_Address] [varchar](50) NULL,
	[Birth_Date] [datetime] NULL,
	[Gender] [char](1) NULL,
	[Driver_Licence_Number] [varchar](25) NULL,
	[Driver_Licence_Expiry] [datetime] NULL,
	[Jurisdiction] [varchar](20) NULL,
	[Program_Number] [varchar](15) NULL,
	[Payment_Method] [varchar](20) NULL,
	[Do_Not_Rent] [bit] NOT NULL,
	[Remarks] [varchar](255) NULL,
	[Vehicle_Class_Code] [char](1) NULL,
	[Organization_ID] [int] NULL,
	[Add_LDW] [bit] NOT NULL,
	[Add_PAI] [bit] NOT NULL,
	[Add_PEC] [bit] NOT NULL,
	[Smoking_Non_Smoking] [char](1) NOT NULL,
	[Inactive] [bit] NOT NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[Preferred_FF_Plan_ID] [smallint] NULL,
	[Preferred_FF_Member_Number] [varchar](20) NULL,
	[Driver_Licence_Class] [char](1) NULL,
	[Company_Name] [varchar](30) NULL,
	[Company_Phone_Number] [varchar](31) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Customer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_BCN]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_BCN] ON [dbo].[Customer]
(
	[Program_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_DLNumber]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_DLNumber] ON [dbo].[Customer]
(
	[Driver_Licence_Number] ASC,
	[Jurisdiction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_customer_Jurisdiction]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_customer_Jurisdiction] ON [dbo].[Customer]
(
	[Jurisdiction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Name]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_Name] ON [dbo].[Customer]
(
	[Last_Name] ASC,
	[First_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Organization2] FOREIGN KEY([Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Organization2]
GO
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class11] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Vehicle_Class11]
GO
