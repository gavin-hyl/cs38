#let title = "CS 38 Set 0"
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
      #line(length: 100%)
    ],
)

#set par(justify: true)

= // 1
_Warmup:_
Please see below.

_Proof:_
By the fundamental theorem of arithmetic, every integer greater than $1$ can be uniquely expressed as a product of prime numbers.
Therefore, we may express $n in [1, 200]$ as $ n = 2^(r_2) dot 3^(r_3) dot dots.c = 2^r dot m $
where $m$ is an odd integer that contains all prime factors greater than $2$, and $r$ is the number of times $2$ divides $n$.
Since $n <= 200$, we have $m <= 200 / 2^r <= 200$.
Since $m$ is odd, it can at most take on $100$ values, which are $1, 3, 5, dots, 199$.
Since we are choosing $101$ different numbers, by the pigeonhole principle, at least two must have an odd part $m$ that is the same.
Therefore, we have $n_1 = 2^(r_1) dot m$ and $n_2 = 2^(r_2) dot m$ for some $r_1, r_2$.
WLOG, let $r_1 < r_2$ (equality is impossible since $n_1$ and $n_2$ are distinct), so $r_2 - r_1$ is a positive integer.
Then, $ n_2 / n_1 = 2^(r_2) / 2^(r_1) = 2^(r_2 - r_1) in NN_+ => n_1 | n_2 $
#align(right, $qed$)

= // 2
_Warmup:_
The longest path takes up a sufficient amount of vertices, such that another longest path must share at least one (intuitively).
#image("figures/set0/p2.jpg")


_Proof:_
Assume, to the contrary, that there exists two longest paths $P, Q$ of length $n$ in the graph $G$, and that they do not share any vertices.
Select $2$ vertices, $u in P, v in Q$ such that the shortest path $R$ between $u, v$ is the shortest among all possible choices of $u, v$.

We first prove that $R$ does not intersect $P$ or $Q$. Assume, to the contrary (WLOG), that $R$ intersects $P$ at vertex $x$.
Then, we can construct a new path $R'$ by replacing the segment of $P$ from $u$ to $x$ with the segment of $R$ from $x$ to $v$, which is shorter than $R$.
This contradicts the assumption that the selection $u, v$ gives the shortest $R$.
Therefore, $R$ does not intersect $P$ or $Q$.

Next, we construct a path longer than $P$ (and $Q$).
Consider the path $P' + R + Q'$, where 
- $P'$ is the segment of $P$ from one end of $P$ to $u$. Denote $P = P' + P''$, where $P''$ is the segment of $P$ from $u$ to the other end of $P$. Let $P'$ be the longer of the two segments. Therefore, since $|P| = |P'| + |P''|$, we have $|P'| >= ceil (|P|) / 2 ceil.r = ceil n/2 ceil.r$.
- $R$ is the shortest path from $u$ to $v$. It must have length $|R| >= 1$.
- $Q'$ is the segment of $Q$ from $v$ to one end of $Q$, defined in an analogous way to $P'$. $|Q'| >= ceil n/2 ceil.r$.

Therefore, $|P' + R + Q'| = ceil n/2 ceil.r + 1 + ceil n/2 ceil.r >= n+1 > |P| = |Q|$, which contradicts the assumption that $P, Q$ are longest paths in $G$.

Thus, we conclude that $P$ and $Q$ must share at least one vertex.
#align(right, $qed$)


= // 3
_Warmup:_
- Transitive means that if $a$ is related to $b$, and $b$ is related to $c$, then $a$ is related to $c$. Monotone increasing means that if $a > b$, then $f(a) > f(b)$. Functional composition means $(f compose g) (x) = f(g(x))$.
- $n! < n^n$

==
_Proof:_
Defining terms mathematically, we wish to prove the statement
$
  f in O(g) and g in O(h) <=> f in O(h)
$
This may be shown by simply expanding the definition of both sides.
$
  f in O(g) <=> exists c, n_0 in NN_+ "st" space forall n >= n_0, f(n) <= c g(n) \
  g in O(h) <=> exists d, m_0 in NN_+ "st" space forall m >= m_0, g(m) <= d h(m)
$
Let $k = max(n_0, m_0)$.
Then, we have $forall n >= k, f(n) <= c g(n) <= c d h(n)$, where $c d$ is a constant.
Therefore, we have $f in O(h)$.
#align(right, $qed$)


==
_Proof:_
By definition of monotonicity, if $a > b, a, b in ZZ_+$, then $f(a) > f(b), g(a) > g(b)$.
Since the ranges of $f$ and $g$ are both in $ZZ_+$, we have $f(n) > 0, g(m) > 0$ for all $n, m in ZZ_+$.
Therefore,
$
  f(a) + g(a) &> f(a) + g(a) + (g(b) - g(a)) \
  &= f(a) + g(b) \
  &> f(a) + (f(b) - f(a)) + g(b)\
  &= f(b) + g(b) \
$

Therefore, $f+g$ is monotone increasing.

Similarly, if $a > b, a, b in ZZ_+$, then $g(a) > g(b)$ and $g(a), g(b) in ZZ_+$ (in the domain of $f$), so we have $f(g(a)) > f(g(b))$ from the monotonicity of $f$.
Therefore, $f compose g$ is also monotonically increasing.
#align(right, $qed$)


==
_Proof:_
By definition, $T(n) in n^(O(1)) => exists N, c: T(n) <= n^(c dot 1), forall n > N => T(n) in O(n^c)$.
In the reverse direction, suppose $T(n) in O(n^k)$. By definition,
$
  exists N, c: T(n) <= c n^k = n^(log_n (c)) dot n^k = n^(ln(c)/ln(n) + k) space forall n >= N
$

Let $K = k+1$ and $N' = c$. Then, $forall n >= N', ln(c)/ln(n) <= ln(c)/ln(c) = 1$, so $ln(c)/ln(n) + k <= k+1 = K$.

Therefore, we have $exists K, N': T(n) <= n^K = n^(K dot 1)$ for all $n >= N'$, so $T(n) in n^(O(1))$.

#align(right, $qed$)


==
_Proof:_
We first show that $log(n!) in O(n log(n))$.
$
  n! = product_(i=1)^n i <= (product_(i=1)^n i) dot (product_(i=1)^n n/i) = product_(i=1)^n n = n^n \
$
Therefore, for all $n > 0$, we have $n! < n^n$.
Since $log$ is a monotone increasing function, we have $log(n!) < log(n^n) = n log(n)$.
Therefore, we have for $c=1, N=0$, $log(n!) <= c n log(n) space forall n > N$.
Therefore, $log(n!) in O(n log(n))$.

We then show that $log(n!) in Omega(n log(n))$. We achieve this by showing $n! >= n^(n/2)$.

We first prove a lemma: if positive integers $a, b$ satisfy $a+b = n + 1$, then $a b >= n$.
$
  a b - n= a (n + 1 - a) -n = n a + a - a^2 -n =n(a-1) - a(a-1) = (a-1)(n-a) >= 0 \
  a b >= n
$

Then, if $n$ is even,
$
  n! &= (product_(k=1)^(n/2) k) dot (product_(k=1)^(n/2) (n+1-k)) \
  &= (product_(k=1)^(n/2) k dot (n+1-k)) \
  &>= product_(k=1)^(n/2) n = n^(n/2) \
$

If $n$ is odd,
$
  n! &= (product_(k=1)^((n-1)/2) k) dot (product_(k=1)^((n-1)/2) (n+1-k)) dot ((n+1)/2) \
  &= (product_(k=1)^((n-1)/2) k dot (n+1-k)) dot ((n+1)/2) \
  &>= (product_(k=1)^((n-1)/2) n) dot ((n+1)/2) \
  &>= 1/2 (n^((n+1)/2) + n^((n-1)/2)) \
  &>= sqrt(n)/2 (n^(n/2)) \
$
The minimum $n$ such that $sqrt(n)/2 >= 1$ is $n=4$, so we have $n! >= n^(n/2)$ for all $n > 4 = N$. This is equivalent to $log(n!) >= 1/2 n log(n)$.

Therefore, we have $log(n!) in Omega(n log(n))$ for $c=1/2, N=4$.

Since we have proven both $log(n!) in O(n log(n))$ and $log(n!) in Omega(n log(n))$, we conclude that $log(n!) in Theta(n log(n))$.
#align(right, $qed$)


= // 4
_Warmup:_
- The two functions are shown below.
- We want to find the "smallest" $g$ such that all $f_i$ are in $O(g)$. Ignoring the constant in the $O$ notation for now, a "smallest" $g$ would be the maximum of all $f_i$ since going any smaller would not satisfy $f_i < g$.

==
_Proof:_
Define the set 
$
  S = ZZ_+ inter (union.big_(i=1 \ i "is odd") [a_i, 2 a_i)) \
$
where $a_i = 2^i$. Since $2a_i = 2^(i+1) < 2^(i+2) = a_(i+2)$, $S$ is a disjoint union of intervals.
Therefore, if $n in S$, it must be in exactly one of the intervals $[a_i, 2 a_i)$.

Since $4 a_i = a_(i+2)$, we must have 
$
  S' = ZZ_+\\S = ZZ_+ inter (union.big_(i=1 \ i "is odd") [2a_i, 4a_i)) \
$
Similarly, $S'$ is a disjoint union of intervals.
If $n in S'$, it must be in exactly one of the intervals $[2a_i, 4a_i)$.

Define the functions $f$ and $g$ as follows:
$
  f(n) = cases(
    3^(a_i) + (n - a_i) "if" n in [a_i, 2 a_i),
    3^n "if" n in.not S,
  ) \
  g(n) = cases(
    3^n "if" n in S,
    3^(2a_i) + (n - 2a_i) "if" n in [2a_i, 4a_i),
  )
$

*We first show that both $f$ and $g$ are monotone increasing.*
We will show that for any consecutive pair of integers $n, n+1$, $f(n) <= f(n+1)$ and $g(n) <= g(n+1)$.

- Let $n, n+1 in S$. 
Then,
$
  f(n+1) - f(n) &= 3^(a_i) + (n+1 - a_i) - (3^(a_i) + (n - a_i)) = 1 > 0 \
  g(n+1) - g(n) &= 3^(n+1) - 3^n = 3^n (e - 1) > 0 \
$
so both $f$ and $g$ are monotone increasing.

- Similarly, if $n, n+1 in S'$, the same argument applies.

- If $n in S$ and $n+1 in S'$, it must be that $n+1 = 2a_i$ for some $i$ (for all other $n$, we would have $n+1 in S$ since $S$ is a union of intervals).
$
  f(n+1) - f(n) &= 3^(2a_i) - 3^(a_i) - (2a_i - 1-a_i) \
  &= 3^(2a_i) - 3^(a_i) - a_i + 1 > 0 \
  &>= 2 dot 3^(a_i) - 3^(a_i) - a_i + 1 > 0 \
  &>= 3^(a_i) - a_i + 1 > 0 \
  &= (1 + a_i + a_i^2/2 + dots.c) - a_i + 1 \
  &= 2 + a_i^2/2 + dots.c > 0  "  since" a_i > 0\
$
$
  g(n+1) - g(n) &= 3^(2a_i) + 0 - 3^(2a_i - 1) > 0
$
so both $f$ and $g$ are monotone increasing.

- Lastly, if $n in S'$ and $n+1 in S$, it must be that $n+1 = 4a_i$ for some $i$.
$
  f(n+1) - f(n) = 3^(4a_i) - 3^(4a_i - 1) > 0
$
$
  g(n+1) - g(n) &= 3^(4a_i) - (3^(2a_i - 1) + (4a_i - 1 - 2a_i)) \
  &= 3^(4a_i) - 3^(2a_i - 1) - (2a_i - 1) \
$
The analysis proceeds similarly to the previous case, and $g(n+1) - g(n) > 0$.

Therefore, both $f$ and $g$ are monotone increasing.


*We then show that these two functions satisfy $f in.not O(g)$ and $g in.not O(f)$.*

Assume, to the contrary, that $f in O(g)$. 
Then, we have $f(n) <= c g(n)$ for some $c > 0, N>0$ and all $n > N$.
Let $n = 4 a_i - 1$ for some $i$.
Therefore,
$
  f(n) - c g(n) &= 3^(4 a_i - 1) - c (3^(2a_i) + (n - 2a_i)) \
  &= 3^(2a_i) (3^(2 a_i - 1) - c) - c(2a_i - 1)\
  &>= 3^(2a_i) (3^(2 a_i - 1) - c) - c 3^(2a_i) \
  &>= 3^(2a_i) (3^(2 a_i - 1) - 2c)\
$
Since $2c$ is a constant, we can choose $i$ such that $3^(2 a_i - 1) - 2c > 0$ (an explicit formula would be $i > log_2((ln(2c) + 1)/2)$), so $f(n) > c g(n)$, which contradicts the assumption that $f in O(g)$.

Assume, to the contrary, that $g in O(f)$. 
Then, we have $g(n) <= c f(n)$ for some $c > 0, N>0$ and all $n > N$.
Let $n = 2 a_i - 1$ for some $i$.
Therefore,
$
  g(n) - c f(n) &= 3^(2 a_i - 1) - c (3^(a_i) + (n - a_i)) \
  &= 3^(a_i) (3^(a_i - 1) - c) - c(a_i - 1)\
  &>= 3^(a_i) (3^(a_i - 1) - c) - c 3^(a_i) \
  &>= 3^(a_i) (3^(a_i - 1) - 2c)\
$
Since $2c$ is a constant, we can choose $i$ such that $3^(a_i - 1) - 2c > 0$, which contradicts the assumption that $g in O(f)$.
Therefore, we conclude that $f in.not O(g)$ and $g in.not O(f)$.
#align( right, $qed$)

==
_Proof:_
We shall prove the statement.

Let $g(n) = max{f_1(n), dots, f_k (n)} = f_(a_n) (n)$.
By definition, $g(n) >= f_i (n) space forall i in [1, k], n in ZZ_+$.
Therefore, $f_i in O(g) space forall i$.
Let $g'$ be a function such that $f_i in O(g') space forall i$.
Then, by definition, $exists c_i, N_i: f_i (n) <= g'(n) space forall n >= N_i, forall i$.
Let $N = max{N_1, dots, N_k}$, $c = max{c_1, dots, c_k}$.
Then, we have 
$ 
  g(n) = f_(a_n)(n) <= c_(a_n) g'(n) <= c g'(n) space forall n >= N
$
Therefore, $g(n) in O(g')$.
#align( right, $qed$)

#pagebreak()
- Collaborators: Gio Huh

- Link to GitHub repository (tracks changes): https://github.com/gavin-hyl/cs38

- G-drive link for scratchpad: https://drive.google.com/file/d/1fl5h462QWzYFWYphbSEDJuUL8c2fY3bx/view?usp=sharing