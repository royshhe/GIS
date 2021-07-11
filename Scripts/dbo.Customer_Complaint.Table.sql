USE [GISData]
GO
/****** Object:  Table [dbo].[Customer_Complaint]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_Complaint](
	[Complaint_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Complaint_Category] [char](2) NULL,
	[Complaint_Date] [datetime] NULL,
	[Contract_Number] [int] NULL,
	[Origin] [varchar](50) NULL,
	[Refund_Amount] [decimal](9, 2) NULL,
	[Issue] [varchar](800) NULL,
	[Resolution] [varchar](500) NULL,
 CONSTRAINT [PK_Customer_Complaint] PRIMARY KEY CLUSTERED 
(
	[Complaint_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
