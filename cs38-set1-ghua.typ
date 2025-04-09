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
  $0$, $1$, $n$, $ n log(n) $,
  $1$, $2$, $n/2$, $ 2(n/2) log(n/2) = n log(n/2) $,
  $ dots.v $, $ dots.v $, $ dots.v $, $ dots.v $,
  $L$, $2^L$, $ n/(2^L) $, $ n log(n/(2^L)) $,
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


#pagebreak()
- Collaborators: Gio Huh
- Link to GitHub repository (tracks changes): https://github.com/gavin-hyl/cs38
- G-drive link for scratchpad: https://drive.google.com/file/d/1fl5h462QWzYFWYphbSEDJuUL8c2fY3bx/view?usp=sharing