USE [Warehouse]
GO

/****** Object:  View [dbo].[iTxAdminView_Test]    Script Date: 8/5/2015 4:34:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*SELECT * FROM sightlife.dbo.TissueRecoverySiteInspection 
WHERE   a.retrdiscard = 1
SELECT  * FROM    ( 
     ) a
WHERE   a.retrdiscard = 1*/
ALTER VIEW [dbo].[iTxAdminView_Test]
AS
SELECT DISTINCT
        CASE WHEN dr.DeathOn IS NULL
                  AND dr.AddedToStatlineOn IS NULL THEN dr.ReferredOn
             WHEN dr.DeathOn IS NULL THEN dr.AddedToStatlineOn
             ELSE dr.DeathOn
        END AS DateX ,
        et.Id ,
        et.TissueIdentifier ,
        et.Oculus ,
        et.ChildCount ,
        et.RecoveryTissueType ,
        et.RecoveryTissueSubtype ,
        dr.DeathOn ,
        ass.assignedon ,
        dr.CornealPreservationOn ,
        CASE WHEN NOT ( dr.CornealPreservationOn IS NULL )
                  AND et.RecoveryIntent = 'Transplant'
             THEN DATEDIFF(mi, dr.deathon, dr.CornealPreservationOn)
             ELSE NULL
        END AS DtoPminutes ,
        a.QuickestApproval ,
        CASE WHEN NOT ( a.QuickestApproval IS NULL )
             THEN DATEDIFF(mi, dr.deathon, a.QuickestApproval)
             ELSE NULL
        END AS DtoAminutes ,
        dr.CaseFileIdentifier ,
        dr.ReferringOrganizationId ,
        dr.ReferringOrganizationName ,
        dr.CoodinatingAgencyName ,
        CASE WHEN rs.RecoverySiteIsReferringOrganization = 1
             THEN dr.ReferringOrganizationId
             ELSE rso.id
        END AS RecoverySiteID ,
        CASE WHEN rs.RecoverySiteIsReferringOrganization = 1
             THEN dr.ReferringOrganizationname
             ELSE rso.name
        END AS RecoverySiteName ,
        dr.CornealPreservationTechnicianLastName + ', '
        + dr.CornealPreservationTechnicianFirstName AS techname ,
        dr.EyeOutcome ,
        good.outcome ,
        good.outcomedetail ,
        CASE WHEN sr.region = 'Alaska' THEN NULL
             WHEN dr.EyeOutcome IS NOT NULL
                  AND NOT ( dr.eyeoutcome = 'Statline R/O'
                            OR stat.eye IS NULL
                            OR stat.eye = 'No'
                          ) THEN 1
        END AS Refferal ,
        CASE WHEN dr.EyeOutcome = 'Recovered Donor' THEN 1
        END AS EyeDonors ,
        CASE WHEN sr.region = 'Alaska' THEN NULL
             WHEN dr.eyeoutcome = 'Suitable, Not Recovered' THEN 1
             WHEN dr.eyeoutcome = 'Recovered Donor'
                  AND ( et.RecoveryIntent = 'Transplant'
                        OR et.RecoveryIntent IS NULL
                      ) THEN 1
        END AS PotentialDonor ,
        CASE WHEN et.RecoveryIntent <> 'Transplant' THEN 1
        END AS researchdonors ,
        CASE WHEN et.RecoveryIntent = 'Transplant' THEN 1
        END AS transplantDonor ,
        CASE WHEN et.RecoveryIntent = 'Transplant'
                  AND ( good.outcome LIKE 'Research'
                        OR good.outcome LIKE 'Training'
                      ) THEN 1
        END AS TrainingResearchCornea ,
        CASE WHEN good.outcome IS NULL
                  AND et.recoveryintent = 'Transplant'
                  AND et.nsft = 1 THEN 1
        END AS TXNSFTHold ,
        CASE WHEN ( et.Nsft = 1
                    OR et.nsftreleased = 1
                  )
                  AND et.recoveryintent = 'Transplant' THEN 1
        END AS nsft ,
        CASE WHEN et.recoveryintent = 'Transplant'
                  AND good.outcome = 'Discarded' THEN 1
        END AS TxDiscard ,
        et.RecoveryIntent ,
        CASE WHEN good.outcome = 'Transplant'
                  AND ( good.outcomeDetail LIKE 'Domestic%'
                        OR good.outcomeDetail LIKE 'Local%'
                      )
                  AND NOT ( ISNULL(et.RecoveryTissueSubtype, '') LIKE 'Glyc%'
                            OR NOT ( GlycKids.ParentId IS NULL )
                          ) THEN 1
        END AS Domestic ,
        CASE WHEN good.outcome = 'Transplant'
                  AND NOT ( good.outcomeDetail LIKE 'Domestic%'
                            OR good.outcomeDetail LIKE 'Local%'
                          )
                  AND NOT ( et.RecoveryTissueSubtype LIKE 'Glyc%'
                            OR NOT ( GlycKids.ParentId IS NULL )
                          ) THEN 1
        END AS International ,
        CASE WHEN good.outcome IS NULL
                  AND et.ApprovedForTransplant = 1
                  AND glyckids.parentid IS NULL
                  AND NOT ( ISNULL(et.RecoveryTissueSubtype, '') LIKE 'Glyc%'
                            OR NOT ( GlycKids.ParentId IS NULL )
                          ) THEN 1
        END AS TransplantPending ,
        CASE WHEN et.RecoveryIntent = 'Transplant'
                  AND et.releasedon IS NULL
                  AND good.outcome IS NULL
                  AND NOT et.nsft = 1 THEN 1
        END AS DispositionPending ,
        CASE WHEN dr.eyeoutcome IS NULL
                  AND NOT ( ass.assignedon IS NULL ) THEN 1
        END AS pendingrecovery ,
        CASE WHEN et.RecoveryIntent = 'Transplant' THEN 1
        END AS CorneasExcised ,
        CASE WHEN et.RecoveryIntent <> 'Transplant' THEN 1
        END AS RETRCorneasExcisedRETR ,
        CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome = 'Training' THEN 1
        END AS RETRTraining ,
        CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome = 'Research' THEN 1
        END AS RETRResearch ,
        CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome = 'Discarded' THEN 1
        END AS RETRDiscard ,
        CASE WHEN et.RecoveryIntent <> 'Transplant'
                  AND good.outcome IS NULL THEN 1
        END AS RETRNSFTHold ,
        CASE WHEN ( good.outcome IS NULL
                    AND et.ApprovedForTransplant = 1
                  )
                  OR good.outcome = 'Transplant' THEN 1
        END AS transplanted ,
        CASE WHEN NOT ( GlycKids.ParentId IS NULL )
                  AND et.ApprovedForTransplant = 1 THEN 1
             WHEN et.RecoveryTissueSubtype LIKE 'Glyc%'
                  AND et.ApprovedForTransplant = 1 THEN 1
        END AS GlycCornea ,
        et.ReleasedOn ,
        CASE WHEN GlycKids.ParentId IS NOT NULL THEN 1
        END AS HasGlycKidTissue ,
        CASE WHEN et.RecoveryTissueSubtype LIKE 'Glyc%'
                  OR NOT ( GlycKids.ParentId IS NULL ) THEN 1
        END AS GlycTissue ,
        CASE WHEN dr.tissuepartnershortname = 'LADS' THEN 'LADS'
             WHEN dr.tissuepartnershortname = 'CTDN-R' THEN 'CTDN'
             WHEN dr.tissuepartnershortname = 'NEOB' THEN 'NEOB'
             WHEN sr.region IS NULL THEN 'W. Washington'
             ELSE sr.region
        END AS Region ,
        sr.StateCode ,
        sr.PostalCode ,
        sr.City ,
        sr.SubRegion ,
        sr.HospitalSystem ,
        CASE WHEN dr.tissuepartnershortname = 'LADS' THEN 'Other'
             WHEN dr.tissuepartnershortname = 'CTDN-R' THEN 'Other'
             WHEN dr.tissuepartnershortname = 'NEOB' THEN 'Other'
             ELSE 'SL Recovery Area'
        END AS category ,
        CASE WHEN dr.tissuepartnershortname = 'LADS' THEN 'FALSE'
             WHEN dr.tissuepartnershortname = 'CTDN-R' THEN 'FALSE'
             WHEN dr.tissuepartnershortname = 'NEOB' THEN 'FALSE'
             ELSE 'TRUE'
        END AS CategorySubTotal
FROM    Warehouse.iTxPlus.DonorReferral AS dr
        LEFT OUTER JOIN dbo.iTxStatlineSuitability AS stat ON dr.CaseFileIdentifier = stat.casefileidentifier
        LEFT OUTER JOIN ( SELECT    MIN(Warehouse.iTxPlus.EyeTissue.ReleasedOn) AS QuickestApproval ,
                                    Warehouse.iTxPlus.DonorReferral.PatientId
                          FROM      Warehouse.iTxPlus.EyeTissue
                                    LEFT OUTER JOIN Warehouse.iTxPlus.DonorReferral ON Warehouse.iTxPlus.EyeTissue.CaseFileIdentifier = Warehouse.iTxPlus.DonorReferral.CaseFileIdentifier
                          WHERE     ( Warehouse.iTxPlus.EyeTissue.ApprovedForTransplant = 1 )
                                    AND ( Warehouse.iTxPlus.EyeTissue.RecoveryIntent = 'Transplant' )
                          GROUP BY  Warehouse.iTxPlus.DonorReferral.PatientId
                        ) AS a ON dr.PatientId = a.PatientId
        LEFT OUTER JOIN dbo.CorneaTissueHeirarchy AS CH ON dr.CaseFileIdentifier = CH.CaseFileIdentifier
        LEFT OUTER JOIN ( SELECT    cco.id ,
                                    MAX(cco.outcome) AS outcome ,
                                    MAX(cco.OutcomeDetail) AS outcomedetail
                          FROM      dbo.CorneaChildOutcomes AS cco
                                    INNER JOIN ( SELECT MIN(outcomenumber) AS outcomenumber ,
                                                        id
                                                 FROM   dbo.CorneaChildOutcomes
                                                 GROUP BY id
                                               ) AS cco2 ON cco2.id = cco.id
                                                            AND cco.outcomenumber = cco2.outcomenumber
                          GROUP BY  cco.id
                        ) AS good ON good.id = CH.id
        LEFT OUTER JOIN Warehouse.iTxPlus.EyeTissue AS et ON good.id = et.Id
        LEFT OUTER JOIN ( SELECT    ParentId
                          FROM      Warehouse.iTxPlus.EyeTissue AS EyeTissue_1
                          WHERE     ( RecoveryTissueSubtype LIKE 'Glyc%' )
                        ) AS GlycKids ON et.Id = GlycKids.ParentId
        LEFT OUTER JOIN SIGHTLIFE.dbo.OcularDonorOutcome ON dr.PatientId = SIGHTLIFE.dbo.OcularDonorOutcome.PatientId
        LEFT OUTER JOIN ( SELECT    MIN(AssignedOn) AS assignedon ,
                                    CaseFileId
                          FROM      SIGHTLIFE.dbo.Assignment
                          WHERE     ( AssignmentTypeId = '3AAEFF91-37D6-4868-B23A-6E307D647B9A' )
                          GROUP BY  CaseFileId
                        ) AS ass ON dr.Id = ass.CaseFileId
        LEFT OUTER JOIN dbo.ItxOrgRedionSubRegion AS sr ON dr.ReferringOrganizationId = sr.Id
        LEFT OUTER JOIN SIGHTLIFE.dbo.TissueRecoverySiteInspection AS rs ON dr.PatientId = rs.PatientId
        LEFT OUTER JOIN SIGHTLIFE.dbo.Organization AS rso ON rs.RecoverySite = rso.Id
WHERE   ( dr.ReferringOrganizationId NOT IN (
          SELECT    OrganizationId
          FROM      SIGHTLIFE.dbo.OrganizationInRole
          WHERE     ( OrganizationRoleId = 'AD7F0462-21B3-405D-A969-CC83372BE3C1' ) ) )
        AND ( dr.ReferringOrganizationId <> 'C4474053-073A-44F6-831E-61ABF29AD316' )
        AND ( dr.ReferringOrganizationName <> 'Statline Name Not Found' )


GO


