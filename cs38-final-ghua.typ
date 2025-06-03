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
Consider the polynomial
$
  A(x) = (x + a[1]) (x + a[2]) dots.c (x + a[n]) dot 1 dots.c 1
$
with $N = 2^k$ terms, where $k$ is the smallest integer such that $N >= n$.
Note that since $A(x)$ is simply $B(x)$ multiplied by $1$, their coefficients are the same.
Let each term in this polynomial be represented as a vector of coefficients.
For example, the term $(x + a[1])$ is represented as the vector $(1, a[1])$, and the term $1$ is represented as the vector $(0, 1)$.
Our goal is now to multiply these coefficient representations to get the coefficients of $B(x)$.
We do this by invoking the FFT algorithm.
```
============
COEFFICIENTS
------------
// Input: T, a list of vectors representing the coefficients of the terms in A(x). Length of T is N, a power of 2. Each element of T is a vector of length 2.
// Output: C, the coefficients of the polynomial formed by multiplying the terms in T.

IF N == 1
  RETURN T[0] // Base case, return the only term

T1 = T[0:N/2] // First half of the terms
T2 = T[N/2+1:N] // Second half of the terms
C1 = COEFFICIENTS(T1) // Recursively compute coefficients for the first half
C2 = COEFFICIENTS(T2) // Recursively compute coefficients for the second half
C is the vector of coefficients of the polynomial formed by multiplying the polynomials represented by C1 and C2 using the FFT, as described in class.
RETURN C
============
```

== Correctness
$A(x) = B(x)$ trivially since $A(x) = B(x) dot 1$.
The vectors representing the coefficients of the terms in $A(x)$ are constructed correctly, since their construction follows the definition of polynomial coefficients.
We now proceed to show that the algorithm correctly computes the coefficients of $A(x)$ by induction on $k$, where $N = 2^k$.
- Base case: $k = 0, N = 1$.
  In this case, the algorithm simply returns the only term, which is correct.
- Inductive step: Assume the algorithm works for $k = m$, where $N = 2^m$.
  We now show that it works for $k = m + 1$, where $N = 2^(m+1)$.
  The algorithm splits the list of terms into two halves, each of size $N/2 = 2^m$.
  By the inductive hypothesis, the algorithm correctly computes the coefficients of the polynomials formed by the first and second halves of the terms, meaning $C_1, C_2$ are correct.
  As described in class, multiplying the coefficient representations of two polynomials using the FFT gives the correct coefficients of the resulting polynomial.
  Therefore, the vector $C$ is computed correctly.
Since we have shown that the algorithm works for both the base case and the inductive step, we conclude that it works for all $k$.
Since $N$, the number of terms in $A(x)$, is a power of $2$, the algorithm correctly computes the coefficients of $A(x)$, and therefore $B(x)$, for any $n$.

== Complexity
Since $2^k$ is unbounded, there must be some $k$ such that $2^k >= n$.
Moreover, the smallest such $k$ satisfies $2^k <= 2n$.
Assume, to the contrary, that $2^k > 2n$.
Then, we have $2^(k-1) > n$, so we can find a $k' = k-1 < k$ such that $2^k' >= n$, which contradicts the definition of $k$ as the smallest integer such that $2^k >= n$.
Therefore, the total number of terms in $A(x)$ is at most $2n$.
Creating the list of vectors representing the coefficients of the terms in $A(x)$ takes $O(n)$ time, since there are at most $2n$ terms and each term takes a constant time to construct.
We now consider the recurrence relation of the rest of the algorithm.
Let the time complexity of the algorithm be $T(n)$.
The algorithm splits the problem into two subproblems of size $n/2$, which takes $O(n)$ time each.
Moreover, the time complexity of multiplying two polynomials of degree $n/2$ using the FFT is $O(n/2 log(n/2)) = O(n log n)$, which dominates the time complexity of each layer.
Therefore, we have the recurrence relation:
$
  T(n) = 2 T(n/2) + n log n
$
We may evoke the result from PS1, Q1, part (b) to solve this recurrence relation.
$
  T(n) = O(n log^2 n)
$