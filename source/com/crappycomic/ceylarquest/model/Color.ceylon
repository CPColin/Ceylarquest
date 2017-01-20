shared class Color(shared Integer red, shared Integer green, shared Integer blue,
    shared Integer alpha = 255) {
    shared Color withAlpha(Integer alpha) {
        return Color(red, green, blue, alpha);
    }
}
