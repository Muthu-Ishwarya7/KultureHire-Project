use genzdataset;

show tables;

select * from learning_aspirations as la;
select * from manager_aspirations as ma;
select * from mission_aspirations as mia;
select * from personalized_info as pi;

-- 1. What percentage of male and female Genz wants to go to office Every Day?
SELECT
    pi.Gender,   -- COUNT(*) AS Total,
    ROUND((SUM(CASE 
        WHEN la.PreferredWorkingEnvironment LIKE '%Every Day Office%' THEN 1 ELSE 0 END)/ COUNT(*)) * 100,2) AS Percentage_Want_To_Go_To_Office
FROM
    personalized_info as pi
INNER JOIN
    learning_aspirations as la ON pi.ResponseID = la.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r') -- Filter for Male and Female
GROUP BY
    pi.Gender;
    
-- 2. What percentage of Genz's who have chosen their career in Business operations are most likely to be influenced by their Parents?
SELECT (SUM(la.CareerInfluenceFactor like '%My Parents%' and la.ClosestAspirationalCareer like '%Business Operations%')/count(*))*100
         AS Percentage_Influenced_By_Parents   -- COUNT(*) AS Total
FROM learning_aspirations as la;

-- 3. What percentage of Genz prefer opting for higher studies, give a gender wise approach?
SELECT
    pi.Gender,
    (SUM(la.HigherEducationAbroad LIKE '%Yes, I wil%')/COUNT(*))*100 AS Percentage_higher_studies
FROM personalized_info as pi
INNER JOIN
    learning_aspirations as la ON pi.ResponseID = la.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r') -- Filter for Male and Female
GROUP BY
    pi.Gender;
    
-- 4. What percentage of Genz are willing & not willing to work for a company whose mission is misaligned with their public actions or even their products ? (give gender based split)
SELECT
    pi.Gender,
	ROUND((SUM(mia.MisalignedMissionLikelihood LIKE '%Will work%')/COUNT(*))*100,1) AS Percent_Will_work,
    ROUND((SUM(mia.MisalignedMissionLikelihood LIKE '%Will NOT work%')/COUNT(*))*100,1) AS Percent_Will_NOT_work
FROM personalized_info as pi
INNER JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender;
    
-- 5. What is the most suitable working environment according to female genz's?
SELECT
    la.PreferredWorkingEnvironment,
    COUNT(*) AS Count
FROM personalized_info as pi
INNER JOIN
    learning_aspirations as la ON pi.ResponseID = la.ResponseID
WHERE  pi.Gender IN ('Female\r')
GROUP BY
    la.PreferredWorkingEnvironment
ORDER BY
    Count DESC
LIMIT 1;

-- 6. Calculate the total number of Female who aspire to work in their Closest Aspirational Career and have a No Social Impact Likelihood of "1 to 5".
SELECT COUNT(*) AS Total_Females_WithAspiration_And_NoSocialImpact
FROM  mission_aspirations as mia
INNER JOIN
    personalized_info as pi ON mia.ResponseID = pi.ResponseID
INNER JOIN
    learning_aspirations as la ON pi.ResponseID = la.ResponseID
WHERE pi.Gender IN ('Female\r') AND 
      la.ClosestAspirationalCareer IS NOT NULL AND
      NoSocialImpactLikelihood BETWEEN 1 AND 5;

-- 7. Retrieve the Male who are interested in Higher Education Abroad and have a Career Influence Factor of "My Parents".
SELECT    -- pi.ResponseID,
    COUNT(*) AS Percentage_higher_studies_My_Parents
FROM personalized_info as pi
INNER JOIN
    learning_aspirations as la ON pi.ResponseID = la.ResponseID
WHERE
    pi.Gender IN ('Male\r') AND  -- Filter for Male and Female
    la.HigherEducationAbroad LIKE '%Yes, I wil%' AND
    la.CareerInfluenceFactor like '%My Parents%';

-- 8. Determine the percentage of gender who have a No Social Impact Likelihood of "8 to 10" among those who are interested in Higher Education Abroad
SELECT
    pi.Gender,
    SUM((mia.NoSocialImpactLikelihood BETWEEN 8 AND 10) AND la.HigherEducationAbroad LIKE '%Yes, I wil%') AS Interested_InHigherEd_And_NoSocialImpact
FROM  mission_aspirations as mia
INNER JOIN
    personalized_info as pi ON mia.ResponseID = pi.ResponseID
INNER JOIN
    learning_aspirations as la ON pi.ResponseID = la.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender;
    
-- 9. Give a detailed split of the GenZ preferences to work with Teams, Data should include Male, Female and Overall in counts and also the overall in %
SELECT 
	SUBSTRING_INDEX(SUBSTRING_INDEX(ma.PreferredWorkSetup, ' ', -7), ' ', 4) AS ExtractedTeamSize,
    pi.Gender,
    COUNT(*) AS Gender_Count,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM personalized_info) * 100), 1) AS Gender_Percentage
FROM 
    personalized_info AS pi
INNER JOIN
    manager_aspirations AS ma ON pi.ResponseID = ma.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r')
GROUP BY
    pi.Gender, ExtractedTeamSize;

-- 10. Give a detailed breakdown of "WorkLikelihood3Years" for each gender
SELECT 
       ma.WorkLikelihood3Years,
       pi.Gender,
       COUNT(*) AS Total
FROM personalized_info as pi
INNER JOIN
    manager_aspirations as ma ON pi.ResponseID = ma.ResponseID
GROUP BY
	ma.WorkLikelihood3Years,pi.Gender;

-- 11. What is the Average Starting salary expectations at 3 year mark for each gender
SELECT
    pi.Gender,
    -- mia.ExpectedSalary3Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1) AS UNSIGNED))),"k") AS AverageHigherBarSalary
FROM
    personalized_info pi
JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender;   -- mia.ExpectedSalary3Years,SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1);
      
-- 12. What is the Average Starting salary expectations at 5 year mark for each gender
SELECT
    pi.Gender,
    -- mia.ExpectedSalary3Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', 1) AS UNSIGNED))),"k") AS AverageHigherBarSalary
FROM
    personalized_info pi
JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender;   -- mia.ExpectedSalary3Years,SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1);
    
-- 13. What is the Average Higher Bar salary expectations at 3 year mark for each gender
SELECT
    pi.Gender,
    -- mia.ExpectedSalary3Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1) AS UNSIGNED))),"k") AS AverageHigherBarSalary
FROM
    personalized_info pi
JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender;    -- mia.ExpectedSalary3Years,SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1);

-- 14. What is the Average Higher Bar salary expectations at 5 year mark for each gender 
SELECT
    pi.Gender,
    -- mia.ExpectedSalary5Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', -1) AS UNSIGNED))),"k") AS AverageHigherBarSalary
FROM
    personalized_info pi
JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender;    -- mia.ExpectedSalary3Years,SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1);

-- 15. What is the Average Starting salary expectations at 3 year mark for each gender and each state in India 
SELECT * FROM india_pincode;

SELECT
    pi.Gender,
    -- mia.ExpectedSalary3Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1) AS UNSIGNED))),"k") AS AverageHigherBarSalary,
    ip.State
FROM
    personalized_info pi
INNER JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
INNER JOIN
    india_pincode as ip ON pi.ZipCode = ip.Pincode
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender,   -- mia.ExpectedSalary3Years,SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', 1);
    ip.State;

-- 16. What is the Average Starting salary expectations at 5 year mark for each gender and each state in India
SELECT
    pi.Gender,
    -- mia.ExpectedSalary5Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', 1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', 1) AS UNSIGNED))),"k") AS AverageHigherBarSalary,
    ip.State
FROM
    personalized_info pi
INNER JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
INNER JOIN
    india_pincode as ip ON pi.ZipCode = ip.Pincode
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender,   -- mia.ExpectedSalary5Years,SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', 1);
    ip.State;

-- 17. What is the Average Higher Bar salary expectations at 3 year mark for each gender and each state in India
SELECT
    pi.Gender,
    -- mia.ExpectedSalary3Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1) AS UNSIGNED))),"k") AS AverageHigherBarSalary,
    ip.State
FROM
    personalized_info pi
INNER JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
INNER JOIN
    india_pincode as ip ON pi.ZipCode = ip.Pincode
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender,   -- mia.ExpectedSalary3Years,SUBSTRING_INDEX(mia.ExpectedSalary3Years, ' to ', -1);
    ip.State;
    
-- 18. What is the Average Higher Bar salary expectations at 5 year mark for each gender and each state in India
SELECT
    pi.Gender,
    -- mia.ExpectedSalary5Years,
    -- SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', -1),
    CONCAT(FLOOR(AVG(CAST(SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', -1) AS UNSIGNED))),"k") AS AverageHigherBarSalary,
    ip.State
FROM
    personalized_info pi
INNER JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
INNER JOIN
    india_pincode as ip ON pi.ZipCode = ip.Pincode
WHERE
    pi.Gender IN ('Male\r', 'Female\r','Transgender\r')
GROUP BY
    pi.Gender,   -- mia.ExpectedSalary5Years,SUBSTRING_INDEX(mia.ExpectedSalary5Years, ' to ', -1);
    ip.State;
    
-- 19. Give a detailed breakdown of the possibility of GenZ working for an Org if the "Mission is misaligned" for each state in India
SELECT 
	   ip.State,
       COUNT(*) AS GenZ_MisalignedCount,
       ROUND((SUM(mia.MisalignedMissionLikelihood LIKE '%Will work%')/COUNT(*))*100,1) AS GenZ_MisalignedPercentage
FROM
    personalized_info pi
CROSS JOIN
    mission_aspirations as mia ON pi.ResponseID = mia.ResponseID
CROSS JOIN
    india_pincode as ip ON pi.ZipCode = ip.Pincode
GROUP BY
    ip.State;
