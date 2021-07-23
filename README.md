# CoffeeAddicts

This Swift Command Line application will return the three closest coffee shops to you, by providing your location coordinates and a CSV file URL with the coffee shops you want to search through.

## Requirements

MacOS or Linux
Swift 5.x

## Installation

1. Clone this repo.
2. Open a Terminal, go to the project folder you just cloned and run the following commands:

```
$ chmod +x install.sh
$ ./install.sh
```

## How to Run

```
$ coffeeaddicts YOUR_LATITUDE YOUR_LONGITUDE COFFEE_CSV_URL
```
Example:

```
$ coffeeaddicts 42.2115 23.2236 https://raw.githubusercontent.com/Agilefreaks/test_oop/master/coffee_shops.csv
```
`YOUR_LATITUDE` and `YOUR_LONGITUDE` must be provided in decimal format.
`COFFEE_CSV_URL` must be a valid URL containing a CSV formatted file to download.

### Sample Output

```
The closest coffee shops to you are:
Starbucks Moscow - (55.752047, 37.595242) - 1392.8308 km
Starbucks Seattle2 - (47.5869, -122.3368) - 9039.7744 km
Starbucks Seattle - (47.5809, -122.316) - 9039.7816 km
```

### Troubleshooting

Run `coffeeaddicts -h` for more help.

```
OVERVIEW: A program to perform simple computations
USAGE: coffeeaddicts <subcommand>

OPTIONS:
--version Show the version.
-h, --help  Show help information.

SUBCOMMANDS:
find-shops  Returns a list of the three closest coffee shops

See 'coffeeaddicts help <subcommand>' for detailed help.
```
