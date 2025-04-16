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

*Correctness*

_Proof:_
We will demonstrate correctness by strong induction on the size of the array $a$.
For the base case, $|a| = 1$, the array is trivially sorted.
For the inductive step, assume the algorithm is correct for all arrays of size $<=k$.
Let $|a| = k+1$.
All of $L, E, G$ must have size $<=k$.
Therefore, by the inductive hypothesis, `QuickSort`($L$) and `QuickSort`($G$) are correct.
Since all elements in $L$ are less than $p$, and all elements in $G$ are greater than $p$, the concatenation of `QuickSort`($L$), $E$, and `QuickSort`($G$) is sorted.
#align(right, $qed$)


*Runtime*

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
At each level, the work done is at most a single pass through the array $a$, which gives $|a|$ comparisons and $|a|$ list append operations.
This is $O(n)$.
Each level divides the (sub)array into three parts, $L, E, G$.
Define a "good" pivot as one that $max(|L|, |G|) <= (3|a|)/4$.
This means that the pivot must lie between the first quantile and third quantile of the array.
This occurs with probability $1/2$.
By the lemma shown in lecture, the expected number of pivots needed such that 