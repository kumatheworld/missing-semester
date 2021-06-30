# missing-semester
My Exercise Solutions for [The Missing Semester of Your CS Education, Winter 2020](https://missing.csail.mit.edu/2020/).

### Table of Contents
1. [Course overview + the shell](#course-overview--the-shell)

## Course overview + the shell
1.
```
$ echo $SHELL
/bin/bash
```
2.
```
$ mkdir /tmp/missing
```
3.
```
$ man touch
```
4.
```
$ touch /tmp/missing/semester
```
5.
```
$ echo '#!/bin/sh' > /tmp/missing/semester
$ echo 'curl --head --silent https://missing.csail.mit.edu' >> /tmp/missing/semester
```
6.
```
$ /tmp/missing/semester
-bash: /tmp/missing/semester: Permission denied
$ ls -l /tmp/missing/semester
-rw-r--r--  1 kumatheworld  wheel  61 Jun 30 19:20 /tmp/missing/semester
```
