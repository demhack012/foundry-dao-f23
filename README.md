# Foundry DAO Governance

*Please note: ERC20 based voting is not always recommended, and I encourage you to explore other forms of governance like reputation based or "skin-in-the-game" based.*

[One of my favorite articles on money-based voting being bad](https://vitalik.ca/general/2018/03/28/plutocracy.html)

> Note: If you install the most recent version of openzeppelin contracts, this codebase won't work! Be sure to install `v4.8.3` of openzeppelin. See the `Makefile` for more information.

- [Foundry DAO Governance](#foundry-dao-governance)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Test](#test)
  - [Deploy](#deploy)
  - [Estimate gas](#estimate-gas)
- [Formatting](#formatting)
- [Thank you!](#thank-you)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`


## Quickstart

```
git clone https://github.com/demhack012/foundry-dao-f23.git
cd foundry-dao-f23
forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit
forge build
```

# Usage

## Test

```
forge test
```
## Deploy

I did not write deploy scripts for this project, you can if you'd like!

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see and output file called `.gas-snapshot`


# Formatting


To run code formatting:
```
forge fmt
```


# Thank you!
