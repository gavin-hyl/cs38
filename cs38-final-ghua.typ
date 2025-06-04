#let title = "CS 38 Final Exam Responses"
#let author = "Anonymous"
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
By the weak duality theorem, we know that the value of the objective function at any feasible solution to the dual linear program is an upper bound on the value of the objective function at any feasible solution to the primal linear program.
Since we have found a feasible solution to the dual linear program with objective value $8/3$, we know that the value of the objective function at any feasible solution to the primal linear program is at most $8/3$.

Since the given solution to the primal LP has the objective value $8/3$, it is optimal.
#align(right, $qed$)


#pagebreak()
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
Since a polynomial of degree $n$ is uniquely determined by its roots and its value at one point, we conclude that $B(x)$ is uniquely determined by the two conditions.
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
  RETURN T[1] // Base case, return the only term

T1 = T[1:N/2] // First half of the terms, inclusive on both ends
T2 = T[N/2+1:N] // Second half of the terms, inclusive on both ends
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
Let the time complexity of the algorithm be $T(N)$, where $N$ is the number of terms in $A(x)$, a power of $2$.
The algorithm splits the problem into two subproblems of size $N/2$, which takes $O(N)$ time.
Moreover, the time complexity of multiplying two polynomials of degree $N/2$ using the FFT is $O(N/2 log(N/2))$, which dominates the time complexity of each layer.
Therefore, we have the recurrence relation:
$
  T(N) = 2 T(N/2) + O(N/2 log N/2)
$
#table(
  columns: (auto, auto, auto, auto),
  inset: 10pt,
  align: center,
  table.header(
    [*Layer*], [*\# of Problems*], [*Problem Length*], [*Work Done*],
  ),
  $ 0 $, $ 1 $, $ N $, $ O(N/2 log(N/2)) $,
  $ 1 $, $ 2 $, $ N/2 $, $ 2 dot O(N/4 log(N/4))  $,
  $ dots.v $, $ dots.v $, $ dots.v $, $ dots.v $,
  $ L $, $ 2^L $, $ N/(2^L) $, $ 2^L dot O(N/2^(L+1) log(N/(2^(L+1)))) $,
  $ dots.v $, $ dots.v $, $ dots.v $, $ dots.v $,
  $ log_2(N) - 1 $, $ N/2 $, $ 2 $, $ O(N/2) $
)
Therefore, the total work done is:
$
  T(N) &= O(N/2 log(N/2)) + O(N/2 log(N/4)) + dots.c + O(N/2) \
  &= sum_(i=1)^(log_2(N)-1) O(N/2 log(N/2^i)) + O(N/2)\
  &= O(N/2) sum_(i=1)^(log_2(N)-1) log(N/2^i) + O(N)\
  &= O(N) (sum_(i=1)^(log_2(N)-1) (log N - i log 2)+ 1) \
  &= O(N) (log N dot (log_2(N) - 1) - log(2) ((log_2 N) (log_2 N - 1))/2 + 1) \
  &= O(N log^2 N) \
  &= O(n log^2 n)
$
The last step follows from the fact that $N <= 2n$.

Therefore, the overall time complexity of the algorithm is 
$
  O(n log^2 n) + O(n) = O(n log^2 n)
$


#pagebreak()
= // 3
== Algorithm
We employ a greedy algorithm to solve the problem.
We note that since each train costs a constant amount of money, minimizing cost is equivalent to minimizing the number of trains taken.
Essentially, at every city, we want to take the train that takes us to the furthest city possible.
```
=====
ROUTE
-----
// Input: n, the number of cities; (c_t, d_t) for 1 <= t <= m, describing trains.
// Output: T, a sequence of trains represented by a list of integers, where T[i] is the i'th train taken.

trains = [(t, c_t, d_t) for t in 1:m]
sort trains by c_t, break ties randomly  // sort by starting city
t = 1         // index into the *SORTED* list of trains
current = 1   // we start at city 1
T = []        // list of trains taken

WHILE current < n       // greedy scan
  best_t = None // index of the best train to take
  best_d = current // the furthest city we can reach with the best train

  // iterate through all trains we can board
  WHILE (t <= m) AND (trains[t].c <= current)
    IF (trains[t].d > best_d)
      best_t = t            // we should board this train
      best_d = trains[t].d  // update the furthest city we can reach
    t = t + 1
  
  IF best_t is None // no train can take us to the next city
    RETURN None // we cannot reach city n, return None

  // take the best train (best_t is not the index of the original train
  // but the index in the sorted list)
  T.append(trains[best_t].t)
  current = best_d // update the current city to the furthest city we can reach
RETURN T
=====
```

== Correctness
We first show that the algorithm correctly returns None iff no sequence of trains can take us to city $n$.

- Backwards direction:
  Let the first city that is covered by no trains be $c$, i.e., $c$ is the first city such that there is no train that can take the passenger from city $c$ to city $d$ which $d>c$.
  This is the city that made the algorithm return None.
  Assume, to the contrary, that there exists a sequence of trains that can take us to city $n$.
  Since trains stop at every city, the passenger must pass through city $c$ and reach city $c+1$ on some train.
  However, since the algorithm returns None, it must be the case that there is no train that can take the passenger from city $c$ to city $c + 1$, which contradicts the assumption that there exists a sequence of trains that can take us to city $n$.

- Forward direction:
  We show the contrapositive: if there is a sequence of trains that can take us to city $n$, then the algorithm does not return None.
  Let $T = (t_1, t_2, dots, t_k)$ be a sequence of trains that can take us to city $n$.
  By the previous argument, for every city, there must be a train that can take the passenger from that city to the next city.
  Assume, to the contrary, that the algorithm returns None.
  Then, there must be a city $c$ such that there is no train that can take the passenger from city $c$ to city $c + 1$.
  However, this contradicts the assumption that there exists a sequence of trains that can take us to city $n$, since the passenger must pass through city $c$ on some train.

Therefore, the algorithm correctly returns None iff no sequence of trains can take us to city $n$.

We also show that the inner `WHILE` loop correctly finds the train that takes the passenger to the furthest city possible.
We use induction on the number of executions of the outer `WHILE` loop.
- Base case: the outer loop has not been executed once yet.
  In this case, the inner loop iterates through all trains that can be boarded from city 1, and finds the train that takes the passenger to the furthest city possible.
- Inductive step: assume the inner loop correctly finds the train that takes the passenger to the furthest city possible after $k$ executions of the outer loop.
  We now show that it correctly finds the train that takes the passenger to the furthest city possible after $k + 1$ executions of the outer loop.
  Let the initial value of `t` be $t_0$.
  By the inductive hypothesis, every train before $t_0$ has been checked (if not, there is no guarantee for any destination being the furthest), and the train that takes the passenger to the furthest city possible has been found.
  Therefore, every train before $t_0$ cannot be boarded from the current city (as the current city is greater than or equal to the destinations of the trains before $t_0$).
  Therefore, they can be safely ignored.
  The inner loop iterates through all trains starting from $t_0$ that can be boarded from the current city, and finds the train that takes the passenger to the furthest city possible, which is set to the next value of `current`.

We now show that the sequence of trains returned by the algorithm is optimal.


Since this is a greedy algorithm, we use an exchange argument to show that it is correct.
The greedy algorithm entails two conditions.
+ At every city, we take the train that takes us to the furthest city possible (overtly returned in the list of trains).
+ The destination of the train we take is the furthest city we can reach with that train (implicit in the algorithm).
Let $T = (t_1, t_2, dots.c, t_k)$ be the sequence of trains.
Suppose we have a sequence of trains $T$ that is optimal, we will show that it can be iteratively transformed into the sequence of trains returned by the algorithm.
Moreover, denote the optimal destination of train $t_i$ as $d_i^* in [c_i, d_i]$.
Since this need not be specified by the optimal solution, we may choose an arbitrary destination for each train $t_i$ such that the destination is within the range of the train.
Each $d_i^*$ must also be the start of the next train in the sequence (if $d_i^* != n$).
We will show an arbitrary assignment of $d_i^*$ on the optimal sequence $T$ can be transformed into the sequence of trains returned by the algorithm without changing the cost.

Suppose that $t_i in T$ is the first train in the sequence that does not satisfy the greedy condition.
That is, either $d_i^* < d_i$ (we do not take the train to its ending city), or exists a train $t_j$ such that $c_j <= d_(i-1)^* <= d_j$ (we can board $t_j$) and $d_j > d_i^*$ (it takes us further than $t_i$).
We consider the two cases separately.

=== $d_i^* < d_i$
Consider the next train $t_(i+1)$ in the sequence, with $d_(i+1)^* > d_i^*$.
If $d_(i+1)^* > d_i$, then we can take train $t_i$ to its ending city, and then take train $t_(i+1)$ to $d_(i+1)^*$.
This is possible since $c_(i+1) <= d_i^* < d_i < d_(i+1)^* <= d_(i+1)$ (the first inequality is true since we can board train $t_(i+1)$ at city $d_i^*$).
This makes the sequence conform to the greedy condition.
Otherwise, if $d_(i+1)^* <= d_i$, then we can take train $t_i$ to $d_(i+1)^*$ directly, thus skipping train $t_(i+1)$, which contradicts the assumption that $T$ is optimal, since we have created a shorter sequence.

Therefore, the only possible case is $d_(i+1)^* > d_i$, and we can take train $t_i$ to its ending city without changing the cost, which satisfies the greedy condition.

=== There exists a train $t_j$ such that $c_j <= d_(i-1)^* <= d_j$ and $d_j > d_i^*$
In this case, we can take train $t_j$ instead of train $t_i$, and set $d_j^* = d_i^*$.
This does not change the cost of the sequence since the number of trains taken is the same.
This is possible because $d_i^* = d_j^* < d_j$.
We may then invoke the previous case to show that we can take train $t_j$ to its ending city given that $T$ is optimal.

Therefore, by iterating through the trains from start to finish, we can transform the optimal sequence of trains $T$ into the sequence returned by the algorithm without changing the cost.
Therefore, the sequence of trains returned by the algorithm is optimal.


== Complexity
The algorithm first sorts the list of trains by their starting city, which takes $O(m log m)$ time.
The outer `WHILE` loop iterates at most $m$ times, since there are at most $m$ trains, and each time the outer loop is executed, one train is boarded ($t$ incremented at least once).
Otherwise, the algorithm returns None, which is of lower complexity.
Therefore, the outer `WHILE` loop's instructions (excluding the inner loop) run at most $m$ times, which is $O(m)$.
The operations in the inner `WHILE` loop are also constant time operations, and they are run at most $m$ times, which is $O(m)$.
Therefore, the overall time complexity of the algorithm is 
$
  O(m log m + m + m) = O(m log m)
$



#pagebreak()
= // 4
== Algorithm
We use dynamic programming to solve the problem.
The subproblems are defined as $V[i, j]$, the maximum number of pairings that can be formed with the substring $b[i..j]$.
```
========
PAIRINGS
--------
// Input: b[1..n], a string of length n where b[i] is in {A, B, C, D}
// Output: P, a list of pairs of indices representing the maximum cardinality pairings.

V = n by n matrix of 0s representing the values of subproblems
// choices (whether or not to pair the first character, if so, which one) for each subproblems
CHOICES = n by n matrix of None 

FOR length=2:n            // fill in the subproblems in order of increasing length
  FOR i=1:n-length+1      // i is the starting index of the substring (inclusive)
    j = i + length-1      // j is the ending index of the substring (inclusive)
    V[i, j] = V[i+1, j]   // case 1: do not pair the first character
    CHOICES[i, j] = None  // do not pair

    FOR k=i+1:j           // iterate through all characters to find the best pairing
      IF (b[i], b[k]) is a valid pair
        // two subproblems, +1 for the new pair, out of bounds indices give V=0
        value = V[i+1, k-1] + 1 + V[k+1, j] 
        IF value > V[i, j]
          V[i, j] = value   // update the value of the subproblem
          CHOICES[i, j] = k // store the choice of pairing

P = [] // list of pairs to be returned
BACKTRACK(CHOICES, 1, n) // backtrack to find the pairs and add them to P
RETURN P
========


=========
BACKTRACK
---------
// Input: CHOICES, a matrix of choices for each subproblem, and (i, j), the subproblem to backtrack
// Output: added pairs to P, a global variable of list of pairs
IF i < 1 OR j > n OR i >= j
  RETURN      // out of bounds, do nothing
IF CHOICES[i, j] is None
  BACKTRACK(CHOICES, i+1, j) // do not pair the first character
  RETURN
k = CHOICES[i, j] // the index of the character paired with b[i]
append (i, k) to P // add the pair to the list
BACKTRACK(CHOICES, i+1, k-1) // backtrack the first subproblem
BACKTRACK(CHOICES, k+1, j) // backtrack the second subproblem
=========
```

== Correctness
We first show the dynamic programming algorithm is correct by consider the subproblems, ordering, and initialization.
- Subproblems: the subproblems are defined as $V[i, j]$, the maximum number of pairings that can be formed with the substring $b[i..j]$.
  At each subproblem, we can either choose to pair the first character with another character, or not pair.
  If we choose not to pair the first character, then the maximum number of pairings that can be formed with the substring $b[i..j]$ is the same as the maximum number of pairings that can be formed with the substring $b[i+1..j]$, which is stored in $V[i+1, j]$, which is correct.
  If we choose to pair the character, then it must be paired with some character $b[k]$ where $i < k <= j$.
  We claim then the value (not necessarily optimal for arbitrary $k$) of the subproblem is given by
  $
    V[i+1, k-1] + 1 + V[k+1, j]
  $
  (out-of-bounds indices are treated as value $0$).
  Note that $[i+1, k-1]$ and $[k+1, j]$ are disjoint, since $i < k <= j$.
  After a pair is found, the subproblem no longer contains either character used in the pairing, satisfying the first condition in the problem.
  The `IF` statement ensures that the second condition is satisfied, since it only considers valid pairs.
  We then show the subproblem structure ensures the third condition by showing the two solution sets are equal.
  If a pairing $(a, b)$ is found in either of the two subproblems, it must be that the pairing is in $(i+1, k-1)$, which satisfies $i < a < b < k$, or in $(k+1, j)$, which satisfies $[a, b]$ and $[i, k]$ being disjoint.
  Moreover, assume, to the contrary, that there exists a pairing $(a, b)$ such that $a < k < b$, which our algorithm will miss.
  However, this leads to a contradiction, since $[a, b] inter [i, k] != emptyset$ nor is one contained in the other, which violates the third condition.
  Therefore, all possible pairings are considered, and the subproblem structure is correct.
  This gives the recurrence relation:
  $
    V[i, j] = max(V[i+1, j], max_(i < k <= j) (V[i+1, k-1] + 1 + V[k+1, j]))
  $
- Ordering: we note that $V[i, j]$ only depends on $V[i+1, j]$, $V[i+1, k-1]$, and $V[k+1, j]$ for some $k$ such that $i < k <= j$.
  All of the subproblems are shorter in length. 
  Therefore, we can compute the values of the subproblems in order of increasing length of the substring $b[i..j]$, which is what the algorithm does.
  This ensures that whenever a problem is computed, all problems of smaller length have already been computed, adn therefore the values of the subproblems are correct.
- Initialization: we initialize the matrix $V$ to all $0$s.
  Note that this is only for notational convenience, since the algorithm will only depend on $V[i, i]$ (length-$1$) substrings as it computes everything length-$2$ and above.
  The length-$1$ substrings cannot have any pairings, so the initialization is correct.
  The matrix `CHOICES` is initialized to all `None`, which is correct since we have not made any choices yet.

We then show that the given a correct matrix of choices, the backtracking algorithm correctly returns the pairs.
We use induction on the length of the substring $b[i..j]$.
- Base case: the length of the substring $<= 1$.
  In this case, there are no characters to pair, so the algorithm returns an empty list, which is correct.
- Inductive step: assume the algorithm works for substrings of length $<= k$.
  We now show that it works for substrings of length $k + 1$.
  The algorithm first checks if the first character is paired with any other character.
  If it is not, then the algorithm simply backtracks the substring $b[i+1..j]$, which is correct by the inductive hypothesis.
  Otherwise, the algorithm finds the index of the character paired with the first character, and adds the pair to the list.
  It then backtracks the two substrings $b[i+1..k-1]$ and $b[k+1..j]$, which are both of length $<= k$, and therefore correct by the inductive hypothesis.
  Therefore, the algorithm correctly returns the pairs for any substring $b[i..j]$.

== Complexity
The algorithm first initializes the matrix $V$ and `CHOICES`, which takes $O(n^2)$ time.
The outer loop iterates for $O(n)$ times, the inner $i$ loop iterates for $O(n)$ times, which corresponds to the fact that there are $O(n^2)$ subproblems.
For each subproblem, the inner $k$ loop iterates for $O(n)$ times, since it iterates through all characters in the substring $b[i..j]$.
Therefore, the total time complexity to fill in the $V$ and `CHOICES` matrices is $O(n^3)$.
The backtracking algorithm runs in $O(n^2)$ time, since there are at most $O(n^2)$ subproblems to visit.
Therefore, the overall time complexity of the algorithm is
$
  O(n^2 + n^3 + n^2) = O(n^3)
$