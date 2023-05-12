import Int "mo:base/Int";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Principal "mo:base/Principal";

actor Calculator {
    public type TestResult = Result.Result<(), TestError>;
    public type TestError = {
        #UnexpectedValue : Text;
        #UnexpectedError : Text;
    };

    var calc : Int = 1;

    public func add(num : Int) : async Int {
        calc += num;
        return calc;
    };

    public func sub(num : Int) : async Int {
        calc -= num;
        return calc;
    };

    public func mult(num : Int) : async Int {
        calc *= num;
        return calc;
    };

    public func div(num : Int) : async ?Int {
        if (num == 0) return null;
        calc /= num;
        return ?calc;
    };

    public func restart() : async Int {
        calc := 0;
        return calc;
    };

    public query func getCalc() : async Int {
        return calc;
    };

    // public func test(_canisterId : Principal) : async TestResult {

    //     return #err();
    // };
};
