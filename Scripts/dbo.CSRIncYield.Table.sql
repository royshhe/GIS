USE [GISData]
GO
/****** Object:  Table [dbo].[CSRIncYield]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSRIncYield](
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Vehicle_Type_ID] [varchar](10) NOT NULL,
	[CSR_Name] [varchar](20) NOT NULL,
	[Contract_In] [int] NULL,
	[Rental_Days] [numeric](28, 6) NULL,
	[Walk_Up] [int] NULL,
	[FPO] [decimal](28, 2) NULL,
	[Up_sell] [decimal](28, 2) NULL,
	[Additional_Driver_Charge] [decimal](28, 2) NULL,
	[All_Seats] [decimal](28, 2) NULL,
	[Driver_Under_Age] [decimal](28, 2) NULL,
	[All_Level_LDW] [decimal](28, 2) NULL,
	[PAI] [decimal](28, 2) NULL,
	[PEC] [decimal](28, 2) NULL,
	[Ski_Rack] [decimal](28, 2) NULL,
	[All_Dolly] [decimal](28, 2) NULL,
	[All_Gates] [decimal](28, 2) NULL,
	[Blanket] [decimal](28, 2) NULL,
	[WalkUPCount] [decimal](18, 0) NULL,
	[FPOCount] [int] NULL,
	[AdditionalDriverChargeCount] [int] NULL,
	[UpsellCount] [int] NULL,
	[AllSeatsCount] [int] NULL,
	[DriverUnderAgeCount] [int] NULL,
	[AllLevelLDWCount] [int] NULL,
	[PAICount] [int] NULL,
	[PECCount] [int] NULL,
	[SkiRackCount] [int] NULL,
	[AllDollyCount] [int] NULL,
	[AllGatesCount] [int] NULL,
	[BlanketCount] [int] NULL,
 CONSTRAINT [PK_CSRIncYield] PRIMARY KEY CLUSTERED 
(
	[Pick_Up_Location_ID] ASC,
	[CSR_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
