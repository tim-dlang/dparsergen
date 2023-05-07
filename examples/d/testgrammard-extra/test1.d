const(byte) a = const(byte).init;
immutable(byte) b = immutable(byte).init;
shared(byte) c = shared(byte).init;
inout(byte) d = inout(byte).init;

int f()(
    const(byte) a = const(byte).init,
    immutable(byte) b = immutable(byte).init,
    shared(byte) c = shared(byte).init,
    inout(byte) d = inout(byte).init,
);

// based on dmd/test/compilable/test9613.d
