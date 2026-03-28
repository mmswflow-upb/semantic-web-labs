# Lab 3 — XML Document Processing in Java Using XPath

This directory contains a single Java program that solves the five XPath exercises from the lab slides. Each exercise parses an XML file with the DOM API and evaluates an XPath expression against it.

## Exercise layout
- `src/main/resources/document.xml`: exercise 1 — a `<document>` with a `<reference href="..."/>` element.
- `src/main/resources/jobs.xml`: exercise 2 — a `<jobs>` list with five `<job>` elements carrying `priority` and `name` attributes.
- `src/main/resources/persons.xml`: exercises 3-5 — a `<persons>` list with four `<person>` elements carrying `firstName`, `lastName`, and `age` attributes.
- `src/main/java/Lab_3_Solutions.java`: the solution class. Each exercise is its own static method; `main` calls them sequentially.

## Common setup — `loadXml()` helper

Every exercise needs to parse an XML file into a DOM tree before any XPath can run. The helper method `loadXml(String fileName)` wraps the boilerplate:

```java
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
```
`DocumentBuilderFactory` is the entry point for DOM parsing. `.newInstance()` returns a factory configured with the JVM defaults.

```java
DocumentBuilder builder = factory.newDocumentBuilder();
```
The factory produces a `DocumentBuilder` — the object that actually reads XML and builds the in-memory DOM tree.

```java
return builder.parse(Lab_3_Solutions.class.getClassLoader().getResourceAsStream(fileName));
```
This is a 3-step chain that loads the XML from the **classpath** instead of a raw filesystem path:
1. `Lab_3_Solutions.class` — gets the `Class` object representing the compiled class.
2. `.getClassLoader()` — gets the **classloader** that loaded it.
3. `.getResourceAsStream("document.xml")` — asks the classloader to search the classpath for a file with that name and return it as an `InputStream`.

Then `builder.parse(InputStream)` reads the XML from that stream and returns a `Document` — the root of the DOM tree. Every element, attribute, and text node in the XML is now accessible as Java objects.

### What are the classpath and classloader?

The **classpath** is a list of locations (folders, `.jar` files) where Java looks for classes and resources at runtime. Gradle automatically puts `src/main/resources/` on the classpath, so any file in that folder becomes findable by name alone — no full path needed.

The **classloader** is the JVM component that actually does the searching. When your code calls `.getResourceAsStream("document.xml")`, the classloader walks through the classpath locations one by one until it finds a match and returns it.

Think of it like this: the **classpath** is a phonebook (a list of addresses to check) and the **classloader** is the person flipping through it.

### Why not `new File(fileName)`?

Using `new File("document.xml")` looks for the file relative to the **working directory** — whichever folder the JVM was launched from. When IntelliJ/Gradle runs the program, the working directory is the project root (`Lab_3/`), but the XML files live inside `src/main/resources/`, so it would fail with a file-not-found error.

Loading from the classpath avoids this entirely: Gradle always copies `src/main/resources/` contents onto the classpath regardless of the working directory.

### What if two files share the same name?

The classloader returns the **first match** it finds on the classpath and stops. The order depends on how Gradle orders the classpath entries. If `document.xml` existed in both `src/main/resources/` and inside some `.jar` dependency, whichever appears first wins — the other is silently ignored with no warning. That is why real projects often place resources in subdirectories (e.g. `com/mycompany/myapp/document.xml`) to avoid collisions. For a small lab project, plain filenames at the root are fine.

---

## Exercise 1 — select the `href` attribute

**XML** (`document.xml`):
```xml
<document>
    <reference href="http://www.google.ro/"/>
</document>
```

**Java — creating the XPath evaluator:**
```java
Document doc = loadXml("document.xml");
```
Parses the XML into a DOM tree (using the helper above).

```java
XPath xpath = XPathFactory.newInstance().newXPath();
```
`XPathFactory.newInstance()` gives a factory for XPath objects. `.newXPath()` creates an `XPath` evaluator — the object that compiles and runs XPath expressions against a DOM tree.

**Java — compiling and evaluating the expression:**
```java
XPathExpression expr = xpath.compile("/document/reference/@href");
```
`.compile()` takes an XPath string and parses it into a reusable `XPathExpression` object. Compiling once is more efficient than evaluating a raw string repeatedly.

**XPath breakdown — `/document/reference/@href`:**
- `/document` — start at the root, select the `<document>` element.
- `/reference` — go one level deeper, select the `<reference>` child.
- `/@href` — the `@` prefix means "attribute"; select the attribute named `href` on that element.

```java
String href = (String) expr.evaluate(doc, XPathConstants.STRING);
```
`.evaluate(doc, returnType)` runs the compiled expression against the DOM tree `doc`. `XPathConstants.STRING` tells it to return the result as a plain Java `String`. The cast `(String)` matches that return type. Result: `"http://www.google.ro/"`.

---

## Exercise 2 — count low-priority jobs

**XML** (`jobs.xml`):
```xml
<jobs>
    <job priority="critical" name="Take out the trash" />
    <job priority="low"      name="Clean the furniture" />
    <job priority="low"      name="Clean the carpet" />
    <job priority="medium"   name="Wash the windows" />
    <job priority="high"     name="Water the plants" />
</jobs>
```

**Java — compile and evaluate:**
```java
XPathExpression expr = xpath.compile("count(/jobs/job[@priority='low'])");
```

**XPath breakdown — `count(/jobs/job[@priority='low'])`:**
- `/jobs/job` — from the root, select all `<job>` children inside `<jobs>`.
- `[@priority='low']` — a **predicate** (filter) inside square brackets. It keeps only the `<job>` elements whose `priority` attribute equals `"low"`. Two jobs match: furniture and carpet.
- `count(...)` — an XPath function that returns how many nodes are in the set. Result: `2`.

```java
Double count = (Double) expr.evaluate(doc, XPathConstants.NUMBER);
```
`XPathConstants.NUMBER` tells Java to return the result as a `Double`. XPath's numeric type maps to Java's `Double`. `.intValue()` is used when printing to drop the `.0` decimal.

---

## Exercise 3 — persons older than 35

**XML** (`persons.xml`):
```xml
<persons>
    <person firstName="John"   lastName="Smith"   age="28" />
    <person firstName="Henry"  lastName="Hill"    age="33" />
    <person firstName="Peter"  lastName="Miller"  age="37" />
    <person firstName="Alice"  lastName="Brown"   age="45" />
</persons>
```

**Java — compile and evaluate:**
```java
XPathExpression expr = xpath.compile("/persons/person[@age > 35]");
NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
```

**XPath breakdown — `/persons/person[@age > 35]`:**
- `/persons/person` — select all `<person>` elements.
- `[@age > 35]` — a predicate that compares the `age` attribute numerically. XPath automatically converts the string `"37"` to the number `37` for comparison. Peter (37) and Alice (45) pass; John (28) and Henry (33) do not.

`XPathConstants.NODESET` tells Java to return all matching nodes as a `NodeList` — an ordered collection of DOM `Node` objects.

**Java — iterating over results:**
```java
for (int i = 0; i < nodes.getLength(); i++) {
    printPerson(nodes.item(i));
}
```
`.getLength()` returns how many nodes matched. `.item(i)` retrieves the node at index `i`. Each node is passed to `printPerson()`.

**Java — `printPerson()` helper:**
```java
NamedNodeMap attrs = node.getAttributes();
String firstName = attrs.getNamedItem("firstName").getNodeValue();
```
- `.getAttributes()` returns a `NamedNodeMap` — a collection of all attributes on that element.
- `.getNamedItem("firstName")` looks up the attribute by name, returning an `Attr` node.
- `.getNodeValue()` extracts the attribute's text value as a `String`.

This same pattern reads `lastName` and `age`, then prints them formatted.

---

## Exercise 4 — last name starting with "H"

**Java — compile and evaluate:**
```java
XPathExpression expr = xpath.compile("/persons/person[starts-with(@lastName, 'H')]");
NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
```

**XPath breakdown — `/persons/person[starts-with(@lastName, 'H')]`:**
- `/persons/person` — select all `<person>` elements.
- `starts-with(@lastName, 'H')` — a built-in XPath string function. It takes two arguments: the string to test (`@lastName` — the value of the `lastName` attribute) and the prefix to look for (`'H'`). Returns `true` if the attribute value begins with `"H"`.
- Only Henry Hill matches (`"Hill"` starts with `"H"`). Smith, Miller, and Brown do not.

The iteration and printing use the same `NodeList` loop and `printPerson()` as exercise 3.

---

## Exercise 5 — first name shorter than 5 characters

**Java — compile and evaluate:**
```java
XPathExpression expr = xpath.compile("/persons/person[string-length(@firstName) < 5]");
NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
```

**XPath breakdown — `/persons/person[string-length(@firstName) < 5]`:**
- `string-length(@firstName)` — a built-in XPath function that returns the number of characters in the string. Applied to the `firstName` attribute of each `<person>`.
- `< 5` — keeps only persons where that length is strictly less than 5.
- `"John"` has 4 characters — matches. `"Henry"`, `"Peter"`, `"Alice"` each have 5 characters — they do **not** match (5 is not less than 5).

The iteration and printing are identical to exercises 3 and 4.

## Recommended commands
1. Run `./gradlew build` to compile.
2. Run `./gradlew run` to execute all five exercises and see their output.
