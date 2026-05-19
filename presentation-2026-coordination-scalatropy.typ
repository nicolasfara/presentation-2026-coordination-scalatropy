#import "@preview/touying:0.6.3": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.3.0": *
#import "utils.typ": *

#show: codly-init.with()

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
    preamble: {
      codly(
        languages: (
          scala: (name: [Scala], color: blue),
        ),
        display-icon: false,
        display-name: false,
        number-format: none,
        zebra-fill: none,
        fill: luma(248),
        stroke: .6pt + ink.lighten(78%),
        radius: 4pt,
        inset: (x: .65em, y: .28em),
        smart-indent: false,
        breakable: false,
      )
    },
  ),
  config-info(
    title: [ScalaTropy: Multiparty Coordination with Monadic Communication Primitives],
    subtitle: [COORDINATION 2026],
    author: author_list(
      (
        (first_author("Nicolas Farabegoli"), "nicolas.farabegoli@unibo.it"),
        ("Luca Tassinari", "luca.tassinari10@studio.unibo.it"),
        ("Gianluca Aguzzi", "gianluca.aguzzi@unibo.it"),
        ("Mirko Viroli", "mirko.viroli@unibo.it")
      )
    ),
    date: datetime.today().display("[day] [month repr:long] [year]"),
    institution: [University of Bologna],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")
#set raw(tab-size: 2)
#show raw.where(block: false): set text(size: 1em)
#show raw.line: set text(size: 0.9em)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

#title-slide(extra: [
  #chip[One global program. Many runtime peers. Only the messages that matter.]
])

= The Problem

== A Distributed Program Has Two Stories

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.1em)[
  #mini-card([Global coordination], [
    Choreographic programming lets us write the conversation once:
    who talks to whom, and in what order.
  ], color: blue)

  #v(.6em)

  #mini-card([The payoff], [
    A compact, third-person specification of distributed behavior.
  ], color: green)
][
  #mini-card([Deployment architecture], [
    Multitier programming makes placements and allowed ties explicit:
    where values live and which peers may communicate.
  ], color: orange)

  #v(.6em)

  #mini-card([The payoff], [
    Static discipline over runtime topology and communication boundaries.
  ], color: green)
]

#v(.5em)
#statement[
  The two stories are complementary, but today developers often have to choose which one is first-class.
]

== The Catch

#components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
  #text(weight: "medium", fill: blue)[Choreographic DSLs]

  - Excellent global view
  - Strong foundations for coordination
  - Usually centered on point-to-point communication
  - Selective multicast can become manual plumbing
][
  #text(weight: "medium", fill: orange)[Multitier DSLs]

  - Explicit placement discipline
  - Architecture encoded in types
  - Communication is often implicit through placed values
  - Selective intent can be hidden in lower-level boilerplate
]

#v(.4em)
#statement(fill: orange.lighten(90%))[
  The missing piece is not another send primitive. It is communication intent, checked against architecture.
]

== A Tiny Example of Waste

#slide(composer: (1.08fr, .92fr))[
  #text(weight: "medium")[Matrix-vector product]

  A master owns a matrix. Workers should receive different row blocks.

  #v(.4em)

  #mini-card([Broadcast-shaped solution], [
    Send the whole matrix to every worker and let each worker discard the irrelevant rows.
  ], color: orange)

  #mini-card([Selective-shaped solution], [
    Send each worker exactly the block it needs, then collect the partial results.
  ], color: green)
][
  #placeholder(
    [Architecture sketch],
    body: [Master, workers, and per-worker row partitions]
  )
]

= Communication Shapes

== Four Patterns, One Vocabulary

#components.side-by-side(columns: (1fr, 1fr, 1fr, 1fr), gutter: .55em)[
  #align(center)[#image("images/point-to-point.svg", width: 78%)]
  #align(center)[#chip[point-to-point]]
  #text(size: .67em)[one sender, one receiver]
][
  #align(center)[#image("images/isotropic-comm.svg", width: 78%)]
  #align(center)[#chip[isotropic]]
  #text(size: .67em)[same payload to many receivers]
][
  #align(center)[#image("images/anisotropic-comm.svg", width: 78%)]
  #align(center)[#chip[anisotropic]]
  #text(size: .67em)[tailored payloads to many receivers]
][
  #align(center)[#image("images/coanisotropic-comm.svg", width: 78%)]
  #align(center)[#chip[co-anisotropic]]
  #text(size: .67em)[many tailored payloads to one receiver]
]

#v(.6em)
#statement[
  ScalaTropy turns these shapes into first-class primitives, rather than asking the programmer to simulate them.
]

== What Existing DSLs Give Us

#block(
  width: 100%,
  inset: .25em,
  radius: 6pt,
  fill: luma(250),
  stroke: (paint: ink.lighten(72%), thickness: .7pt),
)[
  #table(
    columns: (1.65fr, 1fr, 1.08fr, 1.08fr, 1fr),
    gutter: .08em,
    stroke: none,
    comparison-header[Communication],
    comparison-header[HasChor],
    comparison-header[CloudChor],
    comparison-header[ScalaLoci],
    comparison-header[ScalaTropy],

    comparison-label[Point-to-point],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("native")],

    comparison-label([Isotropic], fill: soft),
    comparison-cell(fill: soft)[#support-chip("absent")],
    comparison-cell(fill: soft)[#support-chip("native")],
    comparison-cell(fill: soft)[#support-chip("native")],
    comparison-cell(fill: soft)[#support-chip("native")],

    comparison-label[Anisotropic],
    comparison-cell[#support-chip("absent")],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("pattern")],
    comparison-cell[#support-chip("native")],

    comparison-label([Co-anisotropic], fill: soft),
    comparison-cell(fill: soft)[#support-chip("absent")],
    comparison-cell(fill: soft)[#support-chip("native")],
    comparison-cell(fill: soft)[#support-chip("pattern")],
    comparison-cell(fill: soft)[#support-chip("native")],
  )
]

#v(.25em)
#align(center)[
  #text(size: .68em, fill: ink.lighten(36%))[
    `pattern` = expressible, but not as a dedicated first-class primitive.
  ]
]

// #v(.4em)
// #statement(fill: soft)[
//   The goal is not just coverage. The goal is explicit coverage under architectural constraints.
// ]

= ScalaTropy

== The Idea in One Line

#slide(composer: (0.82fr, 1.18fr))[
  #text(weight: "medium")[One program, three contracts.]

  #v(.45em)
  #line(length: 100%, stroke: .7pt + ink.lighten(72%))
  #v(.6em)

  #set text(size: .86em)
  #table(
    columns: (auto, 1fr),
    column-gutter: .85em,
    row-gutter: .82em,
    stroke: none,
    align: (right, left),
    [#text(fill: blue, weight: "medium")[topology]],
    [which peer families exist and which ties are admissible],
    [#text(fill: orange, weight: "medium")[placement]],
    [where each value lives, written as `V on P`],
    [#text(fill: green, weight: "medium")[shape]],
    [which flow is intended: point-to-point, scatter, broadcast, or gather],
  )

  #v(.75em)
  #line(length: 100%, stroke: .7pt + ink.lighten(72%))
  #v(.45em)

][
  #v(4.5em)

  ```scala
  type Master <: { type Tie <: Multiple[Worker] }
  type Worker <: { type Tie <: Single[Master] }

  for
    tasks <- on[Master] { buildTasks() }
    work <- anisotropicComm[Master, Worker](tasks)
    part <- on[Worker] { take(work).map(_.compute) }
    all <- coAnisotropicComm[Worker, Master](part)
  yield all
  ```

  #v(.5em)
  #align(right)[
    #text(size: .82em, fill: ink.lighten(22%), weight: "medium")[
      The type signature is the contract.
    ]
  ]
]

== Architecture Is Part of the Program

#slide(composer: (1fr, 1fr))[
  ```scala
  type Client <: {
    type Tie <: Single[Server]
  }

  type Server <: {
    type Tie <: Single[Database]
              & Multiple[Client]
  }

  type Database <: {
    type Tie <: Single[Server]
  }
  ```
][
  #mini-card([Peer families], [
    Types name the classes of participants in the distributed system.
  ], color: blue)

  #mini-card([Ties], [
    `Single[P]` and `Multiple[P]` describe admissible communication relationships.
  ], color: orange)

  #mini-card([Compile-time guardrail], [
    A primitive is callable only when its sender and receiver satisfy the required ties.
  ], color: green)
]

== Placement Types: Values Know Where They Live

#statement[
  `V on P` means: a value of type `V` owned by peer `P`.
]

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .7em)[
  #step-item([1], [place], [`on[P] { ... }` executes the body only at peers of type `P`.])
][
  #step-item([2], [reference], [Other peers retain a typed remote reference to the placed value.])
][
  #step-item([3], [move], [Communication primitives are the only way to make that value available elsewhere.])
]

```scala
for
  message <- on[Client] { "Hello, Server!" }
  atServer <- comm[Client, Server](message)
  _ <- on[Server] { take(atServer).map(println) }
yield ()
```

== The Language Surface

#components.side-by-side(columns: (1fr, 2fr), gutter: .8em)[
  #text(weight: "medium", fill: blue)[Placed computation]

  ```scala
  def on[P <: Peer, V](
    body: Label[P] ?=> F[V]
  ): F[V on P]

  def take[P <: Peer, V](
    value: V on P
  ): F[V]
  ```
][
  #text(weight: "medium", fill: orange)[Communication]

  ```scala
  def comm[S, R, V](value: V on S): F[V on R]
  def isotropicComm[S, R, V](value: V on S): F[V on R]
  def anisotropicComm[S, R, V](
      value: Anisotropic[R, V] on S
  ): F[V on R]
  def coAnisotropicComm[S, R, V](
      value: V on S
  ): F[Anisotropic[S, V] on R]
  ```
]

#statement(fill: green.lighten(88%), stroke: green)[
  The signatures carry both placement and architectural intent.
]

== Why Monads?

#slide(composer: (.95fr, 1.05fr))[
  #mini-card([Same program], [
    Programs are written against `MultiParty[F]`.
  ], color: blue)

  #mini-card([Different effects], [
    `F` can be a production `IO`, an in-memory test effect, or another effect stack.
  ], color: orange)

  #mini-card([Composable runtime], [
    The interpreter delegates to `Network` and `Environment` capabilities.
  ], color: green)
][
  ```scala
  trait MultiParty[F[_]: Monad]:
    def on[P <: Peer, V](...): F[V on P]
    def comm[S, R, V](value: V on S): F[V on R]
    // ...

  trait Network[F[_], LP <: Peer]:
    def send[V, To <: Peer](...): F[Unit]
    def receive[V, From <: Peer](...): F[V]
    def alivePeersOf[P <: Peer]: F[NonEmptyList[Address[P]]]
  ```
]

= ScalaTropy in Practice

== Case Study: Master-Worker

#slide(composer: (.95fr, 1.05fr))[
  #mini-card([Architecture], [
    `Master` is tied to multiple `Worker`s; every `Worker` is tied to one `Master`.
  ], color: blue)

  #mini-card([Scatter], [
    `anisotropicComm` sends a distinct task to each worker.
  ], color: orange)

  #mini-card([Gather], [
    `coAnisotropicComm` collects partial results and acts as a barrier.
  ], color: green)
][
  ```scala
  for
    tasks <- on[Master]:
      for
        peers <- reachablePeers[Worker]
        allocation = peers.map(_ -> Task(...)).toMap
        message <- anisotropicMessage(allocation, Task(0))
      yield message
    taskOnWorker <- anisotropicComm[Master, Worker](tasks)
    partial <- on[Worker] { take(taskOnWorker).map(_.compute) }
    results <- coAnisotropicComm[Worker, Master](partial)
    total <- on[Master] { takeAll(results).map(_.values.sum) }
  yield total
  ```
]

== Case Study: Replicated Key-Value Store

#slide(composer: (1fr, 1fr))[
  #placeholder(
    [Key-value store architecture],
    body: [Clients, primary replica, backup replicas]
  )
][
  - Clients send requests to the primary with `coAnisotropicComm`.
  - The primary processes requests and builds per-client responses.
  - `Put` requests are replicated to backups with `isotropicComm`.
  - Backup acknowledgments flow back with `coAnisotropicComm`.
  - Responses return with `anisotropicComm`.

  #v(.4em)
  #statement(fill: soft)[
    The same choreography works with any number of backup replicas.
  ]
]

== What Selective Communication Buys

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .75em)[
  #mini-card([Efficiency], [
    Send the necessary payload, not the superset each receiver must filter.
  ], color: green)
][
  #mini-card([Confidentiality], [
    Peers do not receive data that was never intended for them.
  ], color: blue)
][
  #mini-card([Expressiveness], [
    The code says scatter, broadcast, or gather directly.
  ], color: orange)
]

#v(.7em)
#statement[
  Selectivity is both an optimization and a way to make distributed intent visible.
]

== Communication Overhead

#slide(composer: (1.1fr, .9fr))[
  #align(center)[
    #image("images/communication-overhead.png", width: 98%)
  ]
][
  #text(weight: "medium")[Matrix-vector product]

  - Broadcast sends the full matrix to every worker.
  - Anisotropic communication sends each worker its row block.
  - For a 50 x 50 matrix, broadcast grows linearly with the number of workers.
  - Selective communication stays almost flat, apart from metadata and vector distribution.
]

= Takeaways

== What ScalaTropy Contributes

#components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
  #mini-card([Unified design], [
    Choreographic global specification with type-level architecture.
  ], color: blue)

  #mini-card([Differentiated communication], [
    Point-to-point, isotropic, anisotropic, and co-anisotropic primitives.
  ], color: orange)
][
  #mini-card([Architectural enforcement], [
    Invalid peer interactions are rejected by Scala's type system.
  ], color: green)

  #mini-card([Monadic implementation], [
    Tagless-final encoding separates the DSL from concrete execution effects.
  ], color: blue)
]

== Future Work

- Formal semantics for the core language.
- Type safety and deadlock-freedom results in the style of choreographic programming.
- Architectural compliance and communication correctness for the ScalaLoci-inspired layer.
- Explore whether existing choreographic languages can benefit from runtime role-instance information.

#v(.65em)
#statement(fill: orange.lighten(88%))[
  The broader question: how much architecture should a choreography know?
]

== Thank You

#align(center + horizon)[
  Questions?

  // #v(.6em)
  // #statement[
  //   ScalaTropy: multiparty coordination where the communication shape is part of the type story.
  // ]

  #v(.6em)
  #text(size: .85em, fill: ink.lighten(25%))[Artifact: github.com/nicolasfara/scalatropy]
]
