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
  &= sum_(i=1)^k O(n^w) + T(n/b_i) \
  &= sum_(i=1)^k O(n^w log(n)) "(Apply Master Theorem)"\
  &= k dot O(n^w log(n)) \
  &= O(n^w log(n)) \
$

==



#pagebreak()
- Collaborators: Gio Huh
- Link to GitHub repository (tracks changes): https://github.com/gavin-hyl/cs38
- G-drive link for scratchpad: https://drive.google.com/file/d/1fl5h462QWzYFWYphbSEDJuUL8c2fY3bx/view?usp=sharing