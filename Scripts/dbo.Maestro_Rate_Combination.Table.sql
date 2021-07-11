USE [GISData]
GO
/****** Object:  Table [dbo].[Maestro_Rate_Combination]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Maestro_Rate_Combination](
	[Rate_Structure] [char](1) NOT NULL,
	[Maestro_Rate_Category_Code1] [char](2) NOT NULL,
	[Maestro_Rate_Category_Code2] [char](2) NOT NULL,
	[Maestro_Rate_Category_Code3] [char](2) NOT NULL,
	[Maestro_Rate_Category_Code4] [char](2) NOT NULL,
	[Process_As_Rate_Category] [char](2) NOT NULL,
 CONSTRAINT [PK_Maestro_Rate_Combination] PRIMARY KEY CLUSTERED 
(
	[Rate_Structure] ASC,
	[Maestro_Rate_Category_Code1] ASC,
	[Maestro_Rate_Category_Code2] ASC,
	[Maestro_Rate_Category_Code3] ASC,
	[Maestro_Rate_Category_Code4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
