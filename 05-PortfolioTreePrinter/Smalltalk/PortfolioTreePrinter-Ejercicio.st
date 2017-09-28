!classDefinition: #PortfolioTest category: #'PortfolioTreePrinter-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	account := ReceptiveAccount new.

	self assert: 0 = account balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:45'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 = account balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 05:34'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 = account balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:48'!
test04PortfolioBalanceIsSumOfManagedAccountsBalance

	| account1 account2 complexPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	 	
	Deposit register: 100 on: account1.
	Deposit register: 200 on: account2.
		
	self assert:300 = complexPortfolio balance .
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 18:53'!
test05PortfolioCanManagePortfolios

	| account1 account2 account3 complexPortfolio composedPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	Deposit register: 100 on:account1.
	Deposit register: 200 on: account2.
	Deposit register: 300 on: account3.

	self assert: 600 = composedPortfolio balance .! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 9/25/2017 20:14:36'!
test06ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account registers: deposit).
	self assert: (account registers: withdraw).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 9/25/2017 20:14:30'!
test07ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account registers: deposit).
	self deny: (account registers:withdraw).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:51'!
test08PortfolioKnowsTransactionsRegisteredByItsManagedAccounts 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 deposit2 deposit3 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 200 on: account2.
	deposit3 := Deposit register: 300 on: account3.
		
 	self assert: (composedPortfolio registers: deposit1).
	self assert: (composedPortfolio registers: deposit2).
	self assert: (composedPortfolio registers: deposit3).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:25'!
test08PortofolioKnowsTransactionsRegisteredByItsManagedAccounts 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 deposit2 deposit3 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 200 on: account2.
	deposit3 := Deposit register: 300 on: account3.
		
 	self assert: (composedPortfolio registers: deposit1).
	self assert: (composedPortfolio registers: deposit2).
	self assert: (composedPortfolio registers: deposit3).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:00'!
test10ReceptiveAccountManageItSelf 

	| account1 |
	account1 := ReceptiveAccount new.
		
	self assert: (account1 manages:account1).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:01'!
test11ReceptiveAccountDoNotManageOtherAccount

	| account1 account2 |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
		
	self deny: (account1 manages: account2).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:02'!
test12PortfolioManagesComposedAccounts

	| account1 account2 account3 complexPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
		
	self assert: (complexPortfolio manages: account1).
	self assert: (complexPortfolio manages: account2).
	self deny: (complexPortfolio manages: account3).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:03'!
test13PortfolioManagesComposedAccountsAndPortfolios 

	| account1 account2 account3 complexPortfolio composedPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	self assert: (composedPortfolio manages: account1).
	self assert: (composedPortfolio manages: account2).
	self assert: (composedPortfolio manages: account3).
	self assert: (composedPortfolio manages: complexPortfolio).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:28'!
test14AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on:account1.
		
	self assert: 1=account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/18/2011 17:15'!
test15PortfolioTransactionsIsTheUnionOftsAccountsTransactions 

	| account1 account2 account3 complexPortfolio account composedPortfolio deposit1 deposit2 deposit3 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 200 on: account2.
	deposit3 := Deposit register: 300 on: account3.
		
	self assert: 3 = composedPortfolio transactions size .
	self assert: (composedPortfolio transactions includes: deposit1).
	self assert: (composedPortfolio transactions includes: deposit2).
	self assert: (composedPortfolio transactions includes: deposit3).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:23'!
test16PortfolioKnowsItsAccountsTransactions 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1= (composedPortfolio transactionsOf:account1) size .
	self assert: ((composedPortfolio transactionsOf: account1) includes:deposit1).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:23'!
test17PortfolioKnowsItsPortfoliosTransactions 

	| account1 account2 account3 complexPortfolio composedPortfolio deposit1 deposit2 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.
		
	deposit1 := Deposit register: 100 on: account1.
	deposit2 := Deposit register: 100 on: account2.
	Deposit register: 100 on: account3.
		
	self assert: 2 = (composedPortfolio transactionsOf:complexPortfolio) size .
	self assert: ((composedPortfolio transactionsOf:complexPortfolio) includes:deposit1).
	self assert: ((composedPortfolio transactionsOf:complexPortfolio) includes:deposit2).
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/12/2011 13:24'!
test18PortfolioCanNotAnswerTransactionsOfNotManagedAccounts 

	| account1 account2 account3 complexPortfolio |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.
		
	self 
		should: [ complexPortfolio transactionsOf:account3 ] 
		raise: Error 
		withExceptionDo: [ :accountNotManaged |
			self assert: Portfolio accountNotManagedMessageDescription = accountNotManaged messageText ]
! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:28'!
test19CanNotCreatePortfoliosWithRepeatedAccount 

	| account1 |
	account1 := ReceptiveAccount new.
	self 
		should: [ Portfolio with: account1 with: account1 ]
		raise: Error
		withExceptionDo: [ :invalidPortfolio |
			self assert: Portfolio accountAlreadyManagedErrorMessage  = invalidPortfolio messageText ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/13/2011 19:15'!
test20CanNotCreatePortfoliosWithAccountsManagedByOtherManagedPortfolio 

	| account1 account2 complexPortfolio |
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	complexPortfolio := Portfolio with: account1 with: account2.

	self 
		should: [ Portfolio with: complexPortfolio with: account1 ]
		raise: Error
		withExceptionDo: [ :invalidPortfolio |
			self assert: Portfolio accountAlreadyManagedErrorMessage = invalidPortfolio messageText ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 05:27'!
test21TransferShouldWithdrawFromFromAccountAndDepositIntoToAccount

	| fromAccount toAccount |

	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new.

	Transfer register: 100 from: fromAccount to: toAccount.
		
	self assert: -100 = fromAccount balance.
	self assert:  100 = toAccount balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 8/13/2017 18:37:06'!
test22AccountSummaryShouldProvideHumanReadableTransactionsDetail

	| fromAccount toAccount lines |
	fromAccount := ReceptiveAccount new.
	toAccount := ReceptiveAccount new.

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
		
	lines := self accountSummaryLinesOf: fromAccount.
		
	self assert: 3 = lines size.
	self assert: 'Deposito por 100' = (lines at: 1).
	self assert: 'Extraccion por 50' = (lines at: 2).
	self assert: 'Transferencia por -100' = (lines at: 3).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test23ShouldBeAbleToBeQueryTransferNet

	| fromAccount toAccount |
	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
	Transfer register: 250 from: toAccount to: fromAccount.
		
	self assert: 150 = (self accountTransferNetOf: fromAccount).
	self assert: -150 = (self accountTransferNetOf: toAccount).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test24CertificateOfDepositShouldWithdrawInvestmentValue

	| account toAccount |
	account := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 1000 on: account.
	Withdraw register: 50 on: account.
	Transfer register: 100 from: account to: toAccount.
	CertificateOfDeposit register: 100 during: 30 at: 1/10 on: account.
		
	self assert: 100 =(self investmentNetOf:account).
	self assert: 750 = account balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test25ShouldBeAbleToQueryInvestmentEarnings

	| account investmentEarnings |
	account := ReceptiveAccount new. 
		
	CertificateOfDeposit register: 100 during: 30 at: 1/10 on: account.
	CertificateOfDeposit register: 100 during: 60 at: 15/100 on: account.

	investmentEarnings := 
		(100*((1/10)/360)*30) +
		(100*((15/100)/360)*60).
		
	self assert: investmentEarnings = (self investmentEarningsOf: account).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 8/13/2017 18:37:21'!
test26AccountSummaryShouldWorkWithCertificateOfDeposit

	| fromAccount toAccount lines |
	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
	CertificateOfDeposit register: 1000 during: 30 at: 1/10 on: fromAccount.
		
	lines := self accountSummaryLinesOf: fromAccount.
		
	self assert: 4 = lines size.
	self assert: 'Deposito por 100' =  (lines at: 1).
	self assert: 'Extraccion por 50' =  (lines at: 2).
	self assert: 'Transferencia por -100' = (lines at: 3).
	self assert: 'Plazo fijo por 1000 durante 30 dias a una tna de 10%' = (lines at: 4).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 7/14/2011 06:58'!
test27ShouldBeAbleToBeQueryTransferNetWithCertificateOfDeposit

	| fromAccount toAccount |
	fromAccount := ReceptiveAccount new. 
	toAccount := ReceptiveAccount new. 

	Deposit register: 100 on: fromAccount.
	Withdraw register: 50 on: fromAccount.
	Transfer register: 100 from: fromAccount to: toAccount.
	Transfer register: 250 from: toAccount to: fromAccount.
	CertificateOfDeposit register: 1000 during: 30 at: 1/10 on: fromAccount.
		
	self assert: 150 = (self accountTransferNetOf: fromAccount).
	self assert: -150 = (self accountTransferNetOf: toAccount).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:29'!
test28PortfolioTreePrinterPrintsTheCompositeInDepthFirstOrder

	| account1 account2 account3 complexPortfolio composedPortfolio accountNames lines |
	
	account1 := ReceptiveAccount new. 
	account2 := ReceptiveAccount new. 
	account3 := ReceptiveAccount new. 
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.

	accountNames := Dictionary new.
	accountNames at: composedPortfolio put: 'composedPortfolio'.
	accountNames at: complexPortfolio put: 'complexPortfolio'.
	accountNames at: account1 put: 'account1'.
	accountNames at: account2 put: 'account2'.
	accountNames at: account3 put: 'account3'.
		
	lines := self portofolioTreeOf: composedPortfolio namingAccountWith: accountNames.
		
	self assert: 5 = lines size.
	self assert: 'composedPortfolio' = (lines at: 1).
	self assert: ' complexPortfolio' = (lines at: 2).
	self assert: '  account1' = (lines at: 3).
	self assert: '  account2' = (lines at: 4).
	self assert: ' account3' = (lines at: 5).! !

!PortfolioTest methodsFor: 'tests' stamp: 'HernanWilkinson 9/26/2011 16:30'!
test29ReversePortfolioTreePrinterPrintsTheCompositeStartingFromTheLeaves

	| account1 account2 account3 complexPortfolio composedPortfolio accountNames lines |
	account1 := ReceptiveAccount new. 
	account2 := ReceptiveAccount new. 
	account3 := ReceptiveAccount new. 
	complexPortfolio := Portfolio with: account1 with: account2.
	composedPortfolio := Portfolio with: complexPortfolio with: account3.

	accountNames := Dictionary new.
	accountNames at: composedPortfolio put: 'composedPortfolio'.
	accountNames at: complexPortfolio put: 'complexPortfolio'.
	accountNames at: account1 put: 'account1'.
	accountNames at: account2 put: 'account2'.
	accountNames at: account3 put: 'account3'.
		
	lines := self reversePortofolioTreeOf: composedPortfolio namingAccountWith: accountNames.
		
	self assert: 5 = lines size.
	self assert: ' account3' = (lines at: 1).
	self assert: '  account2' = (lines at: 2).
	self assert: '  account1' = (lines at: 3).
	self assert: ' complexPortfolio' = (lines at: 4).
	self assert: 'composedPortfolio' = (lines at: 5).
	! !


!PortfolioTest methodsFor: 'test support' stamp: 'HW 9/28/2017 00:14:36'!
accountSummaryLinesOf: aReceptiveAccount
	| summaryLinesVisitor |
	summaryLinesVisitor := SummaryLinesVisitor new.
	^ aReceptiveAccount transactions collect: [ :transaction |
		transaction accept: summaryLinesVisitor].! !

!PortfolioTest methodsFor: 'test support' stamp: 'HW 9/28/2017 00:27:13'!
accountTransferNetOf: aReceptiveAccount
	| netTransferVisitor |
	netTransferVisitor  := NetTransferVisitor new.
	^ aReceptiveAccount transactions
		inject: 0
		into: [ :netTransfer :transaction | 
			transaction accept: netTransferVisitor ].! !

!PortfolioTest methodsFor: 'test support' stamp: 'HW 9/28/2017 01:07:17'!
investmentEarningsOf: aReceptiveAccount 
	| investmentEarningsVisitor |
	investmentEarningsVisitor := InvestmentEarningsVisitor new.
	^ aReceptiveAccount transactions inject: 0 into: [:investmentEarnings :transaction | transaction accept: investmentEarningsVisitor ].! !

!PortfolioTest methodsFor: 'test support' stamp: 'HW 9/28/2017 01:17:03'!
investmentNetOf: aReceptiveAccount
	| netInvestmentVisitor |
	netInvestmentVisitor := NetInvestmentVisitor new.
	^ aReceptiveAccount transactions
		inject: 0
		into: [ :netInvestment :transaction |
			transaction accept: netInvestmentVisitor ].! !

!PortfolioTest methodsFor: 'test support' stamp: 'HernanWilkinson 9/6/2016 19:43'!
portofolioTreeOf: aPortfolio namingAccountWith: aDictionary 
	
	self shouldBeImplemented ! !

!PortfolioTest methodsFor: 'test support' stamp: 'HernanWilkinson 9/6/2016 19:43'!
reversePortofolioTreeOf: aPortfolio namingAccountWith: aDictionary 
	
	self shouldBeImplemented ! !


!classDefinition: #AccountTransaction category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!AccountTransaction methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:47:39'!
accept: anAccountTransactionVisitor
	self subclassResponsibility.! !

!AccountTransaction methodsFor: 'evaluating' stamp: 'HernanWilkinson 7/14/2011 06:48'!
value

	self subclassResponsibility ! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
register: aValue on: account

	| withdraw |
	
	withdraw := self for: aValue.
	account register: withdraw.
		
	^ withdraw! !


!classDefinition: #CertificateOfDepositInvestment category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #CertificateOfDepositInvestment
	instanceVariableNames: 'certificateOfDeposit'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!CertificateOfDepositInvestment methodsFor: 'initialization' stamp: 'HW 9/27/2017 23:04:39'!
initializeFor: aCertificateOfDeposit 
	certificateOfDeposit := aCertificateOfDeposit! !



!CertificateOfDepositInvestment methodsFor: 'accessing' stamp: 'HW 9/28/2017 01:00:28'!
amount
	^ certificateOfDeposit amount.! !

!CertificateOfDepositInvestment methodsFor: 'accessing' stamp: 'HW 9/28/2017 01:00:49'!
annualInterestRate
	^ certificateOfDeposit annualInterestRate.! !

!CertificateOfDepositInvestment methodsFor: 'accessing' stamp: 'HW 9/28/2017 01:13:13'!
interestPayment
	^ certificateOfDeposit interestPayment.! !

!CertificateOfDepositInvestment methodsFor: 'accessing' stamp: 'HW 9/28/2017 01:03:11'!
numberOfDays
	^ certificateOfDeposit numberOfDays.! !

!CertificateOfDepositInvestment methodsFor: 'accessing' stamp: 'HW 9/28/2017 01:02:32'!
value
	^ certificateOfDeposit amount.! !


!CertificateOfDepositInvestment methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:55:41'!
accept: anAccountTransactionVisitor 
	^ anAccountTransactionVisitor visitCertificateOfDepositInvestment: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CertificateOfDepositInvestment class' category: #'PortfolioTreePrinter-Ejercicio'!
CertificateOfDepositInvestment class
	instanceVariableNames: ''!

!CertificateOfDepositInvestment class methodsFor: 'class initialization' stamp: 'HW 9/27/2017 23:03:27'!
registerFor: aCertificateOfDeposit on: aReceptiveAccount 
	| investment |
	
	investment := self new initializeFor: aCertificateOfDeposit.
	aReceptiveAccount register: investment.
		
	^ investment! !


!classDefinition: #Deposit category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !



!Deposit methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:47:46'!
accept: anAccountTransactionVisitor 
	^ anAccountTransactionVisitor visitDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: #'PortfolioTreePrinter-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 19:41'!
register: aValue on: account

	| withdraw |
	
	withdraw := self for: aValue.
	account register: withdraw.
		
	^ withdraw! !


!classDefinition: #TransferDeposit category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #TransferDeposit
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!TransferDeposit methodsFor: 'initialization' stamp: 'BAB 9/26/2017 23:02:02'!
initializeFor: aTransfer

	transfer := aTransfer ! !


!TransferDeposit methodsFor: 'value' stamp: 'HW 9/27/2017 22:51:35'!
value

	^ transfer amount! !



!TransferDeposit methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:47:58'!
accept: anAccountTransactionVisitor
	^ anAccountTransactionVisitor visitTransferDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferDeposit class' category: #'PortfolioTreePrinter-Ejercicio'!
TransferDeposit class
	instanceVariableNames: ''!

!TransferDeposit class methodsFor: 'instance creation' stamp: 'BAB 9/26/2017 23:02:12'!
registerFor: aTransfer on: account

	| deposit |
	
	deposit := self new initializeFor: aTransfer.
	account register: deposit.
		
	^ deposit! !


!classDefinition: #TransferWithdraw category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #TransferWithdraw
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!TransferWithdraw methodsFor: 'initialization' stamp: 'BAB 9/26/2017 23:04:15'!
initializeFor: aTransfer

	transfer := aTransfer! !


!TransferWithdraw methodsFor: 'value' stamp: 'HW 9/27/2017 22:51:42'!
value

	^ transfer amount ! !



!TransferWithdraw methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:48:04'!
accept: anAccountTransactionVisitor 
	^ anAccountTransactionVisitor visitTransferWithdraw: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferWithdraw class' category: #'PortfolioTreePrinter-Ejercicio'!
TransferWithdraw class
	instanceVariableNames: ''!

!TransferWithdraw class methodsFor: 'instance creation' stamp: 'BAB 9/26/2017 23:06:08'!
registerFor: aTransfer on: account

	| withdraw |
	
	withdraw := self new initializeFor: aTransfer.
	account register: withdraw.
		
	^ withdraw! !


!classDefinition: #Withdraw category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'negated 9/25/2017 20:39:59'!
initializeFor: aValue

	value := aValue! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/14/2011 05:54'!
value

	^ value ! !



!Withdraw methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:48:11'!
accept: anAccountTransactionVisitor 
	^ anAccountTransactionVisitor visitWithdraw: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: #'PortfolioTreePrinter-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/14/2011 05:32'!
register: aValue on: account

	| withdraw |
	
	withdraw := self for: aValue.
	account register: withdraw.
		
	^ withdraw! !


!classDefinition: #AccountTransactionVisitor category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #AccountTransactionVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!AccountTransactionVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:10:34'!
visitCertificateOfDepositInvestment: aCertificateOfDepositInvestment
	self subclassResponsibility ! !

!AccountTransactionVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:08:29'!
visitDeposit: aDeposit
	self subclassResponsibility ! !

!AccountTransactionVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:09:54'!
visitTransferDeposit: aTransferDeposit
	self subclassResponsibility ! !

!AccountTransactionVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:10:07'!
visitTransferWithdraw: aTransferWithdraw
	self subclassResponsibility ! !

!AccountTransactionVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:09:18'!
visitWithdraw: aWithdraw
	self subclassResponsibility ! !


!classDefinition: #BalanceVisitor category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransactionVisitor subclass: #BalanceVisitor
	instanceVariableNames: 'balance'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!BalanceVisitor methodsFor: 'as yet unclassified' stamp: 'HW 9/28/2017 01:30:03'!
initialize
	balance := 0.! !


!BalanceVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:35:19'!
visitCertificateOfDepositInvestment: aCertificateOfDepositInvestment 
	balance := balance - aCertificateOfDepositInvestment amount.
	^ balance.! !

!BalanceVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:35:59'!
visitDeposit: aDeposit 
	balance := balance + aDeposit value.
	^ balance.! !

!BalanceVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:36:23'!
visitTransferDeposit: aTransferDeposit 
	balance := balance + aTransferDeposit value.
	^ balance.! !

!BalanceVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:36:35'!
visitTransferWithdraw: aTransferWithdraw 
	balance := balance - aTransferWithdraw value.
	^ balance.! !

!BalanceVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:36:48'!
visitWithdraw: aWithdraw 
	balance := balance - aWithdraw value.
	^ balance.! !


!classDefinition: #InvestmentEarningsVisitor category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransactionVisitor subclass: #InvestmentEarningsVisitor
	instanceVariableNames: 'investmentEarnings'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!InvestmentEarningsVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:37:17'!
visitCertificateOfDepositInvestment: aCertificateOfDepositInvestment 
	investmentEarnings := investmentEarnings + aCertificateOfDepositInvestment interestPayment.
	^ investmentEarnings.! !


!InvestmentEarningsVisitor methodsFor: 'as yet unclassified' stamp: 'HW 9/28/2017 01:13:56'!
initialize
	investmentEarnings := 0.! !


!classDefinition: #NetInvestmentVisitor category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransactionVisitor subclass: #NetInvestmentVisitor
	instanceVariableNames: 'netInvestment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!NetInvestmentVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:37:49'!
visitCertificateOfDepositInvestment: aCertificateOfDepositInvestment 
	netInvestment  := netInvestment  + aCertificateOfDepositInvestment amount.
	^ netInvestment.! !

!NetInvestmentVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:18:18'!
visitDeposit: aDeposit 
	^ netInvestment.! !

!NetInvestmentVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:18:55'!
visitTransferWithdraw: aTransferWithdraw 
	^ netInvestment.! !

!NetInvestmentVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:18:37'!
visitWithdraw: aWithdraw 
	^ netInvestment.! !


!NetInvestmentVisitor methodsFor: 'initialization' stamp: 'HW 9/28/2017 01:21:29'!
initialize 
	netInvestment := 0.! !


!classDefinition: #NetTransferVisitor category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransactionVisitor subclass: #NetTransferVisitor
	instanceVariableNames: 'netTransfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!NetTransferVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:03:58'!
visitCertificateOfDepositInvestment: aCertificateOfDepositInvestment 
	^ netTransfer.! !

!NetTransferVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:35:38'!
visitDeposit: aDeposit 
	^ netTransfer.! !

!NetTransferVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:38:37'!
visitTransferDeposit: aTransferDeposit 
	netTransfer := netTransfer + aTransferDeposit value.
	^ netTransfer.! !

!NetTransferVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:38:53'!
visitTransferWithdraw: aTransferWithdraw 
	netTransfer := netTransfer - aTransferWithdraw value.
	^ netTransfer.! !

!NetTransferVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:44:15'!
visitWithdraw: aWithdraw
	^ netTransfer.! !


!NetTransferVisitor methodsFor: 'initialization' stamp: 'HW 9/28/2017 00:32:39'!
initialize
	netTransfer := 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetTransferVisitor class' category: #'PortfolioTreePrinter-Ejercicio'!
NetTransferVisitor class
	instanceVariableNames: 'netTransfer'!


!classDefinition: #SummaryLinesVisitor category: #'PortfolioTreePrinter-Ejercicio'!
AccountTransactionVisitor subclass: #SummaryLinesVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!SummaryLinesVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 01:02:48'!
visitCertificateOfDepositInvestment: aCertificateOfDepositInvestment 
	 ^ 'Plazo fijo por ', aCertificateOfDepositInvestment value printString ,' durante ',
	aCertificateOfDepositInvestment numberOfDays printString , ' dias a una tna de ',
	(aCertificateOfDepositInvestment annualInterestRate * 100) printString , '%'! !

!SummaryLinesVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:17:53'!
visitDeposit: aDeposit 
	^ 'Deposito por ', aDeposit value asString.! !

!SummaryLinesVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:20:31'!
visitTransferWithdraw: aTransferWithdraw 
	^ 'Transferencia por -', aTransferWithdraw value printString.! !

!SummaryLinesVisitor methodsFor: 'evaluating' stamp: 'HW 9/28/2017 00:19:29'!
visitWithdraw: aWithdraw 
	^ 'Extraccion por ', aWithdraw value printString.! !


!classDefinition: #CertificateOfDeposit category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #CertificateOfDeposit
	instanceVariableNames: 'amount numberOfDays account annualInterestRate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!CertificateOfDeposit methodsFor: 'intialization' stamp: 'HW 9/27/2017 23:59:29'!
register: anAmount during: aNumberOfDays at: anAnnualRate on: aReceptiveAccount 
	amount := anAmount.
	account := aReceptiveAccount .
	annualInterestRate := anAnnualRate.
	numberOfDays := aNumberOfDays.
	CertificateOfDepositInvestment registerFor: self on: aReceptiveAccount.! !


!CertificateOfDeposit methodsFor: 'accessing' stamp: 'HW 9/27/2017 23:18:46'!
amount
	^ amount! !

!CertificateOfDeposit methodsFor: 'accessing' stamp: 'HW 9/27/2017 23:50:54'!
annualInterestRate
	^ annualInterestRate ! !

!CertificateOfDeposit methodsFor: 'accessing' stamp: 'HW 9/27/2017 23:55:13'!
interestPayment
	^ amount * ((annualInterestRate / 360) * numberOfDays)! !

!CertificateOfDeposit methodsFor: 'accessing' stamp: 'HW 9/27/2017 23:50:33'!
numberOfDays
	^numberOfDays! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CertificateOfDeposit class' category: #'PortfolioTreePrinter-Ejercicio'!
CertificateOfDeposit class
	instanceVariableNames: ''!

!CertificateOfDeposit class methodsFor: 'class initialization' stamp: 'HW 9/27/2017 23:51:46'!
register: anAmount during: aNumberOfDas at: anAnnualRate on: aReceptiveAccount 
	self new register: anAmount during: aNumberOfDas at: anAnnualRate on: aReceptiveAccount.! !


!classDefinition: #SummarizingAccount category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #SummarizingAccount
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!SummarizingAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:34'!
manages: anAccount

	self subclassResponsibility ! !

!SummarizingAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:34'!
registers: aTransaction

	self subclassResponsibility ! !


!SummarizingAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:34'!
balance

	self subclassResponsibility ! !

!SummarizingAccount methodsFor: 'transactions' stamp: 'BAB 9/24/2017 13:50:37'!
intersectsWith: anAccountsCollection

	self subclassResponsibility ! !

!SummarizingAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:35'!
transactions

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: #'PortfolioTreePrinter-Ejercicio'!
SummarizingAccount subclass: #Portfolio
	instanceVariableNames: 'accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Portfolio methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 19:22'!
manages: anAccount

	^ self = anAccount  or: [ accounts anySatisfy: [ :managedAccount | managedAccount manages: anAccount  ]  ]! !

!Portfolio methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 19:20'!
registers: aTransaction

	^ accounts anySatisfy: [ :anAccount | anAccount registers: aTransaction ]  ! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 8/13/2017 17:47:44'!
balance

	^ accounts sum: [ :account | account balance ]
! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 9/25/2017 19:40:20'!
transactions 

	^ accounts 
		inject: OrderedCollection new 
		into: [ :transactions :account | transactions addAll: account transactions. transactions ]
	! !

!Portfolio methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 19:27'!
transactionsOf: anAccount 

	^ (self manages: anAccount)
		ifTrue: [ anAccount transactions ] 
		ifFalse: [ self error: self class accountNotManagedMessageDescription]
	! !


!Portfolio methodsFor: 'initialization' stamp: 'HW 9/23/2017 21:57:53'!
initializeWith: anAccountsSet

	accounts := anAccountsSet! !

!Portfolio methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 19:19'!
initializeWithAll: aCollectionOfAccounts

	accounts := aCollectionOfAccounts   ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'PortfolioTreePrinter-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'BAB 9/25/2017 00:33:33'!
failIfHasRepeatedAccount: aCollectionOfAccounts
	| aSetOfAccounts |
	aSetOfAccounts _ Set newFrom: aCollectionOfAccounts.
	aSetOfAccounts size = aCollectionOfAccounts size ifFalse: [ ^ self signalAccountAlreadyManaged ].
	(aCollectionOfAccounts
		allSatisfy: [ :anAccount | | otherAccountsSet |
			otherAccountsSet _ aSetOfAccounts copy.
			otherAccountsSet remove: anAccount.
			(anAccount isIndependentOf: otherAccountsSet)]) ifFalse:
		[self signalAccountAlreadyManaged ].! !

!Portfolio class methodsFor: 'instance creation' stamp: 'BAB 9/24/2017 12:42:19'!
signalAccountAlreadyManaged
	^ Error signal: self accountAlreadyManagedErrorMessage! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:48'!
with: anAccount1 with: anAccount2

	^ self withAll: (Array with: anAccount1 with: anAccount2 )! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 19:40'!
withAll: aCollectionOfAccounts

	aCollectionOfAccounts asSet size = aCollectionOfAccounts size ifFalse: [ self error: self accountAlreadyManagedErrorMessage  ].
	
	aCollectionOfAccounts do: [ :sourceAccount | 
		aCollectionOfAccounts do: [ :targetAccount | 
			(sourceAccount = targetAccount) not ifTrue: [
				(sourceAccount manages: targetAccount) ifTrue: [ self error: self accountAlreadyManagedErrorMessage ]]]].
	
	^self new initializeWithAll: aCollectionOfAccounts ! !


!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:22'!
check: sourceAccount doesNotManagaAnyOf: aCollectionOfAccounts

	^ aCollectionOfAccounts do: [ :targetAccount | 
			(sourceAccount = targetAccount) not ifTrue: [ 
				(sourceAccount manages: targetAccount) ifTrue: [ self error: self accountAlreadyManagedErrorMessage ] ] ]! !

!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:21'!
checkAccountsAreUnique: aCollectionOfAccounts

	aCollectionOfAccounts asSet size = aCollectionOfAccounts size
		ifFalse: [ self error: self accountAlreadyManagedErrorMessage ]! !

!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:21'!
checkCreationPreconditions: aCollectionOfAccounts

	self checkAccountsAreUnique: aCollectionOfAccounts.
	self checkNoCircularReferencesIn: aCollectionOfAccounts! !

!Portfolio class methodsFor: 'assertions' stamp: 'HernanWilkinson 9/18/2011 17:22'!
checkNoCircularReferencesIn: aCollectionOfAccounts

	aCollectionOfAccounts do: [ :sourceAccount | self check: sourceAccount doesNotManagaAnyOf: aCollectionOfAccounts ]! !


!Portfolio class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/13/2011 19:28'!
accountAlreadyManagedErrorMessage

	^ 'Account already managed'! !

!Portfolio class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/13/2011 19:27'!
accountNotManagedMessageDescription
	
	^ 'Account not managed'! !


!classDefinition: #ReceptiveAccount category: #'PortfolioTreePrinter-Ejercicio'!
SummarizingAccount subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HW 9/28/2017 01:29:18'!
balance
	| balanceVisitor |
	balanceVisitor := BalanceVisitor new.
	^ transactions
		inject: 0
		into: [ :balance :transaction |
			transaction accept: balanceVisitor ].! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:37'!
manages: anAccount

	^ self = anAccount 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HernanWilkinson 7/13/2011 18:37'!
registers: aTtransaction

	^ transactions includes: aTtransaction 
! !


!classDefinition: #Transfer category: #'PortfolioTreePrinter-Ejercicio'!
Object subclass: #Transfer
	instanceVariableNames: 'sourceAccount targetAccount amount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PortfolioTreePrinter-Ejercicio'!

!Transfer methodsFor: 'as yet unclassified' stamp: 'HW 9/27/2017 18:30:52'!
amount
	^ amount.! !

!Transfer methodsFor: 'as yet unclassified' stamp: 'BAB 9/26/2017 22:59:22'!
register: anAmount from: aSourceAccount to: aTargetAccount
	amount := anAmount.
	TransferWithdraw registerFor: self on: aSourceAccount.
	TransferDeposit registerFor: self on: aTargetAccount.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: #'PortfolioTreePrinter-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'initialization' stamp: 'BAB 9/26/2017 22:55:02'!
register: anAmount from: aSourceAccount to: aTargetAccount
	Transfer new register: anAmount from: aSourceAccount to: aTargetAccount.! !
