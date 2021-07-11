USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_CI]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_CI](
	[Contract_Number] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Pick_Up_On] [datetime] NOT NULL,
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Status] [char](2) NOT NULL,
	[Foreign_Contract_Number] [varchar](20) NULL,
	[BRAC_Unit] [bit] NULL,
	[Location_Name] [varchar](25) NOT NULL,
	[Rental_Days] [decimal](18, 10) NULL,
	[KM_Driven] [int] NULL,
	[TimeKM_Charge] [decimal](16, 6) NULL,
	[LDW_Charge] [decimal](16, 6) NULL,
	[PAI_Charge] [decimal](16, 6) NULL,
	[PEC_Charge] [decimal](16, 6) NULL,
	[Cargo_Charge] [decimal](16, 6) NULL,
	[Foreign_Opt_Extra_Charge] [decimal](16, 6) NULL
) ON [PRIMARY]
GO
