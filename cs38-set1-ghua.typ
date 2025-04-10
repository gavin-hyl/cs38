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
$
  T(n) &= f(n) + sum_(i=1)^k T(n/b_i) \
  &= f(n) dot sum b_i^(-w) + sum_(i=1)^k T(n/b_i) \
  &= sum_(i=1)^k f(n) b_i^(-w) + T(n/b_i) \
  &= sum_(i=1)^k b_i^(-w) (f(n) + b_i^w T(n/b_i))\
$
We make the identification $a = b_i^w, b = b_i, d = w$.
We then have $a = b^d$, which implies that
$
  T(n)&= sum_(i=1)^k b_i^(-w) O(n^w log(n)) \
  &= O(n^w log(n)) sum_(i=1)^k b_i^(-w) \
  &= O(n^w log(n)) \
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
  - *input*: a 3SAT problem $p$ with n variables [$x_i$], $1<=i<=n$
  - *output*: a 3SAT problem $p'$ that is equivalent to $p$ with no constraints on variables
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

We describe the `3SAT-SP` (sparse 3SAT) algorithm below, and prove its runtime complexity is indeed $O(n^(2c+1))$
#pseudocode-list(booktabs: true, title: smallcaps[3SAT-Sparse])[
  - *input*: a 3SAT problem $p$ with n variables [$x_i$], $1<=i<=n$, $c$ as defined in the problem statement
  - *output*: a list of all possible assignments of the variables [$x_i$], $1<=i<=n$
  + $A <-$ an empty valid assignment list
  + if $n <= 2c$:
    + $A <-$ a list of all feasible assignments of the variables [$x_i$], $1<=i<=n$
  + else:
    + $S <-$ a 3SAT comprising of all clauses in $p$ that only contain variables in ${x_1, dots, x_(n/2)}$
    + $S' <-$ a 3SAT comprising of all clauses in $p$ that only contain variables in ${x_(n/2+1), dots, x_n}$
    + *for* each possible assignment $a$ of the variables in ${x_(n/2-c), dots, x_(n/2+c)}$
      + $S_a <-$ 3SAT-Expand($S$, $a$)
      + $S_a ' <-$ 3SAT-Expand($S'$, $a$)
      + *if* both $S_a$ and $S_a '$ are satisfiable:
        + sol $<-$ 3SAT-Sparse($S_a$, $c$) $+$ 3SAT-Sparse($S_a '$, $c$) // gavin是大蠢猪！！！
        + append $A$ with sol
  + return $A$
]

WLOG, in every clause, let $i <= j <= k$.

We first note that the algorithm is correct.
- The only solutions returned are those that satisfy the original problem. 

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