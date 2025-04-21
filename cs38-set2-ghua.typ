#import "@preview/lovelace:0.3.0": *

#let title = "CS 38 Set 2"
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
In this problem, $compose$ denotes list concatenation.

*Algorithm*
#pseudocode-list(booktabs: true, title: smallcaps[QuickSort])[
  - *Input*: An array $a$.
  - *Output*: The array $a$ sorted in non-decreasing order.
  + if $n <= 1$:
    + return $a$
  + choose a pivot $p$ from $a$ at random
  + $L, E, G <- $ empty lists
  + for each $x$ in $a$:
    + if $x < p$:
      + append $x$ to $L$
    + else if $x = p$:
      + append $x$ to $E$
    + else:
      + append $x$ to $G$
  + return `QuickSort`($L$) + $E$ + `QuickSort`($G$)
]

*Correctness*\
_Proof:_
We will demonstrate correctness by strong induction on the size of the array $a$.
For the base case, $|a| = 1$, the array is trivially sorted.
For the inductive step, assume the algorithm is correct for all arrays of size $<=k$.
Let $|a| = k+1$.
All of $L, E, G$ must have size $<=k$.
Therefore, by the inductive hypothesis, `QuickSort`($L$) and `QuickSort`($G$) are correct.
Since all elements in $L$ are less than $p$, and all elements in $G$ are greater than $p$, the concatenation of `QuickSort`($L$), $E$, and `QuickSort`($G$) is sorted.
#align(right, $qed$)


*Runtime*\
We first describe the worst case runtime.
In the worst case, the recursion minimally reduces the problem size.
This can be achieved by always choosing the largest or smallest element as the pivot.
WLOG, let $p = max(a)$.
In this case, $|L| = |a| - 1$ and $|G| = emptyset$.
At each level, the algorithm does $|a|$ comparisons and $|a|$ list append operations.
This is $Theta(n)$.
`QuickSort`($L$) is called with $|L| = |a| - 1$.
This gives a recurrence relation of the form $T(n) = T(n-1) + Theta(n)$.
Since $T(1) = O(1)$ is the base case, we have $T(n) = sum_(k=0)^n Theta(k) = Theta(n(n-1)/2) = Theta(n^2)$.

We now describe the average case runtime.
We conjecture that $EE[T(k)] <= c_1 (k log(k)) + c_2 k$ for some positive constants $c_1, c_2$.
We use strong induction on the size of the array $a$.
For the base case, we can easily select large constants such that the relation holds.
For the inductive step, assume that $EE[T(k)] <= c_1 (k log(k)) + c_2 k$ for all $k <= n-1$, for some positive constants $c_1, c_2$.
$
  EE[T(n)] &= 1/n sum_(k=1)^(n-1) (EE[T(k) + EE(T(n-k))]) + 2n \
  &= 1/n sum_(k=1)^(n-1) EE[T(k)] + 1/n sum_(k=1)^(n-1) EE[T(n-k)] + 2n \
  &= 1/n sum_(k=1)^(n-1) EE[T(k)] + 1/n sum_(k=1)^(n-1) EE[T(k)] + 2n \
  &= 2/n sum_(k=1)^(n-1) EE[T(k)] + 2n \
  &<= 2/n sum_(k=1)^(n-1) (c_1 k log(k) + c_2 k) + 2n \
$

We now attempt to bound the $k log(k)$ term. We use an integral bound.
$
  I = integral x log(x) d x &= integral x d(x(log(x)) - 1) \
  &= x^2 (log(x) - 1) - integral x(log(x) - 1) d x \
  &= x^2 (log(x) - 1) - integral x log(x) d x + integral x d x \
  &= x^2 (log(x) - 1) - I + x^2/2 \
  I &= 1/2 x^2 (log(x) - 1) + x^2/4 \
$

Since $x log(x)$ is monotone increasing, we can bound the sum by the integral.
$
  sum_(k=1)^(n-1) k log(k) &<= integral_1^n x log(x) d x \
  &= 1/2 n^2 (log(n) - 1) + n^2/4 \
  &= 1/2 n^2 log(n) - n^2 / 4 \
$

Plugging this back into the original inequality yields
$
  EE[T(n)] &<= 2/n (c_1 (1/2 n^2 log(n) - n^2 / 4) + c_2 n(n-1)/2) + 2n \
  &<= 2/n (c_1 (1/2 n^2 log(n) - n^2 / 4) + c_2 n^2/2) + 2n \
  &= c_1 n log(n) - c_1/2 n + c_2 n + 2n \
  &= c_1 n log(n) + (c_2 - c_1/2 + 2) n \
$

We may choose $c_1 = 4, c_2 = 2$.
We first verify that the base case holds: $EE[T(1)] = 1 <= 4 dot 1 dot log(1) + 2 dot 1 = 2$.
The inductive step then becomes $EE[T(n)] <= c_1 n log(n) + c_2 n$, which proves the conjecture.
Therefore, the expected runtime is $O(n log(n))$.
#align(right, $qed$)


=

*Algorithm*
#pseudocode-list(booktabs: true, title: smallcaps[FFT3])[
  - *Input*
    - An array $a = (a_0, a_1, dots, a_(n-1))$, for $n$ a power of $2$
    - A primitive $n$th root of unity, $omega$.
  - *Output*
    - $M_n (omega) a$
  + if $n = 1$:
    + return $a$
  + $(s_0, s_1, dots, s_(n/3-1)) = $ `FFT3`($(a_0, a_3, dots, a_(n-3)), omega^3$)
  + $(s'_0, s'_1, dots, s'_(n/3-1)) = $ `FFT3`($(a_1, a_4, dots, a_(n-2)), omega^3$)
  + $(s''_0, s''_1, dots, s''_(n/3-1)) = $ `FFT3`($(a_2, a_5, dots, a_(n-1)), omega^3$)
  + for $j = 0$ to $n/3 - 1$:
    + $r_j = s_j + omega^j s'_j + omega^(2j) s''_j$
    + $r_(j + n/3) = s_j + e^((2 pi i)/3) omega^j s'_j + e^((2 pi i)/3) omega^(2j) s''_j$
    + $r_(j + (2n)/3) = s_j + e^((4 pi i)/3) omega^j s'_j + e^((4 pi i)/3) omega^(2j) s''_j$
  + return $(r_0, r_1, dots, r_(n-1))$
]


*Correctness*\
_Proof:_
We will demonstrate correctness by strong induction on $n$.

We first note that the $omega$ we chose satisfy the property that $omega^3$ is an $n/3$-th primitive root of unity.
This is because $omega = e^((2 pi i) / n)$, and $omega^3 = e^((2 pi i) / (n\/3))$.
Moreover, we claim that for $k in {0, dots, n-1}$, $(omega^k)^3 = (omega^(k+ n/3))^3 = (omega^(k + (2n)/3))^3$.
This ensures that the sub-problems are valid and of $n/3$ length.

The base case is $n=1$, which is trivially correct since $M_n (1) = I_1$.
For the inductive step, assume correctness for all $n$ such that $n = 3^k$ for $k <= m$.
As one may see in the picture below, rows $0, 1, dots, n/3 - 1$ can be written as the sum of three matrix-vector products (same color matrix/vectors in the picture).
Since we assumed correctness, we know that the individual products are correct.
Since the algorithm computes the sum of three correct products according to the definition of the overall matrix-vector product, all the rows are computed correctly.
#align(center, image("figures/set2/p2.jpg"))
The same holds for the $j + n/3$ and $j + (2n)/3$ rows.
Therefore, the final step is correct by definition.
#align(right, $qed$)


*Runtime*\
_Proof:_
Let the runtime of `FFT3` be $T(n)$.
At each level, the algorithm does $O(n)$ work (one loop of size $n$ with $O(1)$ work per iteration).
The algorithm makes three recursive calls to `FFT3` with $n/3$ elements each.
Therefore, the recurrence relation is $T(n) = 3T(n/3) + O(n)$.
We make the identification with the master theorem: $a = 3$, $b = 3$, $d = 1$.
Since $a = b^d$, we may conclude that $T(n) = O(n log(n))$.
#align(right, $qed$)


=
We may modify the DFS algorithm to achieve this goal.

*Algorithm*

#pseudocode-list(booktabs: true, title: smallcaps[LongPathDFS])[
  - *Input:* A directed graph $G = (V, E)$.
  - *Output:* The months required to build the house $m$.
  + sources = elements of $V$ with no incoming edges
  + for all $v in V$:
    + visited($v$) = false
    + dist($v$) = $1$
  + $P <-$ empty list
  + for all $v in$ sources:
    + if not visited($v$):
      + `LongPathExplore`($G$, $v$, $P$)
  + $P <- "reverse"(P)$
  + for each $v in P$:
    + for each $(v, u) in E$:
      + dist($u$) = max(dist($u$), dist($v$) + 1)
  + return max(dist($v$) for all $v in V$)
]

#pseudocode-list(booktabs: true, title: smallcaps[LongPathExplore])[
  - *Input:* A directed graph $G = (V, E)$, a vertex $v$, a post-order $P$
  - *Output:* The appended post-order $P$.
  + visited($v$) = true
  + for all $(v, u) in E$:
    + if not visited($u$):
      + $P <- $ `LongPathExplore`($G$, $u$, $P$)
  + $P <- P + v$
  + return $P$
]

*Correctness* \
_Proof:_
It is easy to see that the algorithm's post-ordering is correct since it is a copy of the DFS post-ordering discussed in lecture.
We proceed to show that the algorithm correctly computes the longest path in the graph.
Since we have constructed the topological order, at every $v$, we know that all of $v$'s ancestors have been visited. 
In each inner loop, we consider which path is longer: the path from a source to $v$ to $u$, or any other path from a source to $u$.
Therefore, before we visit $u$, we know that all possible paths from a source to $u$ have been considered (since all ancestors have been processed.)
We have taken the maximum of all possible paths from a source to $u$.
Therefore, the algorithm correctly computes the longest path in the graph.
#align(right, $qed$)

*Runtime* \
The DFS post-ordering is $O(|V| + |E|)$.
After that, we iterate through the post-ordering exactly once, and for each vertex, we iterate through its edges exactly once.
Therefore, we touch on every vertex and edge exactly once, which is $O(|V| + |E|)$.
Therefore, the total runtime is $O(|V| + |E|)$.
#align(right, $qed$)

=
We may modify the DFS algorithm to achieve this goal.

*Algorithm* \
#pseudocode-list(booktabs: true, title: smallcaps[OddCycleDFS])[
  - *Input:* A directed graph $G = (V, E)$
  - *Output:* An odd cycle $C$ if any exist, otherwise $bot$.
  + for all $v in V$:
    + visited($v$) = false
    + parity($v$) = $0$
    + parent($v$) = $bot$
  + SCCs = `SCC`($G$) \/\/ _As described in lecture, this takes $O(|V| + |E|)$ time._
  + for all $S$ in SCCs:
    + $v$ is a random vertex in $S$
    + $P_e, P_o <- $ `OddCycleExplore`($G$, $v$, $bot$)
    + if $P_e, P_o = bot, bot$:
      + remove $S$ from SCCs
      + continue
    + $w <- "end"(P_e)$
    + $P_r$ is the path from $w$ to $v$ constructed by running regular DFS on $S$ with $w$ as the root node.
    + if $|P_r|$ is odd:
      + return $P_r + P_e$
    + else:
      + return $P_r + P_o$
  + return $bot$
]

#pseudocode-list(booktabs: true, title: smallcaps[OddCycleExplore])[
  - *Input:* A directed SCC $G = (V, E)$, a vertex $v$, a parent $p$
  - *Output:* Two paths from the root node of the exploration tree to a certain node. $P_e$ is an even-length path from the root to the node, and $P_o$ is an odd-length path from the root to the node. $bot, bot$ is returned if no such paths exist.
  + $"visited"(v) = "true"$
  + $"parent"(v) = p$
  + if $v != bot$
    + $"parity"(v) = ("parity"(p) + 1) mod 2$
  + for all $(v, u) in E$:
    + if $"visited"(u) = "false"$:
      + $C <- $ `OddCycleExplore`($G$, $u$, $v$)
      + if $C != bot$:
        + return $C$
    + else if $"parity"(u) = "parity"(v)$:
      + $P_u$ is the path from the root to $u$ that can be constructed by tracing $u$'s parents to the root node. 
      + $P_v$ is the path from the root to $u$ that can be constructed by tracing $v$'s parents to the root node, and appending the edge $(v, u)$ to the end of the path.
      + if $P_u$ is even-length and $P_v$ is odd-length:
        + return $(P_u, P_v)$
      + else:
        + return $(P_v, P_u)$
  + return $(bot, bot)$
]

#pseudocode-list(booktabs: true, title: smallcaps[OddCycleFromWalk])[
  - *Input:* A closed odd-length walk $W = (v_0, v_1, dots, v_n)$.
  - *Output:* An odd-length cycle $C$ if any exist, otherwise $bot$.
  + if $|W| = 1$ or $W$ is simple:
    + return $W$
  + else:
    + $W_1 = (v_i, v_(i+1), dots, v_j)$ is the walk from $v_i$ to $v_j$.
    + $W_2 = (v_j, v_(j+1), dots, v_n = v_0, v_1, dots, v_i)$ is walk from $v_j$ to $v_i$.
    + if $W_1$ is odd-length and $W_2$ is even-length:
      + return `OddCycleFromWalk`($W_1$)
    + else:
      + return `OddCycleFromWalk`($W_2$)
]


*Correctness* \
We first prove a lemma: if there an odd-length closed walk, then there exists an odd-length cycle.

_Proof:_
Denote the closed walk as $v_0, v_1, ..., v_n = v_0$.
If there is no repeat, then the walk is a cycle.
if there are repeats, let $v_i = v_j$ with $i < j$.
Then the walk can be split into two walks: $v_i, v_(i+1), ..., v_j$ and $v_j, v_(j+1), ..., v_n, v_1, dots, v_i$.
Since these two walks are disjoint, they must be even-length and odd-length.
Select the odd-length walk and repeat this process.
Since the walk is finite and its length is decreasing, we will eventually reach a point where the walk is simple ($|W| = 1$).
#align(right, $qed$)


We then prove the correctness of the algorithm.

_Proof:_
The `SCC` algorithm described in class can be assumed to correctly find all strongly connected components in the graph.
The DFS structure is also unchanged, so without premature returns, the algorithm will explore all vertices in the SCC (property of DFS).
We will now demonstrate the key lemma: 
_if $u$ and $v$ belong in an odd-length cycle in an SCC, _.

We will prove this by proving implications in both directions.
Denote a path from $a$ to $b$ as $P_(a b)$.
The paths of interest are $P_(r u)$, $P_(r v)$, $P_(u v)$, and $P_(v u)$.
- Let us first prove the forward direction.
  Since $u$ and $v$ are in an odd-length cycle, let one of $P_(u v)$ and $P_(v u)$ be an odd-length path, and the other is an even-length path.
  (This is possible since we can split the cycle.)
  WLOG, assume $P_(u v)$ is odd-length and $P_(v u)$ is even-length.
  Arbitrarily fix $P_(r u), P_(r v)$.
  - If $P_(r u)$ has the same parity as $P_(r v)$, then $P_(r u) + P_(u v)$ contains $u$ and has the opposite parity of $P_(r v)$, which satisfies the lemma.
  - If $P_(r u)$ has the opposite parity as $P_(r v)$, then $P_(r u)$ has the opposite parity of $P_(r v) + P_(v u)$ (which contains $v$), which also satisfies the lemma.
  Thus, we have proven the forward direction.
- Let us then prove the backwards direction.
  WLOG, let $P_(r u 0)$ be even-length, $P_(r u 1)$ be odd-length.
  - Suppose $P_(r u 0)$ contains $v$.




#pagebreak()
- Collaborators: Gio Huh
- Link to GitHub repository (tracks changes): https://github.com/gavin-hyl/cs38
- G-drive link for scratchpad: https://drive.google.com/file/d/1fl5h462QWzYFWYphbSEDJuUL8c2fY3bx/view?usp=sharing