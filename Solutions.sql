-- a. Подсчитать общую сумму заключенных с клиентом кредитных договоров в 2024 году только по ипотечным продуктам

SELECT 
    SUM(LC.LoanAmount) AS TotalMortgageAmount
FROM 
    LoanContract LC
JOIN 
    CreditProduct CP ON LC.ProductID = CP.ProductID
WHERE 
    CP.ProductType = 'Mortgage'
    AND YEAR(LC.ContractDate) = 2024;



-- b. По первым двум отклоненным в 2024 году заявкам вывести ФИО клиента, ФИО отклонившего заявку сотрудника и всю информацию о заявке

SELECT 
    C.FirstName AS CustomerFirstName,
    C.LastName AS CustomerLastName,
    C.MiddleName AS CustomerMiddleName,
    E.FirstName AS EmployeeFirstName,
    E.LastName AS EmployeeLastName,
    E.MiddleName AS EmployeeMiddleName,
    LA.*
FROM 
    LoanApplication LA
JOIN 
    Customer C ON LA.CustomerID = C.CustomerID
JOIN 
    StatusHistory SH ON LA.ApplicationID = SH.EntityID AND SH.EntityType = 'LoanApplication'
JOIN 
    BankEmployee E ON SH.EmployeeID = E.EmployeeID
WHERE 
    LA.ApplicationStatus = 'Rejected'
    AND YEAR(LA.ApplicationDate) = 2024
ORDER BY 
    LA.ApplicationDate ASC
LIMIT 2;



-- c. Для клиента, которым была одобрена наибольшая сумма кредита в марте 2024 года необходимо вывести всю информацию о клиенте, сумму выданных кредитов и в одном столбце через запятую ФИО участвовавших в сделках сотрудников

SELECT 
    C.CustomerID,
    C.FirstName,
    C.LastName,
    C.MiddleName,
    C.DateOfBirth,
    C.Address,
    C.PhoneNumber,
    C.Email,
    LC.TotalLoanAmount AS MaxLoanAmount,
    GROUP_CONCAT(DISTINCT CONCAT(E.FirstName, ' ', E.LastName, ' ', E.MiddleName) SEPARATOR ', ') AS EmployeeNames
FROM 
    (SELECT 
        CustomerID,
        SUM(LoanAmount) AS TotalLoanAmount
     FROM 
        LoanContract
     WHERE 
        ApplicationID IN (
            SELECT LA.ApplicationID
            FROM LoanApplication LA
            WHERE 
                LA.ApplicationStatus = 'Approved'
                AND LA.ApplicationDate BETWEEN '2024-03-01' AND '2024-03-31'
        )
     GROUP BY 
        CustomerID
     HAVING 
        TotalLoanAmount = (SELECT MAX(SumLoan)
                           FROM (SELECT 
                                    SUM(LoanAmount) AS SumLoan
                                 FROM 
                                    LoanContract
                                 WHERE 
                                    ApplicationID IN (
                                        SELECT LA.ApplicationID
                                        FROM LoanApplication LA
                                        WHERE 
                                            LA.ApplicationStatus = 'Approved'
                                            AND LA.ApplicationDate BETWEEN '2024-03-01' AND '2024-03-31'
                                    )
                                 GROUP BY 
                                    CustomerID) AS MaxSum)
    ) AS LC
JOIN Customer C ON LC.CustomerID = C.CustomerID
JOIN LoanContract LC2 ON LC.CustomerID = LC2.CustomerID
JOIN EmployeeInContract EIC ON LC2.ContractID = EIC.ContractID
JOIN BankEmployee E ON EIC.EmployeeID = E.EmployeeID
GROUP BY 
    C.CustomerID, 
    C.FirstName, 
    C.LastName, 
    C.MiddleName, 
    C.DateOfBirth, 
    C.Address, 
    C.PhoneNumber, 
    C.Email, 
    LC.TotalLoanAmount;





-- d. Для участвовавших в кредитных заявках в 2024 году клиентов и сотрудников банка вывести в одном столбце ФИО клиентов и ФИО сотрудников

SELECT 
    GROUP_CONCAT(DISTINCT CONCAT(C.FirstName, ' ', C.LastName, ' ', C.MiddleName) SEPARATOR ', ') AS CustomerNames,
    GROUP_CONCAT(DISTINCT CONCAT(E.FirstName, ' ', E.LastName, ' ', E.MiddleName) SEPARATOR ', ') AS EmployeeNames
FROM 
    LoanApplication LA
JOIN 
    Customer C ON LA.CustomerID = C.CustomerID
JOIN 
    EmployeeInApplication EIA ON LA.ApplicationID = EIA.ApplicationID
JOIN 
    BankEmployee E ON EIA.EmployeeID = E.EmployeeID
WHERE 
    LA.ApplicationDate BETWEEN '2024-01-01' AND '2024-12-31';


-- e. Вывести запрошенные в заявках за 2024 год суммы по кредитным продуктам “Ипотека”, “Автокредит” в формате: Сумма по ипотеке Сумма по автокредиту

SELECT 
    SUM(CASE WHEN CP.ProductType = 'Mortgage' THEN LA.RequestedAmount ELSE 0 END) AS MortgageTotal,
    SUM(CASE WHEN CP.ProductType = 'Auto Loan' THEN LA.RequestedAmount ELSE 0 END) AS AutoLoanTotal
FROM 
    LoanApplication LA
JOIN 
    CreditProduct CP ON LA.ProductID = CP.ProductID
WHERE 
    LA.ApplicationDate BETWEEN '2024-01-01' AND '2024-12-31';










