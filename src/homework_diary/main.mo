import Text "mo:base/Text";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
actor {
    type Homework = {
        title: Text;
        description: Text;
        dueDate: Int;
        completed: Bool;
    };

    let homeworks = Buffer.Buffer<Homework>(1);

    public func addHomework(_hw: Homework): async Nat {
        homeworks.add(_hw);
        return homeworks.size() - 1;
    };

    // TODO: agregar error
    public func getHomework(_index: Nat): async ?Homework {
        return ?homeworks.get(_index);
    };

    // TODO: agregar error y ver el return type
    public func updateHomework(_index: Nat, _hw: Homework): async ?Homework {
        switch(?homeworks.get(_index)) {
            case(null) return null; // return error
            case(?res) {
                homeworks.put(_index, _hw);
                return ?_hw;
            };
        };
    };

    // TODO: return correct values
    public func markAsComplete(_index: Nat): async ?Bool {
        switch(?homeworks.get(_index)) {
            case(null) return null;
            case(?res) {
                let newHw = {
                    title = res.title;
                    description = res.description;
                    dueDate = res.dueDate;
                    completed = true;
                };

                homeworks.put(_index, newHw);
                return ?true;
            };
        };
    };

    // TODO: return correct values
    public func deleteHomework(_index: Nat): async Bool {
        switch(?homeworks.get(_index)) {
            case(null) return false;
            case(?res) {
                let removed =  homeworks.remove(_index);
                return true;
            };
        };
    };

    public func getAllHomework(): async [Homework] {
        return Buffer.toArray(homeworks);
    };

    public func getPendingHomework(): async [Homework] {
        let hwPending = Buffer.Buffer<Homework>(0);
        for(hw in homeworks.vals()) {
            if(hw.completed == false) hwPending.add(hw);
        };

        return Buffer.toArray(hwPending);
    };

    public query func searchHomework(_searchTerm: Text): async [Homework] {
        let hwPending = Buffer.Buffer<Homework>(0);
        for(hw in homeworks.vals()) {
            if(Text.contains(hw.title, #text _searchTerm) or Text.contains(hw.description, #text _searchTerm) ) hwPending.add(hw);
        };

        return Buffer.toArray(hwPending);
    }; 
}