#!/bin/bash
set -e
hugo
aws s3 sync --profile personal public/ s3://opticpow.io/
