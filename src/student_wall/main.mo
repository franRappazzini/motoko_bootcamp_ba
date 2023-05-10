import Int "mo:base/Int";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
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

    // TODO: verificar return
    public query func getMessage(_messageId: Nat): async ?Message {
        let msg = wall.get(_messageId);
        return msg;
    };

    // TODO: verificar return 
    public shared({caller}) func updateMessage(_messageId: Nat, _c: Content): async Bool {
        switch(wall.get(_messageId)) {
            case(null) return false;
            case(?res) {
                if(Principal.notEqual(caller, res.creator)) return false;
                let updated = {
                    vote = res.vote;
                    content = _c;
                    creator = res.creator;
                };
                wall.put(_messageId, updated);
                return true;
            };
        };
    };

    // TODO: verificar return 
    public shared({caller}) func deleteMessage(_messageId: Nat): async Bool{
        switch(wall.get(_messageId)) {
            case(null) return false;
            case(?res) {
                if(Principal.notEqual(caller, res.creator)) return false;
        
                wall.delete(_messageId);
                return true;
            };
        };
    };

    public func upVote(_messageId: Nat): async Bool {
        let msg = switch(wall.get(_messageId)) {
            case(null) return false;
            case(?res) {
                let updated = {
                    vote = res.vote + 1;
                    content = res.content;
                    creator = res.creator;
                };
                wall.put(_messageId, updated);
                return true;
            };
        };
    };
   
    public func downVote(_messageId: Nat): async Bool {
        let msg = switch(wall.get(_messageId)) {
            case(null) return false;
            case(?res) {
                let updated = {
                    vote = res.vote - 1;
                    content = res.content;
                    creator = res.creator;
                };
                wall.put(_messageId, updated);
                return true;
            };
        };
    };

    public query func getAllMessages(): async ?[Message] {
        // return ?HashMap.toArray();
        let buffMsg = Buffer.Buffer<Message>(1);
        for(msg in wall.vals()) {
            buffMsg.add(msg);
        };

        return ?Buffer.toArray(buffMsg);
    };

    // public query func getAllMessagesRanked(): async ?[Message] {

    // };
} 