import Int "mo:base/Int";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Float "mo:base/Float";

actor Calculator {
    var counter : Float = 1;

    public func add(num : Float) : async Float {
        counter += num;
        return counter;
    };

    public func sub(num : Float) : async Float {
        counter -= num;
        return counter;
    };

    public func mul(num : Float) : async Float {
        counter *= num;
        return counter;
    };

    public func div(num : Float) : async ?Float {
        if (num == 0) return null;
        counter /= num;
        return ?counter;
    };

    public func reset() : async () {
        counter := 0;
    };

    public query func see() : async Float {
        return counter;
    };

    public func power(num : Float) : async Float {
        return counter ** num;
    };

    public func sqrt() : async Float {
        return Float.sqrt(counter);
    };

    public func floor() : async Float {
        return Float.floor(counter);
    };

    // public func test(_canisterId : Principal) : async TestResult {

    //     return #err();
    // };
};
