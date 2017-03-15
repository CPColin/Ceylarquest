"Encapsulates the red, green, blue, and alpha (RGBA) values for a color. All values are clamped to
 between 0 and 255."
shared class Color {
    static Integer minimum = 0;
    
    static Integer maximum = 255;
    
    shared Integer red;
    
    shared Integer green;
    
    shared Integer blue;
    
    shared Integer alpha;
    
    shared new(Integer red, Integer green, Integer blue, Integer alpha = maximum) {
        function clamp(Integer colorValue) {
            return Integer.smallest(Integer.largest(minimum, colorValue), maximum);
        }
        
        this.red = clamp(red);
        this.green = clamp(green);
        this.blue = clamp(blue);
        this.alpha = clamp(alpha);
    }
    
    string = "[``red``, ``green``, ``blue``, ``alpha``]";
    
    "Returns a color with the given adjustment applied to the three RGB values."
    shared Color withAdjustment(Integer(Integer) adjustment) {
        return Color(adjustment(red), adjustment(green), adjustment(blue), alpha);
    }
    
    "Returns a color with the same hue and value, but the saturation adjusted by the given amount."
    shared Color withSaturation(Float adjustment) {
        return withAdjustment((channel) => (maximum - adjustment * (maximum - channel)).integer);
    }
    
    "Returns a color with the same hue and saturation, but the value adjusted by the given amount."
    shared Color withValue(Float adjustment) {
        return withAdjustment(((channel) => (channel * adjustment).integer));
    }
    
    "Returns a color with the same RGB values, but the given [[alpha]]."
    shared Color withAlpha(Integer alpha) {
        return Color(red, green, blue, alpha);
    }
}
