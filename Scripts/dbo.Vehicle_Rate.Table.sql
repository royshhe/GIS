USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Rate]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Rate](
	[Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Rate_Name] [varchar](30) NOT NULL,
	[Location_Fee_Included] [bit] NOT NULL,
	[Rate_Purpose_ID] [smallint] NOT NULL,
	[Upsell] [bit] NOT NULL,
	[Flex_Discount_Allowed] [bit] NOT NULL,
	[Discount_Allowed] [bit] NOT NULL,
	[Referral_Fee_Paid] [bit] NOT NULL,
	[Commission_Paid] [bit] NOT NULL,
	[Frequent_Flyer_Plans_Honoured] [bit] NOT NULL,
	[Km_Drop_Off_Charge] [bit] NOT NULL,
	[Insurance_Transfer_Allowed] [bit] NOT NULL,
	[Warranty_Repair_Allowed] [bit] NOT NULL,
	[Contract_Remarks] [varchar](255) NULL,
	[Other_Remarks] [varchar](255) NULL,
	[Special_Restrictions] [varchar](255) NULL,
	[Manufacturer_ID] [tinyint] NULL,
	[GST_Included] [bit] NOT NULL,
	[PST_Included] [bit] NOT NULL,
	[PVRT_Included] [bit] NOT NULL,
	[Update_Ctrl] [timestamp] NOT NULL,
	[Violated_Rate_ID] [int] NULL,
	[Violated_Rate_Level] [char](1) NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[FPO_Purchased] [bit] NOT NULL,
	[License_Fee_Included] [bit] NOT NULL,
	[Amount_Markup] [decimal](9, 2) NULL,
	[ERF_Included] [bit] NULL,
	[Calendar_Day_Rate] [bit] NULL,
	[Underage_Charge] [bit] NULL,
	[CFC_Included] [bit] NULL,
 CONSTRAINT [PK_Vehicle_Rate] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Rate] ADD  CONSTRAINT [DF_Vehicle_Rate_FPO_Purchased]  DEFAULT (0) FOR [FPO_Purchased]
GO
ALTER TABLE [dbo].[Vehicle_Rate] ADD  DEFAULT (0) FOR [License_Fee_Included]
GO
ALTER TABLE [dbo].[Vehicle_Rate] ADD  CONSTRAINT [DF_Vehicle_Rate_Calendar_Day_Rate]  DEFAULT (0) FOR [Calendar_Day_Rate]
GO
ALTER TABLE [dbo].[Vehicle_Rate]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Rate_Rate_Purpose] FOREIGN KEY([Rate_Purpose_ID])
REFERENCES [dbo].[Rate_Purpose] ([Rate_Purpose_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Vehicle_Rate] NOCHECK CONSTRAINT [FK_Vehicle_Rate_Rate_Purpose]
GO
