#import "@preview/lovelace:0.3.0": *

#let title = "CS 38 Set 6 Responses"
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
Define $e_i$ forall $i$, which intuitively bounds $|y_i - (a+b x_i)|$.
We claim that the following LP is equivalent to the original problem.
$
  min sum_i e_i\
  "s.t." forall i: e_i >= 0, e_i >= y_i - (a + b x_i), e_i >= -(y_i - (a + b x_i))\
$
where $a, b, e_1, ..., e_n$ are the decision variables.
We briefly note this is correct since $|a| = max(a, -a)$, and by the lecture notes, we know how to convert a max into an LP: simply introduce a new variable $x$ such that $x >= a, x >= -a$. 

We show that the optimal solution to the original problem (with cost $C_1$) is equivalent to the optimal solution of this LP (with cost $C_2$). Let $a^*, b^*$ be the optimal solution to the original problem. We will show it is both feasible and optimal for the LP.
- Feasibility: we show that any optimal solution to the original problem satisfies the constraints of this LP.
  *Define* $e_i^* = |y_i - (a^* + b^* x_i)|$.
  Since $e_i^* = |y_i - (a^* + b^* x_i)|$, we have $e_i^* >= 0, e_i^* >= y_i - (a^* + b^* x_i), e_i^* >= -(y_i - (a^* + b^* x_i))$, which satisfies all constraints of this LP.
  Moreover, the cost of this LP is $C_2 = sum_i e_i^* = sum_i |y_i - (a^* + b^* x_i)|$, which is exactly the cost of the original problem.
  Therefore, $C_1 >= C_2$.
- Optimality: we show that any cost of the LP cannot be strictly less than the cost of the original problem.
  Select an arbitrary solution $(a, b, e_1, ..., e_n)$ to the LP.
  We can rewrite the constraints as $e_i >= max(0, y_i - (a + b x_i), -(y_i - (a + b x_i))) = |y_i - (a + b x_i)|$.
  Therefore, the LP cost is $C_2 = sum_i e_i >= sum_i |y_i - (a + b x_i)|$.
  Therefore, there does not exist any solution to the LP that has a cost strictly less than the cost of the original problem.
  $C_2 >= C_1$.

Therefore, we have $C_1 = C_2$.
We have constructed a solution to the LP that has cost $C_2 = C_1$ in the first argument, and since $C_2 >= C_1$ by the second argument, that solution must be optimal for the LP.
Its decision variables were defined as $a=a^*, b=b^*, e_1^*, ..., e_n^*$, so the optimal solution to the LP contains $a^*, b^*$, which is the optimal solution to the original problem.
#align(right, $qed$)



=

== (with warmup)
Let the paths be $P_1, P_2, ..., P_k$, and the flow that passes through $P_i$ be $F_i$.
The reformulated linear program is
$
  max sum_(i=1)^k F_i\
  "s.t." forall i: F_i >= 0, forall e: sum_(i "if" e in P_i) F_i <= c_e\
$

Intuition: the flows on each path can be superimposed linearly to create an overall flow on the graph, just like how currents in circuits can be superimposed.
The three constraints we need to respect are:
- the flow on each path is nonnegative, guaranteed by the first constraint
- the flow on each edge is less than or equal to the capacity of that edge, guaranteed by the second constraint
- that the flow entering each node is equal to the flow leaving that node (except for $s, t$), guaranteed by the fact that we are superimposing flows on paths, and every vertex on the path has the same incoming and outgoing flow, which is equal to the flow on that path.

By maximizing the sum of all flows, the total flow from $s$ to $t$ is maximized since each path starts from $s$ and ends at $t$.

==
We first place the LP in the previous section into standard matrix form.
We note that $ c = bb(1)_k, b = vec(dots.v, c_e, dots.v), x = vec(dots.v, F_i, dots.v) $

The second constraint restricting the flow on each edge can be expressed as
$
  sum_(i=1)^k F_i dot bb(1)[e in P_i]<= c_e\
  (..., bb(1)[e in P_i], ...) vec(dots.v, F_i, dots.v) <= c_e\
$
Define the first row vector to be $A_e$, which has a $1$ in the $i$-th position if edge $e$ is in path $P_i$, and 0 otherwise.
Stacking these row vectors for all edges $e$ gives us a matrix $A in RR^(|E| times k)$, where the $i, j$ entry is $1$ if edge $e_i$ is in path $P_j$, and 0 otherwise.
We can then write the LP as
$
  max c^top x\
  "s.t." A x <= b, x >= 0\
$

Therefore, the dual is given by
$
  min y^top b = sum_e y_e c_e \
  "s.t." y^top A >= c^top = bb(1)_k^top, y >= 0\
$
where $y in RR^(|E|)$.
Unraveling the matrix multiplication, we have
$
  forall i in [1, k]: y^top A_(*i) >= 1
$
where $A_(*i)$ is the $i$-th column of $A$.
Unraveling further, we have
$
  forall i in [1, k]: sum_(e in P_i) y_e >= 1\
$


==
Let the cut be across the edges $e_1, e_2, ..., e_m$.
The corresponding feasible solution in the dual is given by
$y_e = 1$ for all $e in {e_1, e_2, ..., e_m}$, and $y_e = 0$ otherwise.
We first show that this is feasible.
- $y>=0$ is trivially satisfied by definition.
- We use the form $forall i in [1, k]: sum_(e in P_i) y_e >= 1$ instead of $y^top A >= c^top$.
  For each path $P_i$, we have $sum_(e in P_i) y_e = |{e in P_i: e in {e_1, e_2, ..., e_m}}|$.
  Since $P_i$ is a path from $s$ to $t$, it must cross at least one edge in the cut, so $|{e in P_i: e in {e_1, e_2, ..., e_m}}| >= 1$.
  Therefore, $forall i: sum_(e in P_i) y_e >= 1$ is satisfied.
We then show that the cost of the solution is equal to the capacity of the cut.
The cost of the solution is given by
$
  sum_e y_e c_e = sum_(e in {e_1, e_2, ..., e_m}) c_e\
$
Since the capacity of the cut is defined as the total capacity of the edges crossing the cut, it is equal to the cost of the solution by definition.
#align(right, $qed$)



=

== Algorithm
```
-------------------------------
function OptimalBST
// Input: an array of distinct integers a[1, ..., n], an array of probs p[1, ..., n]
// Output: a BST with minimum expected cost

n = length(a)
C, P, R = matrices of size n*n initialized to 0 // cost, prob, root
root = none // root of the optimal BST

FOR i=1:n
  FOR j=i:n
    P[i, j] = sum(p[i:j]) // O(n^3) time to compute all P[i, j]

FOR i=1:n
  C[i, i] = p[i]  // cost of a single node is its probability
  C[i, i-1] = 0
  C[i+1, i] = 0
  R[i, i] = i // root of a single-node tree is the node itself

FOR length=2:n    // we order based on the length of the subtree
  FOR i=1:n-length
    j = i + length
    C[i, j] = +inf
    FOR k=i:j     // k is the root of the subtree
      cost = P[i, j] + C[i, k-1] + C[k+1, j]
      IF cost < C[i, j]
        C[i, j] = cost
        R[i, j] = k // store the root of the optimal subtree

return ReconstructBST(a, R, 1, n)


-------------------------------
function ReconstructBST
// Input: array of sorted integers a[1..n], root matrix R, start/end indices i, j
// Output: the optimal BST of integers a[i..j]
if i > j
  return null
root = new node with fields val, left, right
k = R[i, j]
root.val = a[k]    // the root is the integer at k
root.left = ReconstructBST(a, R, i, k-1) // left subtree
root.right = ReconstructBST(a, R, k+1, j) // right subtree
return root
```



== Correctness

=== Subproblems
Define $P[i, j]$ to be the sum of probabilities of integers $i$ to $j$, i.e., $P[i, j] = sum_(k=i)^j p_k$.
Define $C[i, j]$ to be the minimum cost of the binary search tree constructed from integers $i$ to $j$, with one of the integers as the root.
This is our main object of interest.
Define $k$ to be the root of the tree, which can be any integer from $i$ to $j$.
Let the optimal depths of the element be $d_i, ..., d_j$, relative to the root $k$.
$
  C[i, j] &= sum_(l=i)^j p_l (d_l + 1) \
  &= p_k + sum_(l=i)^(k-1) p_l (d_l + 1) + sum_(l=k+1)^j p_l (d_l + 1) \
  &= p_k + sum_(l=i)^(k-1) p_l + sum_(l=i)^(k-1) p_l ((d_l-1)+1) + sum_(l=k+1)^j p_l + sum_(l=k+1)^j p_l ((d_l-1)+1) \
  &= p_k + P[i, k-1] + C[i, k-1] + P[k+1, j] + C[k+1, j] \
$
The last equality deserves some explanation. 
Since the depth $d_l$ was defined relative to the root $k$, but the cost $C[a, b]$ is defined relative to a root between $a$ and $b$, we need to adjust third and fifth terms to account for the fact that the root $k$ is not in the subsets $[i, k-1]$ and $[k+1, j]$.
Since the root of the two subsets must be one level deeper than the root $k$, we subtract $1$ from the depths of the elements in those subsets, hence the $d_l - 1$.

Simplifying further, we have
$
  p_k + P[i, k-1] + P[k+1, j] = P[i, j]
$
so
$
  C[i, j] = P[i, j] + C[i, k-1] + C[k+1, j] \
$
Since we cannot know the value of $k$ a priori, we need to minimize this expression over all possible values of $k$ from $i$ to $j$.
$
  C[i, j] = min_(i <= k <= j) (P[i, j] + C[i, k-1] + C[k+1, j]) \
$
One caveat is that we need to ensure that $k-1 >= i$ and $k+1 <= j$, which is almost guaranteed by the fact that $i <= k <= j$, except for the cases when $k = i$ or $k = j$.
In the context of the problem, $k = i$ or $k = j$ means that the root of the tree is the leftmost or rightmost integer, respectively.
In that case, the left or right subtree is empty, so we can simply set $C[i,i-1]$ and $C[j+1,j]$ to $0$.

The entry stored in the root matrix $R[i, j]$ is the index of the root of the optimal binary search tree for integers $i$ to $j$, which is the value of $k$ that minimizes the cost $C[i, j]$.

=== Ordering
We observe that $C[i, j]$ only depends on $C[i, k-1]$ and $C[k+1, j]$, which are subproblems of smaller length. 
Therefore, a natural ordering of the subproblems is by the length of the interval $[i, j]$.
However, this ordering is not unique. 
Arbitrarily, we order subproblems of the same length by the starting index $i$.
We use induction to show that this ordering is valid.
Base case: for length $1$, we initialize $C[i, i] = p_i$ for all $i$, since the cost of a single-node tree is simply the probability of that node.
Inductive step: assume that all subproblems of length $l$ have been computed, and we are now computing subproblems of length $l+1$.
As shown above, the relationship between $C[i, j]$ and its subproblems is correct.
Moreover, $C[i, k-1]$ and $C[k+1, j]$ are both at most of length $l$, since $k$ is between $i$ and $j$.
Therefore, by the inductive hypothesis, we know that $C[i, k-1]$ and $C[k+1, j]$ have been computed correctly.
Therefore, the ordering of subproblems by length is valid, and we can compute $C[i, j]$ correctly.

=== Answer Extraction
We prove the correctness of `ReconstructBST` by induction on the length of the interval $[i, j]$.
- Base case: for length $0$, we return `null`, which is correct since there are no integers in the interval.
- Inductive step: assume that the function works for all intervals of length $l$, and we are now computing an interval of length $l+1$.
  The index of the root is given by $R[i, j]$, since we have shown above that $R[i, j]$ contains the index of the root of the optimal binary search tree for integers $i$ to $j$.
  Therefore, the value of the root is correctly set to $a[R[i, j]]$.
  The left subtree is constructed from the interval $[i, R[i, j]-1]$, and the right subtree is constructed from the interval $[R[i, j]+1, j]$.
  By the inductive hypothesis, we know that the function works for these intervals, since they are both of length at most $l$.
  Therefore, the left and right subtrees are constructed correctly, and their roots are correctly returned.
  Therefore, the left and right attributes of the root node are correctly set.
Therefore, the `ReconstructBST` function correctly reconstructs the optimal binary search tree from the root matrix $R$.


== Runtime

=== Main Algorithm
Initialization of $P$ takes $O(n^3)$ time, since there are $O(n^2)$ pairs $(i, j)$ and each pair takes $O(n)$ time to compute the sum of probabilities.
Initialization of $C$ takes $O(n)$ time, since there are $n$ single-node trees.
There are $O(n^2)$ subproblems, since we can choose any $i, j$ such that $1 <= i <= j <= n$.
The cost of each subproblem can be bounded by $O(n)$, since we only need to perform a linear scan of the integers $i$ to $j$ to compute the cost of the tree with root $k$, and there are at most $n$ such integers.
Therefore, the total time complexity of the main algorithm is $O(n^3)$.

=== Answer Extraction
We first note that `ReconstructBST` will not be called on the same interval more than once, since in every level of the recursion, the interval is split into two disjoint intervals (so sub-calls will only be performed on disjoint intervals).
Therefore, an upper bound on the number of calls to `ReconstructBST` is $O(n^2)$, since there are $O(n^2)$ pairs $(i, j)$, which is the number of distinct intervals.
In each call, the function performs a constant amount of work to create a new node and set its attributes, which takes $O(1)$ time.
Therefore, the total time complexity of `ReconstructBST` is $O(n^2)$.

Therefore, the overall time complexity of the algorithm is $O(n^3)$, which is dominated by the main algorithm.


*(warmup)*

We employ dynamic programming to solve this problem.

We define $C[i, j]$ to be the minimum cost of the binary tree constructed of integers $i$ to $j$, and let $P[i, j] = sum_(k=i)^j p_k$.
By definition, the optimal cost is $C[1, n]$.
We can compute $C[i, j]$ recursively, using the fact that among the integers $i$ to $j$, we can choose any integer $k$ as the root of the tree.
The cost of the tree is then the cost of the root $p_k$ plus the cost of the left subtree $C[i, k-1]$ and the cost of the right subtree $C[k+1, j]$.
$
  p_k + C[i, k-1] + P[i, k-1] + C[k+1, j] + P[k+1, j] \ // +2
$
given that $k-1 >= i, k+1 <= j$.
The optimal cost is the minimum of this expression over all $k$ from $i$ to $j$.

We can also efficiently compute $P[i, j]$ as
$
  P[i, j] = P[1, j] - P[1, i-1] \
$


=

== Algorithm
```
function GameOrdering
// Input: a graph G, scores associated with the vertices a[1..n]
// Output: an ordering of the vertices that maximizes the score
pairs = []
FOR i=1:n
  add(pairs, (a[i], i)) // store the score and index as a pair

quicksort pairs by first element in descending order// sort by score
ordering = []
FOR i=1:n
  add(ordering, pairs[i][2]) // extract the indices from the sorted pairs

return ordering
```

== Correctness
We first lay some groundwork for our proof.

Firstly, every solution can be expressed as an ordering of *all* vertices in the graph.
This is because all scores are nonnegative, so selecting another vertex to visit will not decrease the score.
If a solution does not visit all vertices, we can simply add the remaining vertices to the end of the ordering, and the score will not decrease.

The total value extracted from the graph can be expressed in terms of the edges in the graph, since value is only added when both vertices of an edge are visited.
Let $e_(i j)$ be the edge between vertices $i$ and $j$.
The value extracted from this edge is $a[i]$ if $i$ is visited before $j$, and $a[j]$ if $j$ is visited before $i$.
The total value extracted from the graph is then the sum of values extracted from all edges, since in this formulation, each edge is counted exactly once, and the value corresponding to the edge is equivalent to the definition given in the problem.

This is a greedy algorithm.
As such, we will prove that it is correct by an exchange argument.
Consider an arbitrary optimal ordering of the vertices, $o_1, o_2, ..., o_n$.
If the vertices are ordered in decreasing order of their scores, then it coincides with the ordering produced by our algorithm since all vertices have distinct scores.
If not, then there exists some $i$ such that $a[o_i] < a[o_(i+1)]$.
We will show that we can exchange $o_i$ and $o_(i+1)$ to create a new ordering that has the same score.
Assume, to the contrary, that $o_i, o_(i+1)$ are connected.
Then, the value from the edge is $a[o_i]$, since it is visited before $o_(i+1)$.
If we exchange $o_i$ and $o_(i+1)$, then the value from the edge becomes $a[o_(i+1)]$, which is greater than $a[o_i]$.
Moreover, since $o_i, o_(i+1)$ are adjacent in the ordering, this exchange does not affect the values from any other edges, since the ordering of $o_i, o_(i+1)$ relative to all other vertices remain the same. 
Therefore, we have constructed a new ordering that has a greater score than the original ordering, which contradicts the assumption that the original ordering was optimal.
Therefore, there is no edge between $o_i$ and $o_(i+1)$, so we can exchange them without affecting the score (since the remaining relative ordering of the vertices remains the same).
Therefore, for any two vertices $o_i, o_(i+1)$ that are not ordered in decreasing order of their scores, we can exchange them to create a new ordering that has the same score.
We can use the bubble sort algorithm to repeatedly exchange adjacent vertices until all vertices are ordered in decreasing order of their scores, without changing the total score. 
Each element must be exchanged at most $O(n)$ times, from the end of the ordering to the front. 
Since there are $n$ elements in total, the total number of exchanges is $O(n^2)$, which is finite.
Therefore, we have shown that the greedy algorithm produces an ordering that is optimal, since it is equivalent to the ordering produced by repeatedly exchanging adjacent vertices in the optimal solution until all vertices are ordered in decreasing order of their scores.


== Runtime
Creating the pairs array takes $O(|V|)$ time, since we iterate over all vertices and create a pair for each vertex.
Sorting the pairs array takes $O(|V| log |V|)$ time, since that is the runtime of quicksort.
Extracting the indices from the sorted pairs array takes $O(|V|)$ time, since we iterate over all pairs and extract the second element.
Therefore, the overall time complexity of the algorithm is $O(|V| log |V|)$.

*(warmup)*
We employ a greedy algorithm to solve this problem.
We simply visit the nodes in decreasing order of their values. 
The intuition behind this algorithm is that we want the high-value nodes to be visited first, thereby increasing the number of times that their neighbors are visited, which increases the score.
This is efficient in the input size since sorting the nodes only takes $O(n ln(n))$ time, and visiting the nodes takes $O(n)$ time.