USE [Warehouse]
GO

/****** Object:  View [dbo].[iTxTissueRequestTroubleshooting]    Script Date: 8/5/2015 4:41:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
01 - Missing processing fee
02 - EK processing fee error
03 - DMEK processing fee error
04 - IEK processing fee error
05 - IEALK processing fee error
06 - DMAEK processing fee error
07 - Shipping fee is missing or duplicate
08 - Should not have shipping fee for Kaiser North
09 - UCI tissue fee should be 2950
10 - Over Jules Stein fee limit.  Adjust tissue fee to reach limit
11 - Over Jules Stein fee limit.  Adjust tissue fee to reach limit
12 - Over Jules Stein fee limit.  Adjust tissue fee to reach limit
13 - TDC tissue fee should be 2800
14 - Outcome and Intended Outcome not matching.
15 - Outcome Detail and Intended Outcome Detail not matching.
16 - Tissue discarded, check to see if tissue fee should be charged
17 - Surgery Location is blank
18 - Intended Outcome Detail is blank
19 - Tissue fee  is blank (if gratis must enter 0)
20 - Data needs to be removed from "fee adjustment"  field


2015_07_17 Rule '25 - Halo tissue OutcomeDetail/SurgeryLocationName does not match SurgeryLocationName/OutcomeDetail' was added for new halo contract.
2015_07_15 'Halo Preservation - LVG' was added to exclude halo tissue from this rule'19 - Tissue fee is blank (if gratis must enter 0)'

1*/
ALTER VIEW [dbo].[iTxTissueRequestTroubleshooting]
AS
    SELECT TOP ( 100 ) PERCENT
        srET.TissueIdentifier
       ,Errors.RequestIdentifier
       ,Errors.SurgeryLocationName
       ,srET.RequiredOn
       ,LEFT(srET.RequiredOn, 3) AS Month
       ,srET.RequestComments
       ,BC.BillingComment
       ,CASE WHEN sret.requestcomments LIKE '%#reviewed%' THEN 'Reviewed'
             WHEN ( CHARINDEX('dummy', srET.RequestComments) > 0 )
                  AND ( CHARINDEX('request', srET.RequestComments) > 0 )
                  AND sret.requestcomments NOT LIKE '%#reviewed%'
             THEN 'Dummy Request'
             ELSE 'Normal'
        END AS [Dummy Request]
       ,Errors.ERROR
    FROM
        (
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( PreCutRequested = 1
                        AND ProcessingFee IS NULL
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      ) THEN '01 - Processing Fee Blank'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( ( IntendedSubOutcome ) = 'Local - Kaiser North'
                        OR ( IntendedSubOutcome ) = 'Local - Kaiser South'
                      )
                      AND RequiredOn >= CONVERT(DATETIME, '2/1/2014')
                      AND ( (PreCutRequestedType = 'EK'
                            AND RequestType = 'Surgery'
                            AND NOT ( ProcessingFee = 750.00 )
                            AND NOT ( RequestStatus = 'Cancelled'
                                      OR RequestStatus = 'Returned'
                                    ))
                          ) THEN '02 - EK processing fee error'
                 WHEN ( IntendedSubOutcome ) = 'International'
                      AND RequiredOn >= CONVERT(DATETIME, '2/1/2014')
                      AND RequiredOn < CONVERT(DATETIME, '4/1/2014')
                      AND ( (PreCutRequestedType = 'EK'
                            AND RequestType = 'Surgery'
                            AND NOT ( ProcessingFee = 750.00 )
                            AND NOT ( RequestStatus = 'Cancelled'
                                      OR RequestStatus = 'Returned'
                                    ))
                          ) THEN '02 - EK processing fee error'
                 WHEN ( ( IntendedSubOutcome ) = 'Japan - Class A'
                        OR ( IntendedSubOutcome ) = 'Japan - Class B'
                      )
                      AND RequiredOn >= CONVERT(DATETIME, '3/1/2014')
                      AND ( (PreCutRequestedType = 'EK'
                            AND RequestType = 'Surgery'
                            AND NOT ( ProcessingFee = 950.00 )
                            AND NOT ( RequestStatus = 'Cancelled'
                                      OR RequestStatus = 'Returned'
                                    ))
                          ) THEN '02 - EK processing fee error'
                 WHEN ( ( ISNULL(IntendedSubOutcome, '') ) != 'Local - Kaiser North'
                        AND ( ISNULL(IntendedSubOutcome, '') ) != 'Local - Kaiser South'
                        AND ( ISNULL(IntendedSubOutcome, '') ) != 'Japan - Class A'
                        AND ( ISNULL(IntendedSubOutcome, '') ) != 'Japan - Class B'
                        AND ( ISNULL(IntendedSubOutcome, '') ) != 'International'
                      )
                      AND RequiredOn >= CONVERT(DATETIME, '2/1/2014')
                      AND PreCutRequestedType = 'EK'
                      AND RequestType = 'Surgery'
                      AND NOT ( ProcessingFee = 950.00 )
                      AND NOT ( RequestStatus = 'Cancelled'
                                OR RequestStatus = 'Returned'
                              ) THEN '02 - EK processing fee error'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_19
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( PreCutRequestedType = 'DMEK'
                        AND NOT ( ProcessingFee = 950.00 )
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      ) THEN '03 - DMEK processing fee error'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_18
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( PreCutRequestedType = 'IEK'
                        AND NOT ( ProcessingFee = 1200.00 )
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      ) THEN '04 - IEK processing fee error'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_17
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( PreCutRequestedType = 'IEALK'
                        AND NOT ( ProcessingFee = 1200.00 )
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      ) THEN '05 - IEALK processing fee error'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_16
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( PreCutRequestedType = 'DMAEK'
                        AND NOT ( ProcessingFee = 1200.00 )
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      ) THEN '06 - DMAEK processing fee error'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_15
          UNION
          SELECT
            ship.SurgeryLocationName
           ,'07 - Shipping fee is missing or duplicate' AS ERROR
           ,ship.RequestIdentifier
          FROM
            SIGHTLIFE.Data.ShipmentRequestInventory AS ship
            LEFT OUTER JOIN (
                              SELECT
                                COUNT(ShippingFee) AS countof
                               ,SUM(ShippingFee) AS sumof
                               ,ShipmentId
                              FROM
                                SIGHTLIFE.Data.ShipmentRequestInventory AS sri
                              WHERE
                                ( ShipmentItemId NOT IN (
                                  SELECT
                                    Id
                                  FROM
                                    SIGHTLIFE.EyeDist.ShipmentItem
                                  WHERE
                                    ( DeletedBy IS NOT NULL ) ) )
                                AND ( TissueTypeRequested = 'CN' )
                                AND ( RecoveryTissueType = 'Cornea' )
                                AND ( TissueSubTypeRequested = 'WCN' )
                                AND ( IntendedSubOutcome = 'Japan - Class A'
                                      OR IntendedSubOutcome = 'Japan - Class B'
                                    )
                                AND ( RequestType = 'Surgery' )
                                AND ( NOT ( RequestStatus = 'Cancelled'
                                            OR RequestStatus = 'Returned'
                                          )
                                    )
                              GROUP BY
                                ShipmentId
                            ) AS a_1 ON ship.ShipmentId = a_1.ShipmentId
          WHERE
            ( ship.ShipmentPurpose = 'Request Fulfillment' )
            AND ( ship.ShipmentDeletedOn IS NULL )
            AND ( a_1.sumof > 250 )
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( TissueTypeRequested = 'CN'
                        AND TissueSubTypeRequested = 'WCN'
                        AND IntendedSubOutcome = 'Local - Kaiser North'
                        AND NOT ( ShippingFee = 0
                                  OR ShippingFee IS NULL
                                )
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      )
                 THEN '08 - Should not have shipping fee for Kaiser North'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_13
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( TissueTypeRequested = 'CN'
                        AND TissueSubTypeRequested = 'WCN'
                        AND SurgeryLocationName IN (
                        'University of California - Irvine',
                        'Gavin Herbert Eye Institute' )
                        AND NOT ( TissueFee = 3150 )
                        AND RequestType = 'Surgery'
                        AND PreCutRequestedType = 'EK'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                        AND RequiredOn >= CONVERT(DATETIME, '2/12/2015')
                      ) THEN '09 - UCI tissue fee should be 3150'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_12
          WHERE
            ( TissueTypeRequested = 'CN' )
            AND ( TissueSubTypeRequested = 'WCN' )
            AND ( SurgeryLocationName IN ( 'University of California - Irvine',
                                           'Gavin Herbert Eye Institute' ) )
            AND ( NOT ( TissueFee = 3150 )
                )
            AND ( RequestType = 'Surgery' )
            AND ( PreCutRequestedType = 'EK' )
            AND ( NOT ( RequestStatus = 'Cancelled'
                        OR RequestStatus = 'Returned'
                      )
                )
            AND ( RequiredOn >= CONVERT(DATETIME, '2/12/2015') )
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( TissueTypeRequested = 'CN'
                        AND TissueSubTypeRequested = 'WCN'
                        AND SurgeryLocationName = 'Jules Stein Eye Institute, UCLA'
                        AND NOT ( PreCutRequested = 1 )
                        AND TotalFee > 3100.00
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      )
                 THEN '10 - Over Jules Stein fee limit. Adjust tissue fee to reach limit'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_11
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( TissueTypeRequested = 'CN'
                        AND TissueSubTypeRequested = 'WCN'
                        AND SurgeryLocationName = 'Jules Stein Eye Institute, UCLA'
                        AND PreCutRequestedType = 'EK'
                        AND TotalFee > 3800.00
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      )
                 THEN '11 - Over Jules Stein fee limit. Adjust tissue fee to reach limit'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_10
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( TissueTypeRequested = 'CN'
                        AND TissueSubTypeRequested = 'WCN'
                        AND SurgeryLocationName = 'Jules Stein Eye Institute, UCLA'
                        AND ( PreCutRequestedType = 'IEK'
                              OR PreCutRequestedType = 'IEALK'
                            )
                        AND TotalFee > 4100.00
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      )
                 THEN '12 - Over Jules Stein fee limit. Adjust tissue fee to reach limit'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_9
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( TissueTypeRequested = 'CN'
                        AND TissueSubTypeRequested = 'WCN'
                        AND SurgeryLocationName = 'Tokyo Dental College'
                        AND NOT ( TissueFee = 2800 )
                        AND RequestType = 'Surgery'
                        AND NOT ( RequestStatus = 'Cancelled'
                                  OR RequestStatus = 'Returned'
                                )
                      ) THEN '13 - TDC tissue fee should be 2800'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_8
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN RequestStatus = 'Shipped'
                      AND NOT ( ISNULL(Outcome, '') = 'Discarded' )
                      AND NOT ( ISNULL(IntendedOutcome, 'NULL') = ISNULL(Outcome,
                                                              'NULL') )
                 THEN '14 - Outcome and Intended Outcome not matching'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_7
          WHERE
            ( RequestStatus = 'Shipped' )
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN RequestStatus = 'Shipped'
                      AND NOT ( ISNULL(Outcomedetail, '') = 'Off-site' )
                      AND NOT ( ISNULL(IntendedSubOutcome, 'NULL') = ISNULL(OutcomeDetail,
                                                              'NULL') )
                 THEN '15 - Outcome and Intended Sub Outcome not matching'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_6
          WHERE
            ( RequestStatus = 'Shipped' )
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN Outcome = 'Discarded'
                      AND NOT ( TissueFee = 0
                                OR TissueFee IS NULL
                              )
                 THEN '16 - Tissue discarded, check to see if tissue fee should be charged'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_5
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN SurgeryLocationName IS NULL
                      AND RequestType = 'Surgery'
                      AND NOT ( RequestStatus = 'Cancelled'
                                OR RequestStatus = 'Returned'
                              ) THEN '17 - Surgery Location is blank'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_4
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN IntendedSubOutcome IS NULL
                      AND RequestType = 'Surgery'
                      AND NOT ( RequestStatus = 'Cancelled'
                                OR RequestStatus = 'Returned'
                              ) THEN '18 - Intended Outcome Detail is blank'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_3
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN TissueFee IS NULL
                      AND RequestType = 'Surgery'
                      AND NOT ( RequestStatus = 'Cancelled'
                                OR RequestStatus = 'Returned'
                              )
                      AND NOT ( SurgeryLocationName IN (
                                'Glycerin Preserved - Sightlife',
                                'Halo Preservation - LVG' ) ) -- 2015_07_15 'Halo Preservation - LVG' was added to exclude halo tissue from this rule.
                      THEN '19 - Tissue fee is blank (if gratis must enter 0)'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_2
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN NOT ( FeeAdjustment IS NULL
                            OR FeeAdjustment = 0
                          )
                      AND RequestType = 'Surgery'
                      AND NOT ( RequestStatus = 'Cancelled'
                                OR RequestStatus = 'Returned'
                              )
                 THEN '20 - Data needs to be removed from the "fee adjustment" field'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_1
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( DATEDIFF(D, DeathOn, RequiredOn) < 0 )
                      AND RequestType = 'Surgery'
                      AND RecoveryTissueType = 'Cornea'
                      AND RecoveryTissueSubtype = 'Whole'
                 THEN '21a - Death to surgery days is negative'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_20
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( DATEDIFF(D, DeathOn, RequiredOn) > 20 )
                      AND RequestType = 'Surgery'
                      AND RecoveryTissueType = 'Cornea'
                      AND RecoveryTissueSubtype = 'Whole'
                 THEN '21b - Death to surgery days is greater than 20.'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_20
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( RequestType = 'Surgery'
                        AND SurgeryLocationName IS NULL
                      )
                      OR ( RequestType = 'Research'
                           AND ResearchLocationName IS NULL
                         ) THEN '22 - Surgery or Research Location is blank.'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_21
          UNION
          SELECT
            SurgeryLocationName
           ,CASE WHEN ( EyebankFollowUp IS NULL )
                      AND outcome = 'Transplant'
                 THEN '23 - Sightlife responsible for follow-up is blank'
            END AS ERROR
           ,RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS iTxShipRequestET_22
          UNION
          SELECT
            a.SurgeryLocationName
           ,CASE WHEN SurgeryLocationShortName = 'osi'
                      AND Outcome = 'Transplant'
                      AND RecoveryTissueType = 'Cornea'
                      AND RecoveryTissueSubtype = 'Whole'
                      AND ShippingFee != '50.00'
                      AND b.ShipOnActual >= '8/21/2014'
                 THEN '24 -OSI $50 shipping fee.'
            END AS error
           ,a.RequestIdentifier
          FROM
            dbo.iTxShipRequestET AS a
            LEFT OUTER JOIN (
                              SELECT
                                RequestId
                               ,RequestIdentifier
                               ,ShipmentId
                               ,ShipOnActual
                               ,IsDeleted
                              FROM
                                SIGHTLIFE.Data.ShipmentRequestInventory
                              WHERE
                                ( ShipmentItemId NOT IN (
                                  SELECT
                                    Id
                                  FROM
                                    SIGHTLIFE.EyeDist.ShipmentItem AS ShipmentItem_1
                                  WHERE
                                    ( DeletedOn IS NOT NULL ) ) )
                                AND ( SurgeryLocationShortName = 'osi' )
                                AND ( ShipmentPurpose = 'Request Fulfillment' )
                                AND ( ShipmentDeletedOn IS NULL )
                            ) AS b ON a.RequestIdentifier = b.RequestIdentifier
          UNION
			/*2015_07_17 Rule '25 - Halo tissue OutcomeDetail/SurgeryLocationName does not match SurgeryLocationName/OutcomeDetail' was added to ensure that the Outcome Detail and Surgery Location Name were appropriate for halo tissue.*/
          SELECT
            iTxShipRequestET.SurgeryLocationName
           ,CASE WHEN ( iTxShipRequestET.OutcomeDetail = 'TempOutcomeB'
                        AND ISNULL(iTxShipRequestET.SurgeryLocationName, '') != 'Halo Preservation - LVG'
                      )
                      OR ( ISNULL(iTxShipRequestET.OutcomeDetail, '') != 'TempOutcomeB'
                           AND iTxShipRequestET.SurgeryLocationName = 'Halo Preservation - LVG'
                         )
                 THEN '25 - Halo tissue OutcomeDetail/SurgeryLocationName does not match SurgeryLocationName/OutcomeDetail'
            END AS Error
           ,iTxShipRequestET.RequestIdentifier
          FROM
            dbo.iTxShipRequestET
          WHERE
            ( iTxShipRequestET.OutcomeDetail = 'TempOutcomeB'
              AND ISNULL(iTxShipRequestET.SurgeryLocationName, '') != 'Halo Preservation - LVG'
            )
            OR ( ISNULL(iTxShipRequestET.OutcomeDetail, '') != 'TempOutcomeB'
                 AND iTxShipRequestET.SurgeryLocationName = 'Halo Preservation - LVG'
               )
        ) AS Errors
        LEFT OUTER JOIN dbo.iTxShipRequestET AS srET ON Errors.RequestIdentifier = srET.RequestIdentifier
        LEFT OUTER JOIN SIGHTLIFE.EyeDist.Request AS BC ON Errors.RequestIdentifier = BC.Identifier
    WHERE
        ( NOT ( Errors.SurgeryLocationName = 'Glycerin Preserved - Sightlife' )
        )
        AND ( Errors.ERROR IS NOT NULL )
        OR ( Errors.SurgeryLocationName IS NULL )
        AND ( Errors.ERROR IS NOT NULL )
    ORDER BY
        Errors.ERROR


GO


