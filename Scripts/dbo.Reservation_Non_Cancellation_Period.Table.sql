USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Non_Cancellation_Period]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Non_Cancellation_Period](
	[Time_Period_id] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [int] NULL,
	[Vehicle_Class_Code] [char](1) NULL,
	[Valid_From] [datetime] NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Reservation_No_Cancellation_Period] PRIMARY KEY CLUSTERED 
(
	[Time_Period_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
