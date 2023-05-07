
int f(T...)(T params = T.init)
{
    return 0;
}
auto test1 = f!(int*[][]); // Found in phobos/std/array.d: auto c = minimallyInitializedArray!(int*[][])(1, 1);
auto test2 = f!(size_t*[][]);
auto test3 = f!(size_t*[1][1]);
enum var = 0;
static assert(!__traits(compiles, f!(var*[1][0]))); // Error: variable `var` is used as a type
auto test5 = var*[1][0];
struct S
{
    void opBinary(string op, T)(ref const T other) if(op == "*")
    {
    }
}
void h()
{
    size_t*[1][0] x;
    S s;
    s*[1][0];
}
