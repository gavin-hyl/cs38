#import "@preview/lovelace:0.3.0": *


#let title = "CS 39 Set 4 Responses"
#let author = "Anonymous"
#let date = "2025-05"

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

== Algorithm

#pseudocode-list(booktabs: true, title: smallcaps[TreeExactCover])[
  - *Input* a tree $G = (V, E).
  $ 
]