Xtreme
======
A benchmark framework implemented in Kotlin.

## Overview

Currently, there are 2 type benchmark frameworks: `CioHttpBenchmark`, `ThreadPoolBenchmark`.

See detail in Unit Test.

## Requirements

- Java 1.8
- Docker

## Troubleshooting

1. Seems most Http Mock Components doesn't support HTTP pipelining, so disabled in default, and then every HTTP request 
will create and close a TCP connection, it may cause `java.net.BindException: Address already in use: no further information`.