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

We show that the optimal solution to the original problem (with cost $C_1$) is equivalent to the optimal solution of this LP (with cost $C_2$).
- Feasibility: we show that any optimal solution to the original problem satisfies the constraints of this LP.
  Suppose the original problem has an optimal solution $(a^*, b^*)$.
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

In sum, since both $C_1 >= C_2$ and $C_2 >= C_1$, we have $C_1 = C_2$.

=

==
Let the paths be $P_1, P_2, ..., P_k$, and the flow that passes through $P_i$ be $F_i$.
The reformulated linear program is
$
  max sum_(i=1)^k F_i\
  "s.t." forall i: F_i >= 0, forall e: sum_(i "if" e in P_i) F_i <= f_e\
$

Intuition: the flows on each path can be superimposed linearly to create an overall flow on the graph, just like how currents in circuits can be superimposed.
The three constraints we need to respect are:
- the flow on each path is nonnegative, guaranteed by the first constraint
- the flow on each edge is less than or equal to the capacity of that edge, guaranteed by the second constraint
- that the flow entering each node is equal to the flow leaving that node (except for $s, t$), guaranteed by the fact that we are superimposing flows on paths, and every vertex on the path has the same incoming and outgoing flow, which is equal to the flow on that path.

By maximizing the sum of all flows, the total flow from $s$ to $t$ is maximized since each path starts from $s$ and ends at $t$.



=
We employ dynamic programming to solve this problem.

We define $C[i, j]$ to be the minimum cost of the binary tree constructed of integers $i$ to $j$, and let $P[i, j] = sum_(k=i)^j p_k$.
By definition, the optimal cost is $C[1, n]$.
We can compute $C[i, j]$ recursively, using the fact that among the integers $i$ to $j$, we can choose any integer $k$ as the root of the tree.
The cost of the tree is then the cost of the root $p_k$ plus the cost of the left subtree $C[i, k-1]$ and the cost of the right subtree $C[k+1, j]$.
$
  p_k + (C[i, k-1] + 1) P[i, k-1] + (C[k+1, j] + 1) P[k+1, j] \
$
given that $k-1 >= i, k+1 <= j$.
The optimal cost is the minimum of this expression over all $k$ from $i$ to $j$.

We can also efficiently compute $P[i, j]$ as
$
  P[i, j] = P[1, j] - P[1, i-1] \
$


=
We employ a greedy algorithm to solve this problem.
We simply visit the nodes in decreasing order of their values. 
The intuition behind this algorithm is that we want the high-value nodes to be visited first, thereby increasing the number of times that their neighbors are visited, which increases the score.
This is efficient in the input size since sorting the nodes only takes $O(n ln(n))$ time, and visiting the nodes takes $O(n)$ time.