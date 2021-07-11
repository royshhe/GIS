USE [GISData]
GO
/****** Object:  Table [dbo].[CSRIncentiveRevenue]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSRIncentiveRevenue](
	[EmployeeID] [varchar](10) NULL,
	[EmployeeStatus] [varchar](5) NULL,
	[Location_ID] [varchar](10) NOT NULL,
	[Location] [varchar](20) NULL,
	[Vehicle_Type_ID] [varchar](10) NULL,
	[CSR_Name] [varchar](25) NOT NULL,
	[Contract_In] [int] NULL,
	[Rental_Days] [decimal](9, 2) NULL,
	[Walk_Up] [int] NULL,
	[FPO] [int] NULL,
	[Up_sell] [decimal](9, 2) NULL,
	[Up_Sell_Walkup] [decimal](9, 2) NULL,
	[Additional_Driver_Charge] [decimal](9, 2) NULL,
	[All_Seats] [decimal](9, 2) NULL,
	[Driver_Under_Age] [decimal](9, 2) NULL,
	[All_Level_LDW] [decimal](9, 2) NULL,
	[PAI] [decimal](9, 2) NULL,
	[PEC] [decimal](9, 2) NULL,
	[Ski_Rack] [decimal](9, 2) NULL,
	[All_Dolly] [decimal](9, 2) NULL,
	[All_Gates] [decimal](9, 2) NULL,
	[Blanket] [decimal](9, 2) NULL,
	[Walk_Up_PO] [decimal](9, 2) NULL,
	[FPO_PO] [decimal](9, 2) NULL,
	[Up_sell_PO] [decimal](9, 2) NULL,
	[Additional_Driver_Charge_PO] [decimal](9, 2) NULL,
	[All_Seats_PO] [decimal](9, 2) NULL,
	[Driver_Under_Age_PO] [decimal](9, 2) NULL,
	[All_Level_LDW_PO] [decimal](9, 2) NULL,
	[PAI_PO] [decimal](9, 2) NULL,
	[PEC_PO] [decimal](9, 2) NULL,
	[Ski_Rack_PO] [decimal](9, 2) NULL,
	[All_Dolly_PO] [decimal](9, 2) NULL,
	[All_Gates_PO] [decimal](9, 2) NULL,
	[Blanket_PO] [decimal](9, 2) NULL,
 CONSTRAINT [PK_CSRIncentiveRevenue] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC,
	[CSR_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
