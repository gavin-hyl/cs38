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


=
== Algorithm
We employ a greedy algorithm to solve the problem.
We note that since each train costs a constant amount of money, minimizing cost is equivalent to minimizing the number of trains taken.
```
=====
ROUTE
-----
// Input: n, the number of cities; (c_t, d_t) for 1 <= t <= m, describing trains.
// Output: trains, a sequence of trains represented by a list of integers, where trains[i] is the i'th train taken.

current = 1   // we start at city 1
trains = []   // list of trains taken
WHILE current < n       // greedy scan
  best = -1             // best train to take
  best_destination = -1 // furthest city we can reach with the best train
  FOR t = 1:m           // iterate through all trains to find the best one
    IF (c_t <= current <= d_t) AND (d_t > best_destination) // train is better
      best = t                // update best train
      best_destination = d_t  // update best city we can reach with the best train
  IF best == -1         // no train can be taken, return None
    RETURN None 
  append best to trains // take the best train
  current = best_destination // update current city
RETURN trains
```

== Correctness
We first show that the algorithm correctly returns None iff no sequence of trains can take us to city $n$.

- Backwards direction:
  Let the first city that is covered by no trains be $c$.
  This is the city that made the algorithm return None.
  Assume, to the contrary, that there exists a sequence of trains that can take us to city $n$.
  Since the passenger must progress one city at a time, they must pass through city $c$ on some train.
  However, since the algorithm returns None, it must be the case that there is no train that can take the passenger from city $c$ to city $c + 1$, which contradicts the assumption that there exists a sequence of trains that can take us to city $n$.

- Forward direction:
  We show the contrapositive: if there is a sequence of trains that can take us to city $n$, then the algorithm does not return None.
  Let $T = (t_1, t_2, dots, t_k)$ be a sequence of trains that can take us to city $n$.
  By the previous argument, for every city, there must be a train that can take the passenger from that city to the next city.
  Assume, to the contrary, that the algorithm returns None.
  Then, there must be a city $c$ such that there is no train that can take the passenger from city $c$ to city $c + 1$.
  However, this contradicts the assumption that there exists a sequence of trains that can take us to city $n$, since the passenger must pass through city $c$ on some train.

Therefore, the algorithm correctly returns None iff no sequence of trains can take us to city $n$.
We now turn our attention to the optimality of the sequence.

Since this is a greedy algorithm, we use an exchange argument to show that it is correct.
Suppose we have a sequence of trains $T$ that is optimal, we will show that it can be iteratively transformed into the sequence of trains returned by the algorithm.
Let $T = (t_1, t_2, dots.c, t_k)$ be the sequence of trains.
Moreover, denote the optimal destination of train $t_i$ as $d_i^* in [c_i, d_i]$.
Each $d_i^*$ must also be the start of the next train in the sequence (if $d_i^* != n$).

Suppose that $t_i^* in T$ is the first train in the sequence that does not satisfy the greedy condition.
That is, either $d_i^* < d_i$ (we do not take the train to its ending city), or exists a train $t_j$ such that $c_j <= d_(i-1)^* <= d_j$ and $d_j > d_i^*$ (there exists a train that can take us further than $t_i^*$).
We consider the two cases separately.

=== $d_i^* < d_i$.



By definition, 

We will show that we can replace $t_i^*$ with $t_i$ and still reach the same destination.



Since trains must increment the passenger's city number, when we consider a pair of consecutive trains $t_i, t_(i+1)$, it must be the case that $c_i < d_i^* < d_(i+1)^*$.
There are now two cases:
- $d_(i+1)^* <= d_i$: in this case, since $d_(i+1)^* > c_i$ we have $d_(i+1)^* in [c_1, d_i]$, we can replace $t_(i+1)$ with $t_i$ and still reach the same destination, since $d_(i+1)^*$ is reachable by train $t_i$.
  Everything else can remain unchanged.
  Therefore, we can remove $t_(i+1)$ from the sequence and create a shorter one, which contradicts the assumption that $T$ is optimal.
- $d_(i+1)^* > d_i$. There are two subcases.
  - $d_i^* = d_i$: in this case, train $t_i$ satisfies the greedy condition, since we have taken it to its ending city.
  - $d_i^* < d_i$: in this case, we have $d_i^* < d_i < d_(i+1)^*$.
    Since we are able to board train $t_(i+1)$, it must be that $c_(i+1) <= d_i^*$.
    Therefore, $d_i in [c_(i+1), d_(i+1)]$.
    Therefore, an equivalent feasible sequence is taking train $t_i$ to its ending city, and then taking train $t_(i+1)$.
    This coincides with the gree