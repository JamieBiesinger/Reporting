--USE [Warehouse]
--GO

--/****** Object:  View [SFOBJECT].[Contact_Classification_Source]    Script Date: 8/5/2015 4:47:25 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--ALTER VIEW [SFOBJECT].[Contact_Classification_Source]
--AS
    SELECT
        a.Contact__r
       ,class.Id AS Classification_r
       ,a.iTx_ID__c
       ,a.CreatedOn
    FROM
        (
          SELECT
            C.Id AS Contact__r
           ,CR.Description AS Classification__r
           ,CAST(C.Id AS VARCHAR(200)) + CR.Name AS iTx_ID__c
           ,CIR.CreatedOn
          FROM
            SIGHTLIFE.dbo.Contact AS C
            INNER JOIN SIGHTLIFE.dbo.ContactInRole AS CIR ON C.Id = CIR.ContactId
            INNER JOIN SIGHTLIFE.dbo.ContactRole AS CR ON CIR.ContactRoleId = CR.Id
          UNION
          SELECT
            Id AS contactid
           ,'Donor Family' AS RoleName
           ,CAST(Id AS VARCHAR(200)) + 'NOK' AS madeupid
           ,CreatedOn AS Createdon
          FROM
            SIGHTLIFE.dbo.NextOfKin
          UNION
          SELECT
            SIGHTLIFE.dbo.Patient.Id AS contactid
           ,'Domestic Cornea Recipient' AS RoleName
           ,CAST(SIGHTLIFE.dbo.Patient.Id AS VARCHAR(200)) + 'CR' AS madeupid
           ,SIGHTLIFE.dbo.Patient.CreatedOn AS Createdon
          FROM
            SIGHTLIFE.Data.RequestInventory AS dwri
            LEFT OUTER JOIN SIGHTLIFE.Data.EyeTissue AS et ON dwri.InventoryId = et.Id
            LEFT OUTER JOIN SIGHTLIFE.dbo.Patient ON dwri.RecipientId = SIGHTLIFE.dbo.Patient.Id
          WHERE
            ( dwri.Outcome = 'Transplant' )
            AND ( et.RecoveryTissueType = 'Cornea' )
            AND ( et.RecoveryTissueSubtype = 'Whole' )
            AND ( dwri.EyebankFollowUp = 'Yes' )
            AND ( dwri.OutcomeDetail LIKE 'Domestic%'
                  OR dwri.OutcomeDetail LIKE 'No Recovery Agreement%'
                  OR dwri.OutcomeDetail LIKE 'Recovery Agreement%'
                )
          UNION
          SELECT
            Patient_2.Id AS contactid
           ,'Other Tissue Recipient' AS RoleName
           ,CAST(Patient_2.Id AS VARCHAR(200)) + 'otr' AS madeupid
           ,Patient_2.CreatedOn
          FROM
            SIGHTLIFE.Data.RequestInventory AS dwri
            LEFT OUTER JOIN SIGHTLIFE.Data.EyeTissue AS et ON dwri.InventoryId = et.Id
            LEFT OUTER JOIN SIGHTLIFE.dbo.Patient AS Patient_2 ON dwri.RecipientId = Patient_2.Id
          WHERE
            ( dwri.Outcome = 'Transplant' )
            AND ( Patient_2.Id NOT IN (
                  SELECT
                    Patient_1.Id AS contactid
                  FROM
                    SIGHTLIFE.Data.RequestInventory AS dwri
                    LEFT OUTER JOIN SIGHTLIFE.Data.EyeTissue AS et ON dwri.InventoryId = et.Id
                    LEFT OUTER JOIN SIGHTLIFE.dbo.Patient AS Patient_1 ON dwri.RecipientId = Patient_1.Id
                  WHERE
                    ( dwri.Outcome = 'Transplant' )
                    AND ( et.RecoveryTissueType = 'Cornea' )
                    AND ( et.RecoveryTissueSubtype = 'Whole' )
                    AND ( dwri.EyebankFollowUp = 'Yes' )
                    AND ( dwri.OutcomeDetail LIKE 'Domestic%'
                          OR dwri.OutcomeDetail LIKE 'No Recovery Agreement%'
                          OR dwri.OutcomeDetail LIKE 'Recovery Agreement%'
                        ) ) )
        ) AS a
        LEFT OUTER JOIN salesforce.Classification__c AS class ON class.Name = a.Classification__r
                                                              AND class.IsDeleted = 0
    WHERE
        ( a.Contact__r IN ( SELECT
                                Id
                            FROM
                                SFOBJECT.Contact_Source ) )

GO


