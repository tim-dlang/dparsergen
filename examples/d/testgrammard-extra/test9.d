alias AliasSeq(T...) = T;
struct S
{
    enum E;
}
alias X = AliasSeq!(S);
enum x = 0;
/*X[x*[0][0]].E y; // Error: variable `x` is used as a type
pragma(msg, typeof(y));
*/

void f()
{
    size_t s = size_t[x*[0][0]].sizeof;
    //size_t s2 = size_t[S*[0][0]].sizeof; // Error: incompatible types for `(S) * ([0][0])`: cannot use `*` with types
}
