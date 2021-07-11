USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_18_AirMiles_Submission_Auditing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












CREATE PROCEDURE [dbo].[RP_SP_Acc_18_AirMiles_Submission_Auditing] --'2007-02-01','2007-02-04', 16
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001',	
	@paramPickUpLocationID varchar(20) = '*'
)
AS
--convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	


-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 

-- end of fixing the problem

/*

SELECT     dbo.Air_Miles_EFT_Detail.RBR_Date, dbo.Location.Location, dbo.Air_Miles_EFT_Detail.Invoice_Number, dbo.Contract.Last_Name, 
                      dbo.Contract.First_Name, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, dbo.Air_Miles_EFT_Detail.Card_Number, 
                      dbo.Air_Miles_Card.Last_Name AS Card_Holder_Last_Name, dbo.Air_Miles_Card.First_Name AS Card_Holder_First_Name, 
                      dbo.Air_Miles_EFT_Detail.Sales_Amount, CEILING(DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) 
                      / 1440.00) AS LengthOfRental,  dbo.Contract.AM_Coupon_Code, dbo.Air_Miles_EFT_Detail.Base_Offer_Code, dbo.Air_Miles_EFT_Detail.Standard_Mile_Points, 
                      dbo.Air_Miles_EFT_Detail.Bonus_Offer_Code, dbo.Air_Miles_EFT_Detail.Bonus_Miles,(dbo.Air_Miles_EFT_Detail.Standard_Mile_Points+dbo.Air_Miles_EFT_Detail.Bonus_Miles) as Total_Miles_Credited, dbo.Air_Miles_EFT_Detail.AMTM_Tran_Type
FROM         dbo.Contract INNER JOIN
                      dbo.Air_Miles_EFT_Detail ON dbo.Contract.Contract_Number = CONVERT(int, dbo.Air_Miles_EFT_Detail.Invoice_Number) INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID AND 
                      dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID LEFT OUTER JOIN
                      dbo.Air_Miles_Card ON dbo.Air_Miles_EFT_Detail.Card_Number = dbo.Air_Miles_Card.CARD_number
*/


-- Using the same Rental Days when calculating the Air Mile Points
SELECT     dbo.Air_Miles_EFT_Detail.RBR_Date, dbo.Location.Location, dbo.Air_Miles_EFT_Detail.Invoice_Number, dbo.Contract.Last_Name, 
                      dbo.Contract.First_Name, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, dbo.Air_Miles_EFT_Detail.Card_Number, 
                      dbo.Air_Miles_Card.Last_Name AS Card_Holder_Last_Name, dbo.Air_Miles_Card.First_Name AS Card_Holder_First_Name, 
                      dbo.Air_Miles_EFT_Detail.Sales_Amount, dbo.Contract_Rental_Days_vw.Rental_Day AS LengthOfRental, dbo.Contract.AM_Coupon_Code, 
                      dbo.Air_Miles_EFT_Detail.Base_Offer_Code, dbo.Air_Miles_EFT_Detail.Standard_Mile_Points, dbo.Air_Miles_EFT_Detail.Bonus_Offer_Code, 
                      dbo.Air_Miles_EFT_Detail.Bonus_Miles, 
                      dbo.Air_Miles_EFT_Detail.Standard_Mile_Points + dbo.Air_Miles_EFT_Detail.Bonus_Miles AS Total_Miles_Credited, 
                      dbo.Air_Miles_EFT_Detail.AMTM_Tran_Type
FROM         	dbo.Contract 
		INNER JOIN dbo.Air_Miles_EFT_Detail 
			ON dbo.Contract.Contract_Number = CONVERT(int, dbo.Air_Miles_EFT_Detail.Invoice_Number) 
		INNER JOIN  dbo.RP__Last_Vehicle_On_Contract 
			ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number 
		INNER JOIN dbo.Contract_Rental_Days_vw 
			ON dbo.Contract.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number 
		INNER JOIN dbo.Location 
			ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 
		LEFT OUTER JOIN dbo.Air_Miles_Card 
			ON dbo.Air_Miles_EFT_Detail.Card_Number = dbo.Air_Miles_Card.CARD_number


where  dbo.Air_Miles_EFT_Detail.RBR_Date BETWEEN @startBusDate AND @endBusDate  and	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = dbo.Location.Location_ID)

--order by dbo.Air_Miles_EFT_Detail.RBR_Date, dbo.Location.Location, dbo.Air_Miles_EFT_Detail.Invoice_Number

Union 

SELECT     AMDetail.RBR_Date, dbo.Location.Location, AMDetail.Invoice_Number, dbo.Contract.Last_Name, dbo.Contract.First_Name, dbo.Contract.Pick_Up_On, 
                      dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, AMDetail.Card_Number, dbo.Air_Miles_Card.Last_Name AS Card_Holder_Last_Name, 
                      dbo.Air_Miles_Card.First_Name AS Card_Holder_First_Name, AMDetail.Sales_Amount, dbo.Contract_Rental_Days_vw.Rental_Day AS LengthOfRental, 
                      dbo.Contract.AM_Coupon_Code, AMDetail.Base_Offer_Code, AMDetail.Standard_Mile_Points, AMDetail.Bonus_Offer_Code, AMDetail.Bonus_Miles, 
                      AMDetail.Standard_Mile_Points + AMDetail.Bonus_Miles AS Total_Miles_Credited, AMDetail.AMTM_Tran_Type
FROM         dbo.Contract INNER JOIN
                      dbo.Air_Miles_EFT_Detail_NCR AS AMDetail ON dbo.Contract.Contract_Number = CONVERT(int, AMDetail.Invoice_Number) INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Contract_Rental_Days_vw ON dbo.Contract.Contract_Number = dbo.Contract_Rental_Days_vw.Contract_Number INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID LEFT OUTER JOIN
                      dbo.Air_Miles_Card ON AMDetail.Card_Number = dbo.Air_Miles_Card.CARD_number



where  AMDetail.RBR_Date BETWEEN @startBusDate AND @endBusDate  and	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = dbo.Location.Location_ID)

order by  RBR_Date,  Location,  Invoice_Number


GO
