# The Hash language
You already know about words and parentheses. The only remaining thing to learn about is the # symbol. Loosely, `#` means "make it higher" or "make it connect the others".

## Building relationships with #

### A simple (level-1) binary relationship
`bob #needs a library card` creates a binary `needs`-relationship between `bob` and `a library card`. `bob` and `a library card` could be called level-0 expressions. The `#` indicates that `needs` lies one level above them, forming a relationship that connects them.

### A simple (level-1) ternary relationship
`bob #needs money #when traveling` represents a ternary `needs-when`-relationship, between `bob`, `money` and `traveling`.

### A compound (level-2) relationship
In a compound relationship, at least one member is itself a relationship. An example is `bob #likes traveling ##during summer`. That creates a `when`-relationship between the level-1 relationship `bob likes traveling` and the level-0 expression `summer`.

### A compound unary relationship
A `relationship` does not have to have multiple members. `maybe` and `not` are two important unary relationships. `##maybe I #need help` creates a `maybe`-relationship with only one member, `I #need help`.

## Parentheses help too
Parentheses offer another way to delineate subexpressions. # can be applied to a parenthetical expression just like it was a single word -- as in, for instance, `gold #(produced by) a goose`.
