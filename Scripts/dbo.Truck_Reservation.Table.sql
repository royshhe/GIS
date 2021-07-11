USE [GISData]
GO
/****** Object:  Table [dbo].[Truck_Reservation]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Truck_Reservation](
	[Order_Id] [varchar](20) NULL,
	[Order_Date] [varchar](50) NULL,
	[Order_Modified_Date] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Subtotal] [varchar](50) NULL,
	[Sales_Tax] [varchar](50) NULL,
	[Total] [varchar](50) NULL,
	[Discount_Amount] [varchar](50) NULL,
	[Discount_Rate] [varchar](50) NULL,
	[Credit_Card_Type] [varchar](50) NULL,
	[Card_Number] [varchar](50) NULL,
	[Expiration_Month] [varchar](50) NULL,
	[Expiration_Year] [varchar](50) NULL,
	[Name_on_Card] [varchar](50) NULL,
	[First_Name] [varchar](50) NULL,
	[Last_Name] [varchar](50) NULL,
	[Phone_Number] [varchar](50) NULL,
	[Drivers_Name] [varchar](50) NULL,
	[Drivers_Licence_No] [varchar](50) NULL,
	[Issuing_Province] [varchar](50) NULL,
	[Expiry_Date] [varchar](50) NULL,
	[Trip_Type] [varchar](50) NULL,
	[Pickup_City] [varchar](50) NULL,
	[Pickup_Location] [varchar](50) NULL,
	[Dropoff_Location] [varchar](50) NULL,
	[Pickup_Date] [varchar](50) NULL,
	[Pickup_Time] [varchar](50) NULL,
	[Dropoff_Date] [varchar](50) NULL,
	[Dropoff_Time] [varchar](50) NULL,
	[Use_Type] [varchar](50) NULL,
	[Pickup_Dropoff_Same] [varchar](50) NULL,
	[Truck_Selected] [varchar](50) NULL,
	[Extra_Mileage_Amount] [varchar](50) NULL,
	[Base_Days] [varchar](50) NULL,
	[Base_Rate] [varchar](50) NULL,
	[Base_Rate_Desc] [varchar](50) NULL,
	[Confirmation_Code] [varchar](50) NULL,
	[Provincial_Road_Fee] [varchar](50) NULL,
	[Recovery_Fee] [varchar](50) NULL,
	[Deposit_Amount] [varchar](50) NULL,
	[Supplies] [varchar](80) NULL
) ON [PRIMARY]
GO
