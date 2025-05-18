#import "@preview/lovelace:0.3.0": *

#let title = "CS 38 Set 5"
#let author = "Gavin Yuliu Hua"
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
== Correctness and Formulation
We employ dynamic programming to solve this problem.
We first identify the major components of any DP algorithm.
- Let the subproblems be denoted as $D[i, j]$ ($1 <= i <= m, 1 <=j <= n$), where $D[i, j]$ is the optimal cost of removing pixels from rows $1,..., i$, and specifically removing the pixel $(i, j)$.
  Since the pixels removed have to be vertically/diagonally adjacent, if $i, j$ is removed ($i > 1$), then it must be the case that one of $(i-1, j-1), (i-1, j), (i-1, j+1)$ is removed, assuming that $j-1, j, j+1$ are in bounds.
  If any of $(i-1, j-1), (i-1, j), (i-1, j+1)$ are not in bounds, then the corresponding $D = oo$ to remove it from consideration in the max. 
  Therefore, by definition, we have $ D[i, j] = d[1, j] + min{D[i-1, j-1], D[i-1, j], D[i-1, j+1]} $
  which relates the subproblems.
- The ordering of the subproblems are as follows.
  Consider a grid in which the $(i, j)$ element represented $D[i, j]$ ($m n$ elements in total)
  Then, each element would only depend on three elements in the row before it.
  A valid ordering is thus to process the subproblems in increasing row order, and arbitrary column order (we choose increasing column order for ease of implementation).
- Initialization: The only row that cannot be calculated with the recurrence formula is row $i = 1$.
  However, in the first row, $D[1, j]$ simply means to remove one specified pixel $1, j$ from the image. 
  By definition, this gives $D[1, j] = d[1, j]$.
- Answer extraction: since a finished seam of pixels must remove one pixel from row $m$, and each $D[m, j]$ corresponds to a finished seam (as it contains exactly one pixel removed from each row), we first find $ j^* = arg min_j D[m, j] $, and backtrack from $(m, j^*)$.
  At each step $(i, j_i)$, we choose $j_(i-1) in [j_i, j_i+1, j_i-1]$ such that $D[i-1, j_(i-1)]$ is minimized, essentially reversing the process of constructing $D(i, j_i)$.
  Algorithmically, this can be completed by storing the $j_(i-1)$ when the subproblems are first solved.
  The final answer can be expressed as the list $[..., (i, j_i), ...]$.

== Algorithm
```
// Input: costs d[i, j], bounds m*n
// Output: an optimal seam as an array, where the i'th element is the column of the best pixel to remove on row i.

D, back = empty matrices of size m*n
FOR j = 1:n
  D[1, j] = d[1, j]
  back[1, j] = null

FOR i = 2:m
  FOR j = 1:n
    best_cost = D[i-1, j] // always valid since j is always in bounds
    back[i-1, j] = j
    FOR delta = [-1, 1]
      // check if in bounds and better
      IF (1 <= j+delta <= n) AND (D[i-1, j+delta] < best_cost)
        best_cost = D[i-1, j+delta]
        back[i-1, j] = j+delta

best_seam = empty array of size m
best_seam[m] = [argmin_j (D[m, j])]
FOR i = m-1:1
  best_seam[i] = back[i, best_seam[i+1]] // backtrack with the end of best_seam list

RETURN best_seam
```

== Runtime
There are $m n$ subproblems.
In each subproblem, we compare three different options and perform a constant number of operations of storing into memory.
This is $O(m n)$.
In the backtracking process, the algorithm considers $m$ subproblems to construct the list, with each subproblem being processed in constant time.
This is $O(m)$
Therefore, the total runtime is $O(m n + m) = O(m n)$.



=

== Correctness and Formulation
We employ dynamic programming to solve this problem.
We first identify the major components of any DP algorithm.

=== Subproblems
This is nearly identical to what was presented in lecture; we simply need to keep track of some more history.
Let the subproblems be $E[i, j, x_g, y_g]$.
It is the optimal edit distance consisting of the first $i$ characters of $x$ and the first $j$ characters of $y$, and whether each ended in a gap ($x_g, y_g$ are booleans).
There are $4$ cases:
- Optimal sequence ends with $(x[i], -)$; i.e., $x[i]$ is the last element of the $x$ subsequence and $-$ is the last element of the $y$ subsequence.
  We use this notational convention (tuples) to represent the ends of matchings.
  This specific configuration's cost is $E[i, j, F, T]$.
  This tuple can be proceeded by
  - $(x[i-1], -)$, of which optimal cost is represented by $E[i-1, j, F, T]$
  - $(x[i-1], y[j])$, of which optimal cost is represented by $E[i-1, j, F, F]$
  - $(-, y[j])$, of which optimal cost is represented by $E[i-1, j-1, T, F]$
  - $(-, -)$, which immediately has a cost of $oo$.
  $ E[i, j. F, T] = min{E[i-1, j, F, T], E[i-1, j, F, F] + c, E[i-1, j-1, T, F] +c} + 1 $
  The $+c$ terms represents the cost of starting a new contiguous gap $y[j] -> -$, amd the $+1$ term represents the cost of the mismatch in the last element.
- Optimal sequence ends with $(x[i], y[j])$. By the same reasoning above, we have
  $ E[i, j, F, F] = min{E[i-1, j-1, F, T], E[i-1, j-1, F, F], E[i-1, j-1, T, F]} + "diff"(i, j) $
  Since we ended with both $x[i]$ and $y[j]$, we cannot be starting new gaps.
  The $"diff"(i, j)$ term represents the cost of matching $x[i]$ and $y[j]$.
- Optimal sequence ends with $(-, y[j])$. By the same reasoning above, we have
  $ E[i, j, T, F] = min{E[i, j-1, F, F]+c, E[i, j-1, F, T]+c, E[i, j-1, T, F]} + 1 $
  The $+c$ term represents the cost of starting a new contiguous gap $x[i] -> -$, and the $+1$ term represents the cost of the mismatch in the last element.
- Optimal sequence ends with $(-, -)$. This has a cost of $oo$.
  This is because we cannot have two gaps in the same sequence.
  We ignore this case in the recurrence.

These can be grouped as a matrix $M$ of $3$-arrays, where the $M[i, j]$ entry in the matrix corresponds to the list $[E[i, j, F, T], E[i, j, F, F], E[i, j, T, F]]$.

=== Ordering
We note that each subproblem $E[i, j, x_g, y_g]$ only depends on subproblems of the form $E[i-1, j, x_g, y_g]$, $E[i-1, j-1, x_g, y_g]$, and $E[i, j-1, x_g, y_g]$.
This means that in terms of $M$, $M[i, j]$ only depends on $M[i-1, j]$, $M[i-1, j-1]$, and $M[i, j-1]$.
Since the elements within $M[i, j]$ are independent of each other, we can process them in any order.
Therefore, we can process the $M[i, j]$ in increasing order of $i$ and $j$.
One possible ordering is to process the $M[i, j]$ in increasing order of $j$ from $1$ to $n$, and for each $j$, process in increasing order of $i$ from $1$ to $m$.

=== Initialization
We initialize the smallest possible $i$ and $j$ values for $M[i,j]$.
$E[i, 0, F, F]$ and $E[i, 0, T, F]$ are both $oo$, since the configuration is impossible (the $y$ subsequence is empty, as indicated by the $0$, but the $y_g$ parameter indicates the last element of the $y$ subsequence is not a gap).
Therefore, the only valid configuration is $E[i, 0, F, T]$, which has a cost of $i + c$ ($i$ for the $i$ mismatches, and $c$ for the gap).

Similarly, $E[0, j, F, F]$ and $E[0, j, F, T]$ are both $oo$, since the configuration is impossible (the $x$ subsequence is empty, as indicated by the $0$, but the $x_g$ parameter indicates the last element of the $x$ subsequence is not a gap).
Therefore, the only valid configuration is $E[0, j, T, F]$, which has a cost of $j + c$ ($j$ for the $j$ mismatches, and $c$ for the gap).

Since all subproblems decrease $i$ or $j$ by $1$, these base cases covering $M[i, 0], M[0, j]$ are sufficient for the entire matrix.

=== Answer Extraction (HELLO PLEASE CHECK ME THIS IS A VERY LOOSE PROOF)
Similar to the previous problem, we can backtrack from the last element of the matrix.
In the following proof, a "pairing" is defined as a tuple of the form $(a, b)$, where $a$ is either an element of $x$ or a gap, and $b$ is either an element of $y$ or a gap.
We know, by definition, that the optimal cost is given by the minimum of the elements in $M[m, n]$. Call that element $E_min [m, n]$ ($E_min [i, j]$ in general). Add the pairing represented by $E_min [m, n]$ to the optimal matching.
Since the value of $E_min [i, j]$ is generated by the minimum of three elements, in the matrix elements $M[i-1, j], M[i, j-1], M[i-1, j-1]$ separately, we can backtrack into one of those three elements, generating a new $E_min [i', j']$. This effectively reverses the process of constructing $E_min [i, j]$, which builds the optimal matching.

== Algorithm
```
// Input: strings x, y, cost c
// Output: an optimal matching as a list of pairs, where the i'th element is the i'th pairing in the matching.

E = empty m*n*3 matrix, organized as [E[i,j,F,T], E[i,j,F,F], E[i,j,T,F]]
back = empty m*n*3 matrix, organized as [back[i,j,F,T], back[i,j,F,F], back[i,j,T,F]]. Initialized to null.

FOR i = 1:m
  E[i, 0] = [i + c, +oo, +oo]
FOR j = 1:n
  E[0, j] = [+oo, +oo, j + c]

FOR i = 1:m
  FOR j = 1:n
    E[i,j,F,T] = min{E[i-1, j, F, T], E[i-1, j, F, F] + c, E[i-1, j-1, T, F] + c} + 1
    back[i,j,F,T] = i, j, x_g, y_g tuple corresponding to the minimum element
    E[i,j,F,F] = min{E[i-1,j-1,F,T], E[i-1,j-1,F,F], E[i-1,j-1,T,F]} + diff(i,j)
    back[i,j,F,F] = i, j, x_g, y_g ...
    E[i,j,T,F] = min{E[i, j-1, F, F] + c, E[i, j-1, F, T] + c, E[i, j-1, T, F]} + 1
    back[i,j,T,F] = i, j, x_g, y_g ...

best_match = empty list
best_match[0] = i, j, x_g, y_g tuple corresponding to the minimum element of M[m, n]
WHILE best_match[-1] != null
  append back[best_match[i+1]] to best_match

FOR i = 1:len(best_match)
  best_match[i] = best_match[i][0], best_match[i][1] // remove the x_g, y_g elements

RETURN best_match
```


== Runtime
There are $m n$ subproblems (elements in the matrix $M$).
In each subproblem, we solve for $3$ different elements, each of which requires $3$ comparisons and a constant number of operations of storing into memory.
Therefore, processing each subproblem is $O(3*3) = O(1)$.
In the backtracking process, since each loop iteration must decrease $i$ or $j$ by $1$, it must run at most $m+n$ times.
The operation within the loop is constant time, the backtracking process is $O(m+n)$.
The final loop through the best_match list is $O(m+n)$, since the size of the list is at most $m+n$.
Therefore, the total runtime is $O(m n + m + n) = O(m n)$.



=

== Correctness and Formulation

=== Subproblems
Let the subproblem be defined as $V[i, j]$, the maximum value that can be obtained by splitting a cloth of dimensions $i$ by $j$.
For any piece of cloth, we can either make it into a product if the dimensions match perfectly, or split it into two pieces.
- If the cloth is too small to be split (base case), i.e., $i < min(a_i)$ or $j < min(b_i)$, then the value is $V[i, j] = 0$.
- If the dimensions match perfectly, then the value is $V[i=a_k, j=b_k] = c_k$. For notational convenience, denote the products as $P$, where the $i, j$ element of $P$ is $0$ if there does not exist a product of dimensions $i, j$, and $c_k$ if there does exist a product of dimensions $i, j$.
- If we cut along $x$, we can cut into two pieces of dimensions $x, j$ and $i-x, j$.
  The value of this cut is $V[i, j] = max_x {V[x, j] + V[i-x, j]}$.
- Similarly, if we cut along $y$, we can cut into two pieces of dimensions $i, y$ and $i, j-y$.
  The value of this cut is $V[i, j] = max_y {V[i, y] + V[i, j-y]}$.
Therefore, we can express the recurrence as:
$
  V [i, j] = max{P[i, j], max_x {V[x, j] + V[i-x, j]}, max_y {V[i, y] + V[i, j-y]}}
$

=== Ordering
We note that each subproblem $V[i, j]$ only depends on subproblems of the form $V[i-x, j], V[i, j-y], V[x, j], V[i, y]$.
This means that each subproblems only depends on subproblems that have a smaller $i$ or $j$.
This gives rise to a natural ordering of the subproblems.
We can process the $V[i, j]$ in increasing order of $i$ and $j$.
One possible ordering is to process the $V[i, j]$ in increasing order of $j$ from $1$ to $n$, and for each $j$, process in increasing order of $i$ from $1$ to $m$.

=== Initialization
We initialize the smallest possible $i$ and $j$ values for $V[i,j]$.
$V[i, 0]$ and $V[0, j]$ are both $0$ for all valid $i, j$, since in that case, the cloth has no area.


=== Answer Extraction
By definition, the answer is given by $V[X,Y]$.


== Algorithm
```
// Input: cloth dimensions X*Y, products a_i*b_i, costs c_i
// Output: the maximum value of the cloth

V = empty m*n matrix, initialized to 0
P = empty max(a_i)*max(b_i) matrix, initialized to 0
FOR i = 1:n
  P[a_i, b_i] = c_i

FOR i = 1:X
  FOR j = 1:Y
    V[i, j] = P[i, j]
    FOR x = 1:i-1
      V[i, j] = max{V[i, j], V[x, j] + V[i-x, j]}
    FOR y = 1:j-1
      V[i, j] = max{V[i, j], V[i, y] + V[i, j-y]}

RETURN V[X, Y]
```
== Runtime
The first part of the algorithm is $O(n)$, since we iterate through all products and perform one operation for each.
The second part of the algorithm considers $X*Y$ subproblems (elements in the matrix $V$).
In each subproblem, we must check all $x$ and $y$ values that are less than $i$ and $j$, respectively.
This gives $O(i+j)$ operations per subproblem.
Since $i<=X, j<=Y$, we know that $O(i+j)$ is bounded by $O(X+Y)$.
Since there are $X*Y$ subproblems, the second part of the algorithm is $O(X Y (X+Y))$.
Therefore, the total runtime is $O(n + X Y  (X+Y))$.

=

== Algorithm
```
// Input: a set of possible roads R and associated cost, a set of cities V, and a set of quiet cities Q.
// Output: a subset of the roads R that connects all cities, and each quiet city is only connected to one road.

roads = empty set
FOR q in Q
  minCost = infinity
  minRoad = null
  FOR (q, v) in R
    IF cost(q, v) < minCost AND v is not in Q
      minCost = cost(q, v)
      minRoad = (q, v)
  add(roads, minRoad)

roads = union(roads, Kruskal(R, V-Q))
RETURN roads
```


== Correctness
The problem is extremely similar to the MST problem.
The only difference is that some nodes can only be connected to one edge. 
Let $T = V \\ Q$.

We first show that the optimal solution must cover all $q in Q$ in the form $(q, t), t in T$.
Assume, to the contrary, that there exists a solution $R^*$ that contains an edge $(q, q')$ (must cover $q$ since that is in the problem statement).
Then, $q$ would not have any more edges connected to other nodes, nor would $q'$.
This means that $q'$ is not connected to any other nodes, and $q$ is not connected to any other nodes.
Therefore, there cannot exist a path from $v in V \\ {q, q'}$ to $q$ or $q'$.
This means that $R^*$ is not a valid solution, since it does not connect all nodes.
This is a contradiction.

We then show that $forall q in Q$, in the optimal solution, $q$ must be connected to the node $t in T$ that minimizes the cost $w(q, t)$.
Assume, to the contrary, that $(q, t') in R^*$, which is not the minimum cost edge.
Consider the set of edges $R' = R^* - (q, t') + (q, t)$, which has a strictly lower cost than $R^*$.
If $R'$ connected all nodes, then $R'$ is a valid solution with a lower cost than $R^*$, which is a contradiction.
Therefore, $R'$ must not connect all nodes.
Suppose two vertices $v_1, v_2$ are connected in $R^*$ through the path $P$ but not in $R'$.
There are two cases.
- Neither of $v_1, v_2$ are $q$.
  In this case, $P$ must not contain $q$, since for a vertex to be an intermediate vertex in a path, it must be connected to at least $2$ edges, but $q$ is only connected to $1$ edge.
  Since the path does not contain $q$, removing the edge $(q, t)$ does not affect the connectivity of $v_1$ and $v_2$, which is a contradiction since $R'$ does not connect $v_1$ and $v_2$.
- One of $v_1, v_2$ is $q$.
  WLOG, let $v_1 = q$.
  Therefore, $v_2$ must be connected to $t'$ and $t$ in both $R^*$ and $R'$, since none of the nodes are $q$ (by the previous argument).
  Since $q$ is connected to $t$ in $R'$, and $v_2$ must be connected to $t$ in $R'$, $q$ must be connected to $v_2$ in $R^*$.
  This means that $v_1, v_2$ are connected in $R'$, which is a contradiction.
Therefore, we have constructed a valid solution $R'$ that is strictly cheaper than $R^*$, which is a contradiction.

The problem is now reduced the MST problem on $T$, since by connecting all $t in T$, the $q$ nodes are automatically connected, since all are already connected one $t in T$.
We can then use Kruskal's algorithm to find the minimum spanning tree of $T$, which is already proven to be correct.

We can then add the edges $(q, t)$ to the MST of $T$ to get the final solution.

Therefore, we have generated a solution that is valid and has the minimum cost.

== Runtime
The algorithm first processes all quiet cities $Q$, of which there are at most $n$.
To process each quiet city, we must check all edges in $R$ that are connected to it.
Therefore, the worst case is $O(n |R|)$ to process all quiet cities.
Kruskal's algorithm is $O(|R| log |R|)$.
Therefore, the total runtime is $O(n |R| + |R| log |R|)$.
Since $(n+|R|)^2 = n^2 + 2n |R| + |R|^2 > n |R| + |R| log |R|$, this algorithm is $O((n+|R|)^2)$polynomial in the size of the input.
