# Example grammar for JSON

File grammarjson.ebnf contains an example grammar for
[JSON](https://www.json.org/json-en.html). The example application in
file testgrammarjson.d parses a JSON file and prints the resulting
parse tree.

The application can be built with the following command:
```sh
dub build
```

The following command runs the application on the JSON file dub.json:
```sh
./example_json dub.json
```

It is also possible to test the grammar on test cases from
https://github.com/nst/JSONTestSuite using the argument `--test-dir`:
```sh
git clone https://github.com/nst/JSONTestSuite.git
./example_json --test-dir JSONTestSuite/test_parsing
```
It will only print on errors, so the expected output is empty.
