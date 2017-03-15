"Enumerates the possible line join styles."
shared abstract class LineJoin() of bevelJoin | miterJoin | roundJoin {}

shared object bevelJoin extends LineJoin() {}

shared object miterJoin extends LineJoin() {}

shared object roundJoin extends LineJoin() {}
