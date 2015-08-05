USE [Warehouse]
GO

/****** Object:  View [dbo].[NOKLetterType]    Script Date: 8/5/2015 4:43:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[NOKLetterType]
AS
    /*2015-07-15 added logic to glycerin letter type to incorperate halo tissue*/
  SELECT DISTINCT
    case_indicators.CaseFileIdentifier
   ,ref.Name
   ,CASE WHEN [NA Tissue Partner Follow Up Case] = 1
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'N/A -LADS/LEBLI'
         WHEN [Serology Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Positive Serology'
         WHEN [Serology Case] = 0
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Discard Case] = 1
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Discard Letter'
         WHEN [Serology Case] = 0
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [FS Response Blank Case] = 1
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN ''
         WHEN [Cornea Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Transplant Letter'
         WHEN [Glycerin Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Pending Total Case] = 0
              AND [Cornea Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Glycerin Letter'
         WHEN [Sclera Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Glycerin Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Pending Total Case] = 0
              AND [Cornea Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Sclera Letter'
         WHEN [NSFT Research Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Case] = 0
              AND [Glycerin Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL
         THEN 'Not Suitable for Transplant Letter (NSFT) - Research and Training'
         WHEN [Research/Training Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Case] = 0
              AND [Glycerin Case] = 0
              AND [Sclera Case] = 0
              AND [NSFT Research Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL
         THEN 'Research/Training Letter'
         WHEN [Discard Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Case] = 0
              AND [Glycerin Case] = 0
              AND [Sclera Case] = 0
              AND [Cornea Pending Total Case] = 0
              AND [NSFT Research Case] = 0
              AND [Research/Training Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Discard Letter'
         WHEN [CBNR Consent Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND ref.cbnrfollowup__C = 'Notified'
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'CBNR – Notified'
         WHEN [CBNR Consent Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND ref.cbnrfollowup__C = 'Not Notified'
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'CBNR – Not Notified'
         WHEN [CBNR Consent Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND ref.cbnrfollowup__C = 'Rule Out'
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'N/A'
         WHEN [CBNR Consent Case] = 1
              AND [NA Tissue Partner Follow Up Case] = 0
              AND ref.cbnrfollowup__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN ''
         WHEN [CBNR Consent Case] = 0
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Case] = 0
              AND [Glycerin Case] = 0
              AND [Sclera Case] = 0
              AND [NSFT Research Case] = 0
              AND [Research/Training Case] = 0
              AND [Discard Case] = 0
              AND [Not Recovered/Not Suitable/Statline R/O] = 0
              AND [CBNR Consent Case] = 0
              AND [Pending Case] = 1
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Pending Letter Type'
         WHEN [CBNR Consent Case] = 0
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND ( ( [Discard Case] = 1
                      OR [Cornea Case] = 1
                      OR [Glycerin Case] = 1
                      OR [Sclera Case] = 1
                    )
                    AND [Cornea Pending Total Case] = 1
                  )
              AND [NSFT Research Case] = 0
              AND [Research/Training Case] = 0
              AND [Not Recovered/Not Suitable/Statline R/O] = 0
              AND [CBNR Consent Case] = 0
              AND [Pending Case] = 1
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Pending Letter Type'
         WHEN [CBNR Consent Case] = 0
              AND [NA Tissue Partner Follow Up Case] = 0
              AND [Serology Case] = 0
              AND [Serology Discard Case] = 0
              AND [FS Response Blank Case] = 0
              AND [Cornea Pending Total Case] = 1
              AND [NSFT Research Case] = 0
              AND [Research/Training Case] = 0
              AND [Not Recovered/Not Suitable/Statline R/O] = 0
              AND [CBNR Consent Case] = 0
              AND [Pending Case] = 0
              AND fs_follow_up_exceptions__C IS NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'Pending Letter Type'
         WHEN [Not Recovered/Not Suitable/Statline R/O] = 1
              AND [CBNR Consent Case] = 0
              AND [NA Tissue Partner Follow Up Case] = 0
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'N/A'
         WHEN fs_follow_up_exceptions__C IS NOT NULL
              AND ISNULL(Custom_Letter_Needed__c, '') != 1
              AND fso.casefileidentifier IS NULL THEN 'N/A'
         WHEN Custom_Letter_Needed__c = 1
              AND fso.casefileidentifier IS NULL THEN 'Custom Letter'
         WHEN fso.casefileidentifier IS NOT NULL THEN 'Audit'
         ELSE 'LETTER TYPE UNKNOWN'
    END AS LetterType
   ,case_indicators.[Cornea Case]
   ,case_indicators.[Glycerin Case]
   ,case_indicators.[Sclera Case]
   ,case_indicators.[Serology Case]
   ,case_indicators.[CBNR Consent Case]
   ,case_indicators.[NSFT Research Case]
   ,case_indicators.[Research/Training Case]
   ,case_indicators.[Discard Case]
   ,case_indicators.[Other Transplant Case]
   ,case_indicators.[Not Recovered/Not Suitable/Statline R/O]
   ,case_indicators.[FS Response Blank Case]
   ,case_indicators.[Serology Discard Case]
   ,case_indicators.[Pending Case]
   ,case_indicators.[NA Tissue Partner Follow Up Case]
   ,case_indicators.[Cornea Pending Total Case]
   ,max_dates.max_most_recent_date
   ,ref.CBNRFollowUp__c
   ,ref.Custom_Letter_Needed__c
  FROM
    (
      SELECT
        CaseFileIdentifier
       ,[Cornea Case]
       ,[Glycerin Case]
       ,[Sclera Case]
       ,[Serology Case]
       ,[CBNR Consent Case]
       ,[NSFT Research Case]
       ,[Research/Training Case]
       ,[Discard Case]
       ,[Other Transplant Case]
       ,[Not Recovered/Not Suitable/Statline R/O]
       ,[FS Response Blank Case]
       ,[Serology Discard Case]
       ,[Pending Case]
       ,[NA Tissue Partner Follow Up Case]
       ,[Cornea Pending Total Case]
      FROM
        (
          SELECT
            CaseFileIdentifier
           ,sclera_total
           ,glycerin_total
           ,cornea_total
           ,other_total
           ,CASE WHEN cornea_total > 0 THEN 1
                 ELSE 0
            END AS [Cornea Case]
           ,CASE WHEN glycerin_total > 0 THEN 1
                 ELSE 0
            END AS [Glycerin Case]
           ,CASE WHEN sclera_total > 0 THEN 1
                 ELSE 0
            END AS [Sclera Case]
           ,CASE WHEN pos_serology_total > 0 THEN 1
                 ELSE 0
            END AS [Serology Case]
           ,CASE WHEN CBNR_CONSENT_total > 0 THEN 1
                 ELSE 0
            END AS [CBNR Consent Case]
           ,CASE WHEN pos_serology_fs_blank_total > 0 THEN 1
                 ELSE 0
            END AS [FS Response Blank Case]
           ,CASE WHEN pos_serology_discard_total > 0 THEN 1
                 ELSE 0
            END AS [Serology Discard Case]
           ,CASE WHEN NSFT_RESEARCH_total > 0 THEN 1
                 ELSE 0
            END AS [NSFT Research Case]
           ,CASE WHEN research_training_total > 0 THEN 1
                 ELSE 0
            END AS [Research/Training Case]
           ,CASE WHEN discard_total > 0 THEN 1
                 ELSE 0
            END AS [Discard Case]
           ,CASE WHEN other_total > 0 THEN 1
                 ELSE 0
            END AS [Other Transplant Case]
           ,CASE WHEN not_recovered_total > 0 THEN 1
                 ELSE 0
            END AS [Not Recovered/Not Suitable/Statline R/O]
           ,CASE WHEN pending_total > 0 THEN 1
                 ELSE 0
            END AS [Pending Case]
           ,CASE WHEN NA_TissuePartnerFollowUp_total > 0 THEN 1
                 ELSE 0
            END AS [NA Tissue Partner Follow Up Case]
           ,CASE WHEN cornea_pending_total > 0 THEN 1
                 ELSE 0
            END AS [Cornea Pending Total Case]
          FROM
            (
              SELECT
                CaseFileIdentifier
               ,SUM(glycerin_Transplant) AS glycerin_total
               ,SUM(cornea_Transplant) AS cornea_total
               ,SUM(sclera_Transplant) AS sclera_total
               ,SUM(other_Transplant) AS other_total
               ,SUM(pos_serology) AS pos_serology_total
               ,SUM(CBNR_CONSENT) AS CBNR_CONSENT_total
               ,SUM(NSFT_RESEARCH) AS NSFT_RESEARCH_total
               ,SUM(research_training) AS research_training_total
               ,SUM(discard) AS discard_total
               ,SUM(not_recovered) AS not_recovered_total
               ,SUM(pos_serology_fs_blank) AS pos_serology_fs_blank_total
               ,SUM(pos_serology_discard) AS pos_serology_discard_total
               ,SUM(pending) AS pending_total
               ,SUM(NA_TissuePartnerFollowUp) AS NA_TissuePartnerFollowUp_total
               ,SUM(cornea_pending) AS cornea_pending_total
              FROM
                (
                  SELECT
                    CASE WHEN RecoveryTissueType = 'Cornea'
                              AND ( RecoveryTissueSubtype LIKE '%Glycerin%'
                                    OR outcomedetail = 'tempoutcomeb'
                                  ) /*2015-07-15 The outcomedetail = tempoutcomeb was added to include halo tissue. This will make halo tissue categorize as a glycerin letter if both tissue are halo tissue.*/
                              AND EyeOutcomeDetail = 'Transplant'
                              AND ( Outcome = 'Transplant'
                                    OR Outcome IS NULL
                                  ) THEN 1
                         ELSE 0
                    END AS glycerin_Transplant
                   ,CASE WHEN RecoveryTissueType = 'Cornea'
                              AND RecoveryTissueSubtype = 'Whole'
                              AND EyeOutcomeDetail = 'Transplant'
                              AND Outcome = 'Transplant'
                              AND SurgeryLocationName NOT IN (
                              'Glycerin Preserved - Sightlife',
                              'Halo Preservation - LVG' /*2015-07-15 The surgery location = 'Halo Perservation - LVG' was added to include halo tissue. This will make halo tissue categorize as a glycerin letter if both tissue are halo tissue.*/
							  ) THEN 1
                         ELSE 0
                    END AS cornea_Transplant
                   ,CASE WHEN OPT.RecoveryTissueType = 'Cornea'
                              AND RecoveryTissueSubtype = 'Whole'
                              AND ( outcome IS NULL
                                    OR ( outcome = 'Transplant'
                                         AND SurgeryLocationName IN (
                                         'Glycerin Preserved - Sightlife' )
                                       )
                                  ) THEN 1
                         ELSE 0
                    END AS cornea_pending
                   ,CASE WHEN RecoveryTissueType = 'Sclera'
                              AND EyeOutcomeDetail = 'Transplant'
                              AND ( Outcome = 'Transplant'
                                    OR Outcome IS NULL
                                  ) THEN 1
                         ELSE 0
                    END AS sclera_Transplant
                   ,CASE WHEN RecoveryTissueType IN ( 'Lens', 'Other',
                                                      'Whole Globe' )
                              AND EyeOutcomeDetail = 'Transplant'
                              AND ( Outcome = 'Transplant'
                                    OR Outcome IS NULL
                                  ) THEN 1
                         ELSE 0
                    END AS other_Transplant
                   ,CASE WHEN Confirmed_Positive_Serology_Present__c = 1
                              AND Family_Services_Response_Type__c = 'Next of Kin in Close Proximity: Positive Serology Letter Sent'
                         THEN 1
                         ELSE 0
                    END AS pos_serology
                   ,CASE WHEN Confirmed_Positive_Serology_Present__c = 1
                              AND Family_Services_Response_Type__c IS NULL
                         THEN 1
                         ELSE 0
                    END AS pos_serology_fs_blank
                   ,CASE WHEN Confirmed_Positive_Serology_Present__c = 1
                              AND Family_Services_Response_Type__c IN (
                              'Next of Kin Not in Close Proximity: Send Regular Discard Letter',
                              'Next of Kin Not  in Close Proximity: Send Regular Discard Letter' )
                         THEN 1
                         ELSE 0
                    END AS pos_serology_discard
                   ,CASE WHEN opt.EyeOutcomeDetail LIKE '%CBNR%' THEN 1
                         ELSE 0
                    END AS CBNR_CONSENT
                   ,CASE WHEN ( opt.EyeOutcomeDetail IN ( 'NSFT - Research' )
                                AND outcome IN ( 'Research', 'Training' )
                              )
                              AND RecoveryIntent = 'Transplant' THEN 1
                         ELSE 0
                    END AS NSFT_RESEARCH
                   ,CASE WHEN RecoveryIntent != 'Transplant'
                              AND eyeoutcomedetail IN ( 'Research', 'Training' )
                         THEN 1
                         ELSE 0
                    END AS research_training
                   ,CASE WHEN Outcome IN ( 'Discarded' ) THEN 1
                         ELSE 0
                    END AS discard
                   ,CASE WHEN eyeoutcome IN ( 'Not Suitable',
                                              'Research/Training Suitable, Not Recovered',
                                              'Statline R/O',
                                              'Suitable, Not Recovered' )
                         THEN 1
                         ELSE 0
                    END AS not_recovered
                   ,CASE WHEN ( ( EyeOutcomeDetail IS NULL
                                  OR EyeOutcomeDetail = 'NSFT - Hold'
                                )
                                AND EyeOutcome = 'Recovered Donor'
                              )
                              OR outcome IS NULL THEN 1
                         ELSE 0
                    END AS pending
                   ,CASE WHEN TissuePartnerShortName IN ( 'LADS', 'LEBLI',
                                                          'CTDN-R', 'NEOB' )
                         THEN 1
                         ELSE 0
                    END AS NA_TissuePartnerFollowUp
                   ,RecoveryTissueType
                   ,RecoveryTissueSubtype
                   ,EyeOutcomeDetail
                   ,CaseFileIdentifier
                  FROM
                    dbo.NOKLetterTypeDataset AS opt
                ) AS indicators
              GROUP BY
                CaseFileIdentifier
            ) AS totals
        ) AS final
    ) AS case_indicators
    LEFT OUTER JOIN (
                      SELECT
                        MAX([most recent date]) AS max_most_recent_date
                       ,CaseFileIdentifier
                      FROM
                        (
                          SELECT
                            updatedTissue.MaxTissueDate AS [Tissue Updated On]
                           ,referraldates.MaxReferralDate AS [referral updated on]
                           ,CASE WHEN ( updatedTissue.MaxTissueDate > referraldates.MaxReferralDate
                                        OR referraldates.MaxReferralDate IS NULL
                                      ) THEN updatedTissue.MaxTissueDate
                                 WHEN ( updatedTissue.MaxTissueDate < referraldates.MaxReferralDate
                                        OR updatedTissue.MaxTissueDate IS NULL
                                      ) THEN referraldates.MaxReferralDate
                            END AS [most recent date]
                           ,referraldates.CaseFileIdentifier
                          FROM
                            (
                              SELECT
                                MAX(updatedT.TissueUpdatedOn) AS MaxTissueDate
                               ,et.CaseFileIdentifier
                              FROM
                                (
                                  SELECT
                                    TissueId
                                   ,MAX(Date) AS TissueUpdatedOn
                                  FROM
                                    (
                                      SELECT
                                        TissueId
                                       ,ISNULL(UpdatedOn, CreatedOn) AS Date
                                      FROM
                                        SIGHTLIFE.EyeDist.Cut
                                      UNION
                                      SELECT
                                        TissueId
                                       ,ISNULL(UpdatedOn, CreatedOn) AS Date
                                      FROM
                                        SIGHTLIFE.EyeDist.Offer
                                      UNION
                                      SELECT
                                        EyeTissueRecoveredId
                                       ,CreatedOn AS date
                                      FROM
                                        SIGHTLIFE.EyeDist.ShipmentItem
                                      UNION
                                      SELECT
                                        Id
                                       ,ISNULL(UpdatedOn, CreatedOn) AS Date
                                      FROM
                                        SIGHTLIFE.EyeRecovery.EyeTissueRecovered
                                    ) AS a
                                  GROUP BY
                                    TissueId
                                ) AS updatedT
                                LEFT OUTER JOIN SIGHTLIFE.Data.EyeTissue AS et ON updatedT.TissueId = et.Id
                              GROUP BY
                                et.CaseFileIdentifier
                            ) AS updatedTissue
                            LEFT OUTER JOIN (
                                              SELECT
                                                MAX(UpdatedR.ReferralUpdatedOn) AS MaxReferralDate
                                               ,dr.CaseFileIdentifier
                                              FROM
                                                (
                                                  SELECT
                                                    MAX(UpdatedOn) AS ReferralUpdatedOn
                                                   ,ReferralId
                                                  FROM
                                                    (
                                                      SELECT
                                                        ReferralId
                                                       ,ISNULL(UpdatedOn,
                                                              CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.DonorReferral
                                                      UNION
                                                      SELECT
                                                        Id
                                                       ,ISNULL(UpdatedOn,
                                                              CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.Referral
                                                      UNION
                                                      SELECT
                                                        Referral_9.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.MedSoc
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_9 ON Referral_9.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_8.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.[Authorization]
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_8 ON Referral_8.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_7.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.HemodilutionWorksheet
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_7 ON Referral_7.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_6.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.Hemodilution
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_6 ON Referral_6.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_5.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.Clinical
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_5 ON Referral_5.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_4.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.Pathology
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_4 ON Referral_4.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_3.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.TissueRecoverySiteInspection
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_3 ON Referral_3.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_2.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.EyeRecovery.EyeDonor
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_2 ON Referral_2.PatientId = ms.PatientId
                                                      UNION
                                                      SELECT
                                                        Referral_1.Id
                                                       ,ISNULL(ms.UpdatedOn,
                                                              ms.CreatedOn) AS UpdatedOn
                                                      FROM
                                                        SIGHTLIFE.dbo.Serology
                                                        AS ms
                                                        LEFT OUTER JOIN SIGHTLIFE.dbo.Referral
                                                        AS Referral_1 ON Referral_1.PatientId = ms.PatientId
                                                    ) AS dates
                                                  GROUP BY
                                                    ReferralId
                                                ) AS UpdatedR
                                                LEFT OUTER JOIN SIGHTLIFE.DATA.DonorReferral
                                                AS dr ON dr.Id = UpdatedR.ReferralId
                                              GROUP BY
                                                dr.CaseFileIdentifier
                                            ) AS referraldates ON updatedTissue.CaseFileIdentifier = referraldates.CaseFileIdentifier
                        ) AS mostrecentdates
                      GROUP BY
                        CaseFileIdentifier
                    ) AS max_dates ON case_indicators.CaseFileIdentifier = max_dates.CaseFileIdentifier
    LEFT OUTER JOIN salesforce.Referral__c AS ref ON ref.NAME = case_indicators.CaseFileIdentifier
    LEFT OUTER JOIN (
                      SELECT DISTINCT
                        CaseFileIdentifier
                      FROM
                        dbo.FamilyServicesOpAudit
                    ) AS fso ON fso.CaseFileIdentifier = case_indicators.CaseFileIdentifier



GO


