# Ortelius v11 Domain Microservice

> Version 11.0.0

RestAPI for the Domain Object
![Release](https://img.shields.io/github/v/release/ortelius/scec-scorecard?sort=semver)
![license](https://img.shields.io/github/license/ortelius/.github)

![Build](https://img.shields.io/github/actions/workflow/status/ortelius/scec-scorecard/build-push-chart.yml)
[![MegaLinter](https://github.com/ortelius/scec-scorecard/workflows/MegaLinter/badge.svg?branch=main)](https://github.com/ortelius/scec-scorecard/actions?query=workflow%3AMegaLinter+branch%3Amain)
![CodeQL](https://github.com/ortelius/scec-scorecard/workflows/CodeQL/badge.svg)
[![OpenSSF-Scorecard](https://api.securityscorecards.dev/projects/github.com/ortelius/scec-scorecard/badge)](https://api.securityscorecards.dev/projects/github.com/ortelius/scec-scorecard)

![Discord](https://img.shields.io/discord/722468819091849316)

## Path Table

| Method | Path | Description |
| --- | --- | --- |
| GET | [/msapi/domain](#getmsapidomain) | Get a List of Domains |
| POST | [/msapi/domain](#postmsapidomain) | Create a Domain |
| GET | [/msapi/domain/:key](#getmsapidomainkey) | Get a Domain |

## Reference Table

| Name | Path | Description |
| --- | --- | --- |

## Path Details

***

### [GET]/msapi/domain

- Summary  
Get a List of Domains

- Description  
Get a list of domains for the user.

#### Responses

- 200 OK

***

### [POST]/msapi/domain

- Summary  
Create a Domain

- Description  
Create a new Domain and persist it

#### Responses

- 200 OK

***

### [GET]/msapi/domain/:key

- Summary  
Get a Domain

- Description  
Get a domain based on the _key or name.

#### Responses

- 200 OK

## References
