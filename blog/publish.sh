#!/bin/bash
set -e
hugo
aws s3 sync public/ s3://opticpow.io/
