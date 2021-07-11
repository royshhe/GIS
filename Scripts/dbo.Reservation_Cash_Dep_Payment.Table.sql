USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Cash_Dep_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Cash_Dep_Payment](
	[Confirmation_Number] [int] NOT NULL,
	[Collected_On] [datetime] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Cash_Payment_Type] [varchar](20) NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Foreign_Currency_Amt_Collected] [decimal](9, 2) NOT NULL,
	[Exchange_Rate] [decimal](9, 4) NULL,
	[Identification_Number] [varchar](20) NULL,
	[Authorization_Number] [varchar](12) NULL,
	[Swiped_Flag] [bit] NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Trx_Receipt_Ref_Num] [char](20) NULL,
	[Trx_ISO_Response_Code] [char](2) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Reservation_Cash_Dep_Paymnt] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Collected_On] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
