#!/bin/sh
find . -type f -name '*.md' | xargs proselint
