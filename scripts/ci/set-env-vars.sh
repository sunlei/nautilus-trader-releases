#!/usr/bin/env bash
set -euo pipefail

{
  echo "BUILD_MODE=release"

  # > --------------------------------------------------
  # > cargo
  echo "CARGO_TARGET_DIR=${GITHUB_WORKSPACE}/.cache/cargo/target"
  # echo "CARGO_LOG=debug" >> "${GITHUB_ENV}"
  # echo "CARGO_TERM_VERBOSE=true" >> "${GITHUB_ENV}"
  echo "RUST_BACKTRACE=1"

  if [[ "${TARGET_ARCH}" != "aarch64-apple-darwin" ]]; then
    echo "CARGO_BUILD_TARGET=${TARGET_ARCH}"
    echo "RUSTFLAGS=-C target-cpu=${TARGET_CPU}"
  fi

  # -Z tune-cpu=${TARGET_CPU} # the option `Z` is only accepted on the nightly compiler
  # if [[ "${TARGET_ARCH}" == "aarch64-apple-darwin" ]]; then
  #   echo "CARGO_BUILD_TARGET=${TARGET_ARCH}"
  #   echo "RUSTFLAGS=-C target-cpu=${TARGET_CPU} -C link-arg=-undefined -C link-arg=dynamic_lookup"
  # else
  #   echo "CARGO_BUILD_TARGET=${TARGET_ARCH}"
  #   echo "RUSTFLAGS=-C target-cpu=${TARGET_CPU}"
  # fi

  # > --------------------------------------------------
  # > sccache
  # https://github.com/Mozilla-Actions/sccache-action

  echo "SCCACHE_IDLE_TIMEOUT=0"
  echo "SCCACHE_DIRECT=true"
  echo "SCCACHE_CACHE_MULTIARCH=1"
  echo "SCCACHE_DIR=${GITHUB_WORKSPACE}/.cache/sccache"
  echo "RUSTC_WRAPPER=sccache"
  echo "CC=sccache clang"
  echo "CXX=sccache clang++"
  # Incrementally compiled crates cannot be cached by sccache
  # https://github.com/mozilla/sccache#rust
  echo "CARGO_INCREMENTAL=0"
} >>"${GITHUB_ENV}"
