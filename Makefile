#
# Makefile
# Wallet
#

################################################################################
#
# Variables
#

CMD_NAME = wallet
SHELL = /bin/sh

# trunk
# SWIFT_VERSION = swift-DEVELOPMENT-SNAPSHOT-2020-04-23-a

# Swift 5.3
# SWIFT_VERSION = swift-5.3-DEVELOPMENT-SNAPSHOT-2020-04-21-a

SWIFT_VERSION = 5.2.4

# set EXECUTABLE_DIRECTORY according to your specific environment
# run swift build and see where the output executable is created

# OS specific differences
UNAME = ${shell uname}

ifeq ($(UNAME), Darwin)
SWIFTC_FLAGS =
LINKER_FLAGS = -Xlinker -L/usr/local/lib
PLATFORM = x86_64-apple-macosx
EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
TEST_BUNDLE = ${CMD_NAME}PackageTests.xctest
TEST_RESOURCES_DIRECTORY = ./.build/${PLATFORM}/debug/${TEST_BUNDLE}/Contents/Resources
endif
ifeq ($(UNAME), Linux)
SWIFTC_FLAGS = -Xcc -fblocks
LINKER_FLAGS = -Xlinker -rpath -Xlinker .build/debug
PATH_TO_SWIFT = /home/vagrant/swiftenv/versions/$(SWIFT_VERSION)
PLATFORM = x86_64-unknown-linux
EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
TEST_RESOURCES_DIRECTORY = ${EXECUTABLE_DIRECTORY}
endif

RUN_RESOURCES_DIRECTORY = ${EXECUTABLE_DIRECTORY}

################################################################################
#
# Targets
#

.PHONY: version
version:
	xcodebuild -version
	swift --version
	swift package tools-version

.PHONY: init
init:
	- swiftenv install $(SWIFT_VERSION)
	swiftenv local $(SWIFT_VERSION)
ifeq ($(UNAME), Linux)
	cd /vagrant && \
	  git clone --recursive -b experimental/foundation https://github.com/apple/swift-corelibs-libdispatch.git && \
	  cd swift-corelibs-libdispatch && \
	  sh ./autogen.sh && \
	  ./configure --with-swift-toolchain=/home/vagrant/swiftenv/versions/$(SWIFT_VERSION)/usr \
	    --prefix=/home/vagrant/swiftenv/versions/$(SWIFT_VERSION)/usr && \
	  make && make install
endif

.PHONY: xcproj
xcproj:
	swift package generate-xcodeproj

.PHONY: clean
clean:
	rm -rf Packages
	xcodebuild clean
	swift package clean
	swift package reset

.PHONY: describe
describe:
	swift package describe

.PHONY: resolve
resolve:
	swift package resolve

.PHONY: dependencies
dependencies: resolve
	swift package show-dependencies

.PHONY: update
update: resolve
	swift package update

.PHONY: build
build: copyRunResources
	swift build $(SWIFTC_FLAGS) $(LINKER_FLAGS)

.PHONY: test
test: build copyTestResources
	swift test --enable-test-discovery

.PHONY: copyRunResources
copyRunResources:
	mkdir -p ${RUN_RESOURCES_DIRECTORY}
	cp -r Resources/* ${RUN_RESOURCES_DIRECTORY}

.PHONY: copyTestResources
copyTestResources:
	mkdir -p ${TEST_RESOURCES_DIRECTORY}
	cp -r Resources/* ${TEST_RESOURCES_DIRECTORY}

.PHONY: run
# make run ARGS="asdf"
run: build
	${EXECUTABLE_DIRECTORY}/${CMD_NAME} $(ARGS)
