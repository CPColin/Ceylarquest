"Encapsulates information about an owed debt. The given [[debtor]] owes the given [[amount]] to the
 given [[creditor]]."
shared class Debt(shared Player debtor, shared Integer amount, shared Player creditor) {
    shared actual Boolean equals(Object other) {
        if (is Debt other) {
            return debtor == other.debtor
                && amount == other.amount
                && creditor == other.creditor;
        }
        else {
            return false;
        }
    }
    
    string = "``debtor`` owes ``amount`` to ``creditor``";
}
