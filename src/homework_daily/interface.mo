// actor {
//     // Add a new homework task
//     addHomework: shared (homework: Homework) -> async Nat;

//     // Get a specific homework task by id
//     getHomework: shared query (id: Nat) -> async Result.Result<Homework, Text>;

//     // Update a homework task's title, description, and/or due date
//     updateHomework: shared (id: Nat, homework: Homework) -> async Result.Result<(), Text>;

//     // Mark a homework task as completed 
//     markAsCompleted: shared (id: Nat) -> async Result.Result<(), Text>;

//     // Delete a homework task by id
//     deleteHomework: shared (id: Nat) -> async Result.Result<(), Text>;

//     // Get the list of all homework tasks
//     getAllHomework: shared query () -> async [Homework];

//     // Get the list of pending (not completed) homework tasks
//     getPendingHomework: shared query () -> async [Homework];

//     // Search for homework tasks based on a search terms
//     searchHomework: shared query (searchTerm: Text) -> async [Homework];
// }