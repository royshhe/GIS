USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Location_Set]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Location_Set](
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Rate_Location_Set_ID] [int] IDENTITY(1,1) NOT NULL,
	[Km_Cap] [smallint] NULL,
	[Per_Km_Charge] [decimal](7, 2) NULL,
	[Flat_Surcharge] [decimal](7, 2) NULL,
	[Daily_Surcharge] [decimal](7, 2) NULL,
	[Allow_All_Auth_Drop_Off_Locs] [bit] NOT NULL,
	[Override_Km_Cap_Flag] [bit] NOT NULL,
 CONSTRAINT [PK_Rate_Location_Set] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Rate_Location_Set_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Location_Set] ADD  CONSTRAINT [DF_Rate_Locati_Override_Km]  DEFAULT (0) FOR [Override_Km_Cap_Flag]
GO
