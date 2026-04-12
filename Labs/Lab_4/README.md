# Lab 4 — RDF & SPARQL

This directory contains the deliverables for Laboratory 4. The lab introduces RDF as a data model and SPARQL as its query language, using a Star Trek statement as the running example.

## Exercise layout

- `resources/startrek.rdf`: exercise (a) — the Star Trek statement encoded as RDF/XML, using `rdf:Bag` to group the actors.
- `query.sparql`: exercise (c) — a SPARQL query that answers "what roles were interpreted by the actors from Star Trek: The Next Generation?"

Exercise (b) asks for the RDF graph corresponding to the RDF/XML. That graph is described in full in the [Exercise (b)](#exercise-b--rdf-graph) section below and can be visualised at http://www.w3.org/RDF/Validator/.

---

## Tools used in this lab

### Apache Jena (`arq`, `riot`)
A Java framework and command-line toolkit for working with RDF and SPARQL locally.
- `arq` — the SPARQL query engine. Takes an RDF file and a `.sparql` file, evaluates the query, and prints the result table. This is what replaces running queries in an online playground.
- `riot` — RDF I/O technology. Parses RDF files and validates them for syntax errors. Can also convert between RDF formats (RDF/XML → Turtle → N-Triples etc.). Think of it as `xmllint` but for RDF.

Neither tool produces visual output — they are purely text/data processors.

### Protégé
A desktop ontology editor from Stanford. Its main use is building and browsing OWL ontologies (Lab 5 onwards). It can open RDF files and lets you inspect resources and properties through its Individuals and Properties tabs, but its graph view (OntoGraf) works on OWL class hierarchies — not on raw RDF instance data like `startrek.rdf`. Useful here only as a file browser/inspector, not as a graph visualiser.

### W3C RDF Validator (online)
Pastes your RDF/XML, validates it for correctness, and renders a visual graph of the triples. The graph output matches exactly what the RDF data model describes — ellipses for URI resources, rectangles for literals, labelled directed arrows for predicates. Use this for exercise (b). URL: http://www.w3.org/RDF/Validator/

### SPARQL Playground (online)
A browser tool where you paste RDF/XML on the left and a SPARQL query on the right, then click Query to see results. Useful for quickly testing queries without a local Jena installation. URL: https://atomgraph.github.io/SPARQL-Playground/

---

## RDF concepts — how this connects to XML

You already know XML as a tree of nested elements. RDF is a different data model: it represents knowledge as a **graph of facts**, where each fact is a **triple**:

```
subject  —predicate→  object
```

Think of a triple as one sentence in a formal language:
- "STTNG has title 'Star Trek: The Next Generation'"
- "Patrick Stewart played the role CaptPicard"

A collection of triples forms a directed graph — nodes are subjects/objects, edges are predicates.

### RDF/XML is not normal XML

RDF/XML uses XML syntax to **serialize** an RDF graph, not to model a tree. The same graph could equally be written in Turtle (`.ttl`) or N-Triples (`.nt`) format. The XML tags and nesting are just a carrier — the actual meaning lives in the triples they encode.

### XPath/XQuery vs SPARQL

| Tool | Works on | How it navigates |
|------|----------|-----------------|
| XPath | XML tree | path expressions (`/root/child/@attr`) |
| XQuery | XML tree | FLWOR expressions (`for`/`let`/`where`/`return`) |
| SPARQL | RDF graph | triple patterns (`?subject predicate ?object`) |

XPath asks: "go to this location in the tree." SPARQL asks: "find all combinations of values that satisfy these triple patterns."

---

## Exercise (a) — RDF/XML

**Full file** (`startrek.rdf`):

```xml
<?xml version="1.0"?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:ex="http://example.org/startrek/">

  <!-- The TV series -->
  <rdf:Description rdf:about="http://example.org/startrek/STTNG">
    <ex:title>Star Trek: The Next Generation</ex:title>
    <ex:genre>SF TV series</ex:genre>
    <ex:hasActors>
      <rdf:Bag>
        <rdf:li rdf:resource="http://example.org/startrek/PatrickStewart"/>
        <rdf:li rdf:resource="http://example.org/startrek/JonathanFrakes"/>
        <rdf:li rdf:resource="http://example.org/startrek/LeVarBurton"/>
      </rdf:Bag>
    </ex:hasActors>
  </rdf:Description>

  <!-- Actors -->
  <rdf:Description rdf:about="http://example.org/startrek/PatrickStewart">
    <ex:name>Patrick Stewart</ex:name>
    <ex:playedRole rdf:resource="http://example.org/startrek/CaptPicard"/>
  </rdf:Description>

  <rdf:Description rdf:about="http://example.org/startrek/JonathanFrakes">
    <ex:name>Jonathan Frakes</ex:name>
  </rdf:Description>

  <rdf:Description rdf:about="http://example.org/startrek/LeVarBurton">
    <ex:name>LeVar Burton</ex:name>
  </rdf:Description>

  <!-- Role -->
  <rdf:Description rdf:about="http://example.org/startrek/CaptPicard">
    <ex:roleName>Capt. Jean-Luc Picard</ex:roleName>
  </rdf:Description>

</rdf:RDF>
```

---

### RDF/XML breakdown

#### XML declaration

```xml
<?xml version="1.0"?>
```

Standard XML header. RDF/XML is still well-formed XML, so parsers validate the XML layer first before interpreting the RDF triples.

---

#### `rdf:RDF` root element and namespace declarations

```xml
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:ex="http://example.org/startrek/">
```

`<rdf:RDF>` is the mandatory root element for any RDF/XML document. The two `xmlns` attributes bind namespace prefixes:

- `xmlns:rdf="..."` — binds the prefix `rdf:` to the official RDF namespace URI. Every built-in RDF construct (`rdf:Description`, `rdf:Bag`, `rdf:li`, etc.) belongs to this namespace.
- `xmlns:ex="http://example.org/startrek/"` — binds the prefix `ex:` to a custom namespace you define. All your own predicates (`ex:title`, `ex:genre`, `ex:hasActors`, `ex:name`, `ex:playedRole`, `ex:roleName`) are in this namespace.

**Why URIs as namespace names?** In RDF, every resource and every predicate must have a globally unique identifier — a URI. Namespaces prevent collisions: `ex:name` expands to `http://example.org/startrek/name`, which is unambiguous worldwide, whereas the bare word `name` is not.

Alternative: you could use a real, dereferenceable URI (like `https://schema.org/`) to reuse a published vocabulary. For a lab exercise, a custom `example.org` namespace is fine.

---

#### `rdf:Description` — describing a resource

```xml
<rdf:Description rdf:about="http://example.org/startrek/STTNG">
  ...
</rdf:Description>
```

`<rdf:Description>` is the standard way to say "I am about to state facts about a resource." The `rdf:about` attribute gives that resource its URI — its identity in the graph.

Everything nested inside this element becomes a predicate–object pair with `ex:STTNG` as the subject. Each child element is one triple:

```
ex:STTNG  ex:title  "Star Trek: The Next Generation"
ex:STTNG  ex:genre  "SF TV series"
```

Alternative: you can use a **typed node** shorthand. Instead of `<rdf:Description rdf:about="...">` + a `<rdf:type>` child, you can write `<ex:TVSeries rdf:about="...">`. This is syntactic sugar — it produces an additional triple `ex:STTNG rdf:type ex:TVSeries` but otherwise behaves identically.

---

#### Literal properties

```xml
<ex:title>Star Trek: The Next Generation</ex:title>
<ex:genre>SF TV series</ex:genre>
```

When the object of a triple is a plain text value (not another resource), it is called a **literal**. In RDF/XML, you write it as the text content of the property element.

These two elements encode two triples:
```
ex:STTNG  ex:title  "Star Trek: The Next Generation"
ex:STTNG  ex:genre  "SF TV series"
```

Alternative: you can attach a datatype with `rdf:datatype="xsd:string"` or a language tag with `xml:lang="en"` to make the literal more specific. For this lab, untyped literals are sufficient.

---

#### `rdf:Bag` — an unordered container

```xml
<ex:hasActors>
  <rdf:Bag>
    <rdf:li rdf:resource="http://example.org/startrek/PatrickStewart"/>
    <rdf:li rdf:resource="http://example.org/startrek/JonathanFrakes"/>
    <rdf:li rdf:resource="http://example.org/startrek/LeVarBurton"/>
  </rdf:Bag>
</ex:hasActors>
```

`rdf:Bag` is an RDF **container** — a resource that groups other resources or literals. It is semantically unordered (order has no meaning) and allows duplicates.

When an RDF parser reads this block it creates an **anonymous (blank) node** `_:b1` for the Bag, then generates these triples:

```
ex:STTNG      ex:hasActors  _:b1
_:b1          rdf:type      rdf:Bag
_:b1          rdf:_1        ex:PatrickStewart
_:b1          rdf:_2        ex:JonathanFrakes
_:b1          rdf:_3        ex:LeVarBurton
```

`rdf:_1`, `rdf:_2`, `rdf:_3` are called **container membership properties** — they are the actual predicates linking the Bag node to its members. The numbering is an implementation detail of RDF/XML; the `rdf:Bag` type signals to consumers that order is not meaningful.

**`rdf:li` shorthand:** writing `<rdf:li>` is shorthand for `<rdf:_1>`, `<rdf:_2>`, etc. — the parser automatically assigns the next available number. You could write `<rdf:_1 .../>` explicitly, but `<rdf:li>` is cleaner.

**Alternative containers:**
- `rdf:Seq` — use when order matters (e.g., a playlist).
- `rdf:Alt` — use when the members are alternatives (e.g., mirror download links).

---

#### `rdf:resource` vs text content

```xml
<rdf:li rdf:resource="http://example.org/startrek/PatrickStewart"/>
```

The `rdf:resource` attribute means: the object of this triple is **another resource (URI)**, not a literal string. This creates a link in the graph — an edge to another node.

Compare with a literal:
```xml
<ex:name>Patrick Stewart</ex:name>
```
Here the object is a plain string — a leaf node with no outgoing edges.

Rule of thumb: use `rdf:resource` when the object has its own identity and may have further properties. Use text content when the value is just a plain datum (name, number, date).

---

#### `ex:playedRole` — linking two resources

```xml
<ex:playedRole rdf:resource="http://example.org/startrek/CaptPicard"/>
```

This creates the triple:
```
ex:PatrickStewart  ex:playedRole  ex:CaptPicard
```

Because `rdf:resource` is used, `ex:CaptPicard` is a URI — a separate resource described elsewhere in the file with its own `<rdf:Description>` block.

---

## Exercise (b) — RDF graph

The complete set of triples produced by `startrek.rdf`:

```
ex:STTNG           ex:title        "Star Trek: The Next Generation"
ex:STTNG           ex:genre        "SF TV series"
ex:STTNG           ex:hasActors    _:bag
_:bag              rdf:type        rdf:Bag
_:bag              rdf:_1          ex:PatrickStewart
_:bag              rdf:_2          ex:JonathanFrakes
_:bag              rdf:_3          ex:LeVarBurton
ex:PatrickStewart  ex:name         "Patrick Stewart"
ex:PatrickStewart  ex:playedRole   ex:CaptPicard
ex:JonathanFrakes  ex:name         "Jonathan Frakes"
ex:LeVarBurton     ex:name         "LeVar Burton"
ex:CaptPicard      ex:roleName     "Capt. Jean-Luc Picard"
```

In the graph:
- **Ellipse nodes** are URI resources (`ex:STTNG`, `ex:PatrickStewart`, etc.) or blank nodes (`_:bag`).
- **Rectangle nodes** are literals (plain text values).
- **Arrows** are predicates — each arrow is one triple, labelled with its predicate URI.

To generate the visual graph: paste `startrek.rdf` into http://www.w3.org/RDF/Validator/, set "Display Result Options" to **Graph Only** with **PNG-embedded**, then click **Parse RDF**.

---

## Exercise (c) — SPARQL query

**Question:** What roles were interpreted by the actors from "Star Trek: The Next Generation"?

**Full query** (`query.sparql`):

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX ex:  <http://example.org/startrek/>

SELECT ?actorName ?roleName
WHERE {
  <http://example.org/startrek/STTNG> ex:hasActors ?bag .
  ?bag ?p ?actor .
  FILTER(strstarts(str(?p), "http://www.w3.org/1999/02/22-rdf-syntax-ns#_"))
  ?actor ex:name       ?actorName .
  ?actor ex:playedRole ?role .
  ?role  ex:roleName   ?roleName .
}
```

---

### SPARQL breakdown

#### PREFIX declarations

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX ex:  <http://example.org/startrek/>
```

SPARQL PREFIX lines work exactly like `xmlns:` declarations in XML — they bind a short prefix to a full URI so you can write `ex:name` instead of `<http://example.org/startrek/name>` throughout the query.

The prefixes must match the namespaces used in the RDF file, or the URIs will not match any triples.

---

#### SELECT clause

```sparql
SELECT ?actorName ?roleName
```

`SELECT` lists the variables you want returned in the result table. Variables in SPARQL start with `?`. This is analogous to the column list in a SQL `SELECT` or the return value of an XQuery `return` clause.

---

#### WHERE block and triple patterns

```sparql
WHERE {
  ...
}
```

The WHERE block contains **triple patterns** — templates where some positions are fixed URIs/literals and others are variables (`?x`). The SPARQL engine finds all combinations of variable bindings that make every pattern match a real triple in the dataset simultaneously.

**Pattern 1 — navigate from the series to its actor Bag:**

```sparql
<http://example.org/startrek/STTNG> ex:hasActors ?bag .
```

This is a triple pattern where the subject is fixed (`ex:STTNG`), the predicate is fixed (`ex:hasActors`), and the object is a variable `?bag`. The engine binds `?bag` to whatever resource is linked from `ex:STTNG` via `ex:hasActors` — the blank node `_:b1` that represents the Bag.

---

**Pattern 2 — get all members of the Bag:**

```sparql
?bag ?p ?actor .
```

All three positions are variables. This matches every triple whose subject is the Bag node — including:
- `_:b1 rdf:type rdf:Bag`
- `_:b1 rdf:_1 ex:PatrickStewart`
- `_:b1 rdf:_2 ex:JonathanFrakes`
- `_:b1 rdf:_3 ex:LeVarBurton`

Without a filter this would also bind `?actor` to `rdf:Bag` (the type triple), which is not what we want.

---

**FILTER — keep only container membership predicates:**

```sparql
FILTER(strstarts(str(?p), "http://www.w3.org/1999/02/22-rdf-syntax-ns#_"))
```

`FILTER` removes bindings that do not satisfy the condition.

- `str(?p)` — converts the URI value of `?p` to a plain string.
- `strstarts(string, prefix)` — a SPARQL built-in that returns `true` when the string starts with the given prefix.
- `"http://www.w3.org/1999/02/22-rdf-syntax-ns#_"` — the common prefix of all container membership properties (`rdf:_1`, `rdf:_2`, `rdf:_3`, …).

After this filter, `?p` can only be `rdf:_1`, `rdf:_2`, or `rdf:_3`, so `?actor` is bound only to the three actor resources — never to `rdf:Bag`.

This is the SPARQL equivalent of XPath's `[@type='something']` predicate: it filters bindings by a condition on a variable.

---

**Patterns 3–5 — get the actor's name, role, and role name:**

```sparql
?actor ex:name       ?actorName .
?actor ex:playedRole ?role .
?role  ex:roleName   ?roleName .
```

Pattern 3 binds `?actorName` to the literal name of each actor.

Pattern 4 looks for a `ex:playedRole` triple on the actor. Only `ex:PatrickStewart` has this triple — the other two actors have no `ex:playedRole` in the dataset. The engine therefore produces one result row (for Stewart) and discards the other two bindings.

Pattern 5 binds `?roleName` to the literal name of the role.

The three patterns together form a **join** across the graph — exactly like a multi-table join in SQL, but on graph edges instead of table columns.

---

### Expected result

```
----------------------------------------------
| actorName         | roleName               |
==============================================
| "Patrick Stewart" | "Capt. Jean-Luc Picard"|
----------------------------------------------
```

Only one row is returned because only one actor (`ex:PatrickStewart`) has an `ex:playedRole` triple in the dataset.

---

## Running with Jena ARQ

Validate the RDF file first (no output = valid):

```bash
riot --validate Lab_4/resources/startrek.rdf
```

Run the SPARQL query:

```bash
arq --data=Lab_4/resources/startrek.rdf --query=Lab_4/query.sparql
```

Or with full paths if you are not in the `Labs/` directory:

```bash
arq \
  --data="/home/mmswflow/Documents/uni-labs/Sem II/semantic-web-labs/Labs/Lab_4/resources/startrek.rdf" \
  --query="/home/mmswflow/Documents/uni-labs/Sem II/semantic-web-labs/Labs/Lab_4/query.sparql"
```

`arq` is provided by Apache Jena 6.0.0, located at:
```
semantic-web-labs/Apps/apache-jena-6.0.0/bin/arq
```
It is on your PATH via the `JENAROOT` export in `~/.bashrc`. Open a new terminal (or run `source ~/.bashrc`) to pick it up.

---

## Online tools (for exercises a and b)

- **RDF Validator + graph viewer:** http://www.w3.org/RDF/Validator/ — paste `startrek.rdf`, select "Graph Only" → PNG-embedded, click "Parse RDF".
- **SPARQL Playground:** https://atomgraph.github.io/SPARQL-Playground/ — paste `startrek.rdf` on the left, paste `query.sparql` on the right, click "Query".
