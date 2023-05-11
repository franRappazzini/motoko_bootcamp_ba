import Int "mo:base/Int";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Array "mo:base/Array";

actor {
    public type Content = {
        #Text: Text;
        #Image: Blob;
        #Video: Blob;
    };

    type Message = {
        vote: Int;
        content: Content;
        creator: Principal;
    };

    var messageId: Nat = 0;
    var wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

    public shared({caller}) func writeMessage(_c: Content): async Nat {
        let newMsg = {
            vote = messageId;
            content = _c;
            creator = caller;
        };

        wall.put(messageId, newMsg);
        messageId += 1;
        return messageId - 1;
    };

    public query func getMessage(_messageId: Nat): async Result.Result<?Message, ()> {
        let msg = wall.get(_messageId);
        return #ok(msg);
    };

    public shared({caller}) func updateMessage(_messageId: Nat, _c: Content): async Result.Result<(), Text> {
        switch(wall.get(_messageId)) {
            case(null) return #err("Message not found.");
            case(?res) {
                if(Principal.notEqual(caller, res.creator)) return #err("You don't are the owner.");
                let updated = {
                    vote = res.vote;
                    content = _c;
                    creator = res.creator;
                };
                wall.put(_messageId, updated);
                return #ok();
            };
        };
    };

    public shared({caller}) func deleteMessage(_messageId: Nat): async Result.Result<(), Text> {
        switch(wall.get(_messageId)) {
            case(null) return #err("Message not found.");
            case(?res) {
                if(Principal.notEqual(caller, res.creator)) return #err("You don't are the owner.");
        
                wall.delete(_messageId);
                return #ok();
            };
        };
    };

    public func upVote(_messageId: Nat): async Result.Result<(), Text> {
        let msg = switch(wall.get(_messageId)) {
            case(null) return #err("Message not found.");
            case(?res) {
                let updated = {
                    vote = res.vote + 1;
                    content = res.content;
                    creator = res.creator;
                };
                wall.put(_messageId, updated);
                return #ok();
            };
        };
    };
   
    public func downVote(_messageId: Nat): async Result.Result<(), Text> {
        let msg = switch(wall.get(_messageId)) {
            case(null) return #err("Message not found.");
            case(?res) {
                let updated = {
                    vote = res.vote - 1;
                    content = res.content;
                    creator = res.creator;
                };
                wall.put(_messageId, updated);
                return #ok();
            };
        };
    };

    public query func getAllMessages(): async ?[Message] {
        let buffMsg = Buffer.Buffer<Message>(1);
        for(msg in wall.vals()) {
            buffMsg.add(msg);
        };

        return ?Buffer.toArray(buffMsg);
    };

    // public query func getAllMessagesRanked(): async ?[Message] {
    //     let buffMsg = Buffer.Buffer<Message>(1);
    //     for(msg in wall.vals()) {
    //         buffMsg.add(msg);
    //     };
    //     let arrMsg = Buffer.toArray<Message>(buffMsg);

    //     return Array.sortInPlace(arrMsg, compare)
    // };

    // // Función de comparación
    // func compare(a: Message, b: Message) : Bool {
    //     return a.vote > b.vote;
    // };
} 