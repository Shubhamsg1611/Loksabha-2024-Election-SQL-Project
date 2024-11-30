Select * From constituencywise_details
Select * From constituencywise_results
Select * From partywise_results
Select * From statewise_results
Select * From states


-- Q.1 Retrieve records of all candidate who belongs to 'Bharatiya Janata Party'.

SELECT * 
FROM constituencywise_details
WHERE Party = 'Bharatiya Janata Party'

-- Q.2  Retrieve %of_votes by highest to lowest. 

SELECT Candidate, Party, Total_Votes, Round(of_Votes,2) as Vote_Percentage  FROM constituencywise_details
ORDER BY of_Votes DESC

-- Q.3 Get all Unique Parties who involved in Election.

SELECT DISTINCT Party 
FROM constituencywise_details

-- Q.4 Get the constituencies with the largest winning margin.

SELECT Top 5 Constituency, Margin, State
FROM statewise_results
WHERE Status = 'Result Declared'
ORDER BY Margin DESC

-- Q.5 Get constituencies where the election was uncontested:

SELECT Constituency, State
FROM statewise_results
WHERE Status = 'Uncontested'

-- Q.6 Get the leading candidates in each state.

SELECT State, Leading_Candidate, Margin, Constituency
FROM statewise_results
WHERE Status = 'Result Declared'
ORDER BY State, Margin DESC

-- Q.7 Get the number of constituencies with declared results in each state.

SELECT State, COUNT(*) AS Constituencies_With_Declared_Results
FROM statewise_results
GROUP BY State

-- Q.8 Find the leading and trailing candidates for a specific state (e.g., Gujarat).

SELECT Constituency, Leading_Candidate, Trailing_Candidate, Margin
FROM statewise_results
WHERE State = 'Gujarat' AND Status = 'Result Declared'

-- Q.9  Total votes by party across all constituencies.

SELECT Distinct Party, SUM(Total_Votes) AS Total_Votes_By_Party
FROM constituencywise_details
GROUP BY Party
ORDER BY Total_Votes_By_Party DESC

-- Q.10 Identify constituencies with Independent candidates receiving more than 10% of votes.

SELECT d.Constituency_ID, r.Constituency_Name, d.Candidate, d.Total_Votes, d.of_Votes
FROM constituencywise_details d
JOIN constituencywise_results r
ON d.Constituency_ID = r.Constituency_ID
WHERE Party = 'Independent' AND of_Votes > 10

-- Q.11 Top 5 constituencies with the largest margin of victory.

Select Top 5 Parliament_constituency, Constituency_Name, Total_Votes, Margin From constituencywise_results
Order by Margin Desc

-- Q.12 Count the number of uncontested constituencies. 

SELECT COUNT(*) AS Uncontested_Constituencies
FROM constituencywise_results
WHERE Margin = 0

-- Q.13 Retrieve all candidates who participated in Election from 'Baramati'.

SELECT d.Constituency_ID, d.Candidate, d.Party, r.Winning_Candidate, r.Margin, r.Total_Votes
FROM constituencywise_details d
JOIN constituencywise_results r
ON d.Constituency_ID = r.Constituency_ID
Where r.Constituency_Name = 'Baramati'

-- Q.14 Total number of seats won by each party.

SELECT Party, SUM(Won) AS Total_Seats
FROM partywise_results
GROUP BY Party
ORDER BY Total_Seats DESC

-- Q.15 List all parties that have won fewer than 5 seats.

SELECT Party, Won
FROM partywise_results
Where Won < 5

-- Q.16 Count the number of states and union territories.

SELECT COUNT(*) AS Total_States
FROM states

-- Q.17 Total votes cast in each state.

SELECT State, SUM(Margin + Margin) AS Total_Votes
FROM statewise_results
GROUP BY State

-- Q.18 List all trailing and winning margins per constituency.

SELECT Constituency, Leading_Candidate, Trailing_Candidate, Margin
FROM statewise_results

-- Q.19 Constituencies with the largest margin for a specific state.

SELECT Constituency, Leading_Candidate, Margin
FROM statewise_results
WHERE State = 'Gujarat'
ORDER BY Margin DESC;

-- Q.20 What is the total number of seats available for elections in each state?

SELECT s.State AS State_Name, COUNT(cr.Constituency_ID) AS Total_Seats_Available
FROM constituencywise_results cr
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
GROUP BY s.State
ORDER BY s.State

-- Q.21 Total Seats Won by N.D.A. Allianz.

SELECT SUM(CASE WHEN party IN (
                'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
            ) THEN [Won] ELSE 0 END) AS NDA_Alliance_Total_Seats_Won
FROM partywise_results

-- Q.22 Total Seats Won by I.N.D.I.A. Allianz.

SELECT SUM(CASE WHEN party IN (
                'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
            ) THEN [Won] ELSE 0 END) AS INDIA_Alliance_Total_Seats_Won
FROM partywise_results

-- Q.23 Total seats won by I.N.D.I.A. Alliance Parties.

SELECT party as Party_Name, won as Seats_Won
FROM partywise_results
WHERE party IN (
        'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
    )
ORDER BY Seats_Won DESC

-- Q.23 Total seats won by N.D.A. Alliance Parties.

SELECT party as Party_Name, won as Seats_Won
FROM partywise_results
WHERE party IN (
        'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
    )
ORDER BY Seats_Won DESC

-- Q.24 Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER & Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?

ALTER TABLE partywise_results ADD alliance VARCHAR(50);
UPDATE partywise_results SET party_alliance = 'I.N.D.I.A'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK')

UPDATE partywise_results SET party_alliance = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM')

UPDATE partywise_results
SET party_alliance = 'OTHER'
WHERE party_alliance IS NULL

SELECT Party_alliance, COUNT(cr.Constituency_ID) AS Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
WHERE p.Party_alliance IN ('NDA', 'I.N.D.I.A', 'OTHER')
GROUP by p.Party_alliance
ORDER BY Seats_Won DESC
 
 -- Q.25 Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency?

SELECT cr.Winning_Candidate, p.Party, p.party_alliance, cr.Total_Votes, cr.Margin, cr.Constituency_Name, s.State
FROM constituencywise_results cr
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.State = 'Uttar Pradesh' AND cr.Constituency_Name = 'AMETHI'

-- Q.26 What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?

SELECT cd.Candidate, cd.Party, cd.EVM_Votes, cd.Postal_Votes, cd.Total_Votes, cr.Constituency_Name
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
WHERE cr.Constituency_Name = 'Satara'
ORDER BY cd.Total_Votes DESC

-- Q.27 Which parties won the most seats in s State, and how many seats did each party win?

SELECT p.Party, COUNT(cr.Constituency_ID) AS Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.state = 'Maharashtra'
GROUP BY p.Party
ORDER BY Seats_Won DESC

-- Q.28 What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024?

SELECT s.State AS State_Name,
    SUM(CASE WHEN p.party_alliance = 'NDA' THEN 1 ELSE 0 END) AS NDA_Seats_Won,
    SUM(CASE WHEN p.party_alliance = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_Seats_Won,
	SUM(CASE WHEN p.party_alliance = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_Seats_Won
FROM constituencywise_results cr
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE p.party_alliance IN ('NDA', 'I.N.D.I.A',  'OTHER')  -- Filter for NDA and INDIA alliances
GROUP BY s.State
ORDER BY s.State

-- Q.29 Which candidate received the highest number of EVM votes in each constituency (Top 10)?

SELECT TOP 10 cr.Constituency_Name, cd.Constituency_ID, cd.Candidate, cd.EVM_Votes
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
WHERE cd.EVM_Votes = (
        SELECT MAX(cd1.EVM_Votes)
        FROM constituencywise_details cd1
        WHERE cd1.Constituency_ID = cd.Constituency_ID)
ORDER BY cd.EVM_Votes DESC;

-- Q.30 Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?

WITH RankedCandidates AS (
SELECT cd.Constituency_ID, cd.Candidate, cd.Party, cd.EVM_Votes, cd.Postal_Votes, cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
        ROW_NUMBER() OVER (PARTITION BY cd.Constituency_ID ORDER BY cd.EVM_Votes + cd.Postal_Votes DESC) AS VoteRank
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.State = 'Maharashtra')

SELECT cr.Constituency_Name,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runnerup_Candidate
FROM RankedCandidates rc
JOIN constituencywise_results cr ON rc.Constituency_ID = cr.Constituency_ID
GROUP BY cr.Constituency_Name
ORDER BY cr.Constituency_Name;