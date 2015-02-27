class CheckersException < Exception ; end

class OutOfBoard < CheckersException ; end
class MustChainOnlyJumps < CheckersException ; end
class InvalidMove < CheckersException ; end
class OutOfBoard < CheckersException ; end
class OnlyOnePiece < CheckersException ; end
class NotYourPiece < CheckersException ; end

class InputState < Exception ; end
class Ready < InputState ; end
class NotReady < InputState ; end
