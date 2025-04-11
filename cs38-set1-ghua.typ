#import "@preview/lovelace:0.3.0": *



#let title = "CS 38 Homework 1"
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
      #h(1fr)
      #line(length: 100%)
    ],
)

#set par(justify: true)

=
==
_Proof:_
We perform strong induction on $n$. The base case is $n/b_i < 2$ for all $i$. In this case, $n$ is bounded by $2b$ by some $b$, so $T(n) = Theta(1) = Theta(b^w log(b)) = Theta(n^w log(n))$.

For the inductive step, assume that the statement holds for all $n < N$.
We then have
$
  T(n) &= f(n) + sum_(i=1)^k T(n/b_i) \
  &= f(n) dot sum b_i^(-w) + sum_(i=1)^k T(n/b_i) \
  &= sum_(i=1)^k f(n) b_i^(-w) + T(n/b_i) \
  &= sum_(i=1)^k b_i^(-w) (f(n) + b_i^w T(n/b_i))\
  &in sum_(i=1)^k b_i^(-w) (Theta(n^w) + b_i^w Theta((n/b_i)^w log(n/b_i))) \
  &in sum_(i=1)^k b_i^(-w) (Theta(n^w) + Theta(n^w (log(n) - log(b_i)))) \
  &in sum_(i=1)^k b_i^(-w) (Theta(n^w) + Theta(n^w log(n)) - Theta(n^w log(b_i))) \
  &in Theta(n^w log(n)) \
$
#align(right, $qed$)

==
_Proof:_
We make the identification
$
  f(n) &= n log(n) \
  k &= 2 \
  b_1 = b_2 &= 2 \
  2 dot (1/2^w) &= 1 => w = 1 \
$

Therefore,
$
  sum_i f(n / b_i) &= sum_i n/2 log(n/2) \
  &= n log(n/2) \
$
We shall prove that this falls into none of the three cases of the Generalized Master Theorem.

For the first case, assume, to the contrary, that $exists c > 1, n_0$, s.t., the statement holds.
Then,
$
  n log(n/2) &>= c n log(n) \
  log(n) - log(2) &>= c log(n) \
  log(n) (1 - c) &>= log(2) \
$
However, since $c > 1$, and since $log(n) > 0$, we have $log(n) (1-c) < 0 < log(2)$, which is a contradiction.

For the second case, assume, to the contrary, that $n log(n/2) in Theta(n)$. This implies that $exists c > 0, n_0 > 0: n log(n/2) < c n space forall n > n_0$, which implies that $log(n/2) < c space forall n > n_0$, which is a contradiction since $log(n/2)$ is unbounded as $n -> oo$.

For the third case, assume, to the contrary, that $exists c < 1, n_0$, s.t., the statement holds.
Then,
$
  n log(n/2) &<= c n log(n) \
  log(n) - log(2) &<= c log(n) \
  log(n) (1 - c) &<= log(2) \
$
Since $c < 1$, we have $1-c > 0$, so the statement is equivalent to
$
  log(n) &<= log(2)/(1-c) \
$
However, since $log(n)$ is unbounded as $n -> oo$, this is a contradiction.

Therefore, we have shown that the runtime recurrence does not fall into any of the three cases of the Generalized Master Theorem.
#align(right, $qed$)

We now solve the recurrence with a tabular method.
#table(
  columns: (auto, auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Layer*], [*\# problems*], [*length of problem*], [*work done*],
  ),
  $ 0 $, $ 1 $, $ n $, $ n log(n) $,
  $ 1 $, $ 2 $, $ n/2 $, $ 2(n/2) log(n/2) = n log(n/2) $,
  $ dots.v $, $ dots.v $, $ dots.v $, $ dots.v $,
  $ L $, $ 2^L $, $ n/(2^L) $, $ n log(n/(2^L)) $,
  $ dots.v $, $ dots.v $, $ dots.v $, $ dots.v $,
  $ log_2(n) - 1 $, $ n/2 $, $ 2 $, $ n log(2) $
)

Therefore, we have
$
  T(n) &= sum_(i=0)^(log_2(n)-1) n log(n/(2^i)) \
  &= n sum_(i=0)^(log_2(n)-1) log(n/(2^i)) \
  &= n (log(n) dot log_2(n) - sum_(i=0)^(log_2(n)-1) i dot log(2)) \
  &= n (log(n) dot log_2(n)) - n log(2) dot (((0+log_2(n) -1) dot log_2(n))/ 2) \
  &= n (log(n) dot log_2(n)) - n log(2) dot ((log_2(n)^2 - log_2(n))/2) \
  &in Theta(n (log(n) dot log_2(n)) - n log(2) dot ((log_2(n)^2 - log_2(n))/2)) \
  &in Theta(n (log(n) dot log_2(n))) \
  &in Theta(n log^2(n)) \
$


=
_Proof:_
As a lemma, we first describe an algorithm that converts a constrained 3SAT problem into an unconstrained 3SAT problem.
#pseudocode-list(booktabs: true, title: smallcaps([3SAT-Expand]))[
  - *input*: a 3SAT problem $p$ with n variables [$x_i$], a list of assignments $a$ of a subset of the variables.
  - *output*: a 3SAT problem $p'$ that is equivalent to $p$ with no constraints on variables
  + $k <-$ maximum index of all the variables in $a$
  + if $k = 0$:
    + return $p$
  + else:
    + if $a[k] = T$:
      + return ($x_k or x_k or x_k$) $and$ (3SAT-Expand($p, a[1:k-1]$))
    + else:
      + return ($overline(x_k) or overline(x_k) or overline(x_k)$) $and$ (3SAT-Expand($p, a[1:k-1]$))
]
The resulting problem $p'$ is equivalent to the original problem $p$:
- in the case of $x_k$ should be $T$, the $(x_k or x_k or x_k)$ places the constraint that $x_k = T$, otherwise the entire expression is $F$. The rest of the clauses are unchanged, and thus the problem is equivalent.
- in the case of $x_k$ should be $F$, the $(overline(x_k) or overline(x_k) or overline(x_k))$ places the constraint that $x_k = F$, otherwise the entire expression is $F$. The rest of the clauses are unchanged, and thus the problem is equivalent.

We note that `3SAT-Expand` is a recursive algorithm that has runtime $T_1 (n) = T_1 (n-1) + O(1)$.
Therefore, the runtime is $T_1 (n) = O(n)$.

We describe the `3SAT-Sparse` (sparse 3SAT) algorithm below, and prove its runtime complexity is indeed $O(n^(2c+1))$
#pseudocode-list(booktabs: true, title: smallcaps[3SAT-Sparse])[
  - *input*: a 3SAT problem $p$ with n variables [$x_i$], $1<=i<=n$, $c$ as defined in the problem statement
  - *output*: a list of all possible assignments of the variables [$x_i$], $1<=i<=n$
  + $V <-$ an empty valid assignment list
  + if $n <= 2c$:
    + $V <-$ a list of all feasible assignments of the variables [$x_i$], $1<=i<=n$
    + return $V$
  + else:
    + $A <-$ empty valid assignment list
    + $S <-$ a 3SAT comprising of all clauses in $p$ that only contain variables in ${x_1, dots, x_(n/2)}$
    + $S' <-$ a 3SAT comprising of all clauses in $p$ that only contain variables in ${x_(n/2+1), dots, x_n}$
    + $S'' <-$ a 3SAT comprising of all the clauses in $p$ that are not in $S$ or $S'$
    + $A <-$ 3SAT-Sparse($S''$, $c$)
    + *for* each assignment $a$ in $A$:
      + $S_a <-$ 3SAT-Expand($S$, $a$[1:c])
      + $S_a ' <-$ 3SAT-Expand($S'$, $a$[c+1:n])
      + $"sol"$ $<-$ 3SAT-Sparse($S_a$, $c$)
      + $"sol"'$ $<-$ 3SAT-Sparse($S_a '$, $c$)
      + *for* each assignment $a_1$ in $"sol"$:
        + *for* each assignment $a_2$ in $"sol"'$:
          + $V <- a_1 + a_2$
  + return $V$
]

WLOG, in every clause, let $i <= j <= k$, so $k - i <= c$.

We first note that the algorithm is correct.
- We will use induction to show that the only solutions returned are those that satisfy the original problem. In the brute force case, the algorithm generates all feasible assignments. In the inductive step, assume that the recursive calls generate feasible assignments. Since the clauses in $S_a$ and $S_a '$ do not share variables, they are independent and their solutions can be concatenated to generate valid solutions. We have thus ensured that all clauses in $S, S', S''$ are satisfied, which is equivalent to the original problem. 
- We will use induction to show that the solutions generated are all the solutions to the original problem. In the brute force case, this is trivial. In the inductive step, assume that recursive calls generate all feasible assignments. For every feasible assignment for the clauses in $S''$, all feasible assignments are generated for $S_a$ and $S_a '$ given that prior assignment, which, when combined, generate all feasible assignments for $S, S', S''$. We have thus ensured that we have all solution combinations to all clauses.

Lastly, we compute the runtime of the algorithm.
At each level, `3SAT-Sparse` and `3SAT-Expand` are called on two problems of size $n/2$ at most $2^c$ times. Note that the runtime of `3SAT-Expand` is $O(n)$. `3SAT-Sparse` is also called on $S''$ but that is an $O(1)$ operation since the length of $S''$ is at most $2c$.
Concatenating the solutions of $"sol"$ and $"sol"'$ takes $O(n)$ time per operation

Therefore, the work done at each level is $2^c O(n/2) + 2^c O(n/2) = O(n)$.
The recurrence relationship is
$
  T(n) &= 2^c T(n/2) + 2^c T(n/2) + O(n) \
  &= 2^(2c+1) T(n/2) + O(n)
$

We make the identification $a = 2^(2c+1), b = 2, d = 1$.
Therefore, we have $b^d = 2 < a$, so the master theorem gives runtime
$
  T(n) = O(n^(2c+1))
$

#align(right, $qed$)

=
_Proof:_
We adapt the `MERGESORT` algorithm to count the Kendall distance.

We first describe the algorithm in pseudocode:


#pseudocode-list(booktabs: true, title: smallcaps[Kendall])[
  - *input*: an array (arr) of size n representing a permutation
  - *output*: a sorted copy of arr, and the Kendall distance of arr
  + if $n = 1$:
    + return arr, $0$
  + else:
    + mid $<-floor n/2 floor.r$
    + arr1, $d_1$ $<-$ Kendall(arr[0:mid])
    + arr2, $d_2$ $<-$ Kendall(arr[mid+1:n])
    + arr3, $d_3$ $<-$ KMerge(arr1, arr2)
    + return arr3, $d_1 + d_2 + d_3$
]

There is a subroutine, `KMerge`, that merges two sorted arrays and counts the number of inversions in the process.

#pseudocode-list(booktabs: true, title: smallcaps[KMerge])[
  - *input*: two sorted arrays (arr1, arr2) of size m, n
  - *output*: a sorted array (arr3) of size m+n; the distance between arr1+arr2 and arr3
  + if $m = 0$:
    + return arr2, $0$
  + if $n = 0$:
    + return arr1, $0$
  + arr3 $<-$(new array of size m+n)
  + if arr1[0] < arr2[0]:
    + arr3[0] $<-$ arr1[0]
    + arr_rem, $d_r$ $<-$ KMerge(arr1[1:m], arr2)
    + arr3[1:m+n] $<-$ arr_rem
    + return arr3, $d_r$
  + else:
    + arr3[0] $<-$ arr2[0]
    + arr_rem, $d_r$ $<-$ KMerge(arr1, arr2[1:n])
    + arr3[1:m+n] $<-$ arr_rem
    + return arr3, $d_r + m$
]

Note that the array-sorting algorithm is an exact copy of the `MERGESORT` algorithm and thus functions correctly.
Moreover, since the only added segments to the algorithm are at least one integer addition per recursion layer, which is $O(1)$, the algorithm is still $O(n log(n))$.
We now proceed to demonstrate the correctness of the algorithm.

The Kendall distance is equivalently defined as the number of inversions in the array.
We will show that the `KENDALL` algorithm correctly counts the number of inversions in the array.
Note that all nonzero counts of inversions are counted in the `KMERGE` function, in the `else` clause where the first element of the second array is less than the first element of the first array.
This is because this is only time when the order of elements is not preserved.

To move `arr2[0]` to the front of the merged array, we must move all elements of `arr1` that are greater than `arr2[0]` to the right.
This is equivalent to swapping `arr2[0]` with all elements of `arr1` in reverse order, which precisely gives $m$ inversions.

Therefore, the algorithm correctly counts the number of inversions in the array.

#align(right, $qed$)

=



#pagebreak()
- Collaborators: Gio Huh
- Link to GitHub repository (tracks changes): https://github.com/gavin-hyl/cs38
- G-drive link for scratchpad: https://drive.google.com/file/d/1fl5h462QWzYFWYphbSEDJuUL8c2fY3bx/view?usp=sharing