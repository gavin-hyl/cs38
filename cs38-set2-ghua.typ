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
