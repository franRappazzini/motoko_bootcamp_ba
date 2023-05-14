import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat "mo:base/Nat";

module {
    public type Subaccount = Blob;
    public type Account = {
        owner : Principal;
        subaccount : ?Subaccount;
    };

    func getDefaultSubaccount() : Subaccount {
        Blob.fromArrayMut(Array.init(32, 0 : Nat8));
    };

    public func customEqual(lhs : Account, rhs : Account) : Bool {
        let lhsSubaccount : Subaccount = Option.get<Subaccount>(lhs.subaccount, getDefaultSubaccount());
        let rhsSubaccount : Subaccount = Option.get<Subaccount>(rhs.subaccount, getDefaultSubaccount());
        Principal.equal(lhs.owner, rhs.owner) and Blob.equal(lhsSubaccount, rhsSubaccount);
    };

    public func customHash(lhs : Account) : Nat32 {
        let lhsSubaccount : Subaccount = Option.get<Subaccount>(lhs.subaccount, getDefaultSubaccount());
        let hashSum = Nat.add(Nat32.toNat(Principal.hash(lhs.owner)), Nat32.toNat(Blob.hash(lhsSubaccount)));
        Nat32.fromNat(hashSum % (2 ** 32 - 1));
    };

    public func accountBelongsToPrincipal(account : Account, principal : Principal) : Bool {
        Principal.equal(account.owner, principal);
    };

};
