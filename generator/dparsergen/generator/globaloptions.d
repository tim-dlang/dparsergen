
//          Copyright Tim Schendekehl 2023.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.globaloptions;

enum DelayedReduce
{
    none,
    combined
}

class GlobalOptions
{
    bool optimizationDescent;
    DelayedReduce delayedReduce;
    bool mergeSimilarStates;
    bool directUnwrap;
    bool glrParser;
}
