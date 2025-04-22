#import "@preview/lovelace:0.3.0": *


#let title = "CS 38 Set 3 Responses"
#let author = "Gavin Yuliu Hua"
#let date = "2025-04"

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
*Algorithm* \
#pseudocode-list(booktabs: true, title: smallcaps[FindRome])[
  - *Input:* A directed graph $G = (V, E)$
  - *Output:* whether or not there exists a vertex $v$ satisfying the problem
  + $V_S$ = `SCCs`$(G)$ \/\/ _This is the algorithm described in lecture, linear time_
  + $E_S$ are the edges between the SCCs.
  + $G_S = (V_S, E_S)$
  + $forall v_S: "visited"(v_S) <- "false"$
  + $"post" <- []$
  + for $v_S in V_S$
    + if $"visited"(v_S) = "false"$
      + `Explore`($G_S$, $v_S$)
  + $forall v_S: "visited"(v_S) <- "false"$
  + 
  + `Explore`($G_S$, $"post"[-1]$)
  + return $"visited"(v_1) and "visited"(v_2) and ...and "visited"(v_n)$, where $v_i in V_S$
]

#pseudocode-list(booktabs: true, title: smallcaps[Explore])[
  - *Input:* A directed graph $G = (V, E)$, a vertex $v$
  - *Output:* updated the $"visited"$ variable, add vertices to the $"post"$ list according to post-ordering
  + $"visited"(v) = "true"$
  + for all $(v, u) in E$:
    + if $"visited"(u) = "false"$:
      + `Explore`$(G, u)$
  + add $v$ to $"post"$
]

*Correctness* \
_Proof:_
The algorithm to decompose a graph into SCCs is described in lecture and assumed to be correct.
The algorithm then conducts a topological sort of the SCC graph and finds the source SCC.
The source SCC has no incoming edges, so if a "Rome" exists it must be in the source SCC.
Therefore, we may call `Explore` once to expand create a DFS tree with the source SCC as the root.
If the tree touches all SCCs, then any node in the source is a valid Rome, since touching an SCC implies touching all vertices inside the SCC.
However, if the tree misses any SCCs, then no such Rome exists, since Rome must exist in the source.
The last line of the algorithm captures this line of reasoning and correctly returns whether or not there is a vertex that satisfies the problem statement.
#align(right, $qed$)

*Runtime*\
_Proof:_
The SCC decomposition algorithm takes linear time.
Creating the SCC graph also takes at most linear time since we only need to iterate through each edge once.
Running a standard DFS on the components takes less than linear time since $|V_S| <= |V|, |E_S| <= |E|$.
Running one last explore on one node in the SCC graph must also take less than linear time since it touches $V_S$ and $E_S$'s elements at most once.
Combining all the booleans in the return statement also takes linear time in $V_S$, which is smaller than $V$.
Therefore, the algorithm runs in linear time.
#align(right, $qed$)

=
==
_Proof:_
Since $G_I$ has an SCC containing both $x, overline(x)$, there must exist a path both from $x$ to $overline(x)$ and from $overline(x)$ to $x$.
Since $x$ is a boolean literal, it must be either true or false, so one of $x, overline(x)$ must be true. 
If $x$ is true, then since there is a path from $x$ to $overline(x)$, we must have $x => ...=> overline(x) => not x$, which is a contradiction.
Same goes for the case if $overline(x)$ is true.
Therefore, $I$ is not satisfiable.

#align(right, $qed$)


==

*Algorithm*

#pseudocode-list(booktabs: true, title: smallcaps[2SAT])[
  - *Input* A directed graph $G_I$ representing the 2SAT problem, wherein none of the SCCs contain $x, overline(x)$.
  - *Output:* A satisfying assignment
  + SCCs = `SCC`$(G_I)$ \/\/_Linear time_
  + sol = empty map from variable to true/false
  + while $G_I$ is not empty
    + let $C$ be a sink SCC
    + sol = `Solve2SATComponent`$(C, "sol")$
    + remove $C$ from $G_I$
  + return sol
]

#pseudocode-list(booktabs: true, title: smallcaps[Solve2SATComponent])[
  - *Input:* A SCC $C$ of $G_I$, a partial, fixed solution $"sol"$.
  - *Output:* A satisfying assignment of all the variables in the SCC.
  + $forall v: "visited"(v) <- "false"$
  + let $v$ be a random vertex in $C$
  + newsol = `2SATExplore`$(C, v, "sol")$
  + if newsol is empty
    + newsol = `2SATExplore`$(C, overline(v), "sol")$
  + return newsol
]

#pseudocode-list(booktabs: true, title: smallcaps[2SATExplore])[
  - *Input:*
  - *Output:*
  + $"visited"(v) = "true"$
  + $"sol"[v] = "true"$
  + $"sol"[overline(v)] = "false"$
  + for $(v, u) in E$
    + if $"visited"(u)$
      + if $"sol"[u] = "false"$
        + return empty map
    + else
      + sol = `2SATExplore`$(C, u, "sol")$
      + if sol is empty
        + return sol
  + return sol
]

*Correctness*

`2SATExplore` constructs a DFS tree and checks for consistency.
Since it is always initialized on an SCC, we can be sure that if there are no premature returns resulting from inconsistencies, all nodes and edges are touched.
Since all edges are checked and no modifications are made to the checked nodes after they are first checked, any returned solution is guaranteed to be consistent.

We will use induction to prove that 