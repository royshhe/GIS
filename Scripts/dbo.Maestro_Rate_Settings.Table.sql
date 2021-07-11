USE [GISData]
GO
/****** Object:  Table [dbo].[Maestro_Rate_Settings]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Maestro_Rate_Settings](
	[Rate_Name] [varchar](25) NOT NULL,
	[Drop_Charge_Included] [bit] NOT NULL,
 CONSTRAINT [PK_Maestro_Rate_Settings] PRIMARY KEY CLUSTERED 
(
	[Rate_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Maestro_Rate_Settings] ADD  CONSTRAINT [DF_Maestro_Rate_Settings_Drop_Charge_Included]  DEFAULT (0) FOR [Drop_Charge_Included]
GO
