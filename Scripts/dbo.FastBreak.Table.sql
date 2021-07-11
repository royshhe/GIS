USE [GISData]
GO
/****** Object:  Table [dbo].[FastBreak]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FastBreak](
	[Location] [nvarchar](255) NULL,
	[CSR_Name] [nvarchar](255) NULL,
	[Contract_number] [float] NULL,
	[confirmation_number] [float] NULL,
	[Fastbreak_Indicator] [float] NULL,
	[Rental_Days] [float] NULL,
	[Walk_Up] [float] NULL,
	[FPO] [float] NULL,
	[Additional_Driver_Charge] [float] NULL,
	[All_Seats] [float] NULL,
	[Driver_Under_Age] [float] NULL,
	[All_Level_LDW] [money] NULL,
	[PAI] [money] NULL,
	[PEC] [money] NULL,
	[Ski_Rack] [float] NULL,
	[All_Dolly] [float] NULL,
	[All_Gates] [float] NULL,
	[Blanket] [float] NULL,
	[F19] [nvarchar](255) NULL,
	[F20] [nvarchar](255) NULL,
	[F21] [nvarchar](255) NULL,
	[F22] [nvarchar](255) NULL,
	[F23] [nvarchar](255) NULL,
	[F24] [nvarchar](255) NULL,
	[F25] [nvarchar](255) NULL,
	[F26] [nvarchar](255) NULL,
	[F27] [nvarchar](255) NULL,
	[F28] [nvarchar](255) NULL
) ON [PRIMARY]
GO
