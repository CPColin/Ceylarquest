import com.crappycomic.ceylarquest.model {
    Color,
    Location
}

shared interface GraphicsContext {
    shared formal void clear();
    
    shared formal void drawCircle(Location center, Color color, Integer radius, Integer width = 1);
    
    shared formal void drawLine(Location from, Location to, Color color, Integer width = 1);
    
    shared formal void drawPath({Location*} points, Color color, Integer width = 1,
        LineCap lineCap = buttCap, LineJoin lineJoin = miterJoin);
    
    shared formal void fillCircle(Location center, Color color, Integer radius);
    
    shared formal void fillRect(Location topLeft, Color color, Integer width, Integer height);
}
