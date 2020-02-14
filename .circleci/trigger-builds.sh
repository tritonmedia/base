#!/usr/bin/env bash

repos=("beholder" "converter" "downloader" "events")
for repo in ${repos[@]}; do
  echo " --> triggering '$repo' rebuild"
  curl -X POST "https://circleci.com/api/v1.1/project/github/tritonmedia/$repo/build?circle-token=$CIRCLE_API_TOKEN"
  echo ""
done