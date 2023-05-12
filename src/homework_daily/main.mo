import Text "mo:base/Text";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

actor {
    type Homework = {
        title : Text;
        description : Text;
        dueDate : Int;
        completed : Bool;
    };

    let homeworkDiary = Buffer.Buffer<Homework>(1);

    public func addHomework(_hw : Homework) : async Nat {
        homeworkDiary.add(_hw);
        return homeworkDiary.size() - 1;
    };

    public func getHomework(_index : Nat) : async Result.Result<?Homework, ()> {
        let hw = homeworkDiary.get(_index);
        return #ok(?hw);
    };

    public func updateHomework(_index : Nat, _hw : Homework) : async Result.Result<(), Text> {
        switch (?homeworkDiary.get(_index)) {
            case (null) return #err("Homework doesn't exist.");
            case (?res) {
                homeworkDiary.put(_index, _hw);
                return #ok();
            };
        };
    };

    public func markAsComplete(_index : Nat) : async Result.Result<(), Text> {
        switch (?homeworkDiary.get(_index)) {
            case (null) return #err("Homework doesn't exist.");
            case (?res) {
                let newHw = {
                    title = res.title;
                    description = res.description;
                    dueDate = res.dueDate;
                    completed = true;
                };

                homeworkDiary.put(_index, newHw);
                return #ok();
            };
        };
    };

    public func deleteHomework(_index : Nat) : async Result.Result<(), Text> {
        switch (?homeworkDiary.get(_index)) {
            case (null) return #err("Homework doesn't exist.");
            case (?res) {
                let removed = homeworkDiary.remove(_index);
                return #ok();
            };
        };
    };

    public func getAllHomework() : async [Homework] {
        return Buffer.toArray(homeworkDiary);
    };

    public func getPendingHomework() : async [Homework] {
        let hwPending = Buffer.Buffer<Homework>(0);
        for (hw in homeworkDiary.vals()) {
            if (hw.completed == false) hwPending.add(hw);
        };

        return Buffer.toArray(hwPending);
    };

    public query func searchHomework(_searchTerm : Text) : async [Homework] {
        let hwPending = Buffer.Buffer<Homework>(0);
        for (hw in homeworkDiary.vals()) {
            if (Text.contains(hw.title, #text _searchTerm) or Text.contains(hw.description, #text _searchTerm)) hwPending.add(hw);
        };

        return Buffer.toArray(hwPending);
    };
};
