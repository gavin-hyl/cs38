#import "@preview/lovelace:0.3.0": *


#let title = "CS 39 Set 4 Responses"
#let author = "Anonymous"
#let date = "2025-05"

#set heading(numbering: (..nums) => {
let levels = nums.pos();
  if levels.len() == 1 {
    "Problem " + numbering("1", ..levels)
  } else {
    numbering("1.a.i", ..levels)
  }
})

#set page(
  numbering: "1",
    header: [
      #smallcaps([#title])
      #h(1fr) #author
      #line(length: 100%)
    ],
)

#set par(justify: true)

=

== Algorithm

#pseudocode-list(booktabs: true, title: smallcaps[TreeExactCover])[
  - *Input* a tree $G = (V, E)$
  - *Output* whether or not $exists E' subset.eq E$ such that $E'$ touches every vertex in $V$ exactly once
  + if $|V|$ is odd:
    + return false
  + $V_1$ is an empty set of vertices of degree $1$.
  + for each vertex $v in V$:
    + if $v$ has degree $1$ then add $v$ to $V_1$
  + while $V$ is not empty:
    + select a vertex $v$ from $V_1$ at random
    + remove $v$ from $V$ and from $V_1$
    + let $u$ be the unique neighbor of $v$ in $G$
    + for all edges $(u, w) in E$:
      + if $w$ has degree $1$
        + return false
      + else if $w$ has degree $2$:
        + add $w$ to $V_1$
      + remove $(u, w)$ from $E$
    + remove $u$ from $V$
  + return true
]

== Correctness
We claim that every iteration of the loop maintains the invariant that the remaining vertices and graph has a perfect matching (i.e., satisfies the condition in the problem) if and only if the original graph $G$ did.

We use induction on the the number of iterations of the loop.
- Base case: since each iteration removes exactly one vertex and its neighbor, we need two base cases.
  - If $|V| = 0$, we note that the condition $|V|$ is empty is satisfied, and the algorithm returns true.
    The graph is trivially matched by the empty set of edges.
  - If $|V| = 1$, we note that the condition $|V|$ is odd is satisfied, and the algorithm returns false.
    The graph cannot be matched by any set of edges since there are none.
  - The invariant holds in both cases.
- Inductive step: assume that the invariant holds after $k$ iterations of the loop.
  We will show that it holds after $k+1$ iterations.
  Let $G_k = (V_k, E_k)$ be the graph and set of vertices remaining after $k$ iterations of the loop.
  By the inductive hypothesis, $G_k$ has a perfect matching if and only if $G$ does.
  - First, we show that $G_(k+1)$ has a perfect matching if $G_k$ does.
    Let the perfect matching in $G_k$ be the set of edges $E'_k$, and let $v$ be the vertex selected from $V_1$ in the $(k+1)$th iteration of the loop.
    Let $u$ be the unique neighbor of $v$ in $G_k$.
    Since $v$ has degree $1$, the edge $(u, v)$ must be in $E'_k$, since $E'_k$ must cover every vertex in $V_k$.
    Since both $v$ and $u$ are removed from $G_k$, we can remove the edge $(u, v)$ from $E'_k$ (which now covers $V'_k \\ {u, v}$) to obtain a perfect matching in $G_(k+1)$.
  - Next, we show that if $G_(k+1)$ has a perfect matching, then $G_k$ does.
    Let the perfect matching in $G_(k+1)$ be the set of edges $E'_(k+1)$.
    Let $v$ be the vertex selected from $V_1$ in the $(k+1)$th iteration of the loop, and $u$ be its unique neighbor.
    We claim that the set $E'_k = E'_(k+1) union {(u, v)}$ is a perfect matching in $G_k$.
    We first note that $(u, v)$ must be in $G_k$, since the loop chose it to be removed from $G_k$.
    Moreover, in terms of vertices, $V'_(k+1)$ contains all vertices in $V_k$ except for $u$ and $v$, since $u, v$ were removed (and only they were removed) in the $(k+1)$th iteration of the loop.
    Therefore, the extra edge $(u, v)$ added to $E'_(k+1)$ covers both $u$ and $v$, and thus $E'_k$ covers all vertices in $V'_k$.
  Therefore, the invariant holds after $k+1$ iterations of the loop.

To demonstrate the correctness of the algorithm, we now note that 