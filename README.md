# matrix
*/- A token is a representation of something in the blockchain. 
	This something can be money, time, services, shares in a company, a virtual pet, anything. By representing things as tokens, we can allow smart contracts to interact with them, exchange them, create or destroy them.
/*- A token contract is simply an Ethereum smart contract. 
	"Sending tokens" actually means "calling a method on a smart contract that someone wrote and deployed". At the end of the day, a token contract is not much more a mapping of addresses to balances, plus some methods to add and subtract from those balances.
/*- It is these balances that represent the tokens themselves. 
	Someone "has tokens" when their balance in the token contract is non-zero. That’s it! These balances could be considered money, experience points in a game, deeds of ownership, or voting rights, and each of these tokens would be stored in different token contracts.
/*- Note that there’s a big difference between having two voting rights and 
	two deeds of ownership: 
	each vote is equal to all others, but houses usually are not! This is called fungibility. Fungible goods are equivalent and interchangeable, like Ether, fiat currencies, and voting rights. Non-fungible goods are unique and distinct, like deeds of ownership, or collectibles.
	
*TODO* -- reduce the smartcontracts code 
