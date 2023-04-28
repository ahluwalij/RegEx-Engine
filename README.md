# OCaml Regular Expression Engine

This repository contains the source code for a Regular Expression (RegEx) Engine written in OCaml. The engine uses Non-deterministic Finite Automaton (NFA) to parse and match regular expressions against input strings.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- Supports basic regular expression operations such as concatenation, alternation (union), and Kleene star
- Efficient matching using Non-deterministic Finite Automaton (NFA)
- Utilizes sets for efficient NFA state management

## Getting Started

### Prerequisites

- OCaml: Ensure that you have OCaml installed on your system. If you don't have it installed, follow the instructions in the [official documentation](https://ocaml.org/docs/install.html).

- Dune: This project uses Dune as the build system. Install Dune by running:

```
opam install dune
```

### Installation

1. Clone the repository:

```
git clone https://github.com/yourusername/ocaml-regex-engine.git
```

2. Change to the project directory:

```
cd ocaml-regex-engine
```

3. Build the project:

```
dune build
```

## Usage

To use the regular expression engine in your OCaml project, you need to include the `regexp.ml`, `regexp.mli`, `nfa.ml`, `nfa.mli`, `sets.ml`, and `sets.mli` files.

Here's a simple example to get started:

```ocaml
open Regexp

let main () =
let regex = Regexp.from_string "a*b" in
let input = "aaab" in
let result = Regexp.match_string regex input in
Printf.printf "Does the input match the regex? %b\n" result

let () = main ()
```

## Contributing
Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you'd like to contribute code, please submit a pull request.
