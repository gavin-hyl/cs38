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
  + $forall v in V: "visited"(v) = F$
  + let $"sol"$ be an empty map from variable to boolean
  + let $"visited"$ be an empty map from variable to boolean
  + for all $v in V$
    + if not $"visited"[v]$
      + newsol, newvisited = `2SATExplore`$(G_I, v, "sol", "visited")$
      + if newsol is empty
        + newsol, newvisited = `2SATExplore`$(G_I, overline(v), "sol",  "visited")$
      + sol = newsol
      + visited = newvisited
  + return sol
]

#pseudocode-list(booktabs: true, title: smallcaps[2SATExplore])[
  - *Input:* A directed graph $G_I$ representing the 2SAT problem, a given vertex $v$ to set a true, a partial fixed solution $"sol"$, and a map of the visited vertices $"visited"$.
  - *Output:* The new assignments that are implied by setting $v$ to true, and the updated map of visited vertices.
  + $"visited"[v] = "visited"[overline(v)] = T$
  + $"sol"[v] = T$
  + $"sol"[overline(v)] = F$
  + for all $(v, u) in E$
    + if $"visited"(u)$
      + if $"sol"[u] = F$
        + return ($bot$, $bot$)
    + else
      + sol = `2SATExplore`$(G_I, u, "sol", "visited")$
      + if sol is empty
        + return ($bot$, $bot$)
  + return (sol, visited)
]

*Correctness* \
_Proof:_
`2SATExplore` constructs a DFS tree and checks for consistency.
It assumes that the root vertex is true and cascades the implications.
Since all edges are checked and no modifications are made to the checked vertices after they are first checked, any returned solution is guaranteed to be consistent given that the assumption is consistent.

We claim that at the end of every loop, all vertices in $C$ received an assignment that is part of a satisfying assignment.
We prove this with induction.
The base case is trivial.
If neither of the unconstrained searches return unsuccessfully, the problem is unsatisfiable.
For the inductive step, assume that $"sol"$ is part of a satisfying assignment.
Assume, to the contrary, that the problem is now unsatisfiable.
Let the variable that is in question be $x$.
A contradiction in general must be in the form $(a => overline(a)) and a$, where $a$ can be either a literal or its negation.
If the constrained 2SAT is unsatisfiable at this point, that must imply both $x$ and $overline(x)$ lead to contradictions.
This can be written as
$
  x => (a => overline(a)) and a \
  overline(x) => (b => overline(b)) and b \
$
which means
$
  (x=>a) and (x => (a => overline(a))) \
  (overline(x) => b) and (overline(x) => (b => overline(b)))
$
Since a variable assignment cannot change the graph edges, $(a => overline(a))$ is independent of the value of $x$.
For the problem to be unsatisfiable, it must be that both $(a => overline(a))$ and $(b => overline(b))$.
Therefore, we have
$
  x &=> a => overline(a) \
  overline(x) &=> b => overline(b) \
$

Taking the contrapositive,
$
  a => overline(x), b => x \
  x => a => overline(x) => b => x
$
Since each $=>$ implies that there is a path between the two literals, it must be the case that both $x$ and $overline(x)$ are in a cycle, thus in the same SCC, which contradicts the condition given in the problem.
Therefore, the inductive step also yields a partial solution that leads to no contradictions.
#align(right, $qed$)

*Runtime*\
_Proof:_
`2SATExplore` is called on each node at most once (since we mark it and its negation as visited), which is linear in $|V|$.
All edges of the input node are checked in `2SATExplore`, and since each node is only processed once, this is also linear in $|E|$.
Therefore, the algorithm runs in $O(|V|+|E|)$ time.


=
*Algorithm*
#pseudocode-list(booktabs: true, title: smallcaps[FindBottleneck])[
  - *Input:* An undirected graph $G = (V, E)$ with edge lengths $w(e)$, a vertex $x in V$
  - *Output:* The bottleneck distances from $x$ to all other vertices.
  + $g(x) = 0, g(x) = bot$
  + $g(y) = oo, p(y) = bot space (forall y != x)$
  + $R = {}$ is a set
  + $Q = {x}$ is a priority queue with key $g(v)$, where $v$ are the elements
  + while $R != V$
    + $v = "deleteMin"(Q)$
    + $"add"(R, v)$
    + for all $e = (v, z) in E$
      + if $max{g(v), w(e)} < g(z)$
        + $p(z) = v$
        + if $z in.not Q$
          + $g(z) = max{g(v), w(e)}$
          + $"insert"(Q, z)$
        + else
          + $"decreaseKey"(Q, z, max{g(v), w(e)})$
]

*Correctness*\
_Proof:_
We claim that each time a node is deleted from $Q$, its $g$ value is correctly set.
We will prove this with induction.
The base case is trivial: $g(x)$ has an empty path to itself and thus has a $g$ of $0$.
For the inductive step, assume that all vertices in $R$ have their bottleneck distances set correctly.
Since all vertices that are accessible from the vertices in $R$ are either in $R$ or in $Q$ (since all vertices are placed immediately on $Q$ upon discovery), all alternative paths from $x$ to $v$ (the ones that are not defined by tracing back parents starting from $v$) must pass through $R$ and optionally the vertices in $Q$
We will show an alternative path $p$ must have $g(v) <= h(p)$.
- If a path $p$ only consists of $v$ and vertices in $R$, then $h(p)$ of all other potential paths are considered. 
  Let the node before $v$ be $u in R$.
  By the inductive hypothesis, $g(u)$ is correct.
  $ h(p) = max{w_1, dots, w_n} = max{max{w_1, dots, w_(n-1)}, w_n} = max{g(u), w(u, v)} $
  Therefore, all $h(p)$ for arbitrary $u in R$ are correctly considered and compared, and the minimum is chosen and sets $g(v)$
- If a path $p$ consists of $v$, vertices in $R$, and vertices in $Q$, we will show that $h(p) >= g(v)$
  Assume, to the contrary, that $h(p) < g(v)$.
  Since removing a vertex cannot increase $h$, we know that $h(p') < g(v)$, where $p'$ is the subpath from $x$ to the first vertex in $Q$, call it $u$.
  $g(u) <= h(p')$ since $g$ is correct on $R$ and all possible $p'$ have been considered when the vertices were placed on $R$.
  This gives $g(u) <= h(p') < g(v)$, which contradicts the fact that $v$ was removed from $Q$, not $u$.
Therefore, $g(v)$ is correctly set when it is removed from $Q$. 
#align(right, $qed$)

*Runtime* \
_Proof:_
The structure of this code is exactly the same as Dijkstra's, and the only difference is how the keys are constructed.
Other aspects, such as processing the priority queue and iterating over edges of the selected vertex, remain the same.
Therefore, this algorithm runs in the same time complexity class as Dijkstra's, which is $O((m+n) log(n))$.
#align(right, $qed$)
