// See also https://issues.dlang.org/show_bug.cgi?id=14911

void main()
{
    auto x = new S[2].ptr;
}
