USE [GISData]
GO
/****** Object:  Table [dbo].[Truck_Reservation_Rate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Truck_Reservation_Rate](
	[Truck_Reservation_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Pickup_Location_ID] [int] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Trip_Type] [varchar](50) NOT NULL,
	[Pickup_Time_Block] [char](5) NOT NULL,
	[Dropoff_Time_Block] [char](5) NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NULL,
 CONSTRAINT [PK_Truck_Reservation_Rate] PRIMARY KEY CLUSTERED 
(
	[Truck_Reservation_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
