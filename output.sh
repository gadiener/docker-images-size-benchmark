#!/usr/bin/env bash

set -e

function eol {
    echo
}

function title {
    echo "${1}"
    eol
}

function waiting {
	echo "[>>] ${1}"
}

function success {
	echo "[OK] ${1}"
}

function error {
	echo "[!!] ${1}"
}