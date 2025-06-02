#let title = "CS 38 Final Exam Responses"
#let author = "Gavin Yuliu Hua"
#let date = "2025-06"

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
We first show that the given solution is feasible for the linear program.
We may check the constraints one by one.
+ $x_1 - 2 x_2 = 8/3 - 2 dot 1/3 = 2 <= 2$, satisfied.
+ $3 x_2 - 2 x_3 = 3 dot 1/3 - 2 dot 0 = 1 <= 1 $, satisfied.
+ $x_1, x_2, x_3 >= 0$ by definition.

We then compute the value of the objective function at this solution:
$
  x_1 - 3 x_3 = 8/3 - 3 dot 0 = 8/3
$

In order to show that a feasible solution to the linear program is the optimal, we invoke the weak duality theorem.
Let $x = (x_1, x_2, x_3)^top$, and the linear program is given by:
$
  & max (1, 0, -3) x \
  & mat(1, -2, 0; 0, 3, -2) x <= vec(2, 1) \
  & x >= 0
$
Let
$
  c^top = (1, 0, -3), A = mat(1, -2, 0; 0, 3, -2), b = vec(2, 1)
$
The dual linear program is given by:
$
  & min y^top vec(2, 1) \
  & mat(1, 0; -2, 3; 0, -2) y >= vec(1, 0, -3) \
  & y >= 0
$
Let $y = (y_1, y_2)$.
We show that $y = vec(1, 2/3)$ is a feasible solution to the dual linear program.
+ $y_1 + 0 y_2 = 1 >= 1$, satisfied.
+ $-2 y_1 + 3 y_2 = -2 dot 1 + 3 dot 2/3 = -2 + 2 = 0 >= 0$, satisfied.
+ $0 y_1 - 2 y_2 = 0 - 2 dot 2/3 = -4/3 >= -3$, satisfied.
+ $y_1, y_2 >= 0$ by definition.
We now compute the value of the objective function at $y$:
$
  y^top vec(2, 1) = 1 dot 2 + 2/3 dot 1 = 2 + 2/3 = 8/3
$
By the weak duality theorem, we know that the value of the objective function at any feasible solution to the dual linear program is an upper bound on the value of the objective function at any feasible solution to the primal linear program. // FIXME
Since we have found a feasible solution to the dual linear program with objective value $8/3$, we know that the value of the objective function at any feasible solution to the primal linear program is at most $8/3$.

Since the original solution has the objective value $8/3$, it is optimal.
#align(right, $qed$)

=
We first describe the form of $B(x)$.
We claim it has the form
$
  B(x) = (x + a[1]) (x + a[2]) dots.c (x + a[n])
$
We check the two conditions.
$
  B(-a[i]) &= (-a[i] + a[1]) (-a[i] + a[2]) dots.c (-a[i] + a[i]) dots.c (-a[i] + a[n]) = 0 space forall i\
  B(0) &= (0 + a[1]) (0 + a[2]) dots.c (0 + a[n]) = a[1] a[2] dots.c a[n] = product_(i=1)^n a[i]
$
Therefore, to extract the coefficients of $B(x)$, we simply need to expand the product.

== Algorithm

== Correctness

== Complexity