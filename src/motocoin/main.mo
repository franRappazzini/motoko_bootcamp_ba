import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Bool "mo:base/Bool";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Type "./account";
import Buffer "mo:base/Buffer";

actor class MotoCoin() {
    type Subaccount = Type.Subaccount;
    type Account = Type.Account;

    private let _name = "MotoCoin";
    private let _symbol = "MOC";
    stable var _totalSupply = 0;

    let ledger = TrieMap.TrieMap<Account, Nat>(Type.customEqual, Type.customHash);
    let students = actor ("rww3b-zqaaa-aaaam-abioa-cai") : actor {
        getAllStudentsPrincipal : shared () -> async [Principal];
    };

    public query func name() : async Text {
        return _name;
    };

    public query func symbol() : async Text {
        return _symbol;
    };

    public query func totalSupply() : async Nat {
        return _totalSupply;
    };

    public query func balanceOf(_account : Account) : async Nat {
        switch (ledger.get(_account)) {
            case (null) return 0;
            case (?res) return res;
        };
    };

    public shared ({ caller }) func transfer(_from : Account, _to : Account, _amount : Nat) : async Result.Result<(), Text> {
        if (caller != _from.owner) return #err("You don't have permission.");
        switch (ledger.get(_from)) {
            case (null) return #err("You don't have tokens.");
            case (?res) {
                if (res < _amount) return #err("You don't have tokens.");
                ledger.put(_from, (res - _amount));
                switch (ledger.get(_to)) {
                    case (null) ledger.put(_to, _amount);
                    case (?balance) ledger.put(_to, (balance + _amount));
                };
                return #ok();
            };
        };
    };

    public func airdrop() : async Result.Result<(), Text> {
        try {
            let studentsPrincipal = await students.getAllStudentsPrincipal();
            for (pid in studentsPrincipal.vals()) {
                let newStudent : Account = {
                    owner = pid;
                    subaccount = null;
                };
                let currentBalance = await balanceOf(newStudent);
                ledger.put(newStudent, (currentBalance + 100));
                _totalSupply += 100;
            };
            return #ok();
        } catch e {
            return #err("err");
        };
    };
};
