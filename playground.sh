#!/usr/bin/env bash

readonly SERVICES_LIST="mongo | postgres | mysql | mariadb | elasticsearch | redis | sqlite | all"
readonly DOCKER_COMPOSE_FILE="./docker-compose.yml"

require() {
  if [[ -z $(command -v "$1" 2>/dev/null) ]]; then
    echo " 🛑  Please install $1 and try again"
    exit 1
  fi
}

usage() {
  cat << EOS
Usage:
  playground.sh [-c] [-s ${SERVICES_LIST}] [-h]
  -c      - Clean up the existing data in playground
  -h      - Show this help window
  -s      - Run the given service
Examples:
  playground.sh -h                # Show this help window
  playground.sh -c -s mongo       # Clean up and run mongo
  playground.sh -s postgres       # Run postgres service
  playground.sh -s mysql          # Run mysql service
  playground.sh -s mariadb        # Run mariadb service
  playground.sh -s elasticsearch  # Run elasticsearch service
  playground.sh -s redis          # Run redis service
  playground.sh -s sqlite         # Run sqlite service
  playground.sh -s all            # Run all services
  playground.sh -c                # Clean up the data only
EOS
}

require docker

# Read options and values
while getopts "chs:" opt; do
  case $opt in
    c | s | h)
      declare "option_$opt=${OPTARG:-0}"
      ;;
    \?)
      usage
      exit 1
      ;;
  esac
done

# Remove the options from the positional parameters
shift $((OPTIND - 1))

# If no options were passed, run all the services
if [[ $OPTIND -eq 1 ]]; then
  option_s="all"
fi

if [[ $# -gt 0 ]]; then
  echo >&2 "Invalid arguments: $*"
  echo >&2 "Use 'playground.sh -h' to see usage info"
  exit 1
fi

if [[ ${option_h:=} ]]; then
  usage
  exit 0
fi

## Verify the given service name
if [[ ${option_s:=} ]] && [[ $SERVICES_LIST != *"$option_s"* ]]; then
   echo >&2 "Invalid service: $option_s"
   echo >&2 "Use 'playground.sh -h' to see usage info"
   exit 1
fi

# Clean up the container
if [[ ${option_c:=} ]]; then
  echo " 🧹  Cleaning up the existing data in playground"
  docker compose -f "${DOCKER_COMPOSE_FILE}" down -v
fi

# Run the given service
if [[ ${option_s:=} ]]; then
  if [[ $option_s == "all" ]]; then
    echo " 🚀  Running all services"
    docker compose -f "${DOCKER_COMPOSE_FILE}" up
  elif [[ $option_s == "mongo" ]]; then
    echo " 🚀  Running mongo service"
    docker compose -f "${DOCKER_COMPOSE_FILE}" up mongo mongo-seed
  elif [[ $option_s == "elasticsearch" ]]; then
    echo " 🚀  Running elasticsearch service"
    docker compose -f "${DOCKER_COMPOSE_FILE}" up elasticsearch elasticsearch-seed
  else
    echo " 🚀  Running $option_s service"
    docker compose -f "${DOCKER_COMPOSE_FILE}" up "$option_s"
  fi
fi
