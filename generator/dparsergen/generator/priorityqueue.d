
//          Copyright Tim Schendekehl 2026.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module dparsergen.generator.priorityqueue;

import std.algorithm.mutation: swap;
import std.array;

/**
Priority queue based on a binary heap.

Elements with a higher priority are removed first. The queue is stable,
i.e. elements with equal priority are removed in the same order in which
they were inserted.

Params:
    T = type of the stored elements
    P = type of the priorities, has to be comparable with `>`
*/
struct StablePriorityQueue(T, P = size_t)
{
    private static struct Entry
    {
        T value;
        P priority;
        size_t sequence;
    }

    private Appender!(Entry[]) entries;
    private size_t nextSequence;

    private static bool higherPriority(ref const Entry a, ref const Entry b)
    {
        if (a.priority != b.priority)
            return a.priority > b.priority;
        return a.sequence < b.sequence;
    }

    /// Number of elements currently in the queue.
    size_t length() const
    {
        return entries.data.length;
    }

    /// True iff the queue does not contain any element.
    bool empty() const
    {
        return entries.data.length == 0;
    }

    /// Adds an element with the given priority to the queue.
    void insert(T value, P priority)
    {
        entries.put(Entry(value, priority, nextSequence));
        nextSequence++;

        size_t i = entries.data.length - 1;
        while (i > 0)
        {
            size_t parent = (i - 1) / 2;
            if (!higherPriority(entries.data[i], entries.data[parent]))
                break;
            swap(entries.data[i], entries.data[parent]);
            i = parent;
        }
    }

    /// Element with the highest priority. The queue must not be empty.
    ref const(T) front() const
    in (!empty)
    {
        assert(!empty);
        return entries.data[0].value;
    }

    /**
    Removes the element with the highest priority from the queue and
    returns it. The queue must not be empty.
    */
    T removeFront()
    in (!empty)
    {
        T result = entries.data[0].value;
        entries.data[0] = entries.data[$ - 1];
        entries.shrinkTo(entries.data.length - 1);

        size_t i = 0;
        while (true)
        {
            size_t best = i;
            size_t child = 2 * i + 1;
            if (child < entries.data.length && higherPriority(entries.data[child], entries.data[best]))
                best = child;
            child = 2 * i + 2;
            if (child < entries.data.length && higherPriority(entries.data[child], entries.data[best]))
                best = child;
            if (best == i)
                break;
            swap(entries.data[i], entries.data[best]);
            i = best;
        }
        return result;
    }
}

unittest
{
    StablePriorityQueue!(string, size_t) queue;
    assert(queue.empty);
    assert(queue.length == 0);

    queue.insert("a", 1);
    queue.insert("b", 3);
    queue.insert("c", 2);
    queue.insert("d", 3);
    queue.insert("e", 1);

    assert(!queue.empty);
    assert(queue.length == 5);

    assert(queue.front == "b");
    assert(queue.removeFront() == "b");
    assert(queue.removeFront() == "d");
    assert(queue.removeFront() == "c");
    queue.insert("f", 2);
    assert(queue.removeFront() == "f");
    assert(queue.removeFront() == "a");
    assert(queue.removeFront() == "e");
    assert(queue.empty);
}
