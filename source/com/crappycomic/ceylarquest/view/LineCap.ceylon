"Enumerates the possible line cap styles."
shared abstract class LineCap() of buttCap | roundCap | squareCap {}

shared object buttCap extends LineCap() {}

shared object roundCap extends LineCap() {}

shared object squareCap extends LineCap() {}
