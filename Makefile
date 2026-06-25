# ============================================================
# MPlanet iOS 工程 Makefile
# ------------------------------------------------------------
# 常用命令:
#   make bootstrap   初始化: bundle install + pod install
#   make build       编译 Debug
#   make lint        跑 SwiftLint
#   make format      跑 SwiftFormat
#   make test        跑单元测试
#   make clean       清理 DerivedData / Pods / build 产物
# ============================================================

SCHEME       := MainProject-Example
WORKSPACE    := MainProject.xcworkspace
CONFIG       := Debug
DESTINATION  := platform=iOS Simulator,name=iPhone 16,OS=latest
DERIVED_DATA := $(PWD)/DerivedData

# 不签名 (CI / 本地无证书场景)
CODE_SIGN_FLAGS := CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO

.PHONY: help bootstrap build lint format test clean

help:
	@echo "Targets:"
	@echo "  make bootstrap   bundle install + pod install"
	@echo "  make build       xcodebuild Debug"
	@echo "  make lint        SwiftLint"
	@echo "  make format      SwiftFormat (in-place)"
	@echo "  make test        xcodebuild test"
	@echo "  make clean       清理 DerivedData / Pods / build.log"

# ---- bootstrap ----------------------------------------------------
bootstrap:
	@echo "==> bundle install"
	bundle install
	@echo "==> pod install"
	bundle exec pod install

# ---- build --------------------------------------------------------
build:
	@echo "==> xcodebuild build"
	bundle exec xcodebuild \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-sdk iphonesimulator \
		-destination '$(DESTINATION)' \
		-configuration $(CONFIG) \
		-derivedDataPath $(DERIVED_DATA) \
		$(CODE_SIGN_FLAGS) \
		build

# ---- lint ---------------------------------------------------------
lint:
	@command -v swiftlint >/dev/null 2>&1 || { \
		echo "SwiftLint 未安装,执行: brew install swiftlint"; exit 1; }
	@echo "==> SwiftLint"
	swiftlint lint --quiet

# ---- format -------------------------------------------------------
format:
	@command -v swiftformat >/dev/null 2>&1 || { \
		echo "SwiftFormat 未安装,执行: brew install swiftformat"; exit 1; }
	@echo "==> SwiftFormat"
	swiftformat .

# ---- test ---------------------------------------------------------
test:
	@echo "==> xcodebuild test"
	bundle exec xcodebuild \
		-workspace $(WORKSPACE) \
		-scheme $(SCHEME) \
		-sdk iphonesimulator \
		-destination '$(DESTINATION)' \
		-configuration $(CONFIG) \
		-derivedDataPath $(DERIVED_DATA) \
		$(CODE_SIGN_FLAGS) \
		test

# ---- clean --------------------------------------------------------
clean:
	@echo "==> 清理 build 缓存"
	rm -rf $(DERIVED_DATA)
	rm -rf build.log
	@echo "==> 清理 Pods (可选, 加 CONFIRM=1 才会真删)"
	@if [ "$(CONFIRM)" = "1" ]; then \
		rm -rf Pods Podfile.lock; \
	else \
		echo "    跳过 Pods 清理,执行 'make clean CONFIRM=1' 强制清理"; \
	fi