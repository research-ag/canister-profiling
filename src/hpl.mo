import Vector "mo:vector";
import VectorClass "mo:vector/Class";
import E "mo:base/ExperimentalInternetComputer";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Prim "mo:⛔";
import Table "utils/table";
import HPL "mo:hpl/ledger/create";
import Tx "mo:hpl/shared/transaction";

module {
  func generateSimpleTxInput(sender : Principal, senderSubaccountId : Tx.SubaccountId, receiver : Principal, receiverSubaccountId : Tx.SubaccountId, amount : Nat) : Tx.TxInput {
    if (sender == receiver) {
      #v1({
        map = [{
          owner = ?sender;
          inflow = [(#sub(receiverSubaccountId), (0, amount))];
          outflow = [(#sub(senderSubaccountId), (0, amount))];
          mints = [];
          burns = [];
        }];
        memo = [];
      });
    } else {
      #v1({
        map = [
          {
            owner = ?sender;
            inflow = [];
            outflow = [(#sub(senderSubaccountId), (0, amount))];
            mints = [];
            burns = [];
          },
          {
            owner = ?receiver;
            inflow = [(#sub(receiverSubaccountId), (0, amount))];
            outflow = [];
            mints = [];
            burns = [];
          },
        ];
        memo = [];

      });
    };
  };

  public func create_heap() : () -> Any {
    let ledger = HPL.create_ledger(65536, []);
    func() {
      let user = Principal.fromText("un4fu-tqaaa-aaaab-qadjq-cai");
      let tx = generateSimpleTxInput(user, 0, user, 1, 10);
      let caller = Principal.fromBlob("\04");
      Result.assertOk(ledger.submit(caller, Tx.fromInput(tx, caller)));
      ledger;
    };
  };
};
