import com.crappycomic.ceylarquest.model {
    Color
}

import java.awt {
    AwtColor=Color
}

AwtColor awtColor(Color color)
    => AwtColor(color.red, color.green, color.blue, color.alpha);
