import Int "mo:base/Int";

actor Calculator {
    var calc: Int = 0;

    public func add(num: Int): async Int {
        calc += num;
        return calc;
    };

    public func sub(num: Int): async Int {
        calc -= num;
        return calc;
    };

    public func mult(num: Int): async Int {
        calc *= num;
        return calc;
    };

    public func div(num: Int): async ?Int {
        if(num == 0) return null;
        calc /= num;
        return ?calc;
    };

    public func restart(): async Int {
        calc := 0;
        return calc;
    };

    public query func getCalc(): async Int {
        return calc;
    };
};