struct S
{
    Exception opBinary(string op)(int rhs) if(op == "+")
    {
        return new Exception("x");
    }
}
void f()
{
    throw S() + 2;
}
