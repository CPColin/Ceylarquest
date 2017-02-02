shared abstract class Unowned() of unowned {}

shared object unowned extends Unowned() {}

shared alias Owner => Player|Unowned;
