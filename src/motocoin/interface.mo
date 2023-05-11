// actor {
//     // Returns the name of the token 
//     name : shared query () -> async Text;

//     // Returns the symbol of the token 
//     symbol : shared query () -> async Text;

//     // Returns the the total number of tokens on all accounts
//     totalSupply : shared query () -> async Nat;

//     // Returns the balance of the account
//     balanceOf : shared query (account : Account) -> async (Nat);

//     // Transfer tokens to another account
//     transfer : shared (from: Account, to : Account, amount : Nat) -> async Result.Result<(), Text>;

//     // Airdrop 1000 MotoCoin to any student that is part of the Bootcamp.
//     airdrop : shared () -> async Result.Result<(),Text>;
// }