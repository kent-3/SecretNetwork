#! /bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	set -e

	if [[ `whoami` == "root" ]]; then
		MAKE_ME_ROOT=
	else
		MAKE_ME_ROOT=sudo
	fi

	if [ -f /etc/redhat-release ]; then
		echo "Redhat Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1;
	elif [ -f /etc/SuSE-release ]; then
		echo "Suse Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1;
	elif [ -f /etc/arch-release ]; then
		echo "Arch Linux detected."
		$MAKE_ME_ROOT pacman -Syu --needed --noconfirm curl jq tar cmake gcc clang
	elif [ -f /etc/mandrake-release ]; then
		echo "Mandrake Linux detected."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1;
	elif [ -f /etc/debian_version ]; then
		echo "Ubuntu/Debian Linux detected."
		$MAKE_ME_ROOT apt update
		$MAKE_ME_ROOT apt install -y curl jq tar build-essential clang libclang-dev
	else
		echo "Unknown Linux distribution."
		echo "This OS is not supported with this script at present. Sorry."
		echo "Please refer to https://github.com/paritytech/substrate for setup information."
		exit 1;
	fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Mac OS (Darwin) detected."
	set -e

	if ! which brew >/dev/null 2>&1; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	brew update
	brew install binaryen wabt curl cmake llvm
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "FreeBSD detected."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
	exit 1;
else
	echo "Unknown operating system."
	echo "This OS is not supported with this script at present. Sorry."
	echo "Please refer to https://github.com/paritytech/substrate for setup information."
	exit 1;
fi

if ! which rustup >/dev/null 2>&1; then
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.cargo/env
fi

rustup update stable
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain stable
rustup target add wasm32-unknown-unknown --toolchain nightly

## While ink! is pinned to a specific nightly version of the Rust compiler you will need to explicitly install that toolchain.
#rustup install nightly-2019-05-21
#rustup target add wasm32-unknown-unknown --toolchain nightly-2019-05-21

echo "Installing wasm-prune into ~/.cargo/bin"
cargo install pwasm-utils-cli --bin wasm-prune --force

# Copy WASM binaries after successful rust/cargo install.
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	set -e

	tmp=`mktemp -d`
	pushd $tmp > /dev/null
	
	echo "Downloading wabt-1.0.33-ubuntu.tar.gz";
	wget https://github.com/WebAssembly/wabt/releases/download/1.0.33/wabt-1.0.33-ubuntu.tar.gz

	tar --strip-components=2 -xf wabt-1.0.33-ubuntu.tar.gz wabt-1.0.33/bin/wasm2wat wabt-1.0.33/bin/wat2wasm

	echo "Installing wasm2wat & wat2wasm into ~/.cargo/bin"
	cp -f wasm2wat ~/.cargo/bin/
	cp -f wat2wasm ~/.cargo/bin/

	popd > /dev/null
fi

echo ""
echo "Run source ~/.cargo/env now to update environment."
echo ""

source ~/.cargo/env
wasm2wat --version
