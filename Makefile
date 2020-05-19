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

SWIFT_VERSION = 5.2.2

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
endif
ifeq ($(UNAME), Linux)
SWIFTC_FLAGS = -Xcc -fblocks
LINKER_FLAGS = -Xlinker -rpath -Xlinker .build/debug
PATH_TO_SWIFT = /home/vagrant/swiftenv/versions/$(SWIFT_VERSION)
PLATFORM = x86_64-unknown-linux
EXECUTABLE_DIRECTORY = ./.build/${PLATFORM}/debug
endif

################################################################################
#
# Targets
#

.PHONY: build dependencies describe distclean
.PHONY: init list resolve run test update version xcproj

describe:
	swift package describe

resolve:
	swift package resolve

dependencies: resolve
	swift package show-dependencies

update: resolve
	swift package update

xcproj:
	swift package generate-xcodeproj

build:
	swift build $(SWIFTC_FLAGS) $(LINKER_FLAGS)

test: build
	swift test --enable-test-discovery

# make run ARGS="asdf"
run: build
	${EXECUTABLE_DIRECTORY}/${CMD_NAME} $(ARGS)

clean:
	swift package clean
	swift package reset

distclean:
	rm -rf Packages
	swift package clean

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

version:
	swift package tools-version
