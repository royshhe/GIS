USE [GISData]
GO
/****** Object:  Table [dbo].[MOT_Report]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MOT_Report](
	[RBR_Date] [datetime] NOT NULL,
	[Contract_Number] [int] NULL,
	[First_name] [varchar](25) NULL,
	[Last_name] [varchar](25) NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NULL,
	[City] [varchar](20) NULL,
	[Province_State] [varchar](20) NULL,
	[Postal_Code] [varchar](10) NULL,
	[Phone_Number] [varchar](31) NULL,
	[Company_Name] [varchar](30) NULL,
	[Company_Phone_Number] [varchar](31) NULL,
	[Local_Phone_Number] [varchar](31) NULL,
	[Local_Address_1] [varchar](50) NULL,
	[Local_Address_2] [varchar](20) NULL,
	[Local_City] [varchar](20) NULL,
	[Pick_Up_On] [datetime] NOT NULL,
	[Actual_Check_in] [datetime] NULL,
	[PU_Location] [varchar](25) NOT NULL,
	[DO_Location] [varchar](25) NOT NULL,
	[Rental_Days] [numeric](35, 15) NULL,
	[TimeCharge] [decimal](38, 2) NULL,
	[Upgrade] [decimal](38, 2) NULL,
	[KMCharge] [decimal](38, 2) NULL,
	[DropOff_Charge] [decimal](38, 2) NULL,
	[FPO] [decimal](38, 2) NULL,
	[KPO] [decimal](38, 2) NULL,
	[Additional_Driver_Charge] [decimal](38, 2) NULL,
	[All_Seats] [decimal](38, 2) NULL,
	[Driver_Under_Age] [decimal](38, 2) NULL,
	[All_Level_LDW] [decimal](38, 2) NULL,
	[PAI] [decimal](38, 2) NULL,
	[PEC] [decimal](38, 2) NULL,
	[Ski_Rack] [decimal](38, 2) NULL,
	[All_Dolly] [decimal](38, 2) NULL,
	[All_Gates] [decimal](38, 2) NULL,
	[Blanket] [decimal](38, 2) NULL,
	[OutOfArea] [decimal](38, 2) NULL,
	[License_Recovery_fee] [decimal](38, 2) NULL,
	[Energy_Recovery_fee] [decimal](38, 2) NULL,
	[GPS] [decimal](38, 2) NULL,
	[Snow_Tire] [decimal](38, 2) NULL,
	[Fuel] [decimal](38, 2) NULL,
	[ELI] [decimal](38, 2) NULL,
	[Seat_Storage] [decimal](38, 2) NULL,
	[Location_Fee] [decimal](38, 2) NULL,
	[USB_Connector] [decimal](38, 2) NULL,
	[Sales_Accessory] [decimal](38, 2) NULL,
	[LossOfUse] [decimal](38, 2) NULL,
	[TollAdmin] [decimal](38, 2) NULL,
	[TrafficAdmin] [decimal](38, 2) NULL,
	[DamageAdmin] [decimal](38, 2) NULL,
	[Other] [decimal](38, 2) NULL,
	[NonApFeeItem] [decimal](38, 2) NULL,
	[TaxAmount] [decimal](38, 2) NULL,
	[PaymentAmount] [decimal](38, 2) NULL,
	[TotalCharge] [decimal](38, 2) NULL
) ON [PRIMARY]
GO
