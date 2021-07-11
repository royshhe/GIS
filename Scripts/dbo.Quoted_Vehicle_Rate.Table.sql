USE [GISData]
GO
/****** Object:  Table [dbo].[Quoted_Vehicle_Rate]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quoted_Vehicle_Rate](
	[Quoted_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Rate_Source] [varchar](10) NOT NULL,
	[Rate_Name] [varchar](25) NULL,
	[Rate_Purpose_ID] [smallint] NULL,
	[Rate_Structure] [char](1) NULL,
	[Authorized_DO_Charge] [decimal](7, 2) NULL,
	[Tax_Included] [bit] NOT NULL,
	[GST_Included] [bit] NOT NULL,
	[PST_Included] [bit] NOT NULL,
	[PVRT_Included] [bit] NOT NULL,
	[Location_Fee_Included] [bit] NOT NULL,
	[Per_KM_Charge] [decimal](7, 2) NOT NULL,
	[Calendar_Day_Rate] [bit] NOT NULL,
	[FPO_Purchased] [bit] NOT NULL,
	[Commission_Paid] [bit] NOT NULL,
	[Frequent_Flyer_Plans_Honoured] [bit] NOT NULL,
	[Other_Inclusions] [varchar](255) NULL,
	[Corporate_Responsibility] [decimal](9, 2) NULL,
	[License_Fee_Included] [bit] NOT NULL,
	[ERF_Included] [bit] NULL,
 CONSTRAINT [PK_Quoted_Vehicle_Rate] PRIMARY KEY CLUSTERED 
(
	[Quoted_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Quoted_Vehicle_Rate] ADD  CONSTRAINT [DF_Quoted_Vehi_FPO_Purchas]  DEFAULT (0) FOR [FPO_Purchased]
GO
ALTER TABLE [dbo].[Quoted_Vehicle_Rate] ADD  DEFAULT (0) FOR [License_Fee_Included]
GO
