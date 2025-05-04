#import "@preview/lovelace:0.3.0": *

#let title = "CS 38 Midterm Exam Responses"
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

$a, b$ can be interpreted as coefficient representations of polynomials, where $a[i]$ is the coefficient of $x^i$ in polynomial $A(x)$ and $b[i]$ is the coefficient of $x^i$ in polynomial $B(x)$.
The problem is then reduced to finding the coefficients of the polynomial $C(x) = A(x) dot B(x)$.
We adapt the FFT algorithm to compute the coefficients of $C(x)$ efficiently.

== Algorithm
#pseudocode-list(booktabs: true, title: smallcaps[FFTCountCombos])[
  - *Input:* $a[0, ..., n-1], b[0, ..., n-1]$, arrays of integers bounded between $[0, N]$, where $2N+1$ is a power of $2$.
  - *Output:* $d[0, ..., 2N]$, an array of integers where $d[i]$ is the number of pairs $(a[j], b[k])$ such that $a[j] + b[k] = i$ for all $0 <= i <= 2N$.
  + $A, B = $ empty arrays of size $2N + 1$.
  + for $i in [0, n-1]$:
    + $A[a[i]] += 1$.
    + $B[b[i]] += 1$.
  + $A_v = "FFT"(A, omega)$ where $omega$ is a primitive $(2N+1)$th root of unity.
  + $B_v = "FFT"(B, omega)$
  + for $i in [0, 2N]$:
    + $C_v [i] = A_v [i] dot B_v [i]$.
  + $C = "FFT"(C_v, omega^(-1))$.
  + return $C[0, ..., 2N]$.
]

== Correctness

== Runtime


#pagebreak()
=

== Algorithm
#pseudocode-list(booktabs: true, title: smallcaps[FindSpecialPoints])[
  - *Input:* A set of $n$ 2D points $P = {(x_i, y_i)}_(i=1)^n$.
  - *Output:* The set $S$ of special points.
  + if $n <= 1$
    + return $P$
  + $x_m = "Selection"({x_i}, n/2)$ // O(n) time
  + $R = {(x_i, y_i) in P | x_i > x_m}$ // O(n) time
  + $y_R = max{y_i | (x_i, y_i) in R}$ if $R$ is nonempty, else $-oo$
  + $M = {(x_i, y_i) in P | x_i = x_m}$
  + $(x_M, y_M) = $ point in $M$ with maximum $y$-coordinate
  + if $y_M > y_R$
    + $S = {(x_M, y_M)}$
    + $y_"cut" = y_M$
  + else
    + $S = emptyset$
    + $y_"cut" = y_R$
  + $L = {(x_i, y_i) in P | x_i < x_m and y_i > y_"cut"}$
  + return $S union "FindSpecialPoint"(L) union "FindSpecialPoint"(R)$
]

== Correctness
We perform an induction on the number of points $n$, guaranteed to be a power of $2$.
The base case is when $n = 1$.
In this case, the only point is trivially a special point.
For the inductive step, assume the algorithm is correct for $n = 2^k$ for $k >= 0$.
We will show that it is also correct for $n = 2^(k+1)$.

We split the set of points into three sets: $L$, $R$, and $M$.
In the algorithm, we first extract the special points from the set $M$.
This set contains all points with the same $x$-coordinate as the middle element (not median!) $x_m$; it must be nonempty.
Since all points in $M$ have the same $x$-coordinate, only $(x_M, y_M)$ is potentially a special point (if we chose any other point $(x_i, y_i) in M$, we would have $x_i = x_m$ and $y_i <= y_M$, which contradicts the definition of a special point).
It has a greater $x$ coordinate than all points in $L$ by construction.
Therefore, if it has a greater $y$-coordinate than all points in $R$, it is a special point, since no point would be able to dominate it in both coordinates.
This is exactly what the algorithm checks for ($-oo < $ any number, so it is the default if $|R| = 0$), and if it is a special point, it is added to the set $S$.
Moreover, we set $y_"cut"$ to be the maximum $y$-coordinate of all points $R' = M union R$, which will be used to filter points in $L$.

In the return statement of the algorithm, we recursively call `FindSpecialPoints` on two sets of points, $L$ and $R$.
Since we have assumed the algorithm is correct for $n = 2^k$, both calls will return the correct set of special points for their respective sets of points.

We now show set equality between $S$ and the set of special points in $P$.

- Firstly, assume to the contrary that there exists a special point $(x_s, y_s)$ in the original set of points that is not in `FindSpecialPoints(P)`.
By the inductive hypothesis, we have found all special points in $L$ and $R$. Moreover, we have also found any potential special points in $M$.
Therefore, $(x_s, y_s)$ must be in the set of points that were not considered by the algorithm.
Since $(x_s, y_s)$ is not in either $L$ or $R'$, we have that
$
  not (x_s >= x_m) and not (x_s < x_m and y_s > y_"cut") \
  (x_s < x_m) and ((x_s >= x_m) or (y_s <= y_"cut")) \
  ((x_s < x_m) and (x_s >= x_m)) or ((x_s < x_m) and (y_s <= y_"cut")) \
  F or ((x_s < x_m) and (y_s <= y_"cut")) \
  (x_s < x_m) and (y_s <= y_"cut") \
$
For convenience, denote all points that satisfy this property as $B = P \\ (L union R') = {(x, y) in P | (x < x_m) and (y <= y_"cut")}$.
We immediately note $P = L union M union R union B$.
Denote the point that defined $y_"cut"$ as $(x, y)$; it must be in $R'$ since $y_"cut"$ is the maximum $y$-coordinate of all points in $R'$.
We thus have $x > x_m > x_s$, and $y_s <= y_"cut"$.
This means that $(x_s, y_s)$ is not a special point, as we have found a point in $(x, y)$ that contradicts the definition.

- Then, assume to the contrary that one of the points in `FindSpecialPoints(L)` or `FindSpecialPoints(R)` is not a special point (it must be the case that the point extracted from $M$ is actually a special point, as argued above).
We consider two cases.
First, assume that there exists a point $(x_s, y_s)$ in `FindSpecialPoints(L)` that is not a special point.
Since we have assumed that the algorithm is correct for $n = 2^k$, this means that there must exist a point $(x_i, y_i)$ in either $R'$ or $B$ such that $x_i >= x_s$ and $y_i >= y_s$.
Such a point cannot exist in $B$ since we have shown that all points in $B$ have a $y_i <= y_"cut" < y_s$.
Such a point cannot exist in $R'$ since $y_s > y_"cut" = max{y_i} >= y_i$ for all points in $R'$.
We have a contradiction.
 
Then, assume that there exists a point $(x_s, y_s)$ in `FindSpecialPoints(R)` that is not a special point.
Since we have assumed that the algorithm is correct for $n = 2^k$, this means that there must exist a point $(x_i, y_i)$ in $P\\R = L union M union B$ such that $x_i >= x_s$ and $y_i >= y_s$.
Such a point cannot exist in $L$ or $B$ since we have shown that all points in $L$ and $B$ have a $x_i < x_m < x_s$.
Such a point cannot exist in $M$ since all points in $M$ have the same $x$-coordinate as $x_m$, which is less than $x_s$.
We have a contradiction.

Therefore, all points returned by `FindSpecialPoints(L)` and `FindSpecialPoints(R)` are special points in $P$, and all special points in $P$ are returned by the algorithm.

#align(right, $qed$)

== Runtime
Finally, we show that the algorithm runs in $O(n log n)$ time.
The base case of the recursion is when $n = 1$, which runs in constant time.
The selection algorithm has an expected time complexity of $O(n)$.
Constructing the $R$ set takes $O(n)$ time, as does finding the maximum $y$-coordinate in $R$, since both require a single pass through the points.
Constructing the set $M$ also takes $O(n)$ time, as does finding the maximum $y$-coordinate in $M$, which also requires a single pass through the points.
The comparison of $y_M$ and $y_R$ takes constant time.
Constructing the set $L$ takes $O(n)$ time, as it requires a single pass through the points.

$|L| + |M| + |R| = n$.
Since we are splitting the points using the middle element on the $x$ coordinate $x_m$, it must be that $|L|, |R| <= n/2$.
This is because if any of $L$ or $R$ had more than $n/2$ points, then they would contain the middle element $x_m$, resulting in a contradiction since that element is in $M$.
Therefore, the length of the subproblems is at most $n/2$.
Therefore,
$
  T(n) <= 2 T(n/2) + O(n)
$
The master theorem resolves this recurrence to $T(n) = O(n log n)$.
#align(right, $qed$)


#pagebreak()

=

== Algorithm
#pseudocode-list(booktabs: true, title: smallcaps[SolveAcyclic3SAT])[
  - *Input:* An acyclic incidence graph $G = (V, E)$ of a 3SAT instance with $n$ variables and $m$ clauses.
  - *Output:* A boolean assignment $A$ of the variables that satisfies the 3SAT, or "None" if no such assignment exists (it will always exist though).
  + $A$ is an empty map from variables in $V$ to boolean values.
  + while $V$ is not empty:
    + iterate over $V$ to find a variable $v$ with only one edge $e$ in $E$
    + let $c$ be the clause connected to $v$ by $e$
    + if $v$ appears in $c$ positively:
      + $A[v]$ is set to true
    + otherwise:
      + $A[v]$ is set to false
    + for all edges $(c, v') in E$:
      + if $v'$ has only one edge in $E$:
        + $A[v']$ is arbitrarily set to true
        + remove $v'$ from $V$ and the edge $(c, v')$ from $E$
    + remove $v$ from $V$ and $e$ from $E$
  + return $A$
]


== Correctness
We will demonstrate the correctness of the algorithm by performing an induction on the times the `while` loop runs.
This will also show that any 3SAT instance with an acyclic incidence graph of is satisfiable.
- Inductive hypothesis: at any iteration in the loop, there will always be at least one variable in the incidence graph $G$ with only one edge in $E$. After this variable is removed, the resulting problem will still be a 3SAT instance with an acyclic incidence graph.
- Base case: this is when no variables have been removed.
  - Assume, to the contrary, that all variables appear in at least two clauses.
    Consider the number of edges in the incidence graph $G$.
    Each clause is connected to exactly three variables, so there are $3m$ edges in total.
    Since each variable is connected to at least two clauses (consuming $2$ edges), there are at most $3/2 m$ variables in total.
    We thus have $|V| = m + 3/2 m = 5/2 m > m-1$, so $|V|$ is greater than the number of edges required for a tree, which contains the maximum number of edges of an acyclic graph.
    Therefore, the incidence graph must be cyclic. \
  - We now consider the structure of the problem after removing the variable $v$ with only one edge in $E$.
    Since $v$ is only connected to one clause $c$, setting $v$ to either true or false will not affect the satisfiability of the remaining clauses while immediately satisfying clause $c$.
    Removing the edges that are connected to $c$ will not create any cycles, since $G$ is acyclic by assumption.
    The other variable are decoupled from the removed clause by removing the edge connecting them.
    Therefore, the resulting problem is still a 3SAT, with one variable removed and $m-1$ clauses remaining.
- Inductive step:
  Assume the hypothesis holds for $k$ iterations of the loop.
  Then, at the $(k+1)$'th iteration, the problem is still a 3SAT instance with an acyclic incidence graph, with $m-k$ clauses remaining.
  By the argument in the base case, there must be at least one variable in the incidence graph $G$ with only one edge in $E$.
  After removing this variable, the resulting problem is still a 3SAT instance with an acyclic incidence graph, with $m-k-1$ clauses remaining.
  Therefore, the inductive hypothesis holds for $k+1$ iterations of the loop.

Therefore, by induction, the algorithm is correct.
#align(right, $qed$)

An immediate consequence of this proof is that any 3SAT instance with an acyclic incidence graph is satisfiable, since at every step of the algorithm, we are guaranteed to find a variable with only one edge in the incidence graph, and we can always set it to a value that satisfies the clause it is connected to.
We may satisfy all clauses in the 3SAT instance by repeating this process.
#align(right, $qed$)

== Runtime
In every iteration, we perform a linear search through the variables in $V$ to find a variable with only one edge in $E$. This is $O(n)$ time.
We also perform a linear search through the edges in $E$ to find other variables that are connected to the clause $c$ that was just satisfied, which is also $O(m)$ time.
Each iteration of the loop removes one clause from the incidence graph, so the loop will run at most $n$ times (since the number of clauses is strictly smaller than $n$).
Therefore, the total runtime of the algorithm is $O(n(m+n))$, which is polynomial in the size of the input.
#align(right, $qed$)



#pagebreak()
=

==
Lemma: $"lowpre"[v] = "pre"[v]$. \
_Proof:_
Since $D$ is a sink SCC, all edges of the form $(v, u)$ must have $u in D$.
Since $v$ is the first vertex encountered in $D$, it must be that $"pre"[v] < "pre"[u]$ for all $u in D$.
There are only two ways that $"lowpre"$ is modified:
when a vertex is first visited (which sets $"lowpre"[v] = "pre"[v]$), or when a neighbor vertex is visited (which sets $"lowpre"[v] = min("lowpre"[v], "lowpre"[u])$).
Therefore, every $"lowpre"$ value must correspond to the $"pre"$ value of _some_ vertex in the graph.
Assume, to the contrary, that there exists a vertex $u$ in $D$ such that $"lowpre"[u] < "pre"[v]$.

In order to show $T_v = D$, we will show subset inclusion.

=== $D subset.eq T_v$:
Let $u$ be an arbitrary vertex in $D$.
We will first prove that $"lowpre"[u] = "lowpre"[v]$.
A conclusion that follows from $D$ being a sink SCC is that $"lowpre"[u] >= "lowpre"[v]$.
Assume, to the contrary, that there exists a vertex $w$ in $D$ such that $"lowpre"[w] < "lowpre"[v]$.
Since $v$ is the first vertex encountered in $D$ in the DFS traversal, $"pre"[w] > "pre"[v]$.
This must mean that one of $w$'s neighbors $w_1$ has $"lowpre"[w_1] < "lowpre"[v]$.
Then, since $D$ is an SCC, there exists a path from $w$ to $v$ in $D$.

Since $D$ is an SCC, there exists a path from $u$ to $v$ in $D$.
Name that path $P$, $P = [u=p_1, p_2, ..., v = p_n]$
- We will show that $"lowpre"[p_i] = "lowpre"[v], forall i in [1, n]$ with induction.
- Base case: $i = 1$.
  - Since 


=== $T_v subset.eq D$.
Let $u$ be an arbitrary vertex in $T_v$.
Since $D$ is an SCC, 