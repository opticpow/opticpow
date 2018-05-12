#!/bin/bash
set -e
hugo
aws s3 sync --profile personal --delete --storage-class REDUCED_REDUNDANCY public/ s3://opticpow.io/
