USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Class]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Class](
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Vehicle_Class_Name] [varchar](30) NOT NULL,
	[Local_Rental_Only] [bit] NOT NULL,
	[US_Border_Crossing_Allowed] [bit] NOT NULL,
	[Cash_Rental_Allowed] [bit] NOT NULL,
	[Deposit_Amount] [smallmoney] NULL,
	[Minimum_Cancellation_Notice] [tinyint] NULL,
	[Minimum_Age] [tinyint] NOT NULL,
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[FA_Vehicle_Type_ID] [varchar](18) NULL,
	[Upgraded_Vehicle_Class_Name] [varchar](20) NULL,
	[Maestro_Code] [char](6) NULL,
	[Upgraded_Vehicle_Class_Code] [char](1) NULL,
	[Included_FPO_Amount] [decimal](9, 2) NOT NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL,
	[PST] [decimal](9, 2) NULL,
	[SIPP] [char](10) NULL,
	[DisplayOrder] [int] NULL,
	[Alias] [varchar](30) NULL,
	[Description] [varchar](100) NULL,
	[ImageName] [varchar](100) NULL,
	[VCPhoto] [varchar](50) NULL,
	[VCNameImage] [varchar](50) NULL,
	[VCCapImage] [varchar](50) NULL,
	[Number_Passengers] [tinyint] NULL,
	[Large_Bags] [tinyint] NULL,
	[Small_Bags] [tinyint] NULL,
	[SellOnline] [bit] NOT NULL,
	[CSA] [bit] NULL,
	[Acctg_Segment] [varchar](15) NULL,
	[Default_Optional_Extra_ID] [smallint] NULL,
	[AddenDum] [varchar](30) NULL,
	[IBX_VC_Code] [smallint] NULL,
	[Passenger_Vehicle] [bit] NULL,
	[Online_Description] [varchar](400) NULL,
	[CC_Auth_Flat] [decimal](9, 2) NULL,
	[CC_Auth_Minimum] [decimal](9, 2) NULL,
	[CC_Auth_Under_Age] [decimal](9, 2) NULL,
	[CC_Auth_Under_Age_Minimum] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Vehicle_Class] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Class_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Vehicle_Class1] UNIQUE NONCLUSTERED 
(
	[Vehicle_Class_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Class] ADD  CONSTRAINT [DF_Vehicle_Class_SellOnline]  DEFAULT (0) FOR [SellOnline]
GO
ALTER TABLE [dbo].[Vehicle_Class]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class8] FOREIGN KEY([Upgraded_Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Vehicle_Class] CHECK CONSTRAINT [FK_Vehicle_Class8]
GO
