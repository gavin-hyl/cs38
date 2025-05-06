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
    + remove all $(u, w)$ from $E$
    + remove $u$ from $V$
  + return true
]

== Correctness
If the graph has an odd number of vertices, then it cannot have a perfect matching (i.e., satisfy the conditions in the problem), since each edge in a perfect matching must cover exactly two vertices. Therefore, the algorithm correctly returns false in this case.
We now consider the case where the graph has an even number of vertices.

=== $V_1$ set is maintained correctly <v1_correct>
We show that at every iteration of the loop, all degree-$1$ vertices in the graph are contained in the set $V_1$.
We use induction on the the number of iterations of the loop. Let $G_k = (V'_k, E'_k)$ be the graph after $k$ iterations of the loop.
- Base case: since $V_1$ is initialized to all degree-$1$ vertices in the graph, this holds trivially.
- Inductive step: assume that all degree-$1$ vertices in the graph are contained in $V_1$ after $k$ iterations of the loop.
  We will show that this holds after $k+1$ iterations.
  We first consider the removal of vertices.
  - $v$: since $v$ is removed from $V'_k$, it must be removed from $V_1$, since $V_1 subset.eq V'_k$.
  - $u$: since $u$ is the unique neighbor of $v$ in $G_k$, it must have degree at least $2$ in $G_k$ (otherwise, $v$ would not have been selected to be removed from $V_1$). Therefore, it cannot be added to $V_1$.
  We now consider the addition of vertices.
  The change in degree of a vertex can only be affected by the removal/addition of edges incident to that vertex.
  Therefore, we only need to consider the edges that are removed (none are added) to determine if any degree-$1$ vertices are created.
  This is exactly what the algorithm does in the loop: if $(u, w)$ is removed from $E'_k$, then the degree of $w$ is decreased by $1$.
  Therefore, if $w$ has degree $2$ before the $(k+1)$th iteration of the loop, then it must have degree $1$ after the loop, so it should be added to $V_1$.
  No other vertices are changed in degree, so the additions and removals are correct and complete.
#align(right, $qed$)

=== $V_1$ set is nonempty <v1_nonempty>
We note that $V_1$ at the beginning of the $(k+1)$th iteration of the loop is nonempty.
Assume, to the contrary, that $V_1$ is empty after $k$ iterations.
This would imply that all vertices in $G_k$ have degree greater than $1$, which implies at least $(2 |V'_k|) / 2 = |V'_k| > |V_k|-1$ edges.
This means there must be a cycle in $G_k$, which contradicts the fact that $G_k$ was constructed by removing vertices and edges from a tree, which cannot contain cycles.
(If $G_k$ did contain a cycle, adding back the removed vertices and edges would create a cycle in $G$, which is a contradiction.)
#align(right, $qed$)

=== Invariance
We claim that every iteration of the loop maintains the invariant that the remaining vertices and graph has a perfect matching if and only if the original graph $G$ did.
We use induction on the number of iterations of the loop.
- Base case: $k=0$ (i.e., before the loop starts).
  Since $G_0 = G$, the invariant holds trivially.
- Inductive step: assume that the invariant holds after $k$ iterations of the loop.
  We will show that it holds after $k+1$ iterations.
  We first note that the algorithm will not encounter an error since $V_1$ is nonempty at the beginning of the $(k+1)$th iteration of the loop (as shown in @v1_nonempty).
  By the inductive hypothesis, $G_k$ has a perfect matching if and only if $G$ does.
  We now prove equivalence of $G_k$ having a perfect matching and $G_(k+1)$ having a perfect matching, which transfers the invariant to the next iteration of the loop.
  -  $G_(k+1)$ has a perfect matching if $G_k$ does. \
    Let the perfect matching in $G_k$ be the set of edges $E'_k$, and let $v$ be the vertex selected from $V_1$ in the $(k+1)$th iteration of the loop.
    Note that this selection is valid, as proved in @v1_correct
    Let $u$ be the unique neighbor of $v$ in $G_k$.
    Since $v$ has degree $1$, the edge $(u, v)$ must be in $E'_k$, since $E'_k$ must cover every vertex in $V_k$.
    Since both $v$ and $u$ are removed from $G_k$, we can remove the edge $(u, v)$ from $E'_k$ (which now covers $V'_k \\ {u, v}$) to obtain a perfect matching in $G_(k+1)$.
  - If $G_(k+1)$ has a perfect matching, then $G_k$ does. \
    Let the perfect matching in $G_(k+1)$ be the set of edges $E'_(k+1)$.
    Let $v$ be the vertex selected from $V_1$ in the $(k+1)$th iteration of the loop, and $u$ be its unique neighbor.
    Note that this selection is valid, as proved in @v1_correct
    We claim that the set $E'_k = E'_(k+1) union {(u, v)}$ is a perfect matching in $G_k$.
    We first note that $(u, v)$ must be in $G_k$, since the loop chose it to be removed from $G_k$.
    Moreover, in terms of vertices, $V'_(k+1)$ contains all vertices in $V_k$ except for $u$ and $v$, since $u, v$ were removed (and only they were removed) in the $(k+1)$th iteration of the loop.
    Therefore, the extra edge $(u, v)$ added to $E'_(k+1)$ covers both $u$ and $v$, and thus $E'_k$ covers all vertices in $V'_k$.
  Therefore, the invariant holds after $k+1$ iterations of the loop.

We now note that the algorithm must terminate after at most $1/2|V|$ iterations of the loop, since each iteration removes exactly one vertex and its neighbor from the graph.
- If the algorithm returned true, since the invariant holds after every iteration, and the final graph is empty (which is trivially a perfect matching), then the original graph $G$ must have had a perfect matching.
- We now consider the case where the algorithm returns false.
  This only occurs if the algorithm encounters a vertex $w$ with only one edge $(w, u)$ and another vertex $v$ with only one edge $(v, u)$ in $G_k$.
  Assume, to the contrary, that $G_k$ has a perfect matching $E'_k$.
  This means that both $w$ and $v$ must be covered by edges in $E'_k$.
  However, since both vertices only have one edge incident to them, the only edge that can cover both $w$ and $v$ is $(w, u)$ and $(v, u)$, respectively.
  This implies that $u$ must be covered by two edges in $E'_k$, which contradicts the definition of a perfect matching, since a perfect matching must cover every vertex exactly once.
  Therefore, if the algorithm returns false, then the graph $G_k$ (and by extension the graph $G$) must not have had a perfect matching.

Therefore, the algorithm returns true if and only if the original graph $G$ has a perfect matching.
#align(right, $qed$)

== Runtime
Constructing the set $V_1$ initially takes $O(|V|)$ time, since we must iterate through all vertices in the graph.
The while loop runs at most $1/2|V|$ times, since each iteration removes exactly one vertex and its neighbor from the graph.
In each iteration, selection from $V_1$ is constant time.
Since we remove an edge from the graph after examining it, iterating over the edges and removing them takes $O(|E|)$ time *in total, across all iterations*.
Removing $u$ also takes $O(1)$ time.
Therefore, the loop (without the inner loop) takes $O(|V|)$ time in total.
Adding the inner loop, which takes $O(|E|)$ time in total across all iterations, we have that the total runtime of the algorithm is $O(|V| + |E|)$, which is linear in the size of the input graph.
#align(right, $qed$)


#pagebreak()
=

==
=== Algorithm
#pseudocode-list(booktabs: true, title: smallcaps[GreedyMaxCut])[
  - *Input* an undirected graph $G = (V, E)$
  - *Output* a tuple of vertex sets $S, V-S$ such that $E(S, V-S) >= m/2$
  + let $a$ be an empty array of length $|V|$, in which each element is an empty set
  + let $d$ (best degree of vertex to add) be $0$
  + let $S$ be an empty set of vertices
  + initialize all $"deg"[v]$ to the degree of vertex $v$ in $G$
  + for each vertex $v$ in $V$:
    + add $v$ to $a["deg"[v]]$
    + $d = max{d, "deg"[v]}$
  + while $a$ is not empty:
    + let $v$ be an arbitrary vertex in $a[d]$
    + remove $v$ from $a[d]$, and add it to $S$
    + for each neighbor $u$ of $v$:
      + if $u$ is in $a$:
        + remove $u$ from $a["deg"[u]]$
        + decrement $"deg"[u]$ by 2
        + if $"deg"[u] <= 0$:
          + remove $u$ from $a$
        + else:
          + add $u$ to $a["deg"[u]]$
    + while $a[d]$ is empty and $d > 0$:
      + decrement $d$
  + return $(S, V - S)$
]


=== Value Bound


=== Runtime
The 

== Counterexample: Suboptimal Result from Algorithm