#import "@preview/touying:0.6.3": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.6.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.3.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/tiaoma:0.3.0"
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
          scala: (name: [Scala]),
        ),
        display-icon: false,
        display-name: false,
        number-format: none,
        zebra-fill: none,
        fill: luma(248),
        stroke: .6pt + ink.lighten(78%),
        radius: 10pt,
        inset: (x: .6em, y: .25em),
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
    // institution: [University of Bologna],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
#show math.equation: set text(font: "Fira Math")
#set raw(tab-size: 2)
#show raw: set text(font: "JetBrains Mono", weight: "light", size: 0.8em)
#show raw.where(block: false): set text(size: 1.3em)
// #show raw.line: set text(size: 0.9em)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

#title-slide()

= Multiparty Languages

== Choreographic and Multitier Programming

#feature-block("Multiparty Languages")[
  _Describe a distributed system and peers interactions as a #bold[single global program], projecting into the peers the specific logic they need to execute._
]

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.5em)[
  === Choreographic programming

  - *Protocols definition* involving multiple participants; proved deadlock-free.
  - #text(fill: green.lighten(30%), weight: "bold")[Explicit communication] as first-class primitives in the language.
  - #bold[Languages:] Choral, HasChor @haschor2023. //, Choral, Pirouette.
][
  === Multitier programming

  - Placement discipline and #text(fill: green.lighten(30%), weight: "bold")[architectual constraints] among peers.
  - *Implicit communication* through cross-tier operators.
  - #bold[Languages:] ScalaLoci @scalaloci2018, Eliom, Links.
]

#statement(fill: gray.lighten(85%))[
  Can we take the #underline[best of both worlds] and have a single multiparty language for distributed systems with #text(fill: green.lighten(30%))[explicit communication] and #text(fill: green.lighten(30%))[architectural constraints]?
]


// == The Catch

// #components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
//   #text(weight: "medium", fill: blue)[Choreographic DSLs]

//   - Excellent global view
//   - Strong foundations for coordination
//   - Usually centered on point-to-point communication
//   - Selective multicast can become manual plumbing
// ][
//   #text(weight: "medium", fill: orange)[Multitier DSLs]

//   - Explicit placement discipline
//   - Architecture encoded in types
//   - Communication is often implicit through placed values
//   - Selective intent can be hidden in lower-level boilerplate
// ]

// #v(.4em)
// #statement(fill: orange.lighten(90%))[
//   The missing piece is not another send primitive. It is communication intent, checked against architecture.
// ]

// == A Tiny Example of Waste

// #slide(composer: (1.08fr, .92fr))[
//   #text(weight: "medium")[Matrix-vector product]

//   A master owns a matrix. Workers should receive different row blocks.

//   #v(.4em)

//   #mini-card([Broadcast-shaped solution], [
//     Send the whole matrix to every worker and let each worker discard the irrelevant rows.
//   ], color: orange)

//   #mini-card([Selective-shaped solution], [
//     Send each worker exactly the block it needs, then collect the partial results.
//   ], color: green)
// ][
//   #placeholder(
//     [Architecture sketch],
//     body: [Master, workers, and per-worker row partitions]
//   )
// ]
// 

== Communication Primitives in Multiparty Languages

#components.side-by-side(columns: (1fr, 1fr, 1fr, 1fr), gutter: .55em)[
  #align(center)[#image("images/point-to-point.svg", width: 78%)]
  #align(center)[#chip[point-to-point]]
  #text(size: .67em)[Classic point-to-point with one sender, one receiver]
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

// #statement(fill: green.lighten(88%), stroke: green)[
//   The signatures carry both placement and architectural intent.
// ]


== Multiparty Languages Landscape

#let scalatropy-column-fill = orange.lighten(91%)
#let scalatropy-column-soft-fill = orange.lighten(87%)
#let scalatropy-column-header(body) = table.cell(
  fill: orange,
  align: center + horizon,
  inset: (x: .55em, y: .45em),
)[#text(fill: white, weight: "medium", size: .78em)[#body]]

#block(
  width: 100%,
  inset: .25em,
  radius: 6pt,
  fill: luma(250),
  stroke: (paint: ink.lighten(72%), thickness: .7pt),
)[
  #table(
    columns: (2.3fr, 1fr, 1.08fr, 1.08fr, 1fr),
    gutter: .08em,
    stroke: none,
    comparison-header[Feature],
    comparison-header[HasChor],
    comparison-header[CloudChor],
    comparison-header[ScalaLoci],
    scalatropy-column-header[ScalaTropy],

    comparison-label[Point-to-point],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("native")],
    comparison-cell(fill: scalatropy-column-fill)[#support-chip("native")],

    comparison-label([Broadcast (_Isotropic_)], fill: soft),
    comparison-cell(fill: soft)[#support-chip("absent")],
    comparison-cell(fill: soft)[#support-chip("native")],
    comparison-cell(fill: soft)[#support-chip("native")],
    comparison-cell(fill: scalatropy-column-soft-fill)[#support-chip("native")],

    comparison-label[Scatter (_Anisotropic_)],
    comparison-cell[#support-chip("absent")],
    comparison-cell[#support-chip("native")],
    comparison-cell[#support-chip("pattern")],
    comparison-cell(fill: scalatropy-column-fill)[#support-chip("native")],

    comparison-label([Gather (_Co-anisotropic_)], fill: soft),
    comparison-cell(fill: soft)[#support-chip("absent")],
    comparison-cell(fill: soft)[#support-chip("native")],
    comparison-cell(fill: soft)[#support-chip("pattern")],
    comparison-cell(fill: scalatropy-column-soft-fill)[#support-chip("native")],

    comparison-label([#strong[Architectural Constraints]], fill: orange.lighten(86%)),
    comparison-cell(fill: orange.lighten(86%))[#support-chip("absent")],
    comparison-cell(fill: orange.lighten(86%))[#support-chip("absent")],
    comparison-cell(fill: orange.lighten(86%))[#support-chip("native")],
    comparison-cell(fill: orange.lighten(78%))[#support-chip("native")],
  )
]

#v(.25em)
#align(center)[
  #text(size: .68em, fill: ink.lighten(36%))[
    `pattern` = expressible, but not as a dedicated first-class primitive.
  ]
]

// #bold[CloudChor] supports a similar set of communication patterns, but has not architectural constraints enforcement.

// #v(.4em)
// #statement(fill: soft)[
//   The goal is not just coverage. The goal is explicit coverage under architectural constraints.
// ]

= ScalaTropy

== The Idea in One Slide

#slide(composer: (0.82fr, 1.18fr))[

  // #v(.45em)
  // #line(length: 100%, stroke: .7pt + ink.lighten(72%))
  // #v(.6em)

  #let idea-row(label, color, body, fill: luma(252)) = (
    table.cell(
      fill: color.lighten(88%),
      inset: (x: .62em, y: .52em),
      align: center + horizon,
    )[
      #text(size: .78em, fill: color.darken(12%), weight: "medium")[#label]
    ],
    table.cell(
      fill: fill,
      inset: (x: .72em, y: .52em),
      align: left + horizon,
    )[
      #text(size: .78em, fill: ink)[#body]
    ],
  )

  #block(
    width: 100%,
    inset: .22em,
    radius: 6pt,
    fill: luma(250),
    stroke: (paint: ink.lighten(72%), thickness: .7pt),
  )[
    #table(
      columns: (1.1fr, 3fr),
      gutter: .08em,
      stroke: none,
      ..idea-row(
        [Topology],
        blue,
        [which #bold[peer families] exist and which #bold[ties] are admissible],
      ),
      ..idea-row(
        [Placement],
        orange,
        [where each #bold[value lives] among the peers, written as ```scala V on P```],
        fill: soft,
      ),
      ..idea-row(
        [Shape],
        green,
        [which #bold[flow is intended]: point-to-point, scatter, broadcast, or gather],
      ),
    )
  ]

  // #v(.75em)
  // #line(length: 100%, stroke: .7pt + ink.lighten(72%))
  // #v(.45em)

][
  #codly(
    highlights: (
      (line: 1, start: 6, end: 11, fill: blue),
      (line: 1, start: 30, end: 45, fill: blue),
      (line: 2, start: 6, end: 11, fill: blue),
      (line: 2, start: 30, end: 43, fill: blue),
      (line: 5, start: 10, end: 23, fill: orange),
      (line: 5, start: 28, end: 37, fill: orange),
      (line: 7, start: 11, end: 25, fill: green),
      (line: 8, start: 11, end: 20, fill: orange),
      (line: 9, start: 10, end: 26, fill: green),
    )
  )
  ```scala
  type Master <: { type Tie <: Multiple[Worker] }
  type Worker <: { type Tie <: Single[Master] }

  for
    tasks: Task on Master <- on[Master]:
      buildTasks()
    work <- anisotropicComm[Master, Worker](tasks)
    part <- on[Worker] { take(work).map(_.compute) }
    all <- coAnisotropicComm[Worker, Master](part)
  yield all
  ```
]

== Architecture Is Part of the Program

#slide(composer: (0.8fr, 1.2fr))[
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
  #let peer-family-color = rgb("#7a5c9e")
  #let ties-color = rgb("#0f766e")
  #let guardrail-color = rgb("#b04a6f")

  #let architecture-row(label, color, body, fill: luma(252)) = (
    table.cell(
      fill: color.lighten(88%),
      inset: (x: .62em, y: .55em),
      align: center + horizon,
    )[
      #text(size: .76em, fill: color.darken(12%), weight: "medium")[#label]
    ],
    table.cell(
      fill: fill,
      inset: (x: .72em, y: .55em),
      align: left + horizon,
    )[
      #text(size: .76em, fill: ink)[#body]
    ],
  )

  #block(
    width: 100%,
    inset: .22em,
    radius: 6pt,
    fill: luma(250),
    stroke: (paint: ink.lighten(72%), thickness: .7pt),
  )[
    #table(
      columns: (1.25fr, 2.85fr),
      gutter: .08em,
      stroke: none,
      ..architecture-row(
        [Peer families],
        peer-family-color,
        [Types name the classes of participants in the distributed system.],
      ),
      ..architecture-row(
        [Ties],
        ties-color,
        [`Single[P]` and `Multiple[P]` describe admissible communication relationships.],
        fill: soft,
      ),
      ..architecture-row(
        [Compile-time guardrail],
        guardrail-color,
        [A primitive is callable only when its sender and receiver satisfy the required ties.],
      ),
    )
  ]
]

== Placement Types: Values Know Where They Live

#statement[
  The ```scala V on P``` notation can be read as: "_a value of type ```scala V``` owned by peer ```scala P```_".
]

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .7em)[
  #step-item([1], [place], [```scala on[P] { ... }``` evaluates the body expression only at peers of type `P`.])
][
  #step-item([2], [reference], [Other peers retain a typed remote reference to the placed value.])
][
  #step-item([3], [move], [Communication primitives are the only way to transfer values elsewhere.])
]

```scala
for
  message <- on[Client] { "Hello, Server!" }
  atServer <- comm[Client, Server](message)
  _ <- on[Server] { take(atServer).map(F.println) }
yield ()
```

== The Language Surface: Placed Computation

=== Placed computation

```scala
// Evaluates the `body` expression in the context of the peer P.
def on[P <: Peer, V](body: Label[P] ?=> F[V]): F[V on P]
// Extract the placement value into the value V.
def take[P <: Peer, V](value: V on P)(using Label[P]): F[V]
```

#v(.45em)
#table(
  columns: (auto, 1fr),
  column-gutter: .8em,
  row-gutter: .45em,
  stroke: none,
  align: (right + horizon, left + horizon),
  [#chip[```scala on```]],
  [Evaluates an expression on the peer `P` is local, producing a value typed as living at `P`.],
  [#chip[```scala take```]],
  [Uses evidence that the current peer is the local peer `P` to access the local value inside `V on P`.],
)

== The Language Surface: Communication




=== Communication API

#codly(
  highlights: (
    (line: 2, start: 18, end: 31, fill: blue),
    (line: 2, start: 44, end: 57, fill: blue),
    (line: 6, start: 27, end: 42, fill: orange),
    (line: 6, start: 55, end: 68, fill: blue),
    (line: 10, start: 29, end: 44, fill: orange),
    (line: 10, start: 57, end: 70, fill: blue),
    (line: 14, start: 31, end: 44, fill: blue),
    (line: 14, start: 57, end: 72, fill: orange),
  )
)
```scala
// Point-to-point communication
def comm[From <: TiedWithSingle[To], To <: TiedWithSingle[From], V](
  value: V on From
): F[V on To]
// Fan-out communication
def isotropicComm[From <: TiedWithMultiple[To], To <: TiedWithSingle[From], V](
  value: V on From
): F[V on To]
// Fan-out with per-peer overrides
def anisotropicComm[From <: TiedWithMultiple[To], To <: TiedWithSingle[From], V](
  value: Anisotropic[To, V] on From
): F[V on To]
// Fan-in communication
def coAnisotropicComm[From <: TiedWithSingle[To], To <: TiedWithMultiple[From], V](
  value: V on From
): F[Anisotropic[From, V] on To]
```


== Scala and Monads

#v(1em)

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.5em)[
  #styled-block(
    [Why Scala?],
    [
      #v(0.5em)
      - #text(fill: blue.lighten(10%), weight: "bold")[Advanced type system] to elegantly encode architectural constraints (```scala Type <: { ... }```).
      - #text(weight: "bold")[Given/using clauses] (context parameters) to transparently pass placement evidence.
      - #text(weight: "bold")[Flexible syntax] for embedded DSLs (e.g., ```scala on[P] { ... }```).
    ],
    icon: fa-code() + " ",
    fill-color: blue.lighten(90%),
    stroke-color: blue.lighten(40%),
    title-color: blue.darken(20%),
  )
][
  #styled-block(
    [Why Monads?],
    [
      #v(0.5em)
      - ```scala F[_]: Monad``` abstracts the side-effect of distribution (e.g., ```scala IO```, ```scala Future```, or ```scala Id```).
      - ```scala for```-comprehensions provide a clean, sequential syntax.
      - Enables a #text(fill: green.lighten(10%), weight: "bold")[Tagless-final style] to isolate the multiparty choreography from the network.
    ],
    icon: fa-cogs() + " ",
    fill-color: green.lighten(90%),
    stroke-color: green.lighten(40%),
    title-color: green.darken(20%),
  )
]

== Tagless-final Encoding

#components.side-by-side(columns: (2fr, 1fr))[
=== Effect-polymorphic interpretation

```scala
trait MultiParty[F[_]: Monad]:
  def on[P <: Peer, V](...): F[V on P]
  def comm[S, R, V](value: V on S): F[V on R]
  // ... other primitives

trait Network[F[_], LP <: Peer]:
  def send[V, To <: Peer](...): F[Unit]
  def receive[V, From <: Peer](...): F[V]
  def alivePeersOf[P <: Peer]: F[NonEmptyList[Address[P]]]

trait Environment[F[_], LP <: Peer]:
  def provide(peerTag: PeerTag[?]): F[Reference]
```
][
  #align(center + horizon)[
    #cetz.canvas(length: 1.5cm, {
      import cetz.draw: *

      let node(pos, width, height, title, subtitle, color) = {
        let (x, y) = pos
        rect(
          (x - width / 2, y - height / 2),
          (x + width / 2, y + height / 2),
          radius: .08,
          fill: color.lighten(90%),
          stroke: (paint: color.lighten(35%), thickness: .8pt),
        )
        content(
          pos,
          align(center)[
            #text(size: .65em, weight: "medium", fill: color.darken(13%))[#title]
            #linebreak()
            #text(size: .45em, fill: ink.lighten(18%))[#subtitle]
          ],
          anchor: "center",
        )
      }

      circle(
        (0, -.05),
        radius: 2.85,
        fill: ink.lighten(96%),
        stroke: (paint: blue.lighten(55%), thickness: .8pt),
      )
      content(
        (0, 2.7),
        box(
          inset: (x: .35em, y: .12em),
          fill: blue.lighten(96%),
          text(size: .6em, weight: "medium", fill: blue.darken(10%))[#raw("F[_]")],
        ),
        anchor: "center",
      )

      line(
        (0, .95),
        (-1.45, -.7),
        stroke: (paint: ink.lighten(40%), thickness: .85pt),
        mark: (end: ">"),
      )
      line(
        (0, .95),
        (1.45, -.7),
        stroke: (paint: ink.lighten(40%), thickness: .85pt),
        mark: (end: ">"),
      )
      content((-1.05, .2), text(size: .5em, fill: ink.lighten(22%))[uses], anchor: "center")
      content((1.05, .2), text(size: .5em, fill: ink.lighten(22%))[uses], anchor: "center")

      node((0, 1.45), 2.45, .85, [MultiParty], [program API], orange)
      node((-1.55, -1.25), 2.2, .8, [Network], [transport], blue)
      node((1.55, -1.25), 2.2, .8, [Environment], [local peer], green)
    })
  ]
]

#pagebreak()

#let point(color, body) = text(fill: color.darken(8%), weight: "medium")[#body]

#table(
  columns: (auto, 1fr),
  column-gutter: .8em,
  row-gutter: .45em,
  stroke: none,
  align: (right + horizon, left + horizon),
  [#chip(fill: orange.lighten(85%), stroke: orange.lighten(40%))[```scala MultiParty[F]```]],
  [#point(orange)[Defines programs once], abstracting over the effect that will interpret distributed computation.],
  [#chip(fill: green.lighten(88%), stroke: green.lighten(35%))[```scala F[_]```]],
  [Can be #point(green)[production `IO`, in-memory tests, or another monadic stack].],
  [#chip(fill: blue.lighten(88%), stroke: blue.lighten(38%))[```scala Network```]],
  [Provides the concrete #point(blue)[transport operations]: send, receive, and discover reachable peers.],
  [#chip(fill: orange.lighten(90%), stroke: orange.lighten(48%))[```scala Environment```]],
  [Provides the #point(orange)[local peer context] used to run placed computations at the current location.],
)

== Compiler Checks and Guarantees
```scala
type Server <: { type Tie <: Single[Database] & Multiple[Client] }
type Database <: { type Tie <: Single[Server] }
type Client <: { type Tie <: Single[Server] }
```
#components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
  === Architecture violation
  #codly(
    highlights: (
      (line: 3, start: 11, end: 50, fill: red),
    )
  )
  ```scala
  for
    q <- on[Database] { query() }
    leak <- isotropicComm[Database, Client](q)
  yield ()
  ```
][
  === Cardinality violation
  #codly(
    highlights: (
      (line: 3, start: 14, end: 50, fill: red),
    )
  )
  ```scala
  for
    value <- on[Client] { compute() }
    invalid <- comm[Client, Server](value)
  yield ()
  ```
]

#components.side-by-side(columns: (1fr, 1fr))[
=== Invalid placed value access

#codly(
    highlights: (
      (line: 3, start: 27, end: 37, fill: red),
    )
  )
```scala
for
  value <- on[Client] { compute() }
  invalid <- on[Server] { take(value) }
yield ()
```
][
=== Scope violation

#codly(
    highlights: (
      (line: 3, start: 13, end: 37, fill: red),
    )
  )
```scala
for
  value <- on[Client] { compute() }
  invalid = take(value)
yield ()
```
]

- All the static checks are implemented *plainly in the Scala type system*, without #underline[macros] or #underline[compiler plugins].
- #underline[Peers] and #underline[scoping discipline] will be *ereased at runtime*, so there is *no overhead* for the checks.
#statement(fill: green.lighten(88%), stroke: green)[
  If the choreography compiles, the message exchange pattern perfectly adheres to the structural constraints of the distributed system.
]

= ScalaTropy in Practice

== Case Study: Master-Worker

#slide(composer: (.70fr, 1.30fr))[
  #mini-card([Architecture], [
    ```scala Master``` is tied to multiple ```scala Worker```s; every ```scala Worker``` is tied to one ```scala Master```.
  ], color: blue)

  #mini-card([Scatter], [
    ```scala anisotropicComm``` sends a distinct task to each worker.
  ], color: orange)

  #mini-card([Gather], [
    ```scala coAnisotropicComm``` collects partial results and acts as a barrier.
  ], color: green)
][
  #codly(
    highlights: (
      (line: 1, start: 0, end: none, fill: blue),
      (line: 2, start: 0, end: none, fill: blue),
      (line: 10, start: 20, end: none, fill: orange),
      (line: 12, start: 21, end: none, fill: orange),
      (line: 15, start: 16, end: none, fill: green),
    )
  )
  ```scala
  type Master <: { type Tie <: Multiple[Worker] }
  type Worker <: { type Tie <: Single[Master] }

  def masterWorker[F[_]: MonadThrow](using MultiParty[F]) =
    for
      tasks <- on[Master]:
        for
          peers <- reachablePeers[Worker]
          alloc = peers.map(_ -> Task(...)).toMap
          message <- anisotropicMessage(alloc, Task(0))
        yield message
      taskOnWorker <- anisotropicComm[Master, Worker](tasks)
      partial <- on[Worker]:
        take(taskOnWorker).map(_.compute)
      results <- coAnisotropicComm[Worker, Master](partial)
      total <- on[Master]:
        takeAll(results).map(_.values.sum)
    yield total
  ```
]

// == Case Study: Replicated Key-Value Store

// #slide(composer: (1fr, 1fr))[
//   #placeholder(
//     [Key-value store architecture],
//     body: [Clients, primary replica, backup replicas]
//   )
// ][
//   - Clients send requests to the primary with `coAnisotropicComm`.
//   - The primary processes requests and builds per-client responses.
//   - `Put` requests are replicated to backups with `isotropicComm`.
//   - Backup acknowledgments flow back with `coAnisotropicComm`.
//   - Responses return with `anisotropicComm`.

//   #v(.4em)
//   #statement(fill: soft)[
//     The same choreography works with any number of backup replicas.
//   ]
// ]

== What Selective Communication Buys

#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: .75em)[
  #mini-card([Efficiency], [
    Send the necessary payload, not the superset each receiver must filter.
  ], color: green)
][
  #mini-card([Confidentiality], [
    Peers do not receive data that was never intended for them. Checked at compile-time.
  ], color: blue)
][
  #mini-card([Expressiveness], [
    The code make explicit which communication patter is used and which peers are involved. 
  ], color: orange)
]

#v(.7em)
#statement[
  Selectivity is both an optimization and a way to make distributed intent visible.
]

== Communication Overhead

#let overhead-point(label, body, color) = block(width: 100%, inset: (x: .12em, y: .2em))[
  #table(
    columns: (.22em, 1fr),
    column-gutter: .5em,
    stroke: none,
    align: (center + horizon, left + horizon),
    [#box(width: .22em, height: 2.2em, radius: 1.5pt, fill: color)],
    [
      #text(size: .68em, weight: "medium", fill: color.darken(12%))[#label]
      #linebreak()
      #text(size: .64em, fill: ink)[#body]
    ],
  )
]

#slide(composer: (1.13fr, .87fr))[
  
  #align(center + horizon)[
    #block(
      width: 98%,
      inset: .35em,
      radius: 6pt,
      fill: white,
      stroke: (paint: ink.lighten(70%), thickness: .8pt),
    )[
      #chip([Matrix-vector product], fill: ink.lighten(88%), stroke: ink.lighten(55%))
      #image("images/communication-overhead.png", width: 100%)
    ]
  ]
][
  #align(left + horizon)[

    === Selective communication keeps the payload local
    


    #overhead-point([Broadcast], [
      Sends the #text(fill: red)[full matrix] to every worker, so traffic grows with the number of peers.
    ], red)

    #overhead-point([Anisotropic], [
      Sends #text(fill: green)[each worker] only its row block; the shared vector and metadata dominate.
    ], green)

    #v(.14em)

    #block(
      width: 100%,
      inset: (x: .65em, y: .38em),
      radius: 5pt,
      fill: green.lighten(90%),
      stroke: (paint: green.lighten(35%), thickness: .8pt),
    )[
      #text(size: .66em, weight: "medium", fill: ink)[
        50 x 50 matrix: linear broadcast growth vs. an almost flat selective curve.
      ]
    ]
  ]
]

= Takeaways

== What ScalaTropy Contributes

#let contribution-point(title, body, color) = block(width: 100%, inset: (x: .1em, y: .32em))[
  #table(
    columns: (.18em, 1fr),
    column-gutter: .58em,
    stroke: none,
    align: (center + horizon, left + horizon),
    [#box(width: .18em, height: 4em, fill: color, radius: 1pt)],
    [
      #text(weight: "medium", fill: color.darken(12%))[#title]
      #linebreak()
      #text(fill: ink)[#body]
    ],
  )
]

#components.side-by-side(columns: (1fr, 1fr), gutter: 1em)[
  #contribution-point([Unified design], [
    Choreographic global specification with type-level architecture.
  ], blue)

  #v(.55em)

  #contribution-point([Differentiated communication], [
    Point-to-point, isotropic, anisotropic, and co-anisotropic primitives.
  ], orange)
][
  #contribution-point([Architectural enforcement], [
    Invalid peer interactions are rejected by Scala's type system.
  ], green)

  #v(.55em)

  #contribution-point([Monadic implementation], [
    Tagless-final encoding separates the DSL from concrete execution effects.
  ], blue)
]

== Future Work

#let future-work-item(index, title, body, color) = block(width: 100%, inset: (x: .1em, y: .3em))[
  #table(
    columns: (auto, 1fr),
    column-gutter: .62em,
    stroke: none,
    align: (center + horizon, left + horizon),
    [
      #box(
        width: 2.05em,
        height: 2.05em,
        radius: 50%,
        fill: color.lighten(86%),
        stroke: (paint: color.lighten(38%), thickness: .7pt),
      )[
        #align(center + horizon)[#text(size: .7em, weight: "medium", fill: color.darken(14%))[#index]]
      ]
    ],
    [
      #text(weight: "medium", fill: color.darken(12%))[#title]
      #linebreak()
      #text(size: .85em, fill: ink)[#body]
    ],
  )
]

#components.side-by-side(columns: (1fr, 1fr), gutter: 1.1em)[
  #future-work-item([1], [Core semantics], [
    Formalize the core language and the meaning of each communication primitive.
  ], blue)

  #v(.45em)

  #future-work-item([2], [Deployment guarantees], [
    Carry the type-level safety guarantees into deployment descriptors and runtime configuration.
  ], green)
][
  #future-work-item([3], [Peer Subtyping and Enclaves], [
    Study how refined peer definitions (via subtyping) relate to enclaves without adding additional primitives.
  ], orange)

  #v(.45em)

  #future-work-item([4], [Evaluation], [
    Extend the evidence with more case studies, benchmarks, and overhead measurements.
  ], blue)
]


== Thank You

#let artifact-url = "https://github.com/nicolasfara/scalatropy"

#slide(composer: (1.08fr, .92fr))[
  #align(left + horizon)[
    #text(size: 2.1em, weight: "medium", fill: ink)[Questions?]

    // #v(.35em)

    // #text(size: .95em, fill: ink.lighten(18%))[
    //   ScalaTropy: multiparty coordination where communication shape is part of the type story.
    // ]

    // #v(.9em)

    // #block(
    //   width: 88%,
    //   inset: (x: .8em, y: .55em),
    //   radius: 5pt,
    //   fill: orange.lighten(91%),
    //   stroke: (paint: orange.lighten(42%), thickness: .7pt),
    // )[
    //   #text(size: .66em, weight: "medium", fill: orange.darken(12%))[Artifact]
    //   #linebreak()
    //   #text(size: .82em, fill: ink)[#link(artifact-url)[#fa-github() github.com/nicolasfara/scalatropy]]
    // ]

    #text(weight: "medium", fill: ink.lighten(28%))[
      Feel free to check out the code, try it out, and reach out with questions or feedback!
    ]
  ]
][
  #align(center + horizon)[
    #block(
      inset: 1em,
      radius: 6pt,
      fill: white,
      stroke: (paint: ink.lighten(70%), thickness: .8pt),
    )[
      #tiaoma.qrcode(artifact-url, width: 6cm)
      #block(width: 70%)[
        #grid(
          columns: (1fr, 1fr),
          inset: 0.5em,
          image("images/available.png", width: 100%, fit: "contain"),
          image("images/functional.png", width: 100%, fit: "contain")
        )
      ]
      #link("https://doi.org/10.5281/zenodo.19407062", "10.5281/zenodo.19407062")
    ]
  ]
]
