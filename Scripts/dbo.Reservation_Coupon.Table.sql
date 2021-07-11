USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Coupon]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Coupon](
	[Coupon_Number] [varchar](50) NOT NULL,
	[Program_Name] [varchar](100) NULL,
	[Description_1] [varchar](150) NULL,
	[Description_2] [varchar](250) NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Terminate_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Reservation_Coupon] PRIMARY KEY CLUSTERED 
(
	[Coupon_Number] ASC,
	[Effective_Date] ASC,
	[Terminate_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
