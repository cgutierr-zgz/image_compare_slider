# Contribution Guide

Feel free to contribute to this project. If you want to contribute, please follow the steps below:

1. Fork the project
2. Commit your changes
3. Create a pull request

Please make sure that your code is well tested and that the test coverage is 100% and the pana score is perfect.

## Running Tests 🧪

You can run and open the report using the following command:

```sh
flutter test --coverage --test-randomize-ordering-seed random && genhtml coverage/lcov.info -o coverage/ && open coverage/index.html
```

Everything should be green! 🎉
