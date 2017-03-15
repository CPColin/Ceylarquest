import ceylon.test {
    fail
}
import com.crappycomic.ceylarquest.model {
    Game,
    Result,
    incorrectPhase
}

"Fails with the given [[message]] unless the given [[result]] is an
 [[invalid move|com.crappycomic.ceylarquest.model::InvalidMove]] that is not the marker for an
 [[incorrect phase|incorrectPhase]]."
void assertInvalidMove(Result result, String message) {
    if (is Game result) {
        fail(message);
    }
    else if (result == incorrectPhase) {
        fail(result.message);
    }
    else {
        print(result.message);
    }
}
