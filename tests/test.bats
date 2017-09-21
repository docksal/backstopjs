#!/usr/bin/env bats

PHANTOMJS_VERSION=2.1.1
CASPERJS_VERSION=1.1.4
SLIMERJS_VERSION=0.10.3
BACKSTOPJS_VERSION=3.0.25
CHROMIUM_VERSION=61.0
FIREFOX_VERSION=52.3

# Debugging
teardown() {
	echo
	# TODO: figure out how to deal with this (output from previous run commands showing up along with the error message)
	echo "Note: ignore the lines between \"...failed\" above and here"
	echo
	echo "Status: $status"
	echo "Output:"
	echo "================================================================"
	echo "$output"
	echo "================================================================"
}

# Global skip
# Uncomment below, then comment skip in the test you want to debug. When done, reverse.
#SKIP=1

@test "Check PhantomJS" {
	[[ $SKIP == 1 ]] && skip

	### Tests ###

	run fin docker run --name ${NAME} --rm --entrypoint="" ${IMAGE} phantomjs --version
	echo "$output" | grep -F ${PHANTOMJS_VERSION}
}

@test "Check SlimerJS" {
	[[ $SKIP == 1 ]] && skip

	### Tests ###

	run fin docker run --name ${NAME} --rm --entrypoint="" ${IMAGE} slimerjs --version
	echo "$output" | grep -F ${SLIMERJS_VERSION}
}

@test "Check CasperJS" {
	[[ $SKIP == 1 ]] && skip

	### Tests ###

	run fin docker run --name ${NAME} --rm --entrypoint="" ${IMAGE} casperjs --version
	echo "$output" | grep -F ${CASPERJS_VERSION}
}

@test "Check BackstopJS" {
	[[ $SKIP == 1 ]] && skip

	### Tests ###

	run fin docker run --name ${NAME} --rm --entrypoint="" ${IMAGE} backstop --version
	echo "$output" | grep -F ${BACKSTOPJS_VERSION}
}

@test "Check Chrome" {
	[[ $SKIP == 1 ]] && skip

	### Tests ###

	run fin docker run --name ${NAME} --rm --entrypoint="" ${IMAGE} chromium-browser --version
	echo "$output" | grep -F ${CHROMIUM_VERSION}
}

@test "Check Firefox" {
	[[ $SKIP == 1 ]] && skip

	### Tests ###

	run fin docker run --name ${NAME} --rm --entrypoint="" ${IMAGE} firefox --version
	echo "$output" | grep ${FIREFOX_VERSION}
}
