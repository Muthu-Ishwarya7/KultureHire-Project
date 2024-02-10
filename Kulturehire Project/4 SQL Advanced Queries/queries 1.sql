use genzdataset;

show tables;

select * from learning_aspirations as la;
select * from manager_aspirations as ma;
select * from mission_aspirations as mia;
select * from personalized_info as pi;

-- CREATING A NEW BY JOINING 4 TABLES 
CREATE TABLE genz_data AS
SELECT
    ma.ResponseID,
    la.CareerInfluenceFactor,
    la.HigherEducationAbroad,
    la.PreferredWorkingEnvironment,
    la.ZipCode AS Learning_Zip_Code,
    la.ClosestAspirationalCareer,

    ma.Worklikelihood3Years AS Manager_3_Years,
    ma.PreferredEmployer AS Manager_Preferred_Employers,
    ma.PreferredManager AS Manager_Preferred_Manager,
    ma.PreferredWorkSetup AS Manager_Preferred_Work_Setup,
	ma.WorkLikelihood7Years AS Manager_7_Years,

    mia.MissionUndefinedLikelihood,
    mia.MisalignedMissionLikelihood,
    mia.NoSocialImpactLikelihood,
    mia.LaidOffEmployees,
    mia.ExpectedSalary3Years AS Mission_Expected_Salary_3_Years,
    mia.ExpectedSalary5Years AS Mission_Expected_Salary_5_Years,
    
    pi.CurrentCountry,
    pi.ZipCode AS Personalized_Zip_Code,
    pi.Gender
    
from learning_aspirations as la
	  right join manager_aspirations as ma on la.ResponseID = ma.ResponseID
      inner join mission_aspirations as mia on ma.ResponseID = mia.ResponseID
      inner join personalized_info as pi on mia.ResponseID = pi.ResponseID;

select * from genz_data;
      
-- Question 1: How many Male have responded to the survey from India
SELECT COUNT(*) AS MaleRespondentsFromIndia
FROM genz_data
WHERE Gender = 'Male\r' AND CurrentCountry = 'India';  -- escape character (\r) there might be extra carriage return characters in data

-- Question 2: How many Female have responded to the survey from India
SELECT COUNT(*) AS FemaleRespondentsFromIndia
FROM genz_data
WHERE Gender = 'Female\r' AND CurrentCountry = 'India';

-- Question 3: How many of the Gen-Z are influenced by their parents in regards to their career choices from India
SELECT COUNT(*) AS CareerInfluencedByParents
from genz_data
where CareerInfluenceFactor LIKE '%My Parents%' AND CurrentCountry = 'India';

-- Question 4: How many of the Female Gen-Z are influenced by their parents in regards to their career choices from India 
SELECT COUNT(*) AS FemaleCareerInfluencedByParents
from genz_data
where CareerInfluenceFactor = "My Parents" AND Gender = 'Female\r' AND CurrentCountry = 'India';

-- Question 5: How many of the Male Gen-Z are influenced by their parents in regards to their career choices from India
SELECT COUNT(*) AS MaleCareerInfluencedByParents
from genz_data
where CareerInfluenceFactor = "My Parents" AND Gender = 'Male\r' AND CurrentCountry = 'India';

-- Question 6: How many of the Male and Female (individually display in 2 different columns, but as part of the same query) Gen- Z are influenced by their parents in regards to their career choices from India
SELECT
    SUM(Gender = 'Male\r') AS MaleCareerInfluencedByParents,
    SUM(Gender = 'Female\r') AS FemaleCareerInfluencedByParents
from genz_data
where CareerInfluenceFactor = "My Parents" AND CurrentCountry = 'India';

-- Question 7: How many Gen-Z are influenced by Media and Influencers together from India
SELECT COUNT(*) AS CareerInfluencedByMedia_Influencers
from genz_data
where (CareerInfluenceFactor LIKE '%media%' OR CareerInfluenceFactor LIKE '%influencers%') AND CurrentCountry = 'India';

-- Question 8: How many Gen-Z are influenced by Social Media and Influencers together, display for Male and Female seperately from India
SELECT
    SUM(Gender = 'Male\r') AS MaleCareerInfluencedByMedia_Influencers,
    SUM(Gender = 'Female\r') AS FemaleCareerInfluencedByMedia_Influencers
from genz_data
where (CareerInfluenceFactor LIKE '%media%' OR CareerInfluenceFactor LIKE '%influencers%') AND CurrentCountry = 'India';

-- Question 9: How many of the Gen-Z who are influenced by the social media for their career aspiration are looking to go abroad
SELECT COUNT(*) AS CareerInfluencedByMedia_Abroad  -- CareerInfluenceFactor,HigherEducationAbroad
from genz_data
where CareerInfluenceFactor LIKE '%media%' AND HigherEducationAbroad LIKE '%yes%';

-- Question 10: How many of the Gen-Z who are influenced by "people in their circle" for career aspiration are looking to go abroad
SELECT COUNT(*) AS CareerInfluencedByPeopleCircle_Abroad   -- CareerInfluenceFactor,HigherEducationAbroad
from genz_data
where CareerInfluenceFactor LIKE '%people%' AND HigherEducationAbroad LIKE '%yes%';