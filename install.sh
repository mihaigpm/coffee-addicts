#!/usr/bin/env bash

swift build -c release
install .build/release/coffeeaddicts /usr/local/bin/coffeeaddicts
