
-- [dbo].[StatusBoardData]

    SELECT
        [iTx Case ID]
       ,DateX
       ,DeathOn
      
       ,[Referral Created By First]
       ,[Referral Created By Last]
       ,TissueOutcomeDetail
       ,[Authorization Date-Time (UTC)]
       ,[Tech Dispatched Date-Time (PST)]
       ,[Eye Preservation Date-Time (UTC)]
       ,SuitabilityDeterminedBy
       ,[DRAI Interviewer]
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND [Donation Discussion By] = 'SightLife'
                  AND [Registry Status] = 'Not Registered'
                  AND EyeOutcomeDetail IN ( 'CBNR - Logistics', 'NSFT - Hold',
                                            'NSFT - Research', 'Discard',
                                            'Transplant' )
                  AND NOT ( [Discussion Type] = 'Confirmation'
                            AND EyeOutcomeDetail = 'Family Decline'
                          ) THEN 1
        END AS TraditionalAuthorizationNumerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND [Donation Discussion By] = 'SightLife'
                  AND [Registry Status] = 'Not Registered'
                  AND EyeOutcomeDetail IN ( 'CBNR - Logistics', 'NSFT - Hold',
                                            'NSFT - Research', 'Discard',
                                            'Transplant', 'Family Decline' )
                  AND NOT ( [Discussion Type] = 'Confirmation'
                            AND EyeOutcomeDetail = 'Family Decline'
                          ) THEN 1
        END AS TraditionalAuthorizationDenominator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND [Donation Discussion By] = 'SightLife'
                  AND [Registry Status] = 'Registered'
                  AND NOT ( [Discussion Type] = 'Confirmation'
                            AND EyeOutcomeDetail = 'Family Decline'
                          )
                  AND EyeOutcomeDetail IN ( 'CBNR - Logistics', 'NSFT - Hold',
                                            'NSFT - Research', 'Discard',
                                            'Transplant' ) THEN 1
        END AS RegistryAgreementNumerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND [Donation Discussion By] = 'SightLife'
                  AND [Registry Status] = 'Registered'
                  AND NOT ( [Discussion Type] = 'Confirmation'
                            AND EyeOutcomeDetail = 'Family Decline'
                          )
                  AND EyeOutcomeDetail IN ( 'CBNR - Logistics', 'NSFT - Hold',
                                            'NSFT - Research', 'Discard',
                                            'Transplant', 'Family Decline' )
             THEN 1
        END AS RegistryAgreementDenominator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND TissueOutcome IN ( 'Recovered Donor',
                                         'Suitable, Not Recovered' )
                  AND tissueoutcomedetail IN ( 'CBNR - Logistics',
                                               'NSFT - Hold',
                                               'NSFT - Research', 'Discard',
                                               'Transplant' )
                  AND NOT ( [Discussion Type] = 'Confirmation'
                            AND EyeOutcomeDetail = 'Family Decline'
                          ) THEN 1
        END AS TotalTissueAuthorizationNumerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND TissueOutcome IN ( 'Recovered Donor',
                                         'Suitable, Not Recovered' )
                  AND tissueoutcomedetail IN ( 'CBNR - Logistics',
                                               'NSFT - Hold',
                                               'NSFT - Research', 'Discard',
                                               'Transplant', 'Family Decline' )
                  AND NOT ( [Discussion Type] = 'Confirmation'
                            AND EyeOutcomeDetail = 'Family Decline'
                          ) THEN 1
        END AS TotalTissueAuthorizationDenominator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN' )
                  AND [Coordinating Agency] = 'SightLife'
                  AND EyeOutcome IN ( 'Recovered Donor' )
                  AND EyeOutcomeDetail IN ( 'Discard', 'NSFT - Hold',
                                            'NSFT - Research', 'Transplant' )
             THEN 1
        END AS CornealTissueConversionNumerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND EyeOutcomeDetail IN ( 'Discard', 'Family Decline',
                                            'CBNR - Logistics',
                                            'No Approach, Logistics',
                                            'NSFT - Hold', 'NSFT - Research',
                                            'Transplant' ) THEN 1
        END AS CornealTissueConversionDenominator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND EyeOutcomeDetail IN ( 'CBNR - Logistics',
                                            'No Approach, Logistics' ) THEN 1
        END AS LogisticsLossNumerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
                  AND EyeOutcome IN ( 'Recovered Donor',
                                      'Suitable, Not Recovered' )
                  AND EyeOutcomeDetail IN ( 'Discard', 'Family Decline',
                                            'CBNR - Logistics',
                                            'No Approach, Logistics',
                                            'NSFT - Hold', 'NSFT - Research',
                                            'Transplant' ) THEN 1
        END AS LogisticsLossDenominator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
             THEN DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                           [Authorization Date-Time (UTC)]) / 60
        END AS DeathToAuthorization_InHours
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
             THEN DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                           [Authorization Date-Time (UTC)])
        END AS DeathToAuthorization_InMinutes
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
             THEN DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                           [Tech Dispatched Date-Time (UTC)]) / 60
        END AS DeathToDispatch_InHours
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
             THEN DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                           [Tech Dispatched Date-Time (UTC)])
        END AS DeathToDispatch_InMinutes
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
             THEN DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                           [Eye Preservation Date-Time (UTC)]) / 60
        END AS DtoP_InHours
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
             THEN DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                           [Eye Preservation Date-Time (UTC)])
        END AS DtoP_InMinutes
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
                  AND [Eye Preservation Date-Time (UTC)] IS NOT NULL
                  AND DATEDIFF(MINUTE, [Death Date-Time (UTC)],
                               [Eye Preservation Date-Time (UTC)]) / 60 < 12
             THEN 1
        END AS DtoPLessThan12Numerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND [Coordinating Agency] = 'SightLife'
                  AND [Eye Preservation Date-Time (UTC)] IS NOT NULL THEN 1
        END AS DtoPLessThan12Denominator
       ,CASE WHEN ISNULL(tissueoutcome, '') IN ( 'Not Suitable',
                                                 'Suitable, Not Recovered',
                                                 'Recovered Donor',
                                                 'Research/Training Suitable, Not Recovered
' )
                  AND SuitabilityDeterminedBy IS NOT NULL
                  AND ISNULL(region, '') NOT IN ( 'New England',
                                                  'N. Cal - CTDN' ) THEN 1
        END AS TissueReferralsCoordinated
       ,CASE WHEN ISNULL(eyeoutcome, '') NOT IN ( 'Statline R/O', '' )
                  AND SuitabilityDeterminedBy IS NOT NULL
                  AND ISNULL(region, '') NOT IN ( 'New England',
                                                  'N. Cal - CTDN' ) THEN 1
        END AS EyeReferralsCoordinated
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND ISNULL(EyeOutcome, '') IN ( 'Recovered Donor',
                                                  'Suitable, Not Recovered',
                                                  '' )
                  AND eyeoutcomedetail IN ( 'CBNR - Logistics', 'NSFT - Hold',
                                            'NSFT - Research', 'Discard',
                                            'Transplant' )
                  AND [Donation Discussion By] = 'SightLife'
                  AND [DRAI Interviewer] IS NOT NULL THEN 1
        END AS MedSocCompletedNumerator
       ,CASE WHEN ISNULL(region, '') NOT IN ( 'New England', 'N. Cal - CTDN',
                                              'Referral Clients', 'Alaska', '' )
                  AND ISNULL(EyeOutcome, '') IN ( 'Recovered Donor',
                                                  'Suitable, Not Recovered',
                                                  '' )
                  AND eyeoutcomedetail IN ( 'CBNR - Logistics', 'NSFT - Hold',
                                            'NSFT - Research', 'Discard',
                                            'Transplant' )
                  AND [Donation Discussion By] = 'SightLife' THEN 1
        END AS MedSocCompletedDenominator
    FROM
        dbo.iTxEricView

GO

