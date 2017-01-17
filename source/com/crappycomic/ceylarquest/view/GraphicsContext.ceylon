import com.crappycomic.ceylarquest.model {
    Color,
    Location
}

shared interface GraphicsContext {
    shared formal void drawLine(Location from, Location to, Color color, Integer width = 1);
    
    // TODO
    //shared formal void drawPath({Location+} points, Color color, Integer width = 1, Join = miter);
    
    shared formal void fillCircle(Location center, Integer radius, Color color);
}
