import com.crappycomic.ceylarquest.model {
    Color
}

String rgba(Color color)
    => "rgba(``color.red``, ``color.green``, ``color.blue``, ``color.alpha.float / 255``)";
