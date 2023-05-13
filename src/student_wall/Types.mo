import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";

module {
    public type Content = {
        #Text : Text;
        #Image : Blob;
        #Video : Blob;
    };

    public type Message = {
        vote : Int;
        content : Content;
        creator : Principal;
    };

    public type StudentProfile = {
        name : Text;
        team : Text;
        graduate : Bool;
    };
};
