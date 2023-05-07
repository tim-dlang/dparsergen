immutable funcs = [
    {return 0;},
    {return 1;}
];
struct S
{
    int delegate() a;
    int delegate() b;
}
immutable S s1 = {
    {return 0;},
    {return 1;}
};
immutable S s2 = {
    a: {return 0;},
    b: {return 1;}
};
