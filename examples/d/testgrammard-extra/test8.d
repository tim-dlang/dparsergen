template X()
{
    alias T = int;
    T = const int;
}
pragma(msg, X!().T.stringof);
