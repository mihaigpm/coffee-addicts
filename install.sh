#!/usr/bin/env bash

swift build -c release
install .build/release/CoffeeAddicts /usr/local/bin/CoffeeAddicts
