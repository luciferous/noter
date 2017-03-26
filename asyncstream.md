title="AsyncStream"

<section>
A lazy list of Futures.

1. Immutable - safe for concurrent access
2. Persistent - preserves previous versions when modified
2. Lazy - evaluated on demand

Implemented as a chain of nodes.

```
(a, --)-->(b, --)-->(c, --)-->(...)
```

The `Node` type.

```scala
sealed trait Node[+A]
case object Empty extends Node[Nothing]
case class Cons[A](head: A, tail: AsyncStream[A]) extends Node[A]
```

The `AsyncStream` type.

```scala
class AsyncStream[A](node: Future[Node[A]])
```
</section>

<section>
## Basic constructions

The empty stream. (This is the `AsyncStream` equivalent of `Nil`.)

```scala
AsyncStream.empty
```

Two examples `words: AsyncStream[String]` and `ints: AsyncStream[Int]`.

```scala
val words = AsyncStream("hello", "world")
val ints = AsyncStream(1, 2, 3)
```
</section>

<section>
## Lifts

From `Option`.

```scala
val opt: Option[Int] = Some(1)
AsyncStream.fromOption(opt)
```

From `Seq`.

```scala
val seq: Seq[Int] = Seq(2, 3)
AsyncStream.fromSeq(seq)
```

From `Future`.

```scala
val f: Future[Int] = Future.value(4)
AsyncStream.fromFuture(f)
```

How does `fromFuture` work?

```scala
def fromFuture[A](f: Future[A]): AsyncStream[A] =
  AsyncStream(f.map { a => Node(a, AsyncStream.empty) })
```

One `flatMap` to rule them all.

```scala
import AsyncStream._

val as = for {
  x <- fromOption(opt)
  y <- fromSeq(seq)
  z <- fromFuture(f)
} yield x + y + z

Await.result(as.toSeq) == Seq(7, 8)
```
</section>

<section>
## Alternatives

***Why not `Future[Seq[A]]`?***

The `Future` represents a rendezvous with the supplier of the `Seq`. This signature implies that there's a single rendezvous, during (and after) which the `Seq` is accessible. `AsyncStream` models the rendezvous of multiple `Future`s.

***OK, then why not `Seq[Future[A]]`?***

1. `AsyncStream` is more convenient.
2. Explicit control of tail evaluation

To the first point, `Seq[Future[A]]` requires double the number of `map` operations. Consider printing the stream:

```scala
val seq: Seq[Future[A]] = ...
seq.foreach { f => f.map(println) }
```

`Seq[Future[A]]` requires two maps vs. just one when using `AsyncStream`.

```
val as: AsyncStream[A]
as.foreach(println)
```

***That doesn't look so bad.***

Consider an operation `send: A => Future[Unit]` which requires the each iteration to wait until it completes. `foreach` isn't enough, we have to use a `fold` with an accumulator that we can `flatMap` on.

```scala
seq.foldLeft(Future.Done) { (done, f) =>
  done before f.flatMap(send)
}
```

`AsyncStream`'s `foreachF` is a `foreach` specialized for use with `Future`.

```
as.foreachF(send)
```

The second point is very subtle: `AsyncStream` is evaluated in lock-step, at the completion of the last `send` operation, but `Seq[Future[A]]` (even when implemented as a Scala `Stream`) evaluates the entire stream. For infinite streams that operate with `Future`s, `AsyncStream` is the only viable approach.
</section>
