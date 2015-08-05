USE [Warehouse]
GO

/****** Object:  View [dbo].[IndiaAdminStats]    Script Date: 8/5/2015 4:13:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[IndiaAdminStats]
AS
    SELECT DISTINCT
        CASE WHEN dr.DeathOn IS NULL THEN dr.ReferredOn
             ELSE dr.DeathOn
        END AS DateX
       ,dr.OwnedById
       ,dr.OwnedByShortName
       ,obo.Name AS OwnedByName
       ,dr.TakenByOrganizationName
       ,et.Id
       ,et.TissueIdentifier
       ,et.ChildCount
       ,et.RecoveryTissueType
       ,et.RecoveryTissueSubtype
       ,dr.DeathOn
       ,ass.assignedon
       ,dr.CornealPreservationOn
       ,CASE WHEN NOT ( dr.CornealPreservationOn IS NULL )
                  AND et.RecoveryIntent = 'Transplant'
             THEN DATEDIFF(mi, dr.deathon, dr.CornealPreservationOn)
             ELSE NULL
        END AS DtoPminutes
       ,a.QuickestApproval
       ,CASE WHEN NOT ( a.QuickestApproval IS NULL )
             THEN DATEDIFF(mi, dr.deathon, a.QuickestApproval)
             ELSE NULL
        END AS DtoAminutes
       ,dr.CaseFileIdentifier
       ,dr.ReferringOrganizationId
       ,dr.ReferringOrganizationName
       ,dr.CoodinatingAgencyName
       ,CASE WHEN rs.RecoverySiteIsReferringOrganization = 1
             THEN dr.ReferringOrganizationId
             ELSE rso.id
        END AS RecoverySiteID
       ,CASE WHEN rs.RecoverySiteIsReferringOrganization = 1
             THEN dr.ReferringOrganizationname
             ELSE rso.name
        END AS RecoverySiteName
       ,dr.DonationCounselorLastName + ', ' + dr.DonationCounselorFirstName AS edcname
       ,dr.CornealPreservationTechnicianLastName + ', '
        + dr.CornealPreservationTechnicianFirstName AS techname
       ,dr.EyeOutcome
       ,dr.EyeOutcomeDetail
       ,CASE WHEN dr.EyeOutcome IS NULL THEN dr.CaseFileIdentifier
        END AS NoOutcome
       ,CASE WHEN dr.EyeOutcome = 'Not Screened' THEN dr.CaseFileIdentifier
        END AS NotScreened
       ,CASE WHEN dr.EyeOutcome IS NOT NULL
                  AND dr.EyeOutcome <> 'Not Screened'
             THEN dr.CaseFileIdentifier
        END AS Screened
       ,CASE WHEN dr.EyeOutcome = 'Screened, but Not Suitable'
             THEN dr.CaseFileIdentifier
        END AS NotSuitable
       ,CASE WHEN dr.EyeOutcome IS NOT NULL
                  AND dr.EyeOutcome <> 'Not Screened'
                  AND dr.EyeOutcome <> 'Screened, but Not Suitable'
             THEN dr.CaseFileIdentifier
        END AS Eligible
       ,CASE WHEN dr.EyeOutcome = 'Suitable, but Not Approached'
             THEN dr.CaseFileIdentifier
        END AS NotApproached
       ,CASE WHEN dr.EyeOutcome IS NOT NULL
                  AND dr.EyeOutcome <> 'Not Screened'
                  AND dr.EyeOutcome <> 'Screened, but Not Suitable'
                  AND dr.EyeOutcome <> 'Suitable, but Not Approached'
             THEN dr.CaseFileIdentifier
        END AS Approached
       ,CASE WHEN dr.EyeOutcome = 'Approached, but Not Consented'
             THEN dr.CaseFileIdentifier
        END AS NotConsented
       ,CASE WHEN dr.EyeOutcome IS NOT NULL
                  AND dr.EyeOutcome <> 'Not Screened'
                  AND dr.EyeOutcome <> 'Screened, but Not Suitable'
                  AND dr.EyeOutcome <> 'Suitable, but Not Approached'
                  AND dr.EyeOutcome <> 'Approached, but Not Consented'
             THEN dr.CaseFileIdentifier
        END AS Consented
       ,CASE WHEN dr.EyeOutcome = 'Consented, Not Recovered'
             THEN dr.CaseFileIdentifier
        END AS CBNR
       ,CASE WHEN dr.EyeOutcome = 'Consented - Donor'
             THEN dr.CaseFileIdentifier
        END AS Donor
       ,CASE WHEN ( et.RecoveryIntent = 'Research'
                    OR et.RecoveryIntent = 'Training'
                  )
                  AND dr.EyeOutcome = 'Consented - Donor'
             THEN dr.CaseFileIdentifier
        END AS retrdonors
       ,CASE WHEN et.recoveryintent = 'Transplant'
                  AND dr.EyeOutcome = 'Consented - Donor'
             THEN dr.CaseFileIdentifier
        END AS TxDonor
       ,CASE WHEN et.recoveryintent IS NULL
                  AND dr.EyeOutcome = 'Consented - Donor'
             THEN dr.CaseFileIdentifier
        END AS IntentUnknown
       ,good.outcome
       ,good.OutcomeDetail
       ,CASE WHEN good.outcome LIKE 'Research'
                  OR good.outcome LIKE 'Training' THEN 1
        END AS TrainingResearchCornea
       ,CASE WHEN good.outcome IS NULL
                  AND ( et.ApprovedOutcomes LIKE '%research%'
                        OR et.ApprovedOutcomes LIKE '%training%'
                      )
                  AND et.recoveryintent = 'Transplant'
                  AND et.nsft = 1 THEN 1
        END AS TXNSFTHold
       ,CASE WHEN et.Nsft = 1
                  OR et.nsftreleased = 1 THEN 1
        END AS nsft
       ,CASE WHEN et.recoveryintent = 'Transplant'
                  AND good.outcome = 'Discarded' THEN 1
        END AS TxDiscard
       ,et.RecoveryIntent
       ,CASE WHEN good.outcome = 'Transplant'
                  AND ( good.outcomeDetail LIKE 'Domestic%'
                        OR good.outcomeDetail LIKE 'Local%'
                      )
                  AND NOT ( et.RecoveryTissueSubtype LIKE 'Glyc%'
                            OR NOT ( GlycKids.ParentId IS NULL )
                          ) THEN 1
        END AS Domestic
       ,CASE WHEN good.outcome = 'Transplant'
                  AND NOT ( good.outcomeDetail LIKE 'Domestic%'
                            OR good.outcomeDetail LIKE 'Local%'
                          )
                  AND NOT ( et.RecoveryTissueSubtype LIKE 'Glyc%'
                            OR NOT ( GlycKids.ParentId IS NULL )
                          ) THEN 1
        END AS International
       ,CASE WHEN good.outcome IS NULL
                  AND et.ApprovedForTransplant = 1
                  AND glyckids.parentid IS NULL
                  AND NOT ( et.RecoveryTissueSubtype LIKE 'Glyc%'
                            OR NOT ( GlycKids.ParentId IS NULL )
                          ) THEN 1
        END AS TransplantPending
       ,CASE WHEN et.RecoveryIntent = 'Transplant'
                  AND et.releasedon IS NULL
                  AND good.outcome IS NULL
                  AND NOT et.nsft = 1 THEN 1
        END AS DispositionPending
       ,CASE WHEN dr.eyeoutcome IS NULL
                  AND NOT ( ass.assignedon IS NULL ) THEN 1
        END AS pendingrecovery
       ,CASE WHEN et.RecoveryIntent = 'Transplant' THEN 1
        END AS CorneasExcised
       ,CASE WHEN et.RecoveryIntent <> 'Transplant' THEN 1
        END AS RETRCorneasExcisedRETR
       ,CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome = 'Training' THEN 1
        END AS RETRTraining
       ,CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome = 'Research' THEN 1
        END AS RETRResearch
       ,CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome = 'Discarded' THEN 1
        END AS RETRDiscard
       ,CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome IS NULL THEN 1
        END AS RETRNSFTHold
       ,CASE WHEN ( good.outcome IS NULL
                    AND et.ApprovedForTransplant = 1
                  )
                  OR good.outcome = 'Transplant' THEN 1
        END AS transplanted
       ,CASE WHEN NOT ( GlycKids.ParentId IS NULL )
                  AND et.ApprovedForTransplant = 1 THEN 1
             WHEN et.RecoveryTissueSubtype LIKE 'Glyc%'
                  AND et.ApprovedForTransplant = 1 THEN 1
        END AS GlycCornea
       ,et.ReleasedOn
       ,CASE WHEN GlycKids.ParentId IS NOT NULL THEN 1
        END AS HasGlycKidTissue
       ,CASE WHEN et.RecoveryTissueSubtype LIKE 'Glyc%'
                  OR NOT ( GlycKids.ParentId IS NULL ) THEN 1
        END AS GlycTissue
    FROM
        SLINDIA.DATA.DonorReferral AS dr
        LEFT OUTER JOIN dbo.iTxStatlineSuitability AS stat ON dr.CaseFileIdentifier = stat.casefileidentifier
        LEFT OUTER JOIN (
                          SELECT
                            MIN(SLINDIA.Data.EyeTissue.ReleasedOn) AS QuickestApproval
                           ,SLINDIA.Data.DonorReferral.PatientId
                          FROM
                            SLINDIA.Data.EyeTissue
                            LEFT OUTER JOIN SLINDIA.Data.DonorReferral ON SLINDIA.Data.EyeTissue.CaseFileIdentifier = SLINDIA.Data.DonorReferral.CaseFileIdentifier
                          WHERE
                            ( SLINDIA.Data.EyeTissue.ApprovedForTransplant = 1 )
                            AND ( SLINDIA.Data.EyeTissue.RecoveryIntent = 'Transplant' )
                          GROUP BY
                            SLINDIA.Data.DonorReferral.PatientId
                        ) AS a ON dr.PatientId = a.PatientId
        LEFT OUTER JOIN dbo.IndiaCorneaTissueHeirarchy AS CH ON dr.CaseFileIdentifier = CH.CaseFileIdentifier
        LEFT OUTER JOIN (
                          SELECT
                            cco.id
                           ,cco.outcome
                           ,cco.OutcomeDetail
                          FROM
                            dbo.IndiaCorneaChildOutcomes AS cco
                            INNER JOIN (
                                         SELECT
                                            MIN(outcomenumber) AS outcomenumber
                                           ,id
                                         FROM
                                            dbo.IndiaCorneaChildOutcomes
                                         GROUP BY
                                            id
                                       ) AS cco2 ON cco2.id = cco.id
                                                    AND cco.outcomenumber = cco2.outcomenumber
                        ) AS good ON good.id = CH.id
        LEFT OUTER JOIN SLINDIA.Data.EyeTissue AS et ON good.id = et.Id
        LEFT OUTER JOIN (
                          SELECT
                            ParentId
                          FROM
                            SLINDIA.Data.EyeTissue AS EyeTissue_1
                          WHERE
                            ( RecoveryTissueSubtype LIKE 'Glyc%' )
                        ) AS GlycKids ON et.Id = GlycKids.ParentId
        LEFT OUTER JOIN SLINDIA.dbo.OcularDonorOutcome ON dr.PatientId = SLINDIA.dbo.OcularDonorOutcome.PatientId
        LEFT OUTER JOIN (
                          SELECT
                            MIN(AssignedOn) AS assignedon
                           ,CaseFileId
                          FROM
                            SLINDIA.dbo.Assignment
                          WHERE
                            ( AssignmentTypeId = '3AAEFF91-37D6-4868-B23A-6E307D647B9A' )
                          GROUP BY
                            CaseFileId
                        ) AS ass ON dr.Id = ass.CaseFileId
        LEFT OUTER JOIN SLINDIA.dbo.TissueRecoverySiteInspection AS rs ON dr.PatientId = rs.PatientId
        LEFT OUTER JOIN SLINDIA.dbo.Organization AS rso ON rs.RecoverySite = rso.Id
        LEFT OUTER JOIN SLINDIA.dbo.Organization AS obo ON dr.OwnedById = obo.Id

GO


